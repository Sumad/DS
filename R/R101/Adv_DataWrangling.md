Advanced Data Wrangling
================
Sumad Singh
September 17, 2017

``` r
# STARTING EXAMPLE
# Get a combined score, assign A, B,C,D,E grades at 20%ile, sort by student first names
student <- c("Ja De","Aq Wa","Br Mt","Ds Je","Ja Mc","Cw Cf","Rv Yt","Gj Kl","Jo Ek","JM Rw")
math <- c(502,600,412,358,495,512,410,625,573,522)
science <- c(95,99,80,82,75,85,80,95,89,86)
english <-c(25,22,18,15,20,28,15,30,27,18)
df<- data.frame(student, math, science, english, stringsAsFactors = FALSE)
```

``` r
# COMMON MATHEMATICS FUNCTIONS  
# THESE FUNCTIONS ARE VECTORIZED, I.E THEY WORK ON SCALARS, VECTOTS, DATA FRAMES
# sqrt()
# abs()
# floor()
# ceiling()
# trunc(34.99)
# round(34.993,digits =2 ) digits after decimal
# signif(34.993, digits = 4) significant digits
#cos(), sin(), tan() trig functions
#log(x = ,base = ) , log (x) is natural log
#exp(x)
```

``` r
# STATISTICS FUNCTIONS
# CENTRAL TENDENCY
temp <- c(20,25,11,35,60, 25,11)
sort(temp)
```

    ## [1] 11 11 20 25 25 35 60

``` r
mean(x = temp,trim = 0.05 ,na.rm = TRUE ) # can get trimmed mean after specifying a fraction
```

    ## [1] 26.71429

``` r
 # of observations to be trimmed from each end
median(x = temp,na.rm = TRUE )
```

    ## [1] 25

``` r
# DEVIATION
mad(x = temp) # MEDIAN OF ABSOLUTE DEVIATIONS
```

    ## [1] 14.826

``` r
sd(x = temp,na.rm = TRUE )
```

    ## [1] 16.93826

``` r
var(x = temp)
```

    ## [1] 286.9048

``` r
min(x = temp)
```

    ## [1] 11

``` r
max(x = temp)
```

    ## [1] 60

``` r
range(temp)
```

    ## [1] 11 60

``` r
IQR(temp)
```

    ## [1] 14.5

``` r
# RANK/POSITION
quantile(x = temp,probs = c(0.25,0.5,0.75,1)) # creates approx. quantiles
```

    ##  25%  50%  75% 100% 
    ## 15.5 25.0 30.0 60.0

``` r
# like 25%ile is not 11+ 25%  (20-11) 

# LAGGED SERIES
diff(temp,    # Used to create lagged series, given a vector
     lag = 1 , # order of lag
     differences = 2) # order of difference
```

    ## [1] -19  38   1 -60  21

``` r
# CENTERING AND SCALING : scale() function
# IN GENERAL CENTERING A VARIABLE MEANS SUBTRACTING MEAN VALUES FROM ALL IT' VALUES,
# SCALING MEANS DIVIDING BY STANDARD DEVIATION

scale(x = temp,   # CAN OPERATE ON EACH COLUMN OF A MATRIX LIKE OBJECT
      center = TRUE, # EITHER LOGICAL OR NUMERIC VECTOR WITH VALUES TO USE FOR CENTERING INSTEAD OF MEAN
      scale = TRUE) # EITHER LOGICAL OR NUMERIC VECTOR WITH VALUES TO USE FOR SCALING.
```

    ##            [,1]
    ## [1,] -0.3963975
    ## [2,] -0.1012079
    ## [3,] -0.9277389
    ## [4,]  0.4891714
    ## [5,]  1.9651197
    ## [6,] -0.1012079
    ## [7,] -0.9277389
    ## attr(,"scaled:center")
    ## [1] 26.71429
    ## attr(,"scaled:scale")
    ## [1] 16.93826

