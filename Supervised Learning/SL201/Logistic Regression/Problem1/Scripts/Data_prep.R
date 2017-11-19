## FEATURE CREATION


# create all variables using observations
train_1 <- train_noout %>%
  mutate(PPB_cat = cut(x = Past_purchases_band ,breaks = c(-Inf,407,414,Inf), right = TRUE,
                      ordered_result = TRUE, labels = paste("Cat",1:3,sep = "_")),
    OS_cat = cut(x = Overall_spend ,breaks = c(-Inf,402, 408,415,Inf), right = TRUE,
                      ordered_result = TRUE, labels = paste("Cat",1:4,sep = "_")),
    CR_cat = cut(x = Credit_rating ,breaks = c(-Inf,407,417,Inf), right = TRUE,
                 ordered_result = TRUE, labels = paste("Cat",1:3,sep = "_")),
    Sal_cat = cut(x = salary ,breaks = c(-Inf,400,406,415,Inf), right = TRUE,
                 ordered_result = TRUE, labels = paste("Cat",1:4,sep = "_")),
    NW_cat = cut(x = net_worth ,breaks = c(-Inf,400,409,415,Inf), right = TRUE,
                 ordered_result = TRUE, labels = paste("Cat",1:4,sep = "_")),
    IR_cat = cut(x = Internal_rating ,breaks = c(-Inf,401,410,417,Inf), right = TRUE,
                 ordered_result = TRUE, labels = paste("Cat",1:4,sep = "_")),
    PS_cat = cut(x = Premium_score ,breaks = c(-Inf,400,412,Inf), right = TRUE,
                 ordered_result = TRUE, labels = paste("Cat",1:3,sep = "_")),
    SS_cat = cut(x = Survey_score ,breaks = c(-Inf,410,Inf), right = TRUE,
                 ordered_result = TRUE, labels = paste("Cat",1:2,sep = "_")),
    PC_cat = cut(x = Purchase_capacity ,breaks = c(-Inf,407,417,Inf), right = TRUE,
                 ordered_result = TRUE, labels = paste("Cat",1:3,sep = "_")),
    LQS_cat = cut(x = Last_quarter_spend ,breaks = c(-Inf,407,Inf), right = TRUE,
                 ordered_result = TRUE, labels = paste("Cat",1:2,sep = "_"))) %>%
  mutate(Overall_spend_10 = if_else(Overall_spend >410, Overall_spend - 10, Overall_spend),
       Survey_score_10 = if_else(Survey_score >410, Survey_score - 10, Survey_score),
       Last_quarter_spend_10 = if_else(Last_quarter_spend > 410, Last_quarter_spend - 10, Last_quarter_spend))



test_1 <- test %>% 
  mutate(PPB_cat = cut(x = Past_purchases_band ,breaks = c(-Inf,407,414,Inf), right = TRUE,
                       ordered_result = TRUE, labels = paste("Cat",1:3,sep = "_")),
         OS_cat = cut(x = Overall_spend ,breaks = c(-Inf,402, 408,415,Inf), right = TRUE,
                      ordered_result = TRUE, labels = paste("Cat",1:4,sep = "_")),
         CR_cat = cut(x = Credit_rating ,breaks = c(-Inf,407,417,Inf), right = TRUE,
                      ordered_result = TRUE, labels = paste("Cat",1:3,sep = "_")),
         Sal_cat = cut(x = salary ,breaks = c(-Inf,400,406,415,Inf), right = TRUE,
                       ordered_result = TRUE, labels = paste("Cat",1:4,sep = "_")),
         NW_cat = cut(x = net_worth ,breaks = c(-Inf,400,409,415,Inf), right = TRUE,
                      ordered_result = TRUE, labels = paste("Cat",1:4,sep = "_")),
         IR_cat = cut(x = Internal_rating ,breaks = c(-Inf,401,410,417,Inf), right = TRUE,
                      ordered_result = TRUE, labels = paste("Cat",1:4,sep = "_")),
         PS_cat = cut(x = Premium_score ,breaks = c(-Inf,400,412,Inf), right = TRUE,
                      ordered_result = TRUE, labels = paste("Cat",1:3,sep = "_")),
         SS_cat = cut(x = Survey_score ,breaks = c(-Inf,410,Inf), right = TRUE,
                      ordered_result = TRUE, labels = paste("Cat",1:2,sep = "_")),
         PC_cat = cut(x = Purchase_capacity ,breaks = c(-Inf,407,417,Inf), right = TRUE,
                      ordered_result = TRUE, labels = paste("Cat",1:3,sep = "_")),
         LQS_cat = cut(x = Last_quarter_spend ,breaks = c(-Inf,407,Inf), right = TRUE,
                       ordered_result = TRUE, labels = paste("Cat",1:2,sep = "_"))) %>% 
  mutate(Overall_spend_10 = if_else(Overall_spend >410, Overall_spend - 10, Overall_spend),
         Survey_score_10 = if_else(Survey_score >410, Survey_score - 10, Survey_score),
         Last_quarter_spend_10 = if_else(Last_quarter_spend > 410, Last_quarter_spend - 10, Last_quarter_spend))



