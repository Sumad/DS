### Transformations based on hypothesis, and looking at correlations of numeric varibles ###

## 1st LEVEL 
train_6 <- train_5 %>% 
#1. AVG. DEBIT AND CREDIT, AVG. BEING AMOUNT/COUNT OVER A QTR PERIOD 
  # ATM Channel Avg. credit and debit over quarter - No credit exists
  mutate(
        AVG_ATM_D_prevQ1 = (ATM_D_prev1 + ATM_D_prev2 + ATM_D_prev3)/
          (COUNT_ATM_D_prev1 + COUNT_ATM_D_prev2 + COUNT_ATM_D_prev3),
        AVG_ATM_D_prevQ2 = (ATM_D_prev4 + ATM_D_prev5 + ATM_D_prev6)/
          (COUNT_ATM_D_prev4 + COUNT_ATM_D_prev5 + COUNT_ATM_D_prev6),
  # BRANCH
  AVG_BRANCH_C_prevQ1 = (BRANCH_C_prev1 + BRANCH_C_prev2 + BRANCH_C_prev3)/
    (COUNT_BRANCH_C_prev1 + COUNT_BRANCH_C_prev2 + COUNT_BRANCH_C_prev3),
  AVG_BRANCH_C_prevQ2 = (BRANCH_C_prev4 + BRANCH_C_prev5 + BRANCH_C_prev6)/
    (COUNT_BRANCH_C_prev4 + COUNT_BRANCH_C_prev5 + COUNT_BRANCH_C_prev6),
  AVG_BRANCH_D_prevQ1 = (BRANCH_D_prev1 + BRANCH_D_prev2 + BRANCH_D_prev3)/
    (COUNT_BRANCH_D_prev1 + COUNT_BRANCH_D_prev2 + COUNT_BRANCH_D_prev3),
  AVG_BRANCH_D_prevQ2 = (BRANCH_D_prev4 + BRANCH_D_prev5 + BRANCH_D_prev6)/
    (COUNT_BRANCH_D_prev4 + COUNT_BRANCH_D_prev5 + COUNT_BRANCH_D_prev6),
  # IB
  AVG_IB_C_prevQ1 = (IB_C_prev1 + IB_C_prev2 + IB_C_prev3)/
    (COUNT_IB_C_prev1 + COUNT_IB_C_prev2 + COUNT_IB_C_prev3),
  AVG_IB_C_prevQ2 = (IB_C_prev4 + IB_C_prev5 + IB_C_prev6)/
    (COUNT_IB_C_prev4 + COUNT_IB_C_prev5 + COUNT_IB_C_prev6),
  AVG_IB_D_prevQ1 = (IB_D_prev1 + IB_D_prev2 + IB_D_prev3)/
    (COUNT_IB_D_prev1 + COUNT_IB_D_prev2 + COUNT_IB_D_prev3),
  AVG_IB_D_prevQ2 = (IB_D_prev4 + IB_D_prev5 + IB_D_prev6)/
    (COUNT_IB_D_prev4 + COUNT_IB_D_prev5 + COUNT_IB_D_prev6),
  
  # MB - only debit counts exists, debit counts and amounts don't, neither do credit amounts 
  # Not doing any transformation at this level
  
 
   # POS - ONLY DEBIT COUNTS AND AMOUNTS KNOWN
  AVG_POS_D_prevQ1 = (POS_D_prev1 + POS_D_prev2 + POS_D_prev3)/
    (COUNT_POS_D_prev1 + COUNT_POS_D_prev2 + COUNT_POS_D_prev3),
  AVG_POS_D_prevQ2 = (POS_D_prev4 + POS_D_prev5 + POS_D_prev6)/
    (COUNT_POS_D_prev4 + COUNT_POS_D_prev5 + COUNT_POS_D_prev6),
  
#2. AVG. CREDIT AND DEBIT AT MONTH LEVEL, AVG. IS AMOUNT / COUNT
  # FOR EACH CHANNEL
  # For ATM, only debit info. exists
  AVG_ATM_D_prev1 = ATM_D_prev1/COUNT_ATM_D_prev1,
  AVG_ATM_D_prev2 = ATM_D_prev2/COUNT_ATM_D_prev2,
  AVG_ATM_D_prev3 = ATM_D_prev3/COUNT_ATM_D_prev3,
  AVG_ATM_D_prev4 = ATM_D_prev4/COUNT_ATM_D_prev4,
  AVG_ATM_D_prev5 = ATM_D_prev5/COUNT_ATM_D_prev5,
  AVG_ATM_D_prev6 = ATM_D_prev6/COUNT_ATM_D_prev6,

  AVG_BRANCH_C_prev1 = BRANCH_C_prev1/COUNT_BRANCH_C_prev1,
  AVG_BRANCH_C_prev2 = BRANCH_C_prev2/COUNT_BRANCH_C_prev2,
  AVG_BRANCH_C_prev3 = BRANCH_C_prev3/COUNT_BRANCH_C_prev3,
  AVG_BRANCH_C_prev4 = BRANCH_C_prev4/COUNT_BRANCH_C_prev4,
  AVG_BRANCH_C_prev5 = BRANCH_C_prev5/COUNT_BRANCH_C_prev5,
  AVG_BRANCH_C_prev6 = BRANCH_C_prev6/COUNT_BRANCH_C_prev6,
  AVG_BRANCH_D_prev1 = BRANCH_D_prev1/COUNT_BRANCH_D_prev1,
  AVG_BRANCH_D_prev2 = BRANCH_D_prev2/COUNT_BRANCH_D_prev2,
  AVG_BRANCH_D_prev3 = BRANCH_D_prev3/COUNT_BRANCH_D_prev3,
  AVG_BRANCH_D_prev4 = BRANCH_D_prev4/COUNT_BRANCH_D_prev4,
  AVG_BRANCH_D_prev5 = BRANCH_D_prev5/COUNT_BRANCH_D_prev5,
  AVG_BRANCH_D_prev6 = BRANCH_D_prev6/COUNT_BRANCH_D_prev6,

  AVG_IB_C_prev1 = IB_C_prev1/COUNT_IB_C_prev1,
  AVG_IB_C_prev2 = IB_C_prev2/COUNT_IB_C_prev2,
  AVG_IB_C_prev3 = IB_C_prev3/COUNT_IB_C_prev3,
  AVG_IB_C_prev4 = IB_C_prev4/COUNT_IB_C_prev4,
  AVG_IB_C_prev5 = IB_C_prev5/COUNT_IB_C_prev5,
  AVG_IB_C_prev6 = IB_C_prev6/COUNT_IB_C_prev6,
  AVG_IB_D_prev1 = IB_D_prev1/COUNT_IB_D_prev1,
  AVG_IB_D_prev2 = IB_D_prev2/COUNT_IB_D_prev2,
  AVG_IB_D_prev3 = IB_D_prev3/COUNT_IB_D_prev3,
  AVG_IB_D_prev4 = IB_D_prev4/COUNT_IB_D_prev4,
  AVG_IB_D_prev5 = IB_D_prev5/COUNT_IB_D_prev5,
  AVG_IB_D_prev6 = IB_D_prev6/COUNT_IB_D_prev6,

# MB
# Monthly average no applicable

# Only debit data exists for POS
AVG_POS_D_prev1 = POS_D_prev1/COUNT_POS_D_prev1,
AVG_POS_D_prev2 = POS_D_prev2/COUNT_POS_D_prev2,
AVG_POS_D_prev3 = POS_D_prev3/COUNT_POS_D_prev3,
AVG_POS_D_prev4 = POS_D_prev4/COUNT_POS_D_prev4,
AVG_POS_D_prev5 = POS_D_prev5/COUNT_POS_D_prev5,
AVG_POS_D_prev6 = POS_D_prev6/COUNT_POS_D_prev6,

#3. FIND THE TOTAL AVG. CREDIT AND DEBIT (COMBINING) channels, EACH MONTH
AVG_C_prev1 = C_prev1/count_C_prev1,
AVG_C_prev2 = C_prev2/count_C_prev2,
AVG_C_prev3 = C_prev3/count_C_prev3,
AVG_C_prev4 = C_prev4/count_C_prev4,
AVG_C_prev5 = C_prev5/count_C_prev5,
AVG_C_prev6 = C_prev6/count_C_prev6,
AVG_D_prev1 = D_prev1/count_D_prev1,
AVG_D_prev2 = D_prev2/count_D_prev2,
AVG_D_prev3 = D_prev3/count_D_prev3,
AVG_D_prev4 = D_prev4/count_D_prev4,
AVG_D_prev5 = D_prev5/count_D_prev5,
AVG_D_prev6 = D_prev6/count_D_prev6,

AVG_C_prevQ1 = (C_prev1 + C_prev2 + C_prev3)/ (COUNT_C_prev1 + COUNT_C_prev2 + COUNT_C_prev3),
AVG_C_prevQ2 = (C_prev4 + C_prev5 + C_prev6)/ (COUNT_C_prev4 + COUNT_C_prev5 + COUNT_C_prev6),
AVG_D_prevQ1 = (D_prev1 + D_prev2 + D_prev3)/ (COUNT_D_prev1 + COUNT_D_prev2 + COUNT_D_prev3),
AVG_D_prevQ2 = (D_prev4 + D_prev5 + D_prev6)/ (COUNT_D_prev4 + COUNT_D_prev5 + COUNT_D_prev6),

#4. Monthly D & C factors for BRN_CASH

AVG_BRN_CASH_DEP_prev1 = BRN_CASH_Dep_Amt_prev1/BRN_CASH_Dep_Cnt_prev1,
AVG_BRN_CASH_DEP_prev2 = BRN_CASH_Dep_Amt_prev1/BRN_CASH_Dep_Cnt_prev2,
AVG_BRN_CASH_DEP_prev3 = BRN_CASH_Dep_Amt_prev1/BRN_CASH_Dep_Cnt_prev3,
AVG_BRN_CASH_DEP_prev4 = BRN_CASH_Dep_Amt_prev1/BRN_CASH_Dep_Cnt_prev4,
AVG_BRN_CASH_DEP_prev5 = BRN_CASH_Dep_Amt_prev1/BRN_CASH_Dep_Cnt_prev5,
AVG_BRN_CASH_DEP_prev6 = BRN_CASH_Dep_Amt_prev1/BRN_CASH_Dep_Cnt_prev6,

AVG_BRN_CASH_CW_prev1 = BRN_CW_Amt_prev1/BRN_CW_Cnt_prev1,
AVG_BRN_CASH_CW_prev2 = BRN_CW_Amt_prev2/BRN_CW_Cnt_prev2,
AVG_BRN_CASH_CW_prev3 = BRN_CW_Amt_prev3/BRN_CW_Cnt_prev3,
AVG_BRN_CASH_CW_prev4 = BRN_CW_Amt_prev4/BRN_CW_Cnt_prev4,
AVG_BRN_CASH_CW_prev5 = BRN_CW_Amt_prev5/BRN_CW_Cnt_prev5,
AVG_BRN_CASH_CW_prev6 = BRN_CW_Amt_prev6/BRN_CW_Cnt_prev6


)

