### Read data, column selection, missing value addressal ###
dir <- "C:/Users/sumad.singh/Documents/DS/Competitions/AV_Churn"
library(data.table)
library(dplyr)
source(file.path(dir,"scripts/data_prep_01.R"))
source(file.path(dir,"scripts/functions.R"))

# Read Data
train.file <- fread(input = file.path(dir,"train.csv"),na.strings = c("",NA),
                    colClasses = col.classes.train, nrows = 300000, stringsAsFactors = FALSE)
#dim(train.file)
#300000    377
test.file <- fread(input = file.path(dir,"test.csv"),na.strings = c("",NA),
                   colClasses = col.classes.test, nrows = 200000,stringsAsFactors = FALSE)
#dim(test.file)
#200000    376

# Make column selection
vars.remove <- c(id.var,vars.remove1,vars.remove2,vars.remove3,vars.remove4,vars.remove5)
vars.keep.train <- colnames(train.file)[!(colnames(train.file) %in% vars.remove)]
train_1 <- train.file %>% select(vars.keep.train)
#dim(train_1)
# 300000    304

vars.keep.test <- colnames(test.file)[!(colnames(test.file) %in% vars.remove)]
test_1 <- test.file %>% select(vars.keep.test)
#dim(test_1)
# 200000    303

# Fill missing values with 0, N and 'MISSING'
train_2 <- treat.miss(dataset = train_1 ,vars = miss.0,value = 0)
train_3 <- treat.miss(dataset = train_2,vars = miss.n ,value = "N")
train_4 <- treat.miss(dataset = train_3,vars = miss.MISSING, value = "MISSING" )

test_2 <- treat.miss(dataset = test_1 ,vars = miss.0,value = 0)
test_3 <- treat.miss(dataset = test_2, vars = miss.n ,value = "N")
test_4 <- treat.miss(dataset = test_3, vars = miss.MISSING, value = "MISSING" )

### Convert date columns to date class ### 
# Exploring dates seems not to yield data that is specific to dates
#train_sub <- train_4 %>% select(ends_with(match = "DATE"))
#head(train_sub,20)
#table(train_sub$AL_CNC_DATE,useNA = "ifany")
#head(train_sub$AL_DATE,50)

### REMOVE DATE COLUMNS -14 ###
nondate.vars <- grep(pattern = "DATE",x = colnames(train_4),value = TRUE,fixed = TRUE,invert = TRUE)
train_5 <- train_4 %>% select(nondate.vars)
test_5 <- test_4 %>% select(nondate.vars[!nondate.vars %in% "Responders"])

rm(list = list(train_1,train_2,train_3,test_1,test_2,test_3))

### 
