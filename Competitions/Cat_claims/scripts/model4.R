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

train <- train %>% mutate(desc_mismatch = ifelse(is.na(R_INCIDENT_DESC) & !is.na(R_CLM_DESC) ,1,0))
val <- val %>% mutate(desc_mismatch = ifelse(is.na(R_INCIDENT_DESC) & !is.na(R_CLM_DESC) ,1,0) )
test <- test %>% mutate(desc_mismatch = ifelse(is.na(R_INCIDENT_DESC) & !is.na(R_CLM_DESC) ,1,0))

#2. For identification
cont.vars <- c("PAYMENT_TAX_PERC", "LOSS_POSTCODE", "R_SETTLING_BR", "R_INCURRED","MNTH_OCC_DT"  ,             
               "MNTH_REPT_DATE" ,"DT_DIFF_REPT_DT_OCC_DT" ,"DT_DIFF_ACTY_DT_REPT_DT" ,"DT_DIFF_TRN_DT_REPT_DT" ,   
               "DT_DIFF_CLA_SRT_DT_REPT_DT" ,"R_UNIQUEID" ) # 11
cat.vars <-   c("R_INCIDENT_DESC","SUB_CLASS","POLICY_TYP", "LOSS_TYPE", "HS_FLAG", "TERM_ID", "CLAIM_STATUS", "R_T_PARTY",
                "OTHER_PARTY", "MOTOR_RECOVERY" ,"R_CLM_DESC") # 11
response.var <- "CAT_FLAG"
scope.out.vars <- c("R_INCIDENT_DESC", "R_CLM_DESC", "LOSS_POSTCODE", "POLICY_TYP", "R_SETTLING_BR","SUB_CLASS","TERM_ID","R_UNIQUEID", "set")

# 9 - 7 cat.vars, 2 id vars

# 3. Use scored fields from text classification model

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


model4_cv <- xgb.cv(data = xgb.DMatrix(data.matrix(train_2[,-15]),label = train_2[['CAT_FLAG']]), params = params,nrounds = 100,
                    nfold = 10 ,stratified = TRUE,missing = NA,
                    showsd =  TRUE, early_stopping_rounds = TRUE, verbose =  TRUE, 
                    #feval = AUC_fun1,
                    maximize = TRUE)

# best reounds = 70, 0.932814+0.000226

# using the tuned params. above train the model using xgb.train, also get a benchmark score on validations set

train_matrix <- xgb.DMatrix(data = data.matrix(train_2[,-15]), label = train_2$CAT_FLAG)
val_matrix <- xgb.DMatrix(data = data.matrix(val_1[,-15]), label = val_1$CAT_FLAG)

set.seed(2451)
model4 <- xgb.train(data = train_matrix , params = params,
                    nrounds = 70, verbose = 1,
                    #feval = evalf1,maximize = TRUE,
                    watchlist = list( train = train_matrix,val = val_matrix),
                    early_stopping_rounds = 10,
                    maximize = TRUE
)

importance_1 <- xgb.importance(model = model4,feature_names = colnames(train_2[,-15]) )
print(importance_1)

# Feature         Gain        Cover    Frequency
# 1:               model2_score 9.494983e-01 6.400654e-01 0.2389310977
# 2:     DT_DIFF_TRN_DT_REPT_DT 1.734831e-02 6.848722e-02 0.1700288184
# 3:                MNTH_OCC_DT 1.556015e-02 1.470262e-01 0.1472360493
# 4:                  R_T_PARTY 5.260673e-03 2.344944e-02 0.0694262510
# 5:             MNTH_REPT_DATE 4.580186e-03 2.243707e-02 0.0885512182
# 6:              desc_mismatch 2.617876e-03 1.440085e-02 0.0539690857
# 7:     DT_DIFF_REPT_DT_OCC_DT 2.324710e-03 4.395761e-02 0.0951008646
# 8: DT_DIFF_CLA_SRT_DT_REPT_DT 1.240186e-03 2.260714e-02 0.0324862457
# 9:                 R_INCURRED 5.592877e-04 5.680441e-03 0.0395598638
# 10:    DT_DIFF_ACTY_DT_REPT_DT 5.235096e-04 5.644657e-03 0.0330102174
# 11:                  LOSS_TYPE 2.653119e-04 4.635499e-03 0.0130992926
# 12:                    HS_FLAG 1.828793e-04 1.363609e-03 0.0120513492
# 13:           PAYMENT_TAX_PERC 2.593393e-05 6.968214e-05 0.0007859576
# 14:               CLAIM_STATUS 1.273284e-05 1.751781e-04 0.0057636888

# Generate Auc_lift on val set
pred <- predict(object = model4,newdata = xgb.DMatrix(data.matrix(val_1[,-15])))
val_1$pred <- pred
AUC_fun_val(actual = val_1$CAT_FLAG,pred_probs = val_1$pred)
#0.9332652

# attach preds to old val for examonation
val$pred <- pred