########################## EXPERIMENTAL WORK ##########################

# train_2 <- train %>% 
#   mutate(Overall_spend_10 = if_else(Overall_spend >410, Overall_spend - 10, Overall_spend),
#          Survey_score_10 = if_else(Survey_score >410, Survey_score - 10, Survey_score),
#          Last_quarter_spend_10 = if_else(Survey_score > 410, Last_quarter_spend - 10, Last_quarter_spend)) %>% 
#   select(-Overall_spend,Survey_score,Last_quarter_spend)
# 
# test_2 <- test %>% 
#   mutate(Overall_spend_10 = if_else(Overall_spend >410, Overall_spend - 10, Overall_spend),
#          Survey_score_10 = if_else(Survey_score >410, Survey_score - 10, Survey_score),
#          Last_quarter_spend_10 = if_else(Survey_score > 410, Last_quarter_spend - 10, Last_quarter_spend)) %>% 
#   select(-Overall_spend,Survey_score,Last_quarter_spend)
# 
# train_3 <- train
# test_3 <- test
# train_3$Internal_rating_cat <- cut(x = train_3$Internal_rating,
#                                    breaks = c(0,403,410,417,Inf) ,labels = c(paste("IR",1:4,sep="")),
#                                    right = TRUE,ordered_result = TRUE)
# train_3$Credit_rating_cat <- cut(x = train_3$Credit_rating,
#                                  breaks = c(0,405,415,Inf) ,labels = c(paste("CR",1:3,sep="")),
#                                  right = TRUE,ordered_result = TRUE)
# 
# test_3$Internal_rating_cat <- cut(x = test_3$Internal_rating,
#                                   breaks = c(0,403,410,417,Inf) ,labels = c(paste("IR",1:4,sep="")),
#                                   right = TRUE,ordered_result = TRUE)
# test_3$Credit_rating_cat <- cut(x = test_3$Credit_rating,
#                                 breaks = c(0,405,415,Inf) ,labels = c(paste("CR",1:3,sep="")),
#                                 right = TRUE,ordered_result = TRUE)
# 
# # a. Salary, Overall Spend > 500
# # b.Past Purchase band > 500
# # c. Premium score < 100
# #d. Purchase capacity < 250
# 
# train_4 <- train %>% mutate(salary = pmin(salary,500), 
#                             Past_purchases_band = pmin(Past_purchases_band,500),
#                             Premium_score = pmax(Premium_score,350),
#                             Purchase_capacity = pmax(Purchase_capacity,250)) %>%
#   mutate(log_IR = log(Internal_rating),log_CR = log(Credit_rating), 
#          log_Sal = log(salary),log_OS = log(Overall_spend),
#          log_SS = log(Survey_score), log_LQS = log(Last_quarter_spend),
#          log_PPB = log(Past_purchases_band), log_PS = log(Premium_score),
#          log_PC = log(Purchase_capacity), log_NW = log(net_worth) ) 
# 
# test_4 <- test %>% mutate(salary = pmin(salary,500), 
#                           Past_purchases_band = pmin(Past_purchases_band,500),
#                           Premium_score = pmax(Premium_score,350),
#                           Purchase_capacity = pmax(Purchase_capacity,250)) %>%
#   mutate(log_IR = log(Internal_rating),log_CR = log(Credit_rating), 
#          log_Sal = log(salary),log_OS = log(Overall_spend),
#          log_SS = log(Survey_score), log_LQS = log(Last_quarter_spend),
#          log_PPB = log(Past_purchases_band), log_PS = log(Premium_score),
#          log_PC = log(Purchase_capacity), log_NW = log(net_worth) ) 
# 
# # break Past_purchases_band into categories
# 
# train_5 <- train %>% 
#   mutate(PPB_cat = cut(x = Past_purchases_band ,breaks = c(-Inf,405,415,Inf), right = TRUE,
#                     ordered_result = TRUE, labels = paste("Cat",1:3,sep = "_"))) 
# train_5$Responder <-  as.factor(train_5$Responder)
# 
# test_5 <- test %>% 
#   mutate(PPB_cat = cut(x = Past_purchases_band ,breaks = c(-Inf,405,415,Inf), right = TRUE,
#                        ordered_result = TRUE, labels = paste("Cat",1:3,sep = "_"))) 
# 
# # break credit rating using eda
# 
# train_6 <- train %>% 
#   mutate(CR_cat = cut(x = Credit_rating ,breaks = c(-Inf,407,417,Inf), right = TRUE,
#                        ordered_result = TRUE, labels = paste("Cat",1:3,sep = "_"))) 
# train_6$Responder <-  as.factor(train_5$Responder)
# 
# test_6 <- test %>% 
#   mutate(CR_cat = cut(x = Credit_rating ,breaks = c(-Inf,407,417,Inf), right = TRUE,
#                       ordered_result = TRUE, labels = paste("Cat",1:3,sep = "_"))) 
# 
