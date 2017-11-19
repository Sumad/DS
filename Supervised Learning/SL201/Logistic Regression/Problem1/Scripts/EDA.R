### Read data ###
# Change dir home
dir <- "C:/Users/sumad.singh/Documents/Fractal Training Courses/SL201/test"
library(data.table)
library(dplyr)
library(car)
library(rlang)

source(file.path(dir, "scripts/functions.R"))

#1. READ DATA

data <- fread(input = file.path(dir, "Logistic Regression Data_Responder.csv"),na.strings = c("",NA),
      colClasses = c(rep("numeric",12),"integer"))
# Check dimensions
#dim(data)
#79797    13

# Fix names in dataset

colnames(data) <- c("Internal_rating","Credit_rating","Age","salary",             
                    "Overall_spend","Survey_score","Last_quarter_spend","Past_purchases_band",
                    "Premium_score","Purchase_capacity","net_worth","Bank_balance",       
                    "Responder")

#2. DIVIDE DATA INTO TRAIN AND TEST
# Oversample positive class, pick 70% from test, train will 

set.seed(101)
pos <- nrow(data[data$Responder == 1,])
neg <- nrow(data[data$Responder == 0,])
data_p <- data %>% filter(Responder == 1) %>% mutate(index = 1:pos)
data_n <- data %>% filter(Responder == 0) %>% mutate(index = 1:neg)

select_index_pos <- sample(x = data_p$index,size = round(0.7*pos,0),replace = FALSE)
select_index_neg <- sample(x = data_n$index,size = round(0.7*neg,0),replace = FALSE)

train_p <- data_p[select_index_pos,]
train_n <- data_n[select_index_neg,]

train <- as.data.frame(rbind(train_p,train_n))

test_p <- data_p[-select_index_pos,]
test_n <- data_n[-select_index_neg,]

test <- as.data.frame(rbind(test_p,test_n))

# table(test$Responder)
# 0     1 
# 22447 1493 
# 
# table(train$Responder)
# 0     1 
# 52375  3482 


#3 . CHECK DATA QUALITY
#3.1 CHECK FOR PRESENCE OF MISSING VALUES IN COMPLETE DATA
# Check for missing values in data
if(sum(complete.cases(data)) == nrow(data)){
  cat("No missing values in data","\n")
  }else {
  cat("Missing values in data","\n")
  }

#3.2 CHECK FOR PRESENCE OF OUTLIERS IN TRAIN
# 2.2.1 CHECK SUMMARY TO SEE SKEW IN THE VARIABLES, MEDIAN AND MEAN ARE VERY CLOSE, SO DISTRIBUTION
# OF INDIVUAL VARIABLES IS SYMMETRICAL
df.summary.train <- as.data.frame(apply(X = train,MARGIN = 2,FUN = "summary"))

# 3.3 VISUALLY EXPLORE UNIVARIATE DISTRIBUTIONS &
# IF LOG (ODDS) IS RELATED LINEARLY TO EACH OF VARIABLES
path <- file.path(dir,"plots")
eda(dataset = train,path = path )

# 3.3.1 OUTLIERS
# Looking at the box plot and 5 point summaries, a safe case of labeling outlier can be made
# for following variables, values
# a. Salary, Overall Spend > 600
# b.Past Purchase band > 700
# c. Premium score < 100
#d. Purchase capacity < 250

# 3.3.2 HYPOTHESIZED RELATIONSHIP 

#CHECK FOR CORRELATION BETWEEN PREDICTOR VARIABLES IN TRAIN
cor <- cor(x = train[1:12],method = "pearson")
write.csv(cor,file.path(dir,"results/cor.csv"))

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
