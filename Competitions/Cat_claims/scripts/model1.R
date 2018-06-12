## A. xgboost algorithm Model using structured fields
## B. Exploration of text fields , model on text fields
## C. xgboost Model using models B score (strctured and from text fields) 
## D. Two stage model, model on outputs of A, B?

########## 1. Read, data quality, incidence rate ###################

dir <- "/Users/sumad/Documents/DS/Competitions/Cat_claims"
library(data.table)
library(dplyr)
library(car)
library(rlang)

source(file.path(dir, "scripts/functions.R"))

#1. READ DATA

train <- fread(input = file.path(dir, "Raw_Data/Training_set_v2.csv"),na.strings = c("",NA),
              colClasses = c("numeric", "character","numeric", "character", "numeric",rep("character",6),
                             "numeric",rep("character",3), rep("numeric",8)))
#train$set <- 'train' 

val <- fread(input = file.path(dir, "Raw_Data/Validation_v2.csv"),na.strings = c("",NA),
             colClasses = c("numeric", "character","numeric", "character", "numeric",rep("character",6),
                            "numeric",rep("character",3), rep("numeric",8)))
#val$set <- 'val'              

test <- fread(input = file.path(dir, "Raw_Data/Test_set_v2.csv"),na.strings = c("",NA),
              colClasses = c("numeric", "character","numeric", "character", "numeric",rep("character",6),
              "numeric",rep("character",3), rep("numeric",7)))
#test$set <- 'test' 

#2. For data Quality Checks
cont.vars <- c("PAYMENT_TAX_PERC", "LOSS_POSTCODE", "R_SETTLING_BR", "R_INCURRED","MNTH_OCC_DT"  ,             
               "MNTH_REPT_DATE" ,"DT_DIFF_REPT_DT_OCC_DT" ,"DT_DIFF_ACTY_DT_REPT_DT" ,"DT_DIFF_TRN_DT_REPT_DT" ,   
               "DT_DIFF_CLA_SRT_DT_REPT_DT" ,"R_UNIQUEID" ) # 11
cat.vars <-   c("R_INCIDENT_DESC","SUB_CLASS","POLICY_TYP", "LOSS_TYPE", "HS_FLAG", "TERM_ID", "CLAIM_STATUS", "R_T_PARTY",
                "OTHER_PARTY", "MOTOR_RECOVERY" ,"R_CLM_DESC") # 11
response.var <- "CAT_FLAG"
scope.out.vars <- c("R_INCIDENT_DESC", "R_CLM_DESC", "LOSS_POSTCODE", "POLICY_TYP", "R_SETTLING_BR","SUB_CLASS","TERM_ID","R_UNIQUEID", "set")
# 9 - 7 cat.vars, 2 id vars

dq(cat.vars = cat.vars, cont.vars = cont.vars, response.var = "CAT_FLAG", train ,val)

# Incidence
#9% cat. claims

# var                           train_na train_unique   val_na  val_unique    test_na  test_unique
# 1                    CAT_FLAG        0            2       0           2
# 2                    CAT_FLAG        0            2       0           0
# 3               CLAIM_STATUS        0            2       0           2     0         2
# 4     DT_DIFF_ACTY_DT_REPT_DT        0         1096       0         915     0         825
# 5  DT_DIFF_CLA_SRT_DT_REPT_DT        0         1098       0         911     0         829
# 6      DT_DIFF_REPT_DT_OCC_DT        0          802       0         607     0         496
# 7      DT_DIFF_TRN_DT_REPT_DT        0          893       0         671     0         566
# 8                     HS_FLAG        0            3       0           3     0         3
# 9               *LOSS_POSTCODE        0         2556       0        2264     0         2039 # 17 post codes are new in test set, work out a cat. variable
                                                                                             # by possibly clustering on loss amounts
