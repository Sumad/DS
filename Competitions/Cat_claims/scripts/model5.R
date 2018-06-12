
############################# Final model using structured features and model 2 
########## 1. Read, data quality, incidence rate ###################

dir <- "/Users/sumad/Documents/DS/Competitions/Cat_claims"
library(data.table)
library(dplyr)
library(car)
library(rlang)

library(text2vec)
library(data.table)
library(magrittr)

source(file.path(dir, "scripts/functions.R"))

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

# Additional features

## Some functions
# term_id_a <- function(ch){
#   if(sum(strsplit(x = ch,fixed = TRUE,split = "")[1][[1]] =='A'))
#   {return(1)}
#   else{
#     return(0)}
# }

#term_id_a_vec <- Vectorize(FUN = term_id_a,vectorize.args = 'ch',USE.NAMES = FALSE)

# add some features
train <- train %>% mutate(desc_mismatch = ifelse(is.na(R_INCIDENT_DESC) & !is.na(R_CLM_DESC) ,1,0),
                          # term id features
                          term_id_0 = ifelse(TERM_ID == 0 ,1,0))
                          #term_id_1A =  term_id_a_vec(TERM_ID)
                          
val <- val %>% mutate(desc_mismatch = ifelse(is.na(R_INCIDENT_DESC) & !is.na(R_CLM_DESC) ,1,0),
                      term_id_0 = ifelse(TERM_ID == 0 ,1,0))
                     # term_id_1A =  term_id_a_vec(TERM_ID))

test <- test %>% mutate(desc_mismatch = ifelse(is.na(R_INCIDENT_DESC) & !is.na(R_CLM_DESC) ,1,0),
                        term_id_0 = ifelse(TERM_ID == 0 ,1,0))
                        #term_id_1A =  term_id_a_vec(TERM_ID))

# Data frames for ply_type
train_plytype <- data.frame(do.call(rbind,strsplit(x = train$POLICY_TYP,split = "", fixed = TRUE)))
colnames(train_plytype) <- c('ply_type1','ply_type2','ply_type3')
val_plytype <- data.frame(do.call(rbind,strsplit(x = val$POLICY_TYP,split = "", fixed = TRUE)))
colnames(val_plytype) <- c('ply_type1','ply_type2','ply_type3')
test_plytype <- data.frame(do.call(rbind,strsplit(x = test$POLICY_TYP,split = "", fixed = TRUE)))
colnames(test_plytype) <- c('ply_type1','ply_type2','ply_type3')

# Data frames for sub_class
train_subclass <- data.frame(do.call(rbind,strsplit(x = train$SUB_CLASS,split = "", fixed = TRUE)))
colnames(train_subclass) <- c('sub_class1','sub_class2','sub_class3')
val_subclass <- data.frame(do.call(rbind,strsplit(x = val$SUB_CLASS,split = "", fixed = TRUE)))
colnames(val_subclass) <- c('sub_class1','sub_class2','sub_class3')
test_subclass <- data.frame(do.call(rbind,strsplit(x = test$SUB_CLASS,split = "", fixed = TRUE)))
colnames(test_subclass) <- c('sub_class1','sub_class2','sub_class3')


# club these data frame features
train <- cbind(train, train_subclass, train_plytype)
test<- cbind(test,test_subclass,test_plytype)
val <- cbind(val,val_subclass,val_plytype)


#2. For identification
cont.vars <- c("PAYMENT_TAX_PERC", "LOSS_POSTCODE", "R_SETTLING_BR", "R_INCURRED","MNTH_OCC_DT"  ,             
               "MNTH_REPT_DATE" ,"DT_DIFF_REPT_DT_OCC_DT" ,"DT_DIFF_ACTY_DT_REPT_DT" ,"DT_DIFF_TRN_DT_REPT_DT" ,   
               "DT_DIFF_CLA_SRT_DT_REPT_DT" ,"R_UNIQUEID" ) # 11
cat.vars <-   c("R_INCIDENT_DESC","SUB_CLASS","POLICY_TYP", "LOSS_TYPE", "HS_FLAG", "TERM_ID", "CLAIM_STATUS", "R_T_PARTY",
                "OTHER_PARTY", "MOTOR_RECOVERY" ,"R_CLM_DESC") # 11