``` r
   # IF CENTER IS TRUE, STD. DEVIATION IS USED FOR SCALING, ELSE RMS IS USED

# MOVING A SERIES TO A DESIRED MEAN AND STANDARD DEVIATION
#STEP1: STANDARDIZE THE SERIES using Z STATISTIC
#STEP 2: MULTIPLE SERIES BY DESIRED SD ( THIS DOES NOT CHANGES THE MEAN), 
#THEN ADD THE DESIRED MEAN TO SERIES (THIS DOES NOT CHANGES THE SD)

# PRPOERTY 1 :TO MOVE MEAN OF A SERIES BY K, ADD K TO EACH NUMBER, NOTE THAT THIS DOES NOT CHANGE THE SD
mean(temp)
```

    ## [1] 26.71429

``` r
mean(temp+5)  
```

    ## [1] 31.71429

``` r
sd(temp)
```

    ## [1] 16.93826

``` r
sd(temp+5)  
```

    ## [1] 16.93826

``` r
# PROPERTY 2: TO MAKE THE SD OF A SERIES K TIME, MULTIPLY THE SERIES BY K. MEAN ALSO BECOMES K TIMES 
sd(temp)
```

    ## [1] 16.93826

``` r
 sd(2*temp)
```

    ## [1] 33.87653

``` r
 mean(temp)
```

    ## [1] 26.71429

``` r
 mean(2*temp)
```

    ## [1] 53.42857

``` r
# EXAMPLE OF MOVING SERIES TO A MEAN OF 10 AND SD OF 5 
  
temp.new <- scale(x = temp,center = TRUE, scale = TRUE)
temp.new2 <- temp.new * 5 + 10
mean(temp.new2)  
```

    ## [1] 10

``` r
sd(temp.new2)  
```

    ## [1] 5

``` r
# PROBABILITY FUNCTIONS
# DISCRETE AND CONTINUOUS PROBABILITY DISTRIBUTIONS ARE AVAILABLE in R
# 4 TYPES OF FUNCTIONS, THEIR FORM IS - <d/p/q/r><distribution name>, with dpqr meaning and use as below

#d - DENSITY FUNCTION TO GET POINT/ APPROX POINT PROBABILITIES
#r - RANDOM NUMBERS FROM A DISTRIBUTION
set.seed(100)
x <- sort(rnorm(30,10,2)) # RANDOM NUMBERS THAT ARE NORMALLY DISTRIBUTRED 
y <- dnorm(x = x, mean = 10, sd = 2) # APPROXIMATE POINT PROBABILITIES FOR GIVEN X VALUES
plot(x = x,y = y,type = "l", xlab = "Outcomes value",ylab = "Probabilities",main = "Normal Distribution")
```

![](Adv_DataWrangling_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-4-1.png)

``` r
#p - CUMULATIVE PROBABILITY FUNCTION
# WHAT IS PROBABILITY for VALUE LESS THAN 2 SD FROM MEAN
pbs <- pnorm(q = c(6,14) ,mean = 10, sd = 2,lower.tail = TRUE)
pbs[2]-pbs[1]
```

    ## [1] 0.9544997

``` r
#q -  WHAT IS THE VALUE OF X FOR WHICH PROB. IS LESS THAN 97.75% OR
# WHAT IS THE VALUE OF X FOR 97.75%ILE VALUE OF A NORMAL DISTRIBUTION
qnorm(p = 0.9775 ,mean = 10 ,sd = 2,lower.tail = TRUE )
```

    ## [1] 14.00931

``` r
# GENERATE A STANDARD NORMAL DENSITY DISTRIBUTION
x <- seq(from = -3, to = 3, by = 0.02)
y <- dnorm(x = x,mean = 0,sd = 1)
plot(x = x,y = y,type = "l", xlab = "Outcomes value",ylab = "Probabilities",main = "Standard Normal")
```

![](Adv_DataWrangling_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-4-2.png)

``` r
# PSEUDO RANDOM NUMBER GENERATION
set.seed(100)
ns <- sort(runif(n=20,min = 0, max = 1))
probs <- dunif(x = ns)
plot(x = ns,y = probs,type = "l", xlab = "Outcomes value",ylab = "Probabilities",main = "Unfiform Distribution")
```

![](Adv_DataWrangling_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-4-3.png)