# 10                  LOSS_TYPE    67504           21   19399          19     9669      20 # 60% NAs in train and val,test, code as Other
# 11                MNTH_OCC_DT        0           12       0          12
# 12             MNTH_REPT_DATE        0           12       0          12
# 13             MOTOR_RECOVERY    70640            3   20291           3     10110      3  # ~ 60% NAs as well, code as Other
# 14                OTHER_PARTY        0            2       0           2
# 15           PAYMENT_TAX_PERC        0           56       0          30     0          25
# 16                *POLICY_TYP        0           55       0          55     0          45 # combine levels, esp, where levels have no response cases, also use woe
                                                                                            # address a new level 'TRI' in test
# 17                *R_CLM_DESC        0        55569       0       17412     0          9066  # Explore where claims desc differs from incident desc. Why?
# 18          *R_INCIDENT_DESC    33846        36371    9701       11304     4756       5947 # NAs here but claims desc is good
# 19                 R_INCURRED        0        99212       0       28396     0           14217  
# 20            *R_SETTLING_BR        0           83       0          70     0          69  # 1 new code in test (14), high cardinality, use woe to combine
# 21                  R_T_PARTY        0            2       0           2     0           2
# 22                *R_UNIQUEID        0       111058       0       31732     0       15865 # can we use ids
# 23                  *SUB_CLASS        0          223       0         196     0         174 # "IPP" "TGO" "CFL" new in test; reduce cardinality along with ply_typ
# 24                    * TERM_ID        0         2870       0        2025     0        1614 # 98 new codes, extract features from alphanumeric

#ggplot(data = train,aes(x = train$R_INCURRED)) + geom_density() + facet_grid(train$CAT_FLAG ~.)

# 3. Append train and val and remove identified variables to be dealt with separately

train_1 <- rbind(train, val)
train_2 <- select(train_1, which(!colnames(train_1) %in% scope.out.vars))
#colnames(test_1)
test_1 <- select(test, which(!colnames(test) %in% scope.out.vars))
val_1 <- select(val, which(!colnames(val) %in% scope.out.vars))

for(col in colnames(train_2)){
  if (col %in% cat.vars){
    train_2[[col]] <- as.factor(train_2[[col]])
    #if(col != response.var){
    test_1[[col]] <- as.factor(test_1[[col]])
    #}
    val_1[[col]] <- as.factor(val_1[[col]])
  }
}

# 4. Eval Metric
# evalerror <- function(preds, dtrain) {
#   labels <- getinfo(dtrain, "label")
#   err <- as.numeric(sum(labels != (preds > 0)))/length(labels)
#   return(list(metric = "error", value = err))
# }

AUC_fun  <- function( preds, dtrain){
  actual <- getinfo(dtrain, "label")
  df <- data.frame(actual,preds)
  df <- arrange(df, desc(preds))
  df[['com_sum']] <- cumsum(df[['actual']])
  df[['per_y']] <- df[['com_sum']]/max(df[['com_sum']])
  lift_auc <- sum(df[['per_y']])/nrow(df)
  return(list(metric = "lift_auc", value = lift_auc)) 
}

AUC_fun_val  <- function(actual, pred_probs){
  df <- data.frame(actual,pred_probs)
  setDT(df)
  df <- df[order(-eval(pred_probs))]
  df[,com_sum := cumsum(eval(actual))]
  df[,per_y := com_sum/max(com_sum)]
  lift_auc <- sum(df[['per_y']])/nrow(df)
  return(list(metric = "lift_auc", value = lift_auc)) 
}


# 4. Train and Tune hyperparams.
library(xgboost)
set.seed(seed = 2451)
# Complete list of parametets
# https://github.com/dmlc/xgboost/blob/master/doc/parameter.md
params <- list( "booster" = "gbtree",
                "objective" = "binary:logistic", 
                "scale_pos_weight" = 9, # to balance
                "max_depth" = 6 ,
                ## Boosting params. for tree ##
                "eta" = 0.01,
                "gamma" = 0, # 0 to Inf
                #"min_child_weight" = ,
                #"max_delta_step" = ,
                #"subsample" = 0.8,        # default 1     
               # "colsample_bytree" = 0.5, #default 1
                #############################
                
               # "eval_metric" = "auc"
                "eval_metric" = AUC_fun  # custom metric can be defined and used
                #"nthread" = , # default
                #"silent" = 1
)


