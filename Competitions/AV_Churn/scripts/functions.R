####################  1 #############################

# Function to fill missing values 0, N, Missing given a df, vector of variables, values to be filled in
# passes as a list

treat.miss <- function(dataset, vars, value){
  for ( var in vars){
    dataset[is.na(dataset[[var]]),var] <- value
  }
  return(dataset)
}

####################  2 #############################

# Count of na in a vector, supposed to be applied on a df using apply
na_count <- function(x) {sum(is.na(x))}

# Count of uniques in a vector, supposed to be applied on a df using apply
unique_count <- function(x) {length(unique(x))}

# Count of NAN in a vector,supposed to be applied on a df using apply
nan_count <- function(x) {sum(is.nan(x))}

# Count of Inf in a vector,supposed to be applied on a df using apply
inf_count <- function(x) {sum(is.infinite(x))}

####################  3 #############################


# Function that gives a list of two elements
# 1. a df with subset of continuous variables to be used for further analysis on cont. variables
# 1.1 a summary frame with var.names, class, 5 point summary, nacount, unique counts
# 2. a df with subset of categorical variables for further analysis
# 2.2 a summary frame of categorical variables,with var.names, nacount,unique counts/levels

frame_summary <- function(dataset){
  
  # form a data frame with variable name and class type
  vars <- colnames(dataset)
  type <- NULL
  for (var in vars){
  type <- c(type,class(dataset[[var]]))
  }
  df <- data.frame(vars, type, stringsAsFactors = FALSE)
  
  # Subset two data frames, one for num and chr variables
  vars.chr <- df$vars[df$type == "character"]  
  vars.num <- df$vars[df$type == "numeric"]  
  
  df.num.type <- dataset %>% dplyr::select(vars.num)
  df.chr.type <- dataset %>% dplyr::select(vars.chr)
  

  # Get 5 point summary, na count and level count for numeric variables in a frame
  #apply gives a matrix, transpose needs a data frame
  
  df.summary.num1 <- as.data.frame(apply(X = df.num.type,MARGIN = 2,FUN = "summary"))
  df.summary.num <- transpose(df.summary.num1)
  colnames(df.summary.num) <- row.names(df.summary.num1)
  df.summary.num$var <- colnames(df.summary.num1)
   
  vec.na.count <- apply(X = dataset, MARGIN = 2,FUN = "na_count")
  vec.unique.count <- apply(X = dataset, MARGIN = 2,FUN = "unique_count")
  df.na.unique.count <- data.frame(var = names(vec.na.count),
             na.count = vec.na.count,
             unique.count = vec.unique.count,row.names = NULL)

  df.summary.na.unique.num <- merge(x = df.summary.num, y = df.na.unique.count, by = "var", all.x = TRUE )
  
  # Get na count and levels count for character variables
  ## dplyr::select takes column names as input and not a logical vector
  subset.vars.chr <- colnames(dataset)[colnames(dataset) %in% vars.chr]
  df.summary.na.unique.chr <- df.na.unique.count %>% dplyr::filter(var %in% subset.vars.chr)
  
  #rm(list = c(vars.chr,vars.num,df.summary.num1,vec.na.count, vec.unique.count,
   #           df.na.unique.count,subset.vars.chr))
  return(list(df.num.type = df.num.type, df.chr.type = df.chr.type, 
              df.summary.na.unique.num = df.summary.na.unique.num, 
              df.summary.na.unique.chr = df.summary.na.unique.chr ))
}

####################  4 #############################

# Function to take a vector with nan and inf, and return max if non-nan and non-inf values
# assume there is a non-nan, non-inf value
# assume there are no non-NaN NAs

max.in.inf <- function(var){
  # Usefule function when finite/0 and 0/0 conditions introduce NaN and Inf in data
  temp <- var
  temp[is.nan(temp)] <- 0
  temp2 <- temp[!is.infinite(temp)]
  return(max(temp2))
}

####################  5 #############################

# Function to take  a data set and replace NaN and Inf values
fill.nan.inf <- function(dataset){
  vars <- colnames(dataset)
  
  for(var in vars){
    inf.replace.value <- max.in.inf(dataset[[var]])
    ind1 <- is.nan(dataset[[var]]) # index has to be built outside of dataset[]
    ind2 <- is.infinite(dataset[[var]])
    dataset[ind1,var] <- 0
    dataset[ind2,var] <- inf.replace.value
  }
  return(dataset)
}
  

###################### Visualization functions #############################
# Function of plot log (Odds) vs deciles of a variables
# orde
# 
# function(var, response){
#   df <- data.frame(var = var, resp = response)
#   cut()
# }
