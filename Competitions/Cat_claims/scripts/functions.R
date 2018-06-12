library(pROC)
library(ResourceSelection)
library(caret)

############# Data Manipulation Functions ################################

# Function to get NAs in vector

vec_na_check <- function(vec){
  return(sum(is.na(vec)))
} 

vec_unique_check <- function(vec){
  q <- length(unique(vec,na.rm = TRUE))
  return(q)
}

# Function to check data quality in data frames comprising of cat and cont variables

dq <- function(cat.vars = NULL, cont.vars = NULL, response.var = NULL, train, test, ...){
  
  # function to return variable wise attributes in two or more data sets for cont and 
  #  cat variables supplied as vectors
  # List of attributes returned are below
  
  ##                    train         test
  ## cat_na              10           5     # extent of missing
  ## cat_levels           5           4     # can see that a level is missing entirely
  ## cat_lvl_pct        10%          20%    # can see if distribution of levels within a var.
  # varies greatly, or if a level is too thin to be merged into another
  
  ## cont_na            5             4
  ## cont_uniques       100           400  # Check if conti. has a large spread of values, as expected
  ## cont_min           3             4
  ## cont_max           200           300  # Check Range, 
  
  
  # Get NA and UNIQUES in a datframe
  train.na <- apply(X = train, MARGIN = 2,FUN = "vec_na_check")
  train.unique <- apply(X = train ,MARGIN = 2,FUN = "vec_unique_check")
  
  test.na <- apply(X = test, MARGIN = 2,FUN = "vec_na_check")
  test.unique <- apply(X = test ,MARGIN = 2,FUN = "vec_unique_check")
  
  
  df.train <- data.frame(var = names(train.na),train_na = train.na, 
                         train_unique = train.unique,stringsAsFactors = FALSE)
  
  df.test <- data.frame(var = names(test.na),test_na = test.na, 
                        test_unique = test.unique,stringsAsFactors = FALSE)
  df.test <- rbind(df.test,c(response.var, 0,0))
  df <- merge(x = df.train,y = df.test,by = "var", all.x = TRUE)
  
  return(df)
}


# Function to obtain WOE of a numeric variable, given a set of cut points.
# The cut points are informed from eda, which provides a visual on how log(odds)
# varies with decile means, we intend to change the decile break up

woe <- function(dataset,var,breaks){
  subset <- dataset %>% select(c(var, "Responder")) %>% arrange(!!sym(var))
  
  # Break into categories using breaks
  subset$cat <- cut(x = subset[[var]] ,breaks = breaks, right = TRUE,
                    ordered_result = TRUE,labels = paste("Cat",1:(length(breaks)-1),sep = "_"))
  
  # Group by categories and derive log of odds for each decile
  woe_tbl <- subset %>% group_by(cat) %>% 
    summarise(Num_Resp = sum(Responder), Num_nonResp = length(Responder) - sum(Responder)) %>%
    mutate(Percent_Num_Resp = round(100 * Num_Resp/sum(Num_Resp),2),
           Percent_Num_nonResp = round(100 * Num_nonResp/sum(Num_nonResp),2)) %>%
    mutate(woe = log(Percent_Num_Resp/Percent_Num_nonResp))
  
  cat("woe is", sum(woe_tbl$woe))
  return(woe_tbl)
}


#################################################################
# Function to split a data into desired proportion for classification problems
################################################################

split_data <- function(dataset, split.ratio, response.var, seed){
  
  # split ratio - vector with pos,neg proportions eg: 0.7,0.3
  
  set.seed(seed)
  pos <- nrow(dataset[dataset[[response.var]] == 1,])
  neg <- nrow(dataset[dataset[[response.var]] == 0,])
  # data_p <- dataset %>% filter(response == 1) %>% mutate(index = 1:pos)
  #  data_n <- dataset %>% filter(response == 0) %>% mutate(index = 1:neg)
  
  data_p <- dataset[dataset[[response.var]]==1,]
  data_p$index <- 1:pos
  data_n <- dataset[dataset[[response.var]]==0,]
  data_n$index <- 1:neg
  
  select.index.pos <- sample(x = data_p$index,size = round(split.ratio[1]*pos,1),replace = FALSE)
  select.index.neg <- sample(x = data_n$index,size = round(split.ratio[1]*neg,1),replace = FALSE)
  
  train_p <- data_p[select.index.pos,]
  train_n <- data_n[select.index.neg,]
  
  train <- as.data.frame(rbind(train_p,train_n))
  
  val_p <- data_p[-select.index.pos,]
  val_n <- data_n[-select.index.neg,]
  
  val <- as.data.frame(rbind(val_p,val_n))
  
  
  return(list(train, val))
}




############# EDA Functions ################################

