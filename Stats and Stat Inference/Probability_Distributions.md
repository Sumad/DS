Probability Distributions
================
Sumad Singh
September 19, 2017

PROBABILITY DISTRIBUTIONS
-------------------------

Graphical represenation linking each values that a random variable can take, to its relative frequency. The random variable could be discrete or continuous. Accordingly, prob. distributions are discrete or continuous.

### DISCRETE DISTRIBUTIONS

For each value of random variable, a relative frequency can be computed and it is the probability of taking that value. Common distributions - \#\#\#\# Binomial Probability distribution from an experiment that has n independent trials,each trial with two fixed outcomes - success & failure, then the random variable, with r successes follows a binomial distribution. eg: customers going in a store, they come out buying or not buying (one might question,the independence though! but, we spare it for later)

##### PDF and parameters of binomial

PDF is mathemtical represenation of Prob. distribution (graphical representation) PDF = nCr (p)^r (1-p)^(n-r) Here, for a given n and probability of succes, we can find probabity distribution, by varying r. n and p are the paraemeters of this distribution.

``` r
# SIMULATE A BINOMIAL DISTRIBUTION
btrial.outcomes <- sample(x = c("Buy", "NoBuy"), size = 20, replace = TRUE, prob = c(0.5,0.5))
binomial.prob <- function(trials, successes, p.success)
{
  prob <- (factorial(trials)/(factorial(successes) * factorial(trials - successes))) * 
          ((p.success**successes) * (1-p.success)**(trials-successes))
  return(prob)
}
binomial.prob.dist <- Vectorize(FUN = binomial.prob)

# test 
#binomial.prob(20,5,0.5)
probs1 <- binomial.prob.dist(20,1:20,0.3)
probs2 <- binomial.prob.dist(20,1:20,0.4)
probs3 <- binomial.prob.dist(20,1:20,0.5)
probs4 <- binomial.prob.dist(20,1:20,0.6)
successes <- 1:20
layout(mat = matrix(data = c(1,2,3,4),nrow = 2,byrow = TRUE))
barplot(height = probs1, names.arg = successes,main = "Binomial Distribution with n= 20,p=0.3",
        xlab = "Number of successes", ylab = "Probability")
barplot(height = probs2, names.arg = successes,main = "Binomial Distribution with n= 20,p=0.4",
        xlab = "Number of successes", ylab = "Probability")
barplot(height = probs3, names.arg = successes,main = "Binomial Distribution with n= 20,p=0.5",
        xlab = "Number of successes", ylab = "Probability")
barplot(height = probs4, names.arg = successes,main = "Binomial Distribution with n= 20,p=0.6",
        xlab = "Number of successes", ylab = "Probability")
```

![](Probability_Distributions_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-1-1.png)

##### OBSERVATION

For probabilities less than 0.5, distribution is right skewed, for &gt; 0.5 it becomes left skewed. When prob. of success is lower, it becomes increasingly less probable to get an increase in no. of successes, when p is higher, it becomes less probable to get low number of successes.

#### Poisson

Typical for random experiments related to observing counts in an interval of time, given one knows the average count per unit time. ASSUMPTION : PROBABILITY DISTRIBUTION REMAINS SAME FOR A GIVEN TIME INTERVAL, AND IS NOT DEPENDENT ON POINT OF START OF THE INTERVAL Example: Number of cars arriving at a toll booth in 5 mins is likely a poisson random variable

##### PDF and parameters

P(x) = lambda^x . e^(-lambda) / x! i.e probability of observing x counts in TIME T, for which avg. rate of observations is known (i.e lambda OVER TIME T is known) lambda is the parameter of the distribution

``` r
# SIMULATE PROB. DISTRIBUTION
set.seed(111)
# Define a function to compute poisson probability
pois.prob <-  function( lambda, number.obs)
{
  prob <- (exp(-lambda) * (lambda^number.obs)) / factorial(number.obs)
  return(prob)
}

# Vectorize it to operate on a range of no. of observations
pois.dist <- Vectorize(FUN = pois.prob)

lambda <- seq(0.4,3.6,0.4)
obs <- 0:60

# Use apply family to further vectorize it on a range of parameter lambda
pois.probs <- sapply(X = lambda,FUN = pois.dist,number.obs = obs)
colnames(pois.probs) <- paste("lambda", seq(0.4,3.6,0.4), sep="_" )


layout(mat = matrix(data = c(1:9),nrow = 3,byrow = TRUE))
barplot(height = pois.probs[,"lambda_0.4"], names.arg = 0:60, main = "Poisson Distribution-lambda 0.4",
        xlab = "Number of observations", ylab = "Probability",space = 0.3)
barplot(height = pois.probs[,"lambda_0.8"], names.arg = 0:60, main = "Poisson Distribution-lambda 0.8",
        xlab = "Number of observations", ylab = "Probability",space = 0.3)
barplot(height = pois.probs[,"lambda_1.2"], names.arg = 0:60, main = "Poisson Distribution-lambda 1.2",
        xlab = "Number of observations", ylab = "Probability",space = 0.3)
barplot(height = pois.probs[,"lambda_1.6"], names.arg = 0:60, main = "Poisson Distribution-lambda 1.6",
        xlab = "Number of observations", ylab = "Probability",space = 0.3)
barplot(height = pois.probs[,"lambda_2"], names.arg = 0:60, main = "Poisson Distribution-lambda 2",
        xlab = "Number of observations", ylab = "Probability", space = 0.3)
barplot(height = pois.probs[,"lambda_2.4"], names.arg = 0:60, main = "Poisson Distribution-lambda 2.4",
        xlab = "Number of observations", ylab = "Probability", space = 0.3)
barplot(height = pois.probs[,"lambda_2.8"], names.arg = 0:60, main = "Poisson Distribution-lambda 2.8",
        xlab = "Number of observations", ylab = "Probability", space = 0.3)
barplot(height = pois.probs[,"lambda_3.2"], names.arg = 0:60, main = "Poisson Distribution-lambda 3.2",
        xlab = "Number of observations", ylab = "Probability",space = 0.3)
barplot(height = pois.probs[,"lambda_3.6"], names.arg = 0:60, main = "Poisson Distribution-lambda 3.6",
        xlab = "Number of observations", ylab = "Probability",space = 0.3)
```

![](Probability_Distributions_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-2-1.png)

##### OBSERVATION

Right skewed distribution, as lambda increases, the right skew starts decreasing. i.e the probability of a higher count observation starts increasing, and that of lower count starts decreasing.

### CONTINUOUS DISTRIBUTIONS

Probability is defined for a range of values of the random variable, and not at a specific point. Since, a continuous random variables is expected to take an infite set of distinct values, the probability of taking a single value is effectively 0. Area under the curve of a probability distribution b/w two points, is the probability that random variable can take a value b/w those points.

Common continuous distributions - - Exponential - Normal - Lognormal - Gamma - T - Chi-Square - F
