#0. Check VIF
train0 <- train_noout
#train0$Responder <- as.integer(train0$Responder)

model0 <- lm(formula = Responder ~ Internal_rating +Age + Last_quarter_spend +
                Credit_rating + salary + Overall_spend + Survey_score + Past_purchases_band +
                Premium_score +Purchase_capacity + net_worth + Bank_balance,
              data = train0)

vif(model0)

# 1. FIT A FULL MODEL
train_noout$Responder <- as.factor(train_noout$Responder)
model1 <- glm(formula = Responder ~ Internal_rating +Age + Last_quarter_spend +
                Credit_rating + salary + Overall_spend + Survey_score + Past_purchases_band +
                Premium_score +Purchase_capacity + net_worth + Bank_balance, family = binomial,
              data = train_noout)

summary(model1)
model1_step <- step(object = model1,direction = "both",trace = TRUE)
summary(model1_step)

# Fit with significant variables

model1_refit <- glm(formula =Responder ~ Age + Overall_spend + Past_purchases_band + 
                Bank_balance, family = binomial,
              data = train_noout)


# 2. Try add'l features
train_1$Responder <- as.factor(train_1$Responder)
model2 <- glm(formula = Responder ~ Age + Bank_balance + PPB_cat + OS_cat +
                CR_cat + Sal_cat + NW_cat + IR_cat + PS_cat + SS_cat + PC_cat +
                LQS_cat + Overall_spend_10 + Survey_score_10 + Last_quarter_spend_10, 
              family = binomial(link = "logit"), data = train_1)

summary(model2)

model2_step <- step(object = model2,direction = "both",trace = TRUE)
summary(model2_step)

# Fit with significant variables

model2_refit <- glm(formula = Responder ~ Age + Bank_balance + OS_cat + Overall_spend_10,
                    family = binomial,
                    data = train_1)

varImp(model2_refit)
################## EXPERIMENTAL WORK ##############################

#2. Fit model 2 using train_2

# train_2$Responder <- as.factor(train_2$Responder)
# model2 <- glm(formula = Responder ~ Internal_rating +Age + Last_quarter_spend_10 +
#                 Credit_rating + salary + Overall_spend_10 +  
#                 Survey_score_10 + Past_purchases_band + Premium_score +Purchase_capacity + 
#                 net_worth + Bank_balance, family = binomial(link = "logit"), data = train_2)
# 
# summary(model2)
# 
# #3. Fit model 2 using train_3
# train_3$Responder <- as.factor(train_3$Responder)
# model3 <- glm(formula = Responder ~ Internal_rating_cat +Age + Last_quarter_spend +
#                 Credit_rating_cat + salary + Overall_spend +  
#                 Survey_score + Past_purchases_band + Premium_score +Purchase_capacity + 
#                 net_worth + Bank_balance, family = binomial(link = "logit"), data = train_3)
# 
# #4. Fit model 2 using train_4
# 
# train_4$Responder <- as.factor(train_4$Responder)
# model4 <- glm(formula = Responder ~ log_IR +Age + Last_quarter_spend +
#                 log_CR + log_Sal + log_OS +  
#                 log_SS + log_PPB + log_PS +log_PC + 
#                 log_NW + Bank_balance, family = binomial(link = "logit"), data = train_4)
# 
# # Check var importance
# varImp(model4)
# 
# #5. train$Responder <- as.factor(train$Responder)
# model5 <- glm(formula = Responder ~ Internal_rating +Age + Last_quarter_spend +
#                 Credit_rating + salary + Overall_spend + Survey_score + PPB_cat +
#                 Premium_score +Purchase_capacity + net_worth + Bank_balance, 
#               family = binomial(link = "logit"), data = train_5)
# 
# summary(model5)
# 
# #6. 
# train_6$Responder <- as.factor(train_6$Responder)
# model6 <- glm(formula = Responder ~ Internal_rating +Age + Last_quarter_spend +
#                 CR_cat + salary + Overall_spend + Survey_score + Past_purchases_band +
#                 Premium_score +Purchase_capacity + net_worth + Bank_balance, 
#               family = binomial(link = "logit"), data = train_6)
# 
# summary(model6)
# 
# model6_step <- step(object = model6,direction = "both",trace = TRUE)
