#### Data Exploration ####

## Columns need to be treated when using these 
# Numeric columns - 366,368,370/"Req_Resolved_PrevQ1"       "Query_Resolved_PrevQ1"     "Complaint_Resolved_PrevQ1"
# have '>' , thus  1, 1.0 are treated as charcters and separate values

# Cont. variables ::Get 5 point summary stats. , na counts and unique levels
# Cat. variables :: Get  na counts and unique levels
summ <- frame_summary(dataset = train_5)

df.summary.train.num <- summ[[3]]
df.summary.train.chr <- summ[[4]]

write.csv(df.summary.train.num, file.path(dir,"train_num_summary_v1.csv"))
write.csv(df.summary.train.chr, file.path(dir,"test_chr_summary_v1.csv"))

### Feature Derivation ###

## Use EDA for feature derivations

## How should EDA be done
#1. If target method is logistic
# 1.1 Check correlation among cont. predictors, consolidate highly colinear vars.
# 1.2 Univariate: Check individual variable distributions of cont. vars, and extent of outliers.
# For categoricals, check freq. distributions to spot thin segments that can be consolidated
# 1.3 Bivariate : Cont. vars: Check is log of odds increases with increase in deciles linearly.
# & Cat. vars: Check log of odds across categories
# 1.4 Come up with features, that a tree cannot  

#1.1
num.cor <- cor(x = summ[[1]], method = "pearson")
write.csv(num.cor, file.path(dir, "num_cor.csv"))
# New numeric variables using variables that are highly colinear i.e > 0.9
## VARS1 : CHANGE IN TOTAL AMOUNT DEBITED TO CREDITED QUARTER ON QUARTER BY MEDIUM - THIS WILL CARE FOR PICKING 
## SIGNAL OF MEDIUM PREFERENCES BY PEOPLE
### a. amount debited : credited for months 1,2,3, scaled in percentage ; and for months 4,5,6
### b. Quarter 1(4,5,6) to Quarter 2 (1,2,3) factor change in debit to credit

## VARS2 : CHANGE IN MAX(AVG. AMOUNT DEBITED)/ MAX(AVG. AMOUNT CREDITED) Q ON Q ; AVG = AMOUNT/COUNT) BY EACH MEDIUM
# IF GIVEN EACH QUARTER VALUES BY MEDIUM, TREE PICKS UP ABNORMALITIES BY MEDIUM
## VAR 3 : Change in (MAX AVG. AMOUNT DEBITED - MIN. AVG AMOUNT CREDITED I.E RANGE) by MEDIUM Q ON Q
## VAR 4 : Change in (MIN. AVG. AMOUNT DEBIT / MIN. AVG AMOUNT CREDIT) by MEDIUM Q ON Q
## VAR 5 : OVERALL Q TO Q CHANGE IN AVG. DEBIT TO AVG. CREDIT

## var 6 : SAME VARS.  using branch cw and branch cd - because these are not collinear with branch credit and 
## debit amounts


#2. If we go to decision tree - Why?
# 2.1 If we see non-linearities from bivariate plots in cont and cat variables
# 2.2 If we see lots of skewed distributions and outliers in lot of cont. variables
#2.3 Colinearity?

#3. If we go to random forest - Why?
# 3.1 
#4. If we go to boosted trees - Why?

### Distributions of continuous variables ###
# Compare distribution of variables in train and test
  ## to check if capping is required on cont. vars
  ## 
# Skew of variables