response.var <- "CAT_FLAG"
scope.out.vars <- c("R_INCIDENT_DESC", "R_CLM_DESC", "LOSS_POSTCODE", "POLICY_TYP","SUB_CLASS","TERM_ID","R_UNIQUEID", "set")

# 9 - 7 cat.vars, 2 id vars

# 3. Use scored fields from text classification model - model 2

train_1 <- rbind(train, val)
setDT(train_1)
setkey(train_1, R_UNIQUEID)
setDT(val)
setkey(val, R_UNIQUEID)
setDT(test)
setkey(test, R_UNIQUEID)

train_1$model2_score <- preds_train_model2
val$model2_score <- preds_val_model2
test$model2_score <- preds_test_model2

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
                "max_depth" = 7 ,
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


model5_cv <- xgb.cv(data = xgb.DMatrix(data.matrix(train_2[,-16]),label = train_2[['CAT_FLAG']]), params = params,nrounds = 100,
                    nfold = 10 ,stratified = TRUE,missing = NA,
                    showsd =  TRUE, early_stopping_rounds = TRUE, verbose =  TRUE, 
                    #feval = AUC_fun1,
                    maximize = TRUE)

# best reounds = 65, train-lift_auc:0.936154+0.000221	test-lift_auc:0.933268+0.001757

# using the tuned params. above train the model using xgb.train, also get a benchmark score on validations set

train_matrix <- xgb.DMatrix(data = data.matrix(train_2[,-16]), label = train_2$CAT_FLAG)
val_matrix <- xgb.DMatrix(data = data.matrix(val_1[,-16]), label = val_1$CAT_FLAG)

set.seed(2451)
model5 <- xgb.train(data = train_matrix , params = params,
                    nrounds = 65, verbose = 1,
                    #feval = evalf1,maximize = TRUE,
                    watchlist = list( train = train_matrix,val = val_matrix),
                    early_stopping_rounds = 10,
                    maximize = TRUE
)

importance_1 <- xgb.importance(model = model5,feature_names = colnames(train_2[,-16]) )
print(importance_1)

# Feature         Gain        Cover    Frequency
# 1:               model2_score 9.504769e-01 6.642929e-01 0.2486565706
# 2:     DT_DIFF_TRN_DT_REPT_DT 1.713563e-02 6.971829e-02 0.1602344895
# 3:                MNTH_OCC_DT 1.285753e-02 1.362727e-01 0.1172447484
# 4:             MNTH_REPT_DATE 4.049235e-03 2.069913e-02 0.0859794822
# 5:                  R_T_PARTY 3.388533e-03 1.774661e-02 0.0537371764
# 6:                  term_id_0 3.151542e-03 4.469399e-03 0.0366389839
# 7:              R_SETTLING_BR 2.479489e-03 2.716981e-02 0.0508060576
# 8:                 sub_class1 2.196768e-03 1.432676e-03 0.0112359551
# 9:     DT_DIFF_REPT_DT_OCC_DT 1.590882e-03 9.305009e-03 0.0830483635
# 10: DT_DIFF_CLA_SRT_DT_REPT_DT 9.812142e-04 2.178514e-02 0.0205178310
# 11:    DT_DIFF_ACTY_DT_REPT_DT 9.212903e-04 1.057523e-02 0.0644846116
# 12:                  ply_type1 2.101964e-04 2.846512e-03 0.0068392770
# 13:                 sub_class3 1.218787e-04 8.028281e-05 0.0151441133
# 14:                 R_INCURRED 1.118842e-04 3.468334e-03 0.0156326331
# 15:                  ply_type2 1.098903e-04 3.718363e-04 0.0063507572
# 16:                  ply_type3 9.139861e-05 9.336521e-03 0.0175867123
# 17:                 sub_class2 7.106257e-05 2.542318e-04 0.0029311187
# 18:              desc_mismatch 2.850696e-05 5.858519e-05 0.0004885198
# 19:               CLAIM_STATUS 1.538781e-05 6.330383e-05 0.0019540791
# 20:                  LOSS_TYPE 1.077312e-05 5.341865e-05 0.0004885198

# Generate Auc_lift on val set
pred <- predict(object = model5,newdata = xgb.DMatrix(data.matrix(val_1[,-16])))
val_1$pred <- pred
AUC_fun_val(actual = val_1$CAT_FLAG,pred_probs = val_1$pred)
#0.9369177

# attach preds to old val for examonation
#val$pred <- pred

##############################