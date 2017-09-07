Data\_Sets, Data Structures, Data Import Sources
================
Sumad Singh
September 5, 2017

``` r
# Function to return a combination of results for printing at the end of a section
print.all <-  function (...){
  temp <- list(...)
  for (i in 1:length(temp)){
    print(temp[[i]])
  }
}
```

DATASETS, DATA TYPES IN R, SCALES OF MEASUREMENT
------------------------------------------------

``` r
# DATA SETS
# Fundamentally identifiers of a data set are 
#1. Primary Key / Case Identifier : Can be declared as rownames in R or id variables 
# (if using package like reshape)
#2. Rows / Cases are observations
#3. Columns are called variables

# DATA TYPES : A value, in a data structure can be of these types
# Basic data types :numeric, character, logical, imaginary, raw
# Add'l data types : date, factor
# Special types : NA, NaN, NULL

# SCALES OF MEASUREMENT
# Variables with nominal and ordinal scale have to be identified as factors
# Continuous scaled are identified as numeric

# DATA STRUCTURES
# vector, matrix, array - multidimensional matrix, dataframe, list

# OBJECTS 
# Any thing that can be assigned to a variables in R is an object.
# An object has a class, which helps generic functions like print() to 
# handle a wide vriety of objects, and a mode to tell how it is stored

# CLASS - can be seen using class(), usually objects are of class of one
# of the data structures - vector, data frame, list etc
 class(NA) # logical, object of NA class
```

    ## [1] "logical"

``` r
 class(NaN) # numeric, object if numeric class
```

    ## [1] "numeric"

``` r
 class(NULL) # NULL , a separate class
```

    ## [1] "NULL"

DATA STRUCTURES
---------------

``` r
# VECTORS
# Some ways to initialize a vector
x <- 5:10
y <- seq_along(x)
# Initialize a charcter vector of length 10, values are blans i.e ""
z <- vector(mode = "character", length = 10)

# Create a vector of NULLs and populate it
null.vec <- rep(NULL, 6)
vec <- sapply(x, function (x) {
                   x            
})
print.all(x,y,z,vec)
```

    ## [1]  5  6  7  8  9 10
    ## [1] 1 2 3 4 5 6
    ##  [1] "" "" "" "" "" "" "" "" "" ""
    ## [1]  5  6  7  8  9 10

``` r
# MATRICES 
# Explore the function
mat <-matrix(data= vec,nrow = 3,ncol =2 ,byrow = TRUE ,
       dimnames = list(rnames = c("r1","r2","r3"), cnames = c("c1", "c2")) )
print.all(str(mat), dimnames(mat))
```

    ##  int [1:3, 1:2] 5 7 9 6 8 10
    ##  - attr(*, "dimnames")=List of 2
    ##   ..$ rnames: chr [1:3] "r1" "r2" "r3"
    ##   ..$ cnames: chr [1:2] "c1" "c2"
    ## NULL
    ## $rnames
    ## [1] "r1" "r2" "r3"
    ## 
    ## $cnames
    ## [1] "c1" "c2"

``` r
# ARRAYS - multi dimensional matrices
# Example of three dimensional arrays
a <- array(data = 4:27, dim = c(2,3,4) ,dimnames = list(dim1 = c("a1","a2"), 
                                                        dim2= c("b1","b2", "b3"),
                                                        dim3= c("c1","c2", "c3", "c4"))) 
# array of 2*3*4 elements
print.all(a, a[1,2,3]) # element identified as a1,a2,c3
```

    ## , , dim3 = c1
    ## 
    ##     dim2
    ## dim1 b1 b2 b3
    ##   a1  4  6  8
    ##   a2  5  7  9
    ## 
    ## , , dim3 = c2
    ## 
    ##     dim2
    ## dim1 b1 b2 b3
    ##   a1 10 12 14
    ##   a2 11 13 15
    ## 
    ## , , dim3 = c3
    ## 
    ##     dim2
    ## dim1 b1 b2 b3
    ##   a1 16 18 20
    ##   a2 17 19 21
    ## 
    ## , , dim3 = c4
    ## 
    ##     dim2
    ## dim1 b1 b2 b3
    ##   a1 22 24 26
    ##   a2 23 25 27
    ## 
    ## [1] 18

``` r
# Matrices can have same type of elements
```

