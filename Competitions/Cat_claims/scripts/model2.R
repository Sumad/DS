
# Model on claim desc features
########################
library(text2vec)
library(data.table)
library(magrittr)

dir <- "/Users/sumad/Documents/DS/Competitions/Cat_claims"
library(dplyr)
library(car)
library(rlang)


#1. READ DATA

train <- fread(input = file.path(dir, "Raw_Data/Training_set_v2.csv"),na.strings = c("",NA),
               colClasses = c("numeric", "character","numeric", "character", "numeric",rep("character",6),
                              "numeric",rep("character",3), rep("numeric",8)))

val <- fread(input = file.path(dir, "Raw_Data/Validation_v2.csv"),na.strings = c("",NA),
             colClasses = c("numeric", "character","numeric", "character", "numeric",rep("character",6),
                            "numeric",rep("character",3), rep("numeric",8)))

test <- fread(input = file.path(dir, "Raw_Data/Test_set_v2.csv"),na.strings = c("",NA),
              colClasses = c("numeric", "character","numeric", "character", "numeric",rep("character",6),
                             "numeric",rep("character",3), rep("numeric",7)))

train_1 <- rbind(train,val)
setDT(train_1)
setkey(train_1, R_UNIQUEID)

train_1_text <- train_1 %>% select(R_UNIQUEID,R_CLM_DESC) 

prep_fun = tolower
tok_fun = word_tokenizer

it_train = itoken(train_1_text$R_CLM_DESC, 
                  preprocessor = prep_fun, 
                  tokenizer = tok_fun, 
                  ids = train_1_text$R_UNIQUEID, 
                  progressbar = FALSE)
vocab = create_vocabulary(it_train)

vectorizer = vocab_vectorizer(vocab)
t1 = Sys.time()
dtm_train = create_dtm(it_train, vectorizer)
print(difftime(Sys.time(), t1, units = 'sec'))

library(glmnet)
NFOLDS = 4
t1 = Sys.time()
cv_fit = cv.glmnet(x = dtm_train, y = train_1[['CAT_FLAG']], 
                              family = 'binomial', 
                              # L1 penalty
                              alpha = 1,
                              # interested in the area under ROC curve
                              type.measure = "auc",
                              # 5-fold cross-validation
                              nfolds = NFOLDS,
                              # high value is less accurate, but has faster training
                              thresh = 1e-3,
                              # again lower number of iterations for faster training
                              maxit = 2000)
print(difftime(Sys.time(), t1, units = 'sec'))

cv_fit$lambda.1se
cv_fit$lambda.min
print(paste("max AUC =", round(max(cv_fit$cvm), 4)))
# "max AUC = 0.9521"
plot(cv_fit)

# predict on val set and evaluate lift_auc

setDT(val)
setkey(val, R_UNIQUEID)

val_1_text <- val %>% select(R_UNIQUEID,R_CLM_DESC) 

prep_fun = tolower
tok_fun = word_tokenizer

it_val = itoken(val_1_text$R_CLM_DESC, 
                  preprocessor = prep_fun, 
                  tokenizer = tok_fun, 
                  ids = val_1_text$R_UNIQUEID, 
                  progressbar = FALSE)

t1 = Sys.time()
dtm_val = create_dtm(it_val, vectorizer)
print(difftime(Sys.time(), t1, units = 'sec'))
preds = predict(cv_fit, dtm_val, type = 'response')[,1]
glmnet:::auc(val$CAT_FLAG, preds)
#  0.9601981

AUC_fun_val(actual = val$CAT_FLAG,pred_probs = preds)
# 0.9207589

# Score training,val,test set for using score as input in next model

setDT(test)
setkey(test, R_UNIQUEID)
test_1_text <- test %>% select(R_UNIQUEID,R_CLM_DESC) 
prep_fun = tolower
tok_fun = word_tokenizer
it_test = itoken(test_1_text$R_CLM_DESC, 
                preprocessor = prep_fun, 
                tokenizer = tok_fun, 
                ids = test_1_text$R_UNIQUEID, 
                progressbar = FALSE)

t1 = Sys.time()
dtm_test = create_dtm(it_test, vectorizer)

preds_train_model2 <- as.vector(predict(cv_fit, dtm_train, s = 'lambda.min',type = 'response')[,1])
preds_val_model2 <- as.vector(predict(cv_fit, dtm_val, s = 'lambda.min',type = 'response')[,1])
preds_test_model2 <- as.vector(predict(cv_fit, dtm_test, s = 'lambda.min',type = 'response')[,1])

## Next : Remove stopwords after looking at coefs. and then retrain
#coefs <- coef(cv_fit, s = "lambda.min")


## B. Exploration of text fields 


#colnames(train_1)

# claims_df <- train_1 %>% select(R_UNIQUEID,R_CLM_DESC,CAT_FLAG) 
# library(tm)
# 
# docs <- Corpus(VectorSource(claims_df$R_CLM_DESC))
# docs <- tm_map(docs, content_transformer(tolower))
# docs <- tm_map(docs, removeWords, stopwords("english"))
# docs <- tm_map(docs, removePunctuation)
# docs <- tm_map(docs, stripWhitespace)
# 
# library(SnowballC)
# docs <- tm_map(docs, stemDocument)
# # Remove additional stopwords
# #docs <- tm_map(docs, removeWords, c("clintonemailcom", "stategov", "hrod"))
# 
# dtm <- TermDocumentMatrix(docs)
# m <- as.matrix(dtm)
# v <- sort(rowSums(m),decreasing=TRUE)
# d <- data.frame(word = names(v),freq=v)
# head(d, 10)
# 
# library("wordcloud")
# library("RColorBrewer")
# #par(bg="grey30")
# #png(file="WordCloud.png",width=1000,height=700, bg="grey30")
# wordcloud(d$word, d$freq, col=terrain.colors(length(d$word), alpha=0.9), random.order=FALSE, rot.per=0.3 )
# #dev.off()