``` r
# MULTIVARIATE NORMAL DISTRIBUTION
# GENERATE N NORMAL VARIABLES, GIVEN MEANS AND COVARIANCE MATRIX
library(MASS)
set.seed(100)
mean <- c(30,40,45)
# COVARIANCE MATRIX
cov.mat <- matrix(nrow = 3,ncol = 3, data = c(100,-85, -90,
                                             -85,400,200,
                                              -90,200,225))  

df <- mvrnorm(n = 100 ,mu = mean  ,Sigma = cov.mat)

# VALIDATE THE VARIABLES ARE NORMALLY DISTRIBUTED
y1 <- dnorm(x = df[,1], mean = 30, sd = 10)
y2 <- dnorm(x = df[,2], mean = 40, sd = 20)
y3 <- dnorm(x = df[,3], mean = 45, sd = 15)

layout(mat = matrix(nrow = 2,ncol =2 ,data = c(1,1,2,3),byrow = TRUE))
plot(x = df[,1],y = y1,type = "p", xlab = "df[,1]",ylab = "Probabilities",
     main = "Normal Distribution?", col ="red")
plot(x = df[,2],y = y2,type = "p", xlab = "df[,2]",ylab = "Probabilities",
     main = "Normal Distribution?", col = "blue")
plot(x = df[,3],y = y3,type = "p", xlab = "df[,3]",ylab = "Probabilities",
main = "Normal Distribution?" , col = "green")
```

![](Adv_DataWrangling_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-4-4.png)

### TABLE OF COMMON PROBABILITY DISTRIBUTIONS

| No  | DISTRIBUTION NAME | FUNCTION |
|-----|-------------------|----------|
| 1   | normal            | norm     |
| 2   | uniform           | unif     |
| 3   | binomial          | binom    |
| 4   | negative binomial | nbinom   |
| 5   | Exponential       | exp      |
| 6   | Poisson           | pois     |
| 7   | Gamma             | gamma    |
| 8   | Weibull           | weibull  |
| 9   | lognormal         | lnorm    |
| 10  | logistic          | logis    |
| 11  | T                 | t        |
| 12  | Chi square        | chisq    |
| 13  | F                 | f        |
| 14  | Geometric         | geom     |
| 15  | Hypergeometric    | hyper    |
| 16  | Cauchy            | cauchy   |
| 17  | Beta              | beta     |

``` r
# PRINT AND CAT - DIFFERENCES AND WHEN TO USE WHAT
# PRINT() CALLS A METHOD BASED ON THE CLASS OF THE OBJECT GIVEN AS ARGUMENT, AND RETURNS AN OBJECT 
# OF THE SAME CLASS
class(print(1:3))
```

    ## [1] 1 2 3

    ## [1] "integer"

``` r
class(print(c("a","b")))
```

    ## [1] "a" "b"

    ## [1] "character"

``` r
# CAT() INTERNALLY TRIES TO CONVERT THE ARGUMENT/S TO CHARATCER VECTOR, CONCATENATEs
# AND OUTPUTS TO CONSOLE OR A FILE.IT CANNOT ON ACT ON COMPLEX OBJECTS LIKE LISTS,
# DATA FRAMES. IT IS VALID ONLY FOR ATOMIC DATA TYPES
# ALSO RETURNS OBJECT OF CLASS NULL, OUTPUT APPEARS CLEAN
#print()
#cat(... = ,file = ,fill = ,append = )
class(cat(1:3))
```

    ## 1 2 3

    ## [1] "NULL"

``` r
class(cat(c("a","b")))
```

    ## a b

    ## [1] "NULL"

``` r
# WHEN TO USE WHICH
#1.  USE CAT TO USE ESCAPE SEQUENCES: USING ESCAPE SEQUENCES IN CAT() MEANS, THEY ARE NOT RETURNED AS
# CHARACTER VECTORS AND ARE BROUGHT TO EFFECT BY CAT, BUT NOT BY PRINT
#2. USE CAT TO WRITE TO LOG FILES, MAKING USE OF ESCAPE SEQUENCES. OR USE IT'S UNFORMATTED OUTPUT
# TO COPY IT OVER TO OTHER PLACES
#3. USE PRINT WITH NON -ATOMIC CLASSES
```