``` r
# DATA FRAMES
#  Constucting from vectors
id <- c(3,4,2,1,5)
age <- c(22,32,45,33,32)
diabetes1 <- c("Type1", "Type2", "Type1", "Type2", "Type2")
diabetes2 <- c("Type3", "Type3", "Type4", "Type4", "Type3")
pdata <- data.frame(id, age, diabetes1, diabetes2, row.names = id ,stringsAsFactors = FALSE)
# CASE IDENTIFIER CAN BE SPECIFIED IN THE ARGUMENT WHILE CREATING A DATA FRAME

## Noteworthy items
# 1. data frame() has an argument ..., which lets you specify the vectors as columns i.e
 df <- data.frame(ID = id, AGE = age , DIABETES = diabetes1)

# 2. stringsAsFactors is a true by default, one can set them globally as 
# options(stringsAsFactors = FALSE) or in the frame creation

# 3. Indexing using names - PARTIAL MATCHING , A PROBLEM
# $ INDEXING : df$DIAB #returns a vector, because partial matching is applied on column names
# when indexing with $
#pdata$diab returns NULL, you would want it to return an error!

# [] INDEXING:
#1. df[,"DIAB"] though returns an error, which is good

#2. Useful to index and make call to variable by refrence i.e
 #x <- c("ID","AGE") , df[,x] 
 # x <- c("ID","AG") , df[,x] will not work and throw an error
print.all(df$DIAB, pdata$diab)  # df[,"DIAB"] , df[,c("ID","AG")] throw error
```

    ## [1] Type1 Type2 Type1 Type2 Type2
    ## Levels: Type1 Type2
    ## NULL

``` r
# lESSON :You have to be careful of these aspects when building data pipelines, using []
# seems to be helpful
```

``` r
# DATAFRAMES CONTINUED
# CROSS TABS FROM DATA FRAMES 
tbl <- table(pdata$age, pdata$diabetes1)

# HOW TO AVOID USE OF COLUMN NAMES : CREATING ENCLOSURES
# ATTACH(), DETACH(), WITH()
# attach puts the name of the data frame/s in R's search path, so you can use the 
# column names freely, detach does the opposite

attach(mtcars)
str(mtcars)
```

    ## 'data.frame':    32 obs. of  11 variables:
    ##  $ mpg : num  21 21 22.8 21.4 18.7 18.1 14.3 24.4 22.8 19.2 ...
    ##  $ cyl : num  6 6 4 6 8 6 8 4 4 6 ...
    ##  $ disp: num  160 160 108 258 360 ...
    ##  $ hp  : num  110 110 93 110 175 105 245 62 95 123 ...
    ##  $ drat: num  3.9 3.9 3.85 3.08 3.15 2.76 3.21 3.69 3.92 3.92 ...
    ##  $ wt  : num  2.62 2.88 2.32 3.21 3.44 ...
    ##  $ qsec: num  16.5 17 18.6 19.4 17 ...
    ##  $ vs  : num  0 0 1 1 0 1 0 1 1 1 ...
    ##  $ am  : num  1 1 1 0 0 0 0 0 0 0 ...
    ##  $ gear: num  4 4 4 3 3 3 3 4 4 4 ...
    ##  $ carb: num  4 4 1 1 2 1 4 2 2 4 ...

``` r
tbl2 <- table(cyl,gear)
detach()

# Limitation : MASKING OF NAMES OF OBJECTS IN WORKSPACE, IF NAMES ARE SAME
# THIS COMES UP EVEN WHEN FUNCTION NAMES ARE SAME ACROSS PACKAGES
# IN THAT EVENT, ONE HAS TO DO AN EXCLUSIVE CALL TO FUNCTION WITH PACKAGE NAME
# AS <PACKAGE> :: <FUNCTION NAME>
cyl <- c(2,3,4)
print.all(attach(mtcars) , cyl) # 
```

    ## The following object is masked _by_ .GlobalEnv:
    ## 
    ##     cyl

    ## <environment: 0x000000001b348658>
    ## attr(,"name")
    ## [1] "mtcars"
    ## [1] 2 3 4

``` r
detach(mtcars)

# WITH() AND <<-
with(mtcars, table(cyl,gear))
```

    ##    gear
    ## cyl  3  4  5
    ##   4  1  8  2
    ##   6  2  4  1
    ##   8 12  0  2