# Function to do basic eda for logistic regression, numeric vars. and cat. vars

# Function to do basic eda for classification problems
#1. Gives a boxplot of independent variables in the data set
#2. Gives a scatter plot b/w log (odds) and mean independent var in deciles


eda <- function(dataset, path,cont.vars = NULL, cat.vars = NULL, response, print.int =  FALSE){
  con <- file(description = file.path(path,"eda_log.txt"),open = "a")
  pdf(file.path(path,"eda.pdf"))
  #scatterplotMatrix(dataset)
  
  ############## Bivariate plot - log of odds per decile  ###################
  #########   & univariate ( boxplot) for cont. vars ###################
  
  if (!is.null(cont.vars)){
    for (var in cont.vars){
      # Break a variable into deciles, by each decile get no. of responder and non-responders
      subset <- dataset %>% select(var,response) %>% arrange(!!sym(var))
      
      
      # If the variable has negative values, the above method will not divide data well into deciles,
      # we will have to do re-scaling to make all  values >=0, this rescaling will not affect
      # log odds,woe/IV, as rank of observation will not change after rescaling
      if (sum(subset[[var]]<0) >0 ){
        min.val <- min(subset[[var]])
        subset[[var]] <- subset[[var]] + -1*min.val
      }
      
      
      subset$cum <- cumsum(subset[[var]])/sum(subset[[var]]) 
      subset$deciles <- cut(x = subset$cum ,breaks = seq(0,1,0.1),include.lowest = TRUE,right = TRUE,
                            ordered_result = TRUE,labels = paste("dec",1:10,sep = "") )
      
      # Group by deciles and derive log of odds for each decile
      subset_1 <- subset %>% group_by(deciles) %>% 
        summarise(Mean_Value = round(mean(!!sym(var)),3), Num_Resp = sum(!!sym(response)),
                  Num_nonResp = length(!!sym(response)) - sum(!!sym(response))) %>%
        mutate(dec_log_odds = round(log(Num_Resp/(Num_nonResp)),3)) %>% 
        #mutate (withindec_log_odds = if_else(Prob_Resp == 1,10,log_odds)) %>%
        mutate(Percent_Resp = round(100 * Num_Resp/sum(Num_Resp),2),
               Percent_nonResp = round(100 * Num_nonResp/sum(Num_nonResp),2)) %>%
        mutate(woe = round(log(Percent_Resp/Percent_nonResp),3)) %>%
        mutate(IV = round((Percent_Resp-Percent_nonResp) * woe,3))
      
      if (print.int == TRUE){
        write.csv(x = subset_1,file = con)
        cat("\n", con)
      }
      
      # Plots
      
      
      layout(mat = matrix(data = c(1,2,3,0),nrow = 2,byrow = TRUE))
      plot(x = subset_1$Mean_Value, y = subset_1$dec_log_odds, type = "l",
           main = paste("within decile Log of odds vs ", var, sep = ""),xlab = 'Decile Mean',ylab = var)
      #abline(reg = lm(subset_1$withindec_log_odds ~ subset_1$Mean_Value), lty = 2, col = "red")
      
      plot(x = subset_1$Mean_Value, y = subset_1$woe, type = "l",
           main = paste("By Decile woe vs ", var, sep = ""), xlab = 'Decile Mean',ylab = "WOE")
      #abline(reg = lm(subset_1$woe ~ subset_1$Mean_Value), lty = 2, col = "blue")
      
      boxplot(x = subset[,var],horizontal = TRUE,
              main = paste("Boxplot for ", var))
      #barplot(height = subset_1$log_odds,names.arg = subset_1$deciles)
      
      # count.vars <- length(cont.vars)
      # ind <- grep(pattern = var,x = cont.vars,value = FALSE)
      # n.plots <- count.vars - ind
      # rows <- round(sqrt(n.plots),0)+1
      # if (rows == sqrt(n.plots)){
      #   data <- 1:n.plots
      # }else {
      #   empty <- rows^2 - n.plots
      #   data <- c(1 : n.plots, rep(0,empty))
      # }
      # 
      # layout(mat = matrix(data = data,nrow = rows ,byrow = TRUE))
      # 
      # start <- ind 
      # for ( i in start:count.vars) {
      #   plot(dataset[[var]], dataset[[cont.vars[i]]],xlab = var,ylab = cont.vars[[i]] )  
      # }
      
      
      
      iv <- sum(subset_1$IV)
      
      if (print.int == TRUE){
        cat("IV of ",var," is ",iv,"\n",file = con)
        cat(x = "\n", file = con)
      }
      cat("IV of ",var," is ",iv,"\n")
    }
  }
  
  if (!is.null(cat.vars)){
    for (var in cat.vars){
      subset <- dataset %>% select(var,response) %>% arrange(!!sym(var))
      subset_1 <- subset %>% group_by(!!sym(var)) %>% 
        summarise(Count = n(), Num_Resp = sum(!!sym(response)),
                  Num_nonResp = length(!!sym(response)) - sum(!!sym(response))) %>%
        mutate(dec_log_odds = round(log(Num_Resp/(Num_nonResp)),3)) %>% 
        #mutate (withindec_log_odds = if_else(Prob_Resp == 1,10,log_odds)) %>%
        mutate(Percent_Resp = round(100 * Num_Resp/sum(Num_Resp),2),
               Percent_nonResp = round(100 * Num_nonResp/sum(Num_nonResp),2)) %>%
        mutate(woe = round(log(Percent_Resp/Percent_nonResp),3)) %>%
        mutate(IV = round((Percent_Resp-Percent_nonResp) * woe,3))
      
      if (print.int == TRUE){
        write.csv(x = subset_1,file = con)
        cat(x = "\n", file = con)
      }
      
      
      # Plots
      layout(mat = matrix(data = c(1,2,3,0),nrow = 2,byrow = TRUE))
      plot(x = subset_1[[var]], y = subset_1$dec_log_odds, type = "l",
           main = paste("Log of odds vs ", var, sep = ""), xlab = 'Variable levels',ylab = var)
      #abline(reg = lm(subset_1$withindec_log_odds ~ subset_1$Mean_Value), lty = 2, col = "red")
      
      plot(x = subset_1[[var]], y = subset_1$woe, type = "l",
           main = paste("woe vs ", var, sep = ""), xlab = 'Variable levels',ylab = "WOE")
      #abline(reg = lm(subset_1$woe ~ subset_1$Mean_Value), lty = 2, col = "blue")
      
      barplot(height = subset_1$Count,names.arg = subset_1[[var]])
      iv <- sum(subset_1$IV)
      
      # Below plots, hardcoded for the 'CC_default' comp.
      sub.cat.vars <- grep(pattern = "PAY",x = cat.vars,value = TRUE)
      
      if(sum(var %in% sub.cat.vars))
      {
        count.vars <- length(sub.cat.vars)
        rows = round(sqrt(count.vars),0) + 1
        if (rows == sqrt(count.vars)){
          data <- 1:count:vars
        }else {
          empty <- rows^2 - count.vars
          data <- c(1:count.vars,rep(0,empty))
        }
        
        layout(mat = matrix(data = data,nrow = rows ,byrow = TRUE))
        for ( i in 1:count.vars) {
          plot(dataset[[var]], dataset[[sub.cat.vars[i]]],xlab = var,ylab = sub.cat.vars[[i]] )  
        }
      }
      
      
      if (print.int == TRUE){
        cat("IV of ",var," is ",iv,"\n",file = con)
      }
      cat("IV of ",var," is ",iv,"\n")
    }}
  
  dev.off()
  
  close(con)
}