model1 <- xgb.cv(data = xgb.DMatrix(data.matrix(train_2[,-15]),label = train_2[['CAT_FLAG']]), params = params,nrounds = 100,
                 nfold = 10 ,stratified = TRUE,missing = NA,
                 showsd =  TRUE, early_stopping_rounds = TRUE, verbose =  TRUE, 
                 #feval = AUC_fun1,
                 maximize = TRUE)

# best reounds = 6

# using the tuned params. above train the model using xgb.train, also get a benchmark score on validations set

train_matrix <- xgb.DMatrix(data = data.matrix(train_2[,-15]), label = train_2$CAT_FLAG)
val_matrix <- xgb.DMatrix(data = data.matrix(val_1[,-15]), label = val_1$CAT_FLAG)

set.seed(2451)
model1_1 <- xgb.train(data = train_matrix , params = params,
                      nrounds = 6, verbose = 1,
                      #feval = evalf1,maximize = TRUE,
                      watchlist = list( train = train_matrix,val = val_matrix),
                      early_stopping_rounds = 10,
                      maximize = TRUE
)

importance_1 <- xgb.importance(model = model1_1,feature_names = colnames(train_2[,-15]) )
print(importance_1)

# Generate Auc_lift on val set
pred <- predict(object = model1_1,newdata = xgb.DMatrix(data.matrix(val_1[,-15])))
val_1$pred <- pred
AUC_fun_val(actual = val_1$CAT_FLAG,pred_probs = val_1$pred)

# attach preds to old val for examonation
val$pred <- pred



# Predict test set 

pred <- predict(object = model1_1,newdata = xgb.DMatrix(data.matrix(test_4)))
ID <- test_2$ID
PREDICTED_STATUS <- ifelse(pred> 0.5,1,0)

df <- data.frame(ID, PREDICTED_STATUS)

write.csv(df, file.path(dir.path,"sumad_singh_DataChallenge08Jan2018.csv"),row.names = FALSE)




#######################################
# 3.3 VISUALLY EXPLORE UNIVARIATE DISTRIBUTIONS &
# IF LOG (ODDS) IS RELATED LINEARLY TO EACH OF VARIABLES
path <- file.path(dir,"plots")
eda(dataset = train,path = path )


# 3.3.3 IMPROVE THE FEATURES BY CONVERTING NUMERIC VARS. TO CATEGORICAL, USING WOE

train_noout <- train %>% mutate(salary = pmin(salary,500), 
                                Past_purchases_band = pmin(Past_purchases_band,500),
                                Premium_score = pmax(Premium_score,350),
                                Purchase_capacity = pmax(Purchase_capacity,250))

woe(dataset = train_noout ,var = "Past_purchases_band",breaks = c(-Inf,407,414,Inf))
woe(dataset = train_noout ,var = "Overall_spend",breaks = c(-Inf,402, 408,415,Inf))
woe(dataset = train_noout ,var = "Credit_rating",breaks = c(-Inf,407,417,Inf))
woe(dataset = train_noout ,var = "salary",breaks = c(-Inf,400,406,415,Inf))

woe(dataset = train_noout ,var = "net_worth",breaks = c(-Inf,400,409,415,Inf))
woe(dataset = train_noout ,var = "Internal_rating",breaks = c(-Inf,401,410,417,Inf))

woe(dataset = train_noout ,var = "Premium_score",breaks = c(-Inf,400,412,Inf))
woe(dataset = train_noout ,var = "Survey_score",breaks = c(-Inf,410,Inf))
woe(dataset = train_noout ,var = "Purchase_capacity",breaks = c(-Inf,407,417,Inf))
woe(dataset = train_noout ,var = "Last_quarter_spend",breaks = c(-Inf,407,Inf))

#####################
