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

Common continuous distributions -

#### Normal Distribution

Normal distribution's relative frequency is maximum at the mean and tapers off as we move away from the mean

##### PDF and Parameters of Normal Distribution

PDF = ƒ(x) = 1/√(2π)\*sigma exp\[- 0.5((x-mean)/sigma)^2\] It is a two parameter distribution, with location i.e mean and scale i.e std. deviation parameters. Its shape paramter or skewness is 0. The kurtosis or peakedness is 3, and peakedness of normal distribution is taken as reference.

Example : What do you get using the PDF function for a discrete value of x Ans : The relative frequency at that point, not the probability

``` r
norm.freq <- dnorm(x = 140 :220,mean = 180,sd = 20 )
plot(x = 140:220, y = norm.freq,type = "p")
```

![](Probability_Distributions_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-4-1.png)

##### Properties of Normal Distribution

1.  The area covered between two points at known standard deviations away from mean remains the same for every normal distribution
2.  More area is covered closer to the mean, and as you go away from mean, it reduces Example: Area covered in 1 sd = 68% , 2sd = 95.5%, 3sd = 99.7% . For every 2 sd movement away from mean, probability increment is 27.5%age points and 2.2%age points.
3.  probability is defined between two points and not at a point P (a&lt;= x &lt;=b) = ∫ ƒ(x) dx from a to b

``` r
x <- seq(from = -3, to = 3, by = 0.02)
y <- dnorm(x = x,mean = 0,sd = 1)
plot(x = x,y = y,type = "l", xlab = "Outcomes value",ylab = "Probabilities",main = "Standard Normal")
```

![](Probability_Distributions_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-5-1.png)

1.  Method of finding probability of a random variable with normal distribution

-   use integral method
-   another property is that the probability could be computed by converting it to a standard normal using z transformation.

#### CENTRAL LIMIT THEOREM

If we draw large sized independent samples of equal size from a population, which could be anyway distributed, the distribution of mean of the samples tends to be normal, and Same SD = Pop. SD / √n Sample Mean = Population Mean n &gt;=30 qualifies for large sample.

``` r
# Draw random numbers from a uniform distribution, compute mean and sd

# Draw samples of size n, compute mean and sd of each sample

# Compute Mean and SD of the distribution of means

# Verify relationship of mean and SD, and if distributions is normal

samples.df <- Vectorize(FUN = sample, vectorize.args = "size")

clt <- function(pop, sample.size, sample.no)
{
  # computes pop mean
  # draws give no. of random samples of given size from the population
  # computes mean and sd of sample means
  # Compares mean of sample means and their sd, with population per relationship
  # Returns a vector of pop mean na sd, sampling distribution's mean and sd, sample size
  # returns a vector of the sample means
  pop.mean <- mean(pop)
  pop.sd <- sd(pop)
  # Call a vectorized function to draw independent same sized samples
  df <- samples.df(x =pop, size = rep(sample.size, sample.no), replace = TRUE)
  sample.means <- apply(X = df,MARGIN = 2,FUN = mean)
  sample.sds <- apply(X = df,MARGIN = 2,FUN = sd)
   
  mean.sample.mean <- mean(sample.means)
  sd.sampl.mean <- sd(sample.means) 
  derived.pop.sd <- sd.sampl.mean * (sample.size)^0.5
  stats <- c(pop.mean, pop.sd, mean.sample.mean, derived.pop.sd) 
  lst <- list(stats = stats, sample.means = sample.means, samples = df)
  return(lst)
}

clt.vec <- function(pop, sample.size.vec, sample.no){
# Vectorize clt.vec
lt <- list()
length(lt) <- length(sample.size.vec)
#master.lt <- rep(lt, length(sample.size.vec))
names(lt) <- paste("ss", sample.size.vec, sep=".")

for (ss in sample.size.vec){

  name.list <- paste("ss", ss, sep=".")
  lt[[name.list]] <- clt(pop, ss, sample.no)
}
return(lt)
}

set.seed(101)
pop <- runif(n = 100,min = 10,max = 100)
sample.size <- seq(30,70,10)
sample.no <- 50
result <- clt.vec(pop,sample.size,sample.no)

# Show the means and sd match
# Show the prob. distr. approaches normal as n increases.
#rm(list = ls())
```

CLT allows one to make inferences about population charatertistics of location and scale from a sample.

#### T DISTRIBUTION

When the sample size is small or the population standard deviation is not kown, and sample sd is taken as proxy of population sd, then the sampling distribution of means follows t - distribution.

##### PDF and parameters

PDF ? Degrees of Freedom: In general, how many values in a set can be varied, given a set of constraints on the set of values. For a data set of size n, the degress of freedom are n-1, if no other condition is given. Because mean is known, only n-1 values can be varied, and hence the degree of freedom.

Degrees of freedom is the only parameter of t-distribution.

##### PROPERTIES OF T DISTRIBUTIONS

1.Mean is 0.ß 2.It is flatter in the tails than the standard normal distribution, it's variance is more than 1 and is df/df-2 3.It is used for random variables, with more uncertainity at extreme values, as it is fatter in the tails, than normal distribution. 4. As degrees of freedom increase, variance approaches 1, it tends to normal

``` r
# Plot a t and standard normal
```

#### Chi-Square

#### F

#### Exponential

#### Gamma

#### Weibull

#### Tweedie

#### Lognormal