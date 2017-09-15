Basic Data Wrangling
================
Sumad Singh
September 14, 2017

DATA WRANGLING
--------------

### COMMON OPERATORS

### NEW VARIABLES

#### RECODING VARIABLES

#### CATEGORICAL VARIABLES FROM CONTINUOUS VARIABLES

#### MISSING VALUE HANDLING IN R

#### HANDLING AND FORMATTING DATES, ADD'L RESOURCES

### TYPE CONVERSION & SORTING

### SELECTION, FILTERING,MERGING,

### VALUE REPLACEMENT - ESP. MISSING VALUE TREATMENT

``` r
# COMMON OPERATORS
#ARITHMETIC : 
#- X%/%y GIVES QUOTIENT
#- LOGICAL : X %% Y GIVES REMAINDER

# LOGICAL OPERATORS
# X | Y - PAIRWISE OR OPERATION ON TWO VECTORS
# X || y - ADD'L OR OPERATION AFTER PAIRWOSE OR OPERATION TO YIELD SINGLE T/F VALUES
# X & Y - SIMILAR
# X && Y - SIMILAR
```

``` r
### NEW VARIABLES, RECODING, CATEGORICAL VARIABLES FROM CONTINUOUS VARIABLES
# WAYS TO DERIVE NEW VARIABLES in a dat frame
# Example: Use mtcars, 
# -derive disp/wt, after checking no missing or 0's exist for wt,
# - consider wt >5 as missing values, recode is as 5
# derive categorical var. using wt, as <=2 as small, (2,4] as med, (4,) as large

#1. transform(  ) #   ATTCHES DATASET TO THE SEARCH ENV. AND LETS YOU REFER TO THE 
# VARIABLES BY NAMES
data <- mtcars
# THE FIRST ARGUMENT START WITH _, AND HAS TO BE QUOTED IN BACKQUOTE
data_temp <- transform(`_data` = data,var1 = ifelse(wt==0 | is.na(wt),0,disp/wt),
          wt.cat.int = ifelse(wt >=5, 5,wt))
data_final <- transform(`_data` = data_temp, 
                        wt.cat = ifelse(wt.cat.int <= 2,                                                      
                                        "Small",ifelse(wt.cat.int <= 4,"Medium", "Large")))

#table(data_final$wt.cat)
#sum(data_final$wt <=2)
#sum(data_final$wt <=4)
# str(data_final)
# THE CATEGORICAL VARIABLES IS AN UNORDERED FACTOR

#2. dplyr:: mutate
## MORE CONVENIENT, IN LETTING USE OF COLUMNS NAMES DIRECTLY AND CHAINING
# TRANSFORMATIONS, WITHOUT NEEDING TO STORE INTERMEDIATE DATA FRAMES
# check objects using ls() after using chained mutates
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
data_final2 <- data %>% mutate(var1 = ifelse(wt==0 | is.na(wt),0,disp/wt),
          wt.cat.int = ifelse(wt >=5, 5,wt)) %>% 
          mutate(wt.cat = ifelse(wt.cat.int <= 2,                                                      
                                        "Small",ifelse(wt.cat.int <= 4,"Medium", "Large")))

# table(data_final2$wt.cat)
# sum(data_final2$wt <=2)
# sum(data_final2$wt <=4)
# str(data_final2)
# THE CATEGORICAL VARIABLE IS A CHARACTER - DESIRABLE - AND CAN BE CHANGED TO A
# FACTOR ORDERED VAIABLE

#3. simply index on new variable name

#4. CONTINUOUS TO FACTOR, CUT() FUNCTION
  data$wt.cat <- cut(x = data$wt,breaks = c(-Inf,2,4,Inf), # break as integer to get equal intervals
                     # or exact points to forms all intervals, incluidng extrme points,
                     right = TRUE , # if right interval should be closed
                     ordered_result = TRUE ) # created a factor, so should it be ordered
  table(data$wt.cat)
```

    ## 
    ## (-Inf,2]    (2,4] (4, Inf] 
    ##        4       24        4

``` r
# MISSING VALUE HANDLING IN R
# RECODING MISSING VALUES USING SYMBOL NA
# R has an object NA, that is recognized as symbol for missing value
class(NA) # logical behind the scenes
```

    ## [1] "logical"

``` r
# Missing values in both charatcer and numeric vectors are recognized with NA
# Any operation on NAs yield NA
#ONLY SPECIFIC FUNCTIONS RECOGNIZE AND HANDLE NA
# IS.NA() - LOGICAL TEST FOR PRESENCE OF NA

# MISSING VALUE TREATMENT
# MOST SIMPLE WAY IS CASE OMISSION
#complete.cases()
#na.omit()

# BUILT IN R FUNCTIONS HAVE A PROVISION OF HANDLING MISSING VALUES,
# WORTH CHECKING THE FUNCTION HELP TO SEE
# EXAMPLES:
# sum(data $wt, na.rm = TRUE ) # lets remove the NA values and compute the sum
```