vars <- colnames(train_6)[!colnames(train_6) %in% colnames(train_5)] 
train6.subset <- select(train_6,vars)
# QUALITY CHECK
#nan.count <- apply(X = train6.subset,MARGIN = 2,FUN = "nan_count")
#inf.count <- apply(X = train6.subset,MARGIN = 2,FUN = "Inf_count")
#var <- colnames(train6.subset)
#train.6.examine <- data.frame(var,nan.count,inf.count)
#write.csv(train.6.examine, file.path(dir,"train6_examine.csv"))

# FIX AND check
train6.subset2 <- fill.nan.inf(dataset = train6.subset)
#nan.count <- apply(X = train6.subset2,MARGIN = 2,FUN = "nan_count")
#inf.count <- apply(X = train6.subset2,MARGIN = 2,FUN = "Inf_count")
#var <- colnames(train6.subset2)
#train.6.examinev2 <- data.frame(var,nan.count,inf.count)
#write.csv(train.6.examinev2, file.path(dir,"train6_examinev2.csv"))


## 2ND LEVEL

train6.subset3 <- train6.subset2 %>% mutate(
  #1. Per Quarter AVG D to C variables by medium 
  # ATM does not have credit variables
  # BRANCH
  AVG_BRANCH_DtoC_prevQ1 = round(AVG_BRANCH_D_prevQ1/AVG_BRANCH_C_prevQ1, 2),
  AVG_BRANCH_DtoC_prevQ2 = round(AVG_BRANCH_D_prevQ2/AVG_BRANCH_C_prevQ2,2),
  # IB
  AVG_IB_DtoC_prevQ1 = round(AVG_IB_D_prevQ1/AVG_IB_C_prevQ1, 2),
  AVG_IB_DtoC_prevQ2 = round(AVG_IB_D_prevQ2/AVG_IB_C_prevQ2,2),
  # MB -  Only has debit count
  
  # POS does not have credit variables
  
  #2. Within Q max debit/credit ratio
  
  # BRANCH
  WITHINQMAX_BRANCH_DtoC_PREVQ1 = round(max(AVG_BRANCH_D_prev1, AVG_BRANCH_D_prev2, AVG_BRANCH_D_prev3)/ 
          max(AVG_BRANCH_C_prev1, AVG_BRANCH_C_prev2, AVG_BRANCH_C_prev3),2),
  WITHINQMAX_BRANCH_DtoC_PREVQ2 = round(max(AVG_BRANCH_D_prev4, AVG_BRANCH_D_prev5, AVG_BRANCH_D_prev6)/ 
                                           max(AVG_BRANCH_C_prev4, AVG_BRANCH_C_prev5, AVG_BRANCH_C_prev6),2),
  
  WITHINQMIN_BRANCH_DtoC_PREVQ1 = round(min(AVG_BRANCH_D_prev1, AVG_BRANCH_D_prev2, AVG_BRANCH_D_prev3)/ 
                                           min(AVG_BRANCH_C_prev1, AVG_BRANCH_C_prev2, AVG_BRANCH_C_prev3),2),
  WITHINQMIN_BRANCH_DtoC_PREVQ2 <- round(min(AVG_BRANCH_D_prev4, AVG_BRANCH_D_prev5, AVG_BRANCH_D_prev6)/ 
                                           min(AVG_BRANCH_C_prev4, AVG_BRANCH_C_prev5, AVG_BRANCH_C_prev6),2),
  
  # IB
  WITHINQMAX_IB_DtoC_PREVQ1 = round(max(AVG_IB_D_prev1, AVG_IB_D_prev2, AVG_IB_D_prev3)/ 
                                          max(AVG_IB_C_prev1, AVG_IB_C_prev2, AVG_IB_C_prev3),2),
  WITHINQMAX_IB_DtoC_PREVQ2 = round(max(AVG_IB_D_prev4, AVG_IB_D_prev5, AVG_IB_D_prev6)/ 
                                          max(AVG_IB_C_prev4, AVG_IB_C_prev5, AVG_IB_C_prev6),2),
  
  WITHINQMIN_IB_DtoC_PREVQ1 = round(min(AVG_IB_D_prev1, AVG_IB_D_prev2, AVG_IB_D_prev3)/ 
                                          min(AVG_IB_C_prev1, AVG_IB_C_prev2, AVG_IB_C_prev3),2),
  WITHINQMIN_IB_DtoC_PREVQ2 <- round(min(AVG_IB_D_prev4, AVG_IB_D_prev5, AVG_IB_D_prev6)/ 
                                           min(AVG_IB_C_prev4, AVG_IB_C_prev5, AVG_IB_C_prev6),2),
  
  #3. Within Q max debit/credit ratio
  AVG_OVERALL_DtoC_prevQ1 = round(AVG_D_prevQ1/AVG_C_prevQ1, 2),
  AVG_OVERALL_DtoC_prevQ2 = round(AVG_D_prevQ2/AVG_C_prevQ2,2),
  
  WITHINQMIN_OVERALL_DtoC_PREVQ1 = round(min(AVG_D_prev1, AVG_D_prev2, AVG_D_prev3)/ 
                                           min(AVG_C_prev1, AVG_C_prev2, AVG_C_prev3),2),
  WITHINQMIN_OVERALL_DtoC_PREVQ2 = round(min(AVG_D_prev4, AVG_D_prev5, AVG_D_prev6)/ 
                                           min(AVG_C_prev4, AVG_C_prev5, AVG_C_prev6),2) ,
  WITHINQMAX_OVERALL_DtoC_PREVQ1 = round(max(AVG_D_prev1, AVG_D_prev2, AVG_D_prev3)/ 
                                           max(AVG_C_prev1, AVG_C_prev2, AVG_C_prev3),2),
  WITHINQMAX_OVERALL_DtoC_PREVQ2 = round(max(AVG_D_prev4, AVG_D_prev5, AVG_D_prev6)/ 
                                           max(AVG_C_prev4, AVG_C_prev5, AVG_C_prev6),2),
  
  #4. BRNCH_CW and BRNC_DEP ratio month on month spaced by 3 months
  AVG_BRN_CASH_CWtoD_prev1 = AVG_BRN_CASH_CW_prev1/AVG_BRN_CASH_DEP_prev1,
  AVG_BRN_CASH_CWtoD_prev2 = AVG_BRN_CASH_CW_prev2/AVG_BRN_CASH_DEP_prev2,
  AVG_BRN_CASH_CWtoD_prev3 = AVG_BRN_CASH_CW_prev3/AVG_BRN_CASH_DEP_prev3,
  AVG_BRN_CASH_CWtoD_prev4 = AVG_BRN_CASH_CW_prev4/AVG_BRN_CASH_DEP_prev4,
  AVG_BRN_CASH_CWtoD_prev5 = AVG_BRN_CASH_CW_prev5/AVG_BRN_CASH_DEP_prev5,
  AVG_BRN_CASH_CWtoD_prev6 = AVG_BRN_CASH_CW_prev6/AVG_BRN_CASH_DEP_prev6,
  
  #5. CUSTOMER INITITATED CREDIT AS PERCENT OF TOTAL CREDIT
  PCT_CUST_INIT_CREDIT_prev1 = custinit_CR_amt_prev1/C_prev1,
  PCT_CUST_INIT_CREDIT_prev2 = custinit_CR_amt_prev2/C_prev2,
  PCT_CUST_INIT_CREDIT_prev3 = custinit_CR_amt_prev3/C_prev3,
  PCT_CUST_INIT_CREDIT_prev4 = custinit_CR_amt_prev4/C_prev4,
  PCT_CUST_INIT_CREDIT_prev5 = custinit_CR_amt_prev5/C_prev5,
  PCT_CUST_INIT_CREDIT_prev6 = custinit_CR_amt_prev6/C_prev6,
  
  #6. Average investments in each quarter
  AVG_FD_prevQ1 = FD_AMOUNT_BOOK_PrevQ1/NO_OF_FD_BOOK_PrevQ1,
  AVG_FD_prevQ2 = FD_AMOUNT_BOOK_PrevQ2/NO_OF_FD_BOOK_PrevQ2,
  AVG_RD_prevQ1 = RD_AMOUNT_BOOK_PrevQ1/NO_OF_RD_BOOK_PrevQ1,
  AVG_RD_prevQ2 = RD_AMOUNT_BOOK_PrevQ2/NO_OF_RD_BOOK_PrevQ2,
  AVG_MF_prevQ1 = Total_Invest_in_MF_PrevQ1/count_No_of_MF_PrevQ1,
  AVG_MF_prevQ2 = Total_Invest_in_MF_PrevQ2/count_No_of_MF_PrevQ2
  )