``` r
# SPECIAL CHARACTERS, ESCAPE SEQUENCES, NON-STANDARD NAMING OF VARIABLES

#1. SPECIAL CHARACTERS AND ESCAPE SEQUENCES
# SPECIAL CHARACTERS : \, "  HAVE RESERVED INTERPRETATION IN R, FOR THESE TO BE USED
# IN LITERAL SENSE IN CHARACTER VECTORS, EACH OF THEM NEED TO BE ESCAPED WITH A '\'

# x <- c("\", "'", """) # will throw an error
#x <- c("\m", "'") # will throw an error that \m is unrecognized esc seq
x <- c("\\", "'", "\"", "\\m") 
print(x) # RETURNS A CHARACTER VECTOR
```

    ## [1] "\\"  "'"   "\""  "\\m"

``` r
cat(x) # RETURNS A NULL CLASS OBJECT, YOU CAN SEE THE CHARACTERS AS YOU WOULD ON
```

    ## \ ' " \m

``` r
# KEYBOARD INPUT

# ESCAPE SEQUENCES:

# \n, \t, \b, \r, \f, \v have ascribed interpretations for keyboard inputs
# THESE CAN BE USED IN CHARACTER STRINGS

# EXAMPLES OF USING SPECIAL CHARACTER AND ESCAPE SEQUENCES:
# x <- "In ALGOL, you could do logical AND with /\."
# throws an error, because '\' character is interpreted as a special character
# in R, to use it as a normal character have to backlash it.

x <- "In ALGOL, you could do logical AND with /\\."
print(x)
```

    ## [1] "In ALGOL, you could do logical AND with /\\."

``` r
cat(x) 
```

    ## In ALGOL, you could do logical AND with /\.

``` r
# SEE THE DIFFERENCE IN THE TWO OUTPUTS FROM CAT
y <- c("tab:\\t", "newline:\\n", "escape:\\", "arbitrary string:\\s")
print(y)
```

    ## [1] "tab:\\t"              "newline:\\n"          "escape:\\"           
    ## [4] "arbitrary string:\\s"

``` r
cat(y)
```

    ## tab:\t newline:\n escape:\ arbitrary string:\s

``` r
y <- c("tab:\t", "newline:\n", "escape:\\", "arbitrary string:\\s")
print(y)
```

    ## [1] "tab:\t"               "newline:\n"           "escape:\\"           
    ## [4] "arbitrary string:\\s"

``` r
cat(y)
```

    ## tab:  newline:
    ##  escape:\ arbitrary string:\s

``` r
# USING QUOTES IN THE FINAL OUTOUT ON CONSOLE OR A FILE
x <- "My name is \"Sumad\""       
print(x)
```

    ## [1] "My name is \"Sumad\""

``` r
cat(x)
```

    ## My name is "Sumad"

``` r
#2. NON STANDARD NAMES - USE OF ``

`x y` <- 1:5
`x y`
```

    ## [1] 1 2 3 4 5

``` r
# COMMON CHARACTER MANIPULATION FUNCTIONS

vec <- c("Hello", "it has been very .. \\s slow going!" ,"Can we make itt fast??")
#1. nchar()
nchar(vec)  # length(vec[2]) will not count characters
```

    ## [1]  5 34 22

``` r
#2. substr()
vec[2]
```

    ## [1] "it has been very .. \\s slow going!"

``` r
#grep(x =vec ,pattern = "y", value = FALSE)
#substr(x = ,start = ,stop = )

#3. grep  # Search a pattern and return the position where match was found 

#4. sub , gsub # FInd a pattern and substitie, can do global search and replace

#5. strsplit # split a string based on a pattern
# USED TO SPLIT A CHARACTER VECRTOR EITHER TO ITS CONSTITUENT CHARACTERS
# OR CREATE SPLITS BASED ON A PATTERN, RETURNS A LIST
str.split <- strsplit(x = vec[2], 
         fixed = TRUE, # FALSE if a regular expression pattern
         split = "")
str.split <- strsplit(x = vec[2], fixed = TRUE, split = "..")
str(str.split)
```

    ## List of 1
    ##  $ : chr [1:2] "it has been very " " \\s slow going!"

``` r
#6. paste () # pasting string together

#7. cat() # concatenate strings, also understands special quotes

#8. case change functions
```

``` r
# CONTROL FUNCTIONS
```

``` r
# USER DEFINED FUNCTIONS
```

``` r
# RESHAPE DATA
```