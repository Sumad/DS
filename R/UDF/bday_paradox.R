library(data.table)
BirthshareProb <- function (n.vec){
  # Computes the probability of 2 people in a group of n sharing birthday. 
  # Simplifying assumption of 365 days in an year
  
  # Args:
    #  n.list: list of number of people in a room  
  
  # Returns:
    # plot of probability as n varies
  
  dt <- data.table()
  for (i in 1:length(n.vec)){
    nbr <- n.vec[i]
    dt[i, ':=' (n = nbr, Prob = (1-364/365)^nbr)]
  }
    return(dt)
  
  # Line Plot of probability, overlayed by points on line
}