``` r
# With creates an environmnt enclosure, any variables or functions defined in the 
# enclosure are valid in the enclosure only
# << i.e GLOBAL ASSIGNMENT CAN BE USED WITH WITH() TO USE VARIABLES CREATED OUTSIDE THE ENCLOSURE
 with(mtcars,{
   tbl3 <<- table(cyl, gear)
 })
tbl3
```

    ##    gear
    ## cyl  3  4  5
    ##   4  1  8  2
    ##   6  2  4  1
    ##   8 12  0  2

``` r
# FACTORS
# VARIABLES IN A DATA FRAME THAT ARE ON SCALE ORDINAL OR NOMINAL NEED TO BE DECLARED AS FACTORS,
# TO ENSURE PROPER TREATMENT IN STATISTICAL ANALYSIS, AS WELL AS IN PLOTTING
# Use of Function factor()
id <- c(3,4,2,1,5)
age <- c(22,32,45,33,32)
diabetes <- c("Type1", "Type2", "Type1", "Type2", "Type2")
status <- c("poor", "improved", "poor", "improved", "excellent")
pdata1 <- data.frame(id, age, diabetes, status, row.names = id ,stringsAsFactors = FALSE)
pdata2 <- pdata1
pdata3 <- pdata1
pdata4 <- pdata1

# factor is stored in R as a vector of integers, mapped to the levels
# arguments to a factor let you specify if it is for an ordinal or a nominal scale variable, as 
# well as order of the levels in the ordinal variable

## ORDERED FACTOR, SPECIFIED LEVELS, NEW LABLES, INTEGERS ARE ASSIGNED IN THE ORDER THE LEVELS ARE
## SPECIFIED
pdata2$status <- factor(x = pdata2$status ,
                        levels = c("poor", "improved", "excellent") ,
                        labels = c("P", "I", "E"),
                        ordered = TRUE )
## UNORDERED FACTOR, INTEGERS ARE ASSIGNED IN THE ORDER LEVELS ARE SPECIFIED
pdata3$status <- factor(x = pdata3$status ,
                        levels = c("poor", "improved", "excellent") )
## UNORDERED FACTOR, LEVELS ARE NOT SPECIFIED, SO INTEGERS ARE ASSIGNED
## IN ALPHABETIC ORDER
pdata4$status <- factor(x = pdata4$status, 
                        labels = c("P", "I", "E"))
                        

print.all(str(pdata1), str(pdata2), str(pdata3), str(pdata4), summary(pdata4))
```

    ## 'data.frame':    5 obs. of  4 variables:
    ##  $ id      : num  3 4 2 1 5
    ##  $ age     : num  22 32 45 33 32
    ##  $ diabetes: chr  "Type1" "Type2" "Type1" "Type2" ...
    ##  $ status  : chr  "poor" "improved" "poor" "improved" ...
    ## 'data.frame':    5 obs. of  4 variables:
    ##  $ id      : num  3 4 2 1 5
    ##  $ age     : num  22 32 45 33 32
    ##  $ diabetes: chr  "Type1" "Type2" "Type1" "Type2" ...
    ##  $ status  : Ord.factor w/ 3 levels "P"<"I"<"E": 1 2 1 2 3
    ## 'data.frame':    5 obs. of  4 variables:
    ##  $ id      : num  3 4 2 1 5
    ##  $ age     : num  22 32 45 33 32
    ##  $ diabetes: chr  "Type1" "Type2" "Type1" "Type2" ...
    ##  $ status  : Factor w/ 3 levels "poor","improved",..: 1 2 1 2 3
    ## 'data.frame':    5 obs. of  4 variables:
    ##  $ id      : num  3 4 2 1 5
    ##  $ age     : num  22 32 45 33 32
    ##  $ diabetes: chr  "Type1" "Type2" "Type1" "Type2" ...
    ##  $ status  : Factor w/ 3 levels "P","I","E": 3 2 3 2 1
    ## NULL
    ## NULL
    ## NULL
    ## NULL
    ##        id         age         diabetes         status
    ##  Min.   :1   Min.   :22.0   Length:5           P:1   
    ##  1st Qu.:2   1st Qu.:32.0   Class :character   I:2   
    ##  Median :3   Median :32.0   Mode  :character   E:2   
    ##  Mean   :3   Mean   :32.8                            
    ##  3rd Qu.:4   3rd Qu.:33.0                            
    ##  Max.   :5   Max.   :45.0

