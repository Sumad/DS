library(pROC)
library(ResourceSelection)
library(caret)

# Function to do basic eda for logistic regression, numeric vars.
#1. Gives a boxplot of independent variables in the data set
#2. Gives a scatter plot b/w log (odds) and mean independent var in deciles

eda <- function(dataset, path){
  vars <- colnames(dataset)[!colnames(dataset) %in% c("Responder","index")]
  # scatterplot b/w independent variables to visualize correlations
  
  pdf(file.path(path,"eda2.pdf"))
  #scatterplotMatrix(dataset)
  for (var in vars){
        # Break a variable into deciles, by each decile get no. of responder and non-responders
    subset <- dataset %>% select(var,"Responder") %>% arrange(!!sym(var))
    subset$cum <- cumsum(subset[[var]])/sum(subset[[var]]) 
    subset$deciles <- cut(x = subset$cum ,breaks = seq(0,1,0.1),right = TRUE,
                          ordered_result = TRUE,labels = paste("dec",1:10,sep = "") )
    
    # Group by deciles and derive log of odds for each decile
    subset_1 <- subset %>% group_by(deciles) %>% 
      summarise(Mean_Value = mean(!!sym(var)), Num_Resp = sum(Responder),
                Num_nonResp = length(Responder) - sum(Responder)) %>%
      mutate(withindec_log_odds = log(Num_Resp/(Num_nonResp))) %>% 
      #mutate (withindec_log_odds = if_else(Prob_Resp == 1,10,log_odds)) %>%
      mutate(Percent_Responders = round(100 * Num_Resp/sum(Num_Resp),2),
             Percent_nonResponders = round(100 * Num_nonResp/sum(Num_nonResp),2)) %>%
      mutate(woe = log(Percent_Responders/Percent_nonResponders)) %>%
      mutate(IV = (Percent_Responders-Percent_nonResponders) * woe)
    
    # Plots
    layout(mat = matrix(data = c(1,2,3,0),nrow = 2,byrow = TRUE))
    plot(x = subset_1$Mean_Value, y = subset_1$withindec_log_odds, type = "l",
         main = paste("within decile Log of odds vs ", var, sep = ""))
    #abline(reg = lm(subset_1$withindec_log_odds ~ subset_1$Mean_Value), lty = 2, col = "red")
    
    plot(x = subset_1$Mean_Value, y = subset_1$woe, type = "l",
         main = paste("By Decile woe vs ", var, sep = ""))
    #abline(reg = lm(subset_1$woe ~ subset_1$Mean_Value), lty = 2, col = "blue")
    
    boxplot(x = subset[,var],horizontal = TRUE,
            main = paste("Boxplot for ", var))
    #barplot(height = subset_1$log_odds,names.arg = subset_1$deciles)
    iv <- sum(subset_1$IV)
    cat("IV of ",var," is ",iv,"\n")
  }
  dev.off()
}

# Function for HL test, ks statistic, ks plot and getting an actual vs predicted plot

hltest <- function(scrd_data, path, modelname){
  df.hltest <- ResourceSelection::hoslem.test(x = scrd_data$Responder,y = scrd_data$predict,g = 10)
  cat("p value of hl test is", df.hltest$p.value, "\n")
  df.hltest2 <- as.data.frame(cbind(df.hltest$observed,df.hltest$expected))
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