############# Model Validation Functions ################################





# Function for HL test, ks statistic, ks plot and getting an actual vs predicted plot

hltest <- function(scrd_data, path, modelname){
  df.hltest <- ResourceSelection::hoslem.test(x = scrd_data$Responder,y = scrd_data$predict,g = 10)
  cat("p value of hl test is", df.hltest$p.value, "\n")
  df.hltest2 <- as.data.frame(cbind(df.hltest$observed,df.hltest$expected))
  print(df.hltest2)
  df.hltest3 <- df.hltest2 %>% mutate(act_prob = y1/(y1+y0),pred_prob = yhat1/(yhat1+yhat0) )
  
  # ks statistic
  df.hltest3 <- df.hltest3 %>% arrange(desc(pred_prob))
  df.ks <- df.hltest3 %>% mutate(cum_resp = cumsum(y1)/sum(y1), cum_nonresp = cumsum(y0)/sum(y0)) %>%
    mutate(diff = cum_resp - cum_nonresp)
  
  ks <- max(df.ks$diff)*100
  cat("ks is", ks, "\n")
  
  pdf(file.path(path, paste("hl_ks", modelname,".pdf",sep="")))
  plot(x = df.hltest3$act_prob ,type = "l", col = "red", xlab = "Decile", ylab = "Avg prob",
       main = " Avg. Act vs Predicted Prob.")
  lines(x = df.hltest3$pred_prob, type = "l" , col = "blue")
  legend(x = "topright",legend = c("act","pred"),fill = c("red","blue"))
  
  plot(x = df.ks$cum_resp ,type = "o", col = "red", xlab = "Decile", ylab = "Cumulative",
       main = " KS Plot.")
  lines(x = df.ks$cum_nonresp, type = "o" , col = "blue")
  legend(x = "bottomright",legend = c("Resp","NonResp"),fill = c("red","blue"))
  dev.off()
}