``` r
#LISTS
hospital <- c("A","B","C","D")
ls <- list(hp = hospital, hp1 = pdata1, hp2 = pdata2, hp3 = pdata3, hp4 = pdata4)
print.all(ls, names(ls))
```

    ## $hp
    ## [1] "A" "B" "C" "D"
    ## 
    ## $hp1
    ##   id age diabetes    status
    ## 3  3  22    Type1      poor
    ## 4  4  32    Type2  improved
    ## 2  2  45    Type1      poor
    ## 1  1  33    Type2  improved
    ## 5  5  32    Type2 excellent
    ## 
    ## $hp2
    ##   id age diabetes status
    ## 3  3  22    Type1      P
    ## 4  4  32    Type2      I
    ## 2  2  45    Type1      P
    ## 1  1  33    Type2      I
    ## 5  5  32    Type2      E
    ## 
    ## $hp3
    ##   id age diabetes    status
    ## 3  3  22    Type1      poor
    ## 4  4  32    Type2  improved
    ## 2  2  45    Type1      poor
    ## 1  1  33    Type2  improved
    ## 5  5  32    Type2 excellent
    ## 
    ## $hp4
    ##   id age diabetes status
    ## 3  3  22    Type1      E
    ## 4  4  32    Type2      I
    ## 2  2  45    Type1      E
    ## 1  1  33    Type2      I
    ## 5  5  32    Type2      P
    ## 
    ## [1] "hp"  "hp1" "hp2" "hp3" "hp4"

DATA INPUT FROM DIFFERENT SOURCES
---------------------------------

### REFERENCE : <http://cran.r-project.org/doc/manuals/R-data.pdf>

<table style="width:22%;">
<colgroup>
<col width="5%" />
<col width="5%" />
<col width="5%" />
<col width="5%" />
</colgroup>
<thead>
<tr class="header">
<th>INPUT</th>
<th>PACKAGE</th>
<th>KEY FUNCTIONS</th>
<th>FURTHER READING/COMMENTS</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>DELIMITED FILES</td>
<td></td>
<td>read.table() ,read.csv()</td>
<td></td>
</tr>
<tr class="even">
<td>XLS</td>
<td>xlsx,rodbc</td>
<td>read.xlsx()</td>
<td>* Create worksheets in a workbook, read from an excel 2007 file i.e xlsx, which is a collection of zipped xmls</td>
</tr>
<tr class="odd">
<td>ZIPPED FILES</td>
<td></td>
<td>gzfile(),bzfile(),xzfile()</td>
<td></td>
</tr>
<tr class="even">
<td>RDBMS</td>
<td>RODBC</td>
<td></td>
<td>Also helpful to read from ms excel, ms access</td>
</tr>
<tr class="odd">
<td>XML</td>
<td></td>
<td></td>
<td>Useful for putting the semi-structured xml format into structured format, <a href="http://www.omegahat.net/RSXML/Tour.pdf" class="uri">http://www.omegahat.net/RSXML/Tour.pdf</a></td>
</tr>
<tr class="even">
<td>WEB SCRAPING</td>
<td>Rcurl and xml to read complex web data</td>
<td>url()- to make a web connection ,readLines() - to read text data, gsub() and grep() for pattern finding and replacement</td>
<td><a href="http://www.programmingr.com/" class="uri">http://www.programmingr.com/</a></td>
</tr>
<tr class="odd">
<td>HDFS - HIVE TABLES, PARQUET FILES</td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td>JSON</td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td>SPSS, SAS</td>
<td></td>
<td></td>
<td></td>
</tr>
</tbody>
</table>

``` r
# DELIMITED FILES
# Key arguments : read.table(file = ,header = ,sep = ,nrows = ,skip = ,
# colClasses = ,stringsAsFactors = ,na.strings = , nrow = )# 

# MS EXCEL AND ACCESS FILES
#install.packages("RODBC")
# library(RODBC)

# Example of reading an excel workbool
# # create an odbc connection to excel workbook
# con <- RODBC::odbcConnectExcel(xls.file = )
# # Read a workbook 
# dataframe <- RODBC::sqlFetch(channel = con, sqtable = <file name>)
# RODBC::odbcClose()

#install.packages("xlsx")
#library(xlsx)
#xlsx::read.xlsx(file= ,sheetName = ,sheetIndex = ,startRow = ,endRow = ,header = ,colClasses = )
```
