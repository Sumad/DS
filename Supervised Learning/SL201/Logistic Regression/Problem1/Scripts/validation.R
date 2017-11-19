


###################1. Validation for model1 ####################
# Score test set
test$predict <- predict(object = model1_refit,newdata = test,type = "response")

### HL Statistic - goodness of fit, KS test, Actual vs predicted

hltest(scrd_data = test,path = file.path(dir,"plots"),modelname = "model1_refit")
# p value of hl test is 0.0835901 
# ks is 5.095023

### AUC - 
temp <- roc(Responder ~ predict, data = test)
auc(temp)
# 0.5302



###################1. Validation for model2####################
# Score test set
test_1$predict <- predict(object = model2_refit,newdata = test_1,type = "response")

### HL Statistic - goodness of fit, KS test, Actual vs predicted

hltest(scrd_data = test_1,path = file.path(dir,"plots"),modelname = "model2_refit")
# p value of hl test is 0.6165168,  a good fit 
# ks is 5.707591

### AUC - 
temp <- roc(Responder ~ predict, data = test_1)
auc(temp)
# 0.5403

#################################################


###################1. metrics on train set for model2 ####################
# Score test set
train_1$predict <- predict(object = model2_refit,newdata = train_1,type = "response")

### HL Statistic - goodness of fit, KS test, Actual vs predicted



### AUC - 
temp <- roc(Responder ~ predict, data = train_1)
auc(temp)
# 0.5414 

#################################################


################## BETA STABILITY ##############

# tRAIN MODEL ON VAL SET
model2_refit_val <- glm(formula = Responder ~ Age + Bank_balance + OS_cat + Overall_spend_10,
                        family = binomial(link = "logit"), data = test_1)


#remove variables for whcih betas deviate more than +/- 20% in val sample
dev_betas<-as.data.frame(model2_refit$coefficients)
val_betas<-as.data.frame(model2_refit_val$coefficients)
compare<-dev_betas
compare$valbetas<-val_betas$`model2_refit_val$coefficients`
compare$ratio<-compare$valbetas/compare$`model2_refit$coefficients`
compare$ratio


