# Data file used with modifications: https://www.umass.edu/statdata/statdata/data/myopia.pdf

raw_data <- read.csv('logistic_data.csv',stringsAsFactors = FALSE)

library(data.table)
library(sqldf)
library(tidyr)
library(dplyr)
library(car)

#for ROC
#install.packages("pROC")
library(pROC)

#for Var Imp
#install.packages("caret")
library(caret)

#for HL test
#install.packages("ResourceSelection")
library(ResourceSelection)

#nomissing values
summary(raw_data)

#outliers
quantile(raw_data$al,c(0.95,0.99,1))
quantile(raw_data$acd,c(0.95,0.99,1))
quantile(raw_data$lt,c(0.95,0.99,1))

#dev and val samp - 70-30 split
temp<-raw_data
temp$rand<-runif(nrow(temp))
dev<-temp %>% filter (rand<=0.7)
val<-temp %>% filter (rand>0.7)

#first run with all variables
full_model<-glm(formula=myopic ~ age+gender+
                  spheq+
                  al+acd+lt+vcd+sporthr+readhr+comphr+studyhr+tvhr+mommy,
                family=binomial,dev)

#discussion on information value and variable selection in logistic reg
#http://www.mwsug.org/proceedings/2013/AA/MWSUG-2013-AA14.pdf

#look at some model statistics
summary(full_model)

backwards = step(full_model)
#default is backward selection

back_model<-glm(formula=myopic ~  gender + spheq + al + acd + lt + vcd + sporthr + readhr + 
                  comphr + studyhr + tvhr + mommy,
                family=binomial,dev)
summary(back_model)

final_dev_model<-glm(formula=myopic ~  gender + spheq + sporthr + readhr + 
                       comphr + studyhr + tvhr + mommy,
                     family=binomial,dev)
summary(final_dev_model)

#VIF check
fit <- lm(myopic ~  gender + spheq + sporthr + readhr + 
            comphr + studyhr + tvhr + mommy, data=dev)
vif(fit)

#calculating probabilities for dev and ROC 

prob=predict(final_dev_model,type=c("response"))
dev$prob=prob

g <- roc(myopic ~ prob, data = dev)
plot(g)  
auc(g)
#ideally above 0.7

#realtive importance of variables-represent in percentage
varImp(final_dev_model, scale = FALSE)

#beta stability

final_val_model<-glm(formula=myopic ~  gender + spheq + sporthr + readhr + 
                       comphr + studyhr + tvhr + mommy,
                     family=binomial,val)


summary(final_dev_model)
summary(final_val_model)

#remove variables for whcih betas deviate more than +/- 20% in val sample
dev_betas<-as.data.frame(final_dev_model$coefficients)
val_betas<-as.data.frame(final_val_model$coefficients)
compare<-dev_betas
compare$valbetas<-val_betas$`final_val_model$coefficients`
compare$ratio<-compare$valbetas/compare$`final_dev_model$coefficients`


#rerun dev and val exercise with new variable list after dropping variable 
#not passing beta stability



final_dev_model<-glm(formula=myopic ~  gender + spheq +  mommy,
                     family=binomial,dev)


final_val_model<-glm(formula=myopic ~  gender + spheq +  mommy,
                     family=binomial,val)

#remove variables for whcih betas deviate more than +/- 20% in val sample
dev_betas<-as.data.frame(final_dev_model$coefficients)
val_betas<-as.data.frame(final_val_model$coefficients)
compare<-dev_betas
compare$valbetas<-val_betas$`final_val_model$coefficients`


# Output 1: Beta stability
compare$ratio<-compare$valbetas/compare$`final_dev_model$coefficients`



#recaclualting accuracy statistics on dev sample

#calculating probabilities for dev and ROC 
prob=predict(final_dev_model,type=c("response"))
dev$prob=prob

g <- roc(myopic ~ prob, data = dev)
plot(g)  
auc(g)
#ideally above 0.7

# Output 2: Variable importance
varImp(final_dev_model, scale = FALSE)



# DIAGNOSTICS ON VALIDATION SAMPLE USING FINALISED DEV MODEL



#Running dev model on validation data

val_prob=predict(final_dev_model,newdata=subset(val,select=c("gender", "spheq" ,  "mommy")), type="response")
val$devprob<-val_prob

# Output 3. check ROC and compare wit dev roc
g <- roc(myopic ~ devprob, data = val)
plot(g)  
auc(g)
#ideally above 0.7


# Output 4. perform HL test
hl <- hoslem.test(val$myopic, val$devprob, g=10)
hl_val_data<-as.data.frame(cbind(hl$observed,hl$expected))
hl
#ideally one should not be able to reject the null hypothesis. More iterations could be required


# Output 5. actual vs predicted prob curve----Use the HL table here
hl_val_data$actual_prob <- hl_val_data$y1/(hl_val_data$y1+hl_val_data$y0)
hl_val_data$predicted_prob <- hl_val_data$yhat1/(hl_val_data$y1+hl_val_data$y0)
plot(hl_val_data$actual_prob,hl_val_data$predicted_prob)

plot(rev(hl_val_data$actual_prob),type = "o",col = "red", xlab = "Decile", ylab = "Avg. Prob", 
     main = "Actual vs. predicted")

lines(rev(hl_val_data$predicted_prob), type = "o", col = "blue")



# Output 6. KS statsitic....again using HL table here

#sort HL table in desc order of predicted prob
hl_val_data <- hl_val_data[order(-hl_val_data$predicted_prob),]


#calculate cummulative sum of responders and non-responder and conver to % of total resp and non resp

vec <- hl_val_data$y1
cummulative <- cumsum(vec)
hl_val_data$cummulative_resp<-cummulative/max(cummulative)

vec <- hl_val_data$y0
cummulative <- cumsum(vec)
hl_val_data$cummulative_nonresp<-cummulative/max(cummulative)

hl_val_data$diff<-hl_val_data$cummulative_resp-hl_val_data$cummulative_nonresp

KS<-max(hl_val_data$diff)*100
#Which decile?

#KS plot

plot(c(0,hl_val_data$cummulative_resp),type = "o",col = "red", xlab = "Decile", ylab = "Cummuative %", 
     main = "KS chart")

lines(c(0,hl_val_data$cummulative_nonresp), type = "o", col = "blue")