``` r
# HANDLING DATES AND TIMES IN R
# R offers date and time classes to create objects, and built in functions, and add'l
# packages to handle these objects

# CONVERTING CHARACTER VALUES TO DATES, CHANGING DATA FORMATS  
#1.as.Date() and format() to generate date class objects from charatcer scalars/vectors
fmt.date <- as.Date(x = "2017-03-01",  # character scalar or vector
                   format = "%Y-%m-%d") # format in which scalar/vector is specified
# Function returns an object of class date

#|--------|---------------------|--------|
#  Symbol  Meaning                Example
#|--------|---------------------|--------|
#    %y     year(2D)                17
#    %Y     year(4D)                2017
#    %m     month(2D)               03
#    %b     abb. month             Mar
#    %B     Unabb. month           March
#    %d     date(2D)                30
#    %a     abb. day of week        Mon
#    %A     Unabb. day of week      Monday

fmt.date<- as.Date(x = "2017-Mar-01", format = "%Y-%b-%d")
class(fmt.date)
```

    ## [1] "Date"

``` r
# FORMAT CAN BE USED TO CHANGE THE DATE FORMAT, OR EXTRACT COMPONENTS

format(x = fmt.date, "%b-%y-%a")
```

    ## [1] "Mar-17-Wed"

``` r
format(x = fmt.date, "%a")
```

    ## [1] "Wed"

``` r
#2. NUMERICAL OPERATIONS ON DATES:
# DATES ARE INTERNALLY STORED AS NO. OF DAYS FROM 1970-01-01
unclass(as.Date("1970-01-01", format = "%Y-%m-%d"))
```

    ## [1] 0

``` r
# COMMON FUNCTIONS TO GENERATE DATES, Sys.time() and date()
datetime <- Sys.time() # Sys.time() returns a date and time,an object of POSIXlt and POSIXct class
class(datetime)
```

    ## [1] "POSIXct" "POSIXt"

``` r
dt <- date() # date() returns date and time, object of character class
class(dt)
```

    ## [1] "character"

``` r
fmt.date
```

    ## [1] "2017-03-01"

``` r
datetime
```

    ## [1] "2017-09-15 14:38:16 CDT"

``` r
date
```

    ## function () 
    ## .Internal(date())
    ## <bytecode: 0x000000001af60650>
    ## <environment: namespace:base>

``` r
# TIME DIFFERENCE
t1 <- Sys.time()
difftime(t1, fmt.date, units = "days")
```

    ## Time difference of 198.8182 days

``` r
# FUNCTION TO EXPLORE FOR HANDLING DATE TIMES
#strftime
#ISOdatetime

# PACKAGES TO EXPLORE FOR COMPLEX FUNCTION ON DATA TIME CLASSES
# fCalendar() and lubridate()
```

``` r
### TYPE CONVERSION & SORTING

# Logical check on typf data structures and type conversion functions are available
#is.<>  as.<> 

# SORTING
# 1. vector : use of sort
sort(data$wt,decreasing = TRUE)
```

    ##  [1] 5.424 5.345 5.250 4.070 3.845 3.840 3.780 3.730 3.570 3.570 3.520
    ## [12] 3.460 3.440 3.440 3.440 3.435 3.215 3.190 3.170 3.150 2.875 2.780
    ## [23] 2.770 2.620 2.465 2.320 2.200 2.140 1.935 1.835 1.615 1.513

``` r
#2. DATA FRAME : 
#a. using function order()

data.sort <- data[order(data$wt),] # order is used to sort, sign with var. determines
# ascending or descending, can do sorting on multiple variables as well

#b. using dplyr's arrange
data.sort1 <- data %>% arrange(wt)
```

``` r
### MERGING DATA SETS, ADDING ROWS AND COLUMNS
#merge(x = data.sort1,y = data.sort2 ,by = ,all.x = ,all.y = ,sort = ,
#        )
# Options to join left, right, inner, outer
# rbind () and cbind() to join rows and columns
```

``` r
### SELECTION, FILTERING a DATA FRAME
# 1. SUPPLY INDEX VALUES IN [] 
# data frame can be indexed using column names, column numbers, logical vectors
# Rows can be indenxed using rownames, row numbers or logical vector
data <- mtcars
#str(data)
cols <- c("mpg","cyl")
data.sel <- data[data$wt > 5, colnames(data) %in% cols]
```

``` r
# SAMPLING
# sample(x = ,    # vector from which to choose 
#        size = , # no. of elements to choose
#        replace = ,
#        prob = ) ?? # need to understand

#sample(1:5, 2, replace = FALSE)

# EXTENSIVE PACKAGE FOR SAMPLING
# sampling and survey
```
