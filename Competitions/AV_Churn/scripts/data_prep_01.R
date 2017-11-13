# 377 variables
 # 1 - id, 1 response
 # 375 potential predictors , usable in first iteration - 303, 72 removed
 #1. removing due to no variation - 48
 #2. high cardinality + missing : geo vars  - 3
 #3 less missing, removing for 1st iter - 3
 #4. removed due to high missingness - 18

# Out of 303, 257 - numeric; 32 - factors ; 14 - date

id.var <- "UCIC_ID"
response <- "Responders"  

#### Columns Classes All ####
col.classes.train <- c(rep("numeric",2),"character","numeric",
                 rep("character",4),"numeric",rep("character",2),
                 rep("numeric",235),"character",
                 rep("numeric",47), rep("character",22),
                 rep("character",14), # dates
                 rep("numeric",5),rep("character",4),
                 "numeric","character","numeric","character",
                 rep("numeric",34))

col.classes.test <-  col.classes.train[1:376]
  
#### MISSING VALUES TREATMENT ####  
  
### Variable with no variation - 48 ###
vars.remove1 <- c("ATM_C_prev1","MB_C_prev1", "MB_D_prev1", "POS_C_prev1",
                  "COUNT_ATM_C_prev1","COUNT_MB_C_prev1","COUNT_POS_C_prev1",
                  "ATM_C_prev2","MB_C_prev2", "MB_D_prev2", "POS_C_prev2",
                  "COUNT_ATM_C_prev2","COUNT_MB_C_prev2","COUNT_POS_C_prev2",
                  "ATM_C_prev3","MB_C_prev3", "MB_D_prev3", "POS_C_prev3",
                  "COUNT_ATM_C_prev3","COUNT_MB_C_prev3","COUNT_POS_C_prev3",
                  "ATM_C_prev4","MB_C_prev4", "MB_D_prev4", "POS_C_prev4",
                  "COUNT_ATM_C_prev4","COUNT_MB_C_prev4","COUNT_POS_C_prev4",
                  "ATM_C_prev5","MB_C_prev5", "MB_D_prev5", "POS_C_prev5",
                  "COUNT_ATM_C_prev5","COUNT_MB_C_prev5","COUNT_POS_C_prev5",
                  "ATM_C_prev6","MB_C_prev6", "MB_D_prev6", "POS_C_prev6",
                  "COUNT_ATM_C_prev6","COUNT_MB_C_prev6","COUNT_POS_C_prev6",
                  "CC_PREM_CLOSED_PREVQ1", "EDU_PREM_CLOSED_PREVQ1","TL_PREM_CLOSED_PREVQ1",
                  "EDU_Closed_PrevQ1","TL_Closed_PrevQ1", "LAS_TAG_LIVE")

### High cardinality and missing - 3 ###
# city and zip have missing also, brn_code only has high cardinality and uniques in train and test
vars.remove2 <- c("city", "zip", "brn_code")

### Less number of missing, need to try imputations - 3 ###

vars.remove3 <- c("FINAL_WORTH_prev1","ENGAGEMENT_TAG_prev1",
                  "Recency_of_Activity")

### High missingness > 10% ###

# These can be probably derived - 7 + 6 + 5 = 18
vars.remove4 <- c("Recency_of_CR_TXN", "Recency_of_DR_TXN","Recency_of_IB_TXN","Recency_of_ATM_TXN",
                  "Recency_of_BRANCH_TXN", "Recency_of_POS_TXN", "Recency_of_MB_TXN",
# Prefer to remove, else create a separate level                  
                  "Req_Logged_PrevQ1","Req_Resolved_PrevQ1","Query_Logged_PrevQ1",
                  "Query_Resolved_PrevQ1","Complaint_Logged_PrevQ1","Complaint_Resolved_PrevQ1",
# Could be 0/0 errors, prefer to remove or create a separate level
                  "Percent_Change_in_Credits","Percent_Change_in_FT_Bank",
                  "Percent_Change_in_FT_outside","Percent_Change_in_Self_Txn","Percent_Change_in_Big_Expenses")

### Duplicate variables ### 

vars.remove5 <- c("FRX_PrevQ1", "Billpay_Active_PrevQ1", "Billpay_Reg_ason_Prev1" , "Charges_cnt_PrevQ1")