# CHECK and FIX NaN and Inf

## 3RD LEVEL is for movement of D/C or D to D or Count to Count ratios 

train6.subset4 <- train6.subset3 %>% mutate(
  #1. Q to Q of ratios of D/C or D to D or Count to Count BY MEDIUM
  # ATM, POS TAKEN CARE AT LEVEL 2
  AVG_ATM_DtoD_Q_Q = round(100 * AVG_ATM_D_prevQ1/ AVG_ATM_D_prevQ2 ,2),
  AVG_BRANCH_DtoC_Q_Q = round(100 * AVG_BRANCH_DtoC_prevQ1/AVG_BRANCH_DtoC_prevQ2,2),
  AVG_IB_DtoC_Q_Q = round(100 * AVG_IB_DtoC_prevQ1/AVG_IB_DtoC_prevQ2,2),
  TOTAL_COUNT_MB_D_Q_Q = round(100*(COUNT_MB_D_prev1 + COUNT_MB_D_prev2 + COUNT_MB_D_prev3) / 
                                 (COUNT_MB_D_prev4 + COUNT_MB_D_prev5 + COUNT_MB_D_prev6),2),
  AVG_POS_DtoD_Q_Q = round(100 *AVG_POS_D_prevQ1/AVG_POS_D_prevQ2,2),
  
  
  #2. Q to Q on D/C ratios for max, min
  # ATM
  WITHINQMAX_ATM_DtoD_Q_Q = round(100 *max(AVG_ATM_D_prev1, AVG_ATM_D_prev2, AVG_ATM_D_prev3)/ 
                                    max(AVG_ATM_D_prev4, AVG_ATM_D_prev5, AVG_ATM_D_prev6),2),
  WITHINQMIN_ATM_DtoD_Q_Q = round(100 * min(AVG_ATM_D_prev1, AVG_ATM_D_prev2, AVG_ATM_D_prev3)/ 
                                    min(AVG_ATM_D_prev4, AVG_ATM_D_prev5, AVG_ATM_D_prev6),2),
  
  # BRANCH
  WITHINQMAX_BRANCH_DtoC_Q_Q = round(100 * WITHINQMAX_BRANCH_DtoC_PREVQ1/WITHINQMAX_BRANCH_DtoC_PREVQ2,2),
  WITHINQMIN_BRANCH_DtoC_Q_Q = round(100 * WITHINQMIN_BRANCH_DtoC_PREVQ1/WITHINQMIN_BRANCH_DtoC_PREVQ2,2),
  
  # IB
  WITHINQMAX_IB_DtoC_Q_Q = round(100 * WITHINQMAX_IB_DtoC_PREVQ1/WITHINQMAX_IB_DtoC_PREVQ2,2),
  WITHINQMIN_IB_DtoC_Q_Q = round(100 * WITHINQMIN_IB_DtoC_PREVQ1/WITHINQMIN_IB_DtoC_PREVQ2,2),
  
  # MB
  COUNT_MB_D_MAX_Q_Q = round(100* max(COUNT_MB_D_prev1,COUNT_MB_D_prev2,COUNT_MB_D_prev3)/
    max(COUNT_MB_D_prev4,COUNT_MB_D_prev5,COUNT_MB_D_prev6),2) ,
  
  COUNT_MB_D_MIN_Q_Q = round(100* min(COUNT_MB_D_prev1,COUNT_MB_D_prev2,COUNT_MB_D_prev3)/
    min(COUNT_MB_D_prev4,COUNT_MB_D_prev5,COUNT_MB_D_prev6), 2) ,
  
  # POS
  WITHINQMAX_POS_DtoD_Q_Q = round(100 * max(AVG_POS_D_prev1, AVG_POS_D_prev2, AVG_POS_D_prev3)/ 
                                    max(AVG_POS_D_prev4, AVG_POS_D_prev5, AVG_POS_D_prev6),2),
  WITHINQMIN_POS_DtoD_Q_Q = round(100 * min(AVG_POS_D_prev1, AVG_POS_D_prev2, AVG_POS_D_prev3)/ 
                                    min(AVG_POS_D_prev4, AVG_POS_D_prev5, AVG_POS_D_prev6),2),
  
  #3. Overall
  
  AVG_OVERALL_DtoC_Q_Q = round(100 * AVG_OVERALL_DtoC_prevQ1/ AVG_OVERALL_DtoC_prevQ2,2),
  WITHINQMIN_OVERALL_DtoC_Q_Q = round( 100 * WITHINQMIN_OVERALL_DtoC_PREVQ1/WITHINQMIN_OVERALL_DtoC_PREVQ2,2),
  WITHINQMAX_OVERALL_DtoC_Q_Q = round( 100 * WITHINQMAX_OVERALL_DtoC_PREVQ1/WITHINQMAX_OVERALL_DtoC_PREVQ2,2),
  
  #4. Use CW to capture cycles Month on Month cyclic anomalies if any
  
 M1_M4_CWtoD = round(100 * AVG_BRN_CASH_CWtoD_prev1/AVG_BRN_CASH_CWtoD_prev4,2),
 M2_M5_CWtoD = round(100 * AVG_BRN_CASH_CWtoD_prev2/AVG_BRN_CASH_CWtoD_prev5,2),
 M3_M6_CWtoD = round(100 * AVG_BRN_CASH_CWtoD_prev3/AVG_BRN_CASH_CWtoD_prev6,2),
 
 # 5. SHIFTS IN CR_AMB
 M1_M4_AMB = round(100 * CR_AMB_Prev1/CR_AMB_Prev4,2),
 M2_M5_AMB = round(100 * CR_AMB_Prev2/CR_AMB_Prev5,2),
 M3_M6_AMB = round(100 * CR_AMB_Prev3/CR_AMB_Prev6,2),
 
 #6. SHIFTS IN CUST. INITIATED CREDIT
 M1_M4_CINIT_CREDIT = round(100 * PCT_CUST_INIT_CREDIT_prev1/ PCT_CUST_INIT_CREDIT_prev4,2),
 M2_M5_CINIT_CREDIT = round(100 * PCT_CUST_INIT_CREDIT_prev2/ PCT_CUST_INIT_CREDIT_prev5,2),
 M3_M6_CINIT_CREDIT = round(100 * PCT_CUST_INIT_CREDIT_prev3/ PCT_CUST_INIT_CREDIT_prev6,2),
 
 # SHIFTS IN INVESTMENTS
 AVG_FD_Q_Q = AVG_FD_prevQ1 / AVG_FD_prevQ2,
 AVG_RD_Q_Q = AVG_RD_prevQ1 / AVG_RD_prevQ2,
 AVG_MF_Q_Q = AVG_MF_prevQ1 / AVG_MF_prevQ2,
 DMAT_Q_Q = Dmat_Investing_PrevQ1/Dmat_Investing_PrevQ2,
 
 # SERVICE VARIABLES
 AVG_CASH_WD_6MNTHS = round(CASH_WD_AMT_Last6/CASH_WD_CNT_Last6,2),
 AVG_CHARGES_PREVQ1 = round(Charges_PrevQ1/Charges_cnt_PrevQ1_N,2),
 
 # ADD'L CASH FLOW VARIABLES
 I_CNR_Q_Q = round( 100 * I_CNR_PrevQ1 / I_CNR_PrevQ2,2)
)

### Transformations after looking at variable distributions b/w train and test ###