### VARIABLES WITH IMPUTED VALUE 0 - 104###
miss.0 <- c("custinit_CR_amt_prev1","custinit_DR_amt_prev1","custinit_CR_cnt_prev1",
            "custinit_DR_cnt_prev1","ATM_amt_prev1","ATM_CW_Amt_prev1","ATM_CW_Cnt_prev1",
            "BRN_CW_Amt_prev1","BRN_CW_Cnt_prev1","BRN_CASH_Dep_Amt_prev1",
            "BRN_CASH_Dep_Cnt_prev1","custinit_CR_amt_prev2","custinit_DR_amt_prev2","custinit_CR_cnt_prev2",
            "custinit_DR_cnt_prev2","ATM_amt_prev2","ATM_CW_Amt_prev2","ATM_CW_Cnt_prev2","BRN_CW_Amt_prev2",
            "BRN_CW_Cnt_prev2","BRN_CASH_Dep_Amt_prev2","BRN_CASH_Dep_Cnt_prev2","custinit_CR_amt_prev3",
            "custinit_DR_amt_prev3","custinit_CR_cnt_prev3","custinit_DR_cnt_prev3","ATM_amt_prev3","ATM_CW_Amt_prev3",
            "ATM_CW_Cnt_prev3","BRN_CW_Amt_prev3","BRN_CW_Cnt_prev3","BRN_CASH_Dep_Amt_prev3","BRN_CASH_Dep_Cnt_prev3",
            "custinit_CR_amt_prev4","custinit_DR_amt_prev4","custinit_CR_cnt_prev4","custinit_DR_cnt_prev4",
            "ATM_amt_prev4","ATM_CW_Amt_prev4","ATM_CW_Cnt_prev4","BRN_CW_Amt_prev4","BRN_CW_Cnt_prev4",
            "BRN_CASH_Dep_Amt_prev4","BRN_CASH_Dep_Cnt_prev4","custinit_CR_amt_prev5","custinit_DR_amt_prev5",
            "custinit_CR_cnt_prev5","custinit_DR_cnt_prev5","ATM_amt_prev5","ATM_CW_Amt_prev5",
            "ATM_CW_Cnt_prev5","BRN_CW_Amt_prev5","BRN_CW_Cnt_prev5","BRN_CASH_Dep_Amt_prev5",
            "BRN_CASH_Dep_Cnt_prev5","custinit_CR_amt_prev6","custinit_DR_amt_prev6",
            "custinit_CR_cnt_prev6","custinit_DR_cnt_prev6","ATM_amt_prev6","ATM_CW_Amt_prev6",
            "ATM_CW_Cnt_prev6","BRN_CW_Amt_prev6","BRN_CW_Cnt_prev6","BRN_CASH_Dep_Amt_prev6",
            "BRN_CASH_Dep_Cnt_prev6","FRX_PrevQ1","Billpay_Active_PrevQ1","Billpay_Reg_ason_Prev1",
            "NO_OF_FD_BOOK_PrevQ1","NO_OF_FD_BOOK_PrevQ2","NO_OF_RD_BOOK_PrevQ1","NO_OF_RD_BOOK_PrevQ2",
            "count_No_of_MF_PrevQ1","count_No_of_MF_PrevQ2","AGRI_PREM_CLOSED_PREVQ1","AL_CNC_PREM_CLOSED_PREVQ1",
            "AL_PREM_CLOSED_PREVQ1","BL_PREM_CLOSED_PREVQ1","CE_PREM_CLOSED_PREVQ1","CV_PREM_CLOSED_PREVQ1",
            "OTHER_LOANS_PREM_CLOSED_PREVQ1","PL_PREM_CLOSED_PREVQ1","RD_PREM_CLOSED_PREVQ1","FD_PREM_CLOSED_PREVQ1",
            "TWL_PREM_CLOSED_PREVQ1","AGRI_Closed_PrevQ1","AL_CNC_Closed_PrevQ1","AL_Closed_PrevQ1",
            "BL_Closed_PrevQ1","CC_CLOSED_PREVQ1","CE_Closed_PrevQ1","CV_Closed_PrevQ1","GL_Closed_PrevQ1",
            "OTHER_LOANS_Closed_PrevQ1","PL_Closed_PrevQ1","RD_CLOSED_PREVQ1","FD_CLOSED_PREVQ1",
            "TWL_Closed_PrevQ1","DEMAT_CLOSED_PREV1YR","SEC_ACC_CLOSED_PREV1YR","Charges_cnt_PrevQ1",
            "NO_OF_COMPLAINTS","NO_OF_CHEQUE_BOUNCE_V1")

### VARIABLES WITH IMPUTED VALUE N - 22###
miss.n <- c("EMAIL_UNSUBSCRIBE","AGRI_TAG_LIVE","AL_CNC_TAG_LIVE","AL_TAG_LIVE","BL_TAG_LIVE",
"CC_TAG_LIVE","CE_TAG_LIVE","CV_TAG_LIVE","DEMAT_TAG_LIVE","EDU_TAG_LIVE",
"GL_TAG_LIVE","HL_TAG_LIVE","SEC_ACC_TAG_LIVE","INS_TAG_LIVE",
"MF_TAG_LIVE","OTHER_LOANS_TAG_LIVE","PL_TAG_LIVE","RD_TAG_LIVE","FD_TAG_LIVE",
"TL_TAG_LIVE","TWL_TAG_LIVE","lap_tag_live")


### VARIABLES WITH IMPUTED VALUE 'MISSING' - 2###
miss.MISSING <- c("OCCUP_ALL_NEW","dependents")
                  
