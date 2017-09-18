Intro to Regular Expressions
================
Sumad Singh
9/17/2017

``` r
# REGULAR EXPRESSIONS ARE A SET OF INSTRUCTIONS GIVEN AS A SET OF CHARACTERS, 
# COMBINED TOGETHER USING ARITHMETIC LIKE OPERATORS, BUILT IN MANY LANGAGES TO MAKE STRING MATCHING
# AND REPLACEMENT EASY IN MANY LANGUAGES
# YOU HAVE THEM IN PERL, PYTHON , R AND MANY MORE.

# THE SPECIAL FUNCTIONS BUILT TO DO PATTER MATCHING, UNDERSTAND THESE 'REGULAR  EXPRESSIONS' AS
# INSTRUCTIONS. IF ONE IS NOT AWARE OF WHAT REGULAR EXPRESSIONS ARE OR HOW THEY ARE FORMED, 
#1.ONE MAY NOT EFFICIENTLY SOLVE THE PROBLEMS INVOLVING TEXT CLEANING/STRUCTURING
#2. ONE MAY GET ERRORS IN SIMPLE TASKS FO PATTERN MATCHING

# R'S DOCUMENTATION MAY BE INSUFFICIENT, SO AN OPTION IN R IS TO UNDERSTAND THE IMPLEMENTATION OF
# REGULAR EXPRESSIONS IN PERL, perl = TRUE , AND ONE CAN READ PERL DOCUMENTATION  OR EVEN 
# PYTHON'S 
```

``` r
# R FUNCTIONS (MOST BUT NOT ALL ARE USED FOR PATTERN MATCHING) AND UNDERSTAND REGULAR EXPRESSIONS
# GREP(), GSUB(), STRSPLIT(), CAT(), PRINT() ETC
```

``` r
# METACHARACTERS -  BASIC REGULAR EXPR., THESE HAVE SPECIAL MEANINGS WHEN USED IN "PATTERN" ARGUMENT 
# IN SOME FUNCTIONS

# "( )" - interpreted to group the metacharacters together to form extended regular expressions
# "{ }"
# "[ ]" - bracket used to build a character class, any charcter class will be enclosed with []
# "|" - interpreted as an OR when building extended regular expressions
# "\" 
# "^" : instruction to match empty i.e "" (0 character string) string at begininig of line, 
#       except in CHARCTER CLASS (SEE BELOW)
#       where it means to match for any character except the one following ^
# "*" : instruction to match zero or more occurence of pattern preceeding *
# "+" : instruction to match one or more occurence of pattern preceeding +
# "$" : instruction to match empty string at end of line
# "."
# "?"

# EXAMPLES OF UNITENDED USAGE
str <- "R's use of $ {dollar}, .(period)"
# replace {} with ()
# WRONG USAGE, $ IS A METACHARACTER, WHEN SUPPLIED AS PATTERN, IT IS MEANT TO BE INTERPRETED TO LOOK 
# FOR END OF LINE
gsub(x = str, pattern = "$",str, replacement = "D")
```

    ## [1] "R's use of $ {dollar}, .(period)D"

``` r
# TO R NOT TO UNDERSTAND REGULAR EXPRESSIONS, USE FIXED = TRUE
gsub(x = str, pattern = "$",str, replacement = "D", fixed = TRUE)
```

    ## [1] "R's use of D {dollar}, .(period)"

``` r
# OR PRECEED A METACHARACTER BY \\, MAKING \\ AS OF A REGULAR EXPRESSION ITSELF
gsub(x = str, pattern = "\\$",str, replacement = "D")
```

    ## [1] "R's use of D {dollar}, .(period)"

``` r
# EXAMPLE - CLEANING NAMES IN A DATA FRAME
col..1 <- c(1,2,3)
col.....2 <- c(4,5,6)
col.3 <- c(3,4,5)  
df <- data.frame(col..1, col.....2, col.3)
newnames <- gsub(pattern = "\\.+",replacement = "." ,x = names(df) ) # NOTE THAT "." IS A REGEX ITESELF, 
                                                                    # SO USED \\.
colnames(df) <- newnames
df
```

    ##   col.1 col.2 col.3
    ## 1     1     4     3
    ## 2     2     5     4
    ## 3     3     6     5

``` r
# CHARACTER CLASS ( explained with examples)
# EX1 : "[acd]" - character class to match charatcers a OR charcter c OR charcter d in a string
# EX2 : "[A-Z]" - match for any capitalized letters
# EX3 : "[a-z]" - match for any small capped letters
# EX4 : "[0-9]" - match for any numeric
# EX5 : "[a-zA-Z]" - match for any letter cap or uncapped
# EX6 : "[a-zA-Z0-9]" - match for any letter or numeric
# EX7 : "[^a-zA-Z0-9]" - match for any character except letters or numerics
# Ex8 : "[\n\t\r\f\v]" - special characters for space, new line,tab,carriage return, form feed,
#                        vertical tab
# Ex9 : "[]`~!@#$%^&*()-_+="[{}\|;:'"",<.>/?\\]" - 35 punctuation characters

# WHAT ABOUT MEANING OF METACHARACTERS INSIDE A CHARACTER CLASS
# METACHARACTERS ARE TREATED AS NORMAL CHARATCERS INSIDE A CHARATCER CLASS, EXCEPT THE FOLLOWING 
# ] - ^ \
# ] : TO USE IT FOR MATCHING,IT SHOULD BE PLACED FIRST
# - : TO USE FOR MATCHING, SHOULD BE PLACED FIRST OR LAST
# ^ : ANYTHING SUCCESSDING '^', IS TREATED AS NOT BE MATCHED WHEN IT IS PUT IN THE FIRST PLACE  
#     IN A CHARACTER CLASS;SO TO USE IT FOR MATCHING IT SHOULD NOT BE PUT FIRST
# \ : IT RETAINS ITS MEANING IN A CHARACTER CLASS, EXCEPT WHEN USED WITH \\

# EXAMPLES:
#1.
grep("[nco]", c("nose", "letter38", "window9", "apple0"), value = TRUE)
```

    ## [1] "nose"    "window9"

``` r
#2.
grep("[01234567]", c("nose", "letter38", "window9", "apple0"),
     value = TRUE)
```

    ## [1] "letter38" "apple0"

``` r
# EXAMPLE : REPLACE space related text with NA
d = data.frame(id = c(11, 22, 33, 44, 55, 66, 77, 88), drug = c("vitamin E",
     "vitamin ESTER-C", " vitamin E ", "vitamin E(ointment)",
     "", "vitamin E ", "provitamin E\n", "vit E"), text = c("",
     "  ", "3 times a day after meal", "once a day", "       ",
     "  one per day ", "\t", "\n  "), stringsAsFactors = FALSE)
d
```

    ##   id                drug                     text
    ## 1 11           vitamin E                         
    ## 2 22     vitamin ESTER-C                         
    ## 3 33          vitamin E  3 times a day after meal
    ## 4 44 vitamin E(ointment)               once a day
    ## 5 55                                             
    ## 6 66          vitamin E              one per day 
    ## 7 77      provitamin E\n                       \t
    ## 8 88               vit E                     \n

``` r
# method using alphanumeric character classes
d1 <-d
ind <- grep(pattern = "[a-zA-Z0-9]", x = d$text,value = FALSE,invert = TRUE)
d1$text[ind] <- NA
d1
```

    ##   id                drug                     text
    ## 1 11           vitamin E                     <NA>
    ## 2 22     vitamin ESTER-C                     <NA>
    ## 3 33          vitamin E  3 times a day after meal
    ## 4 44 vitamin E(ointment)               once a day
    ## 5 55                                         <NA>
    ## 6 66          vitamin E              one per day 
    ## 7 77      provitamin E\n                     <NA>
    ## 8 88               vit E                     <NA>

``` r
# Another method using space related characters
d2 <-d
d2$text <- gsub(pattern = "[\t\n\r\v\f]+|^( +)$|^$", replacement = NA, x = d2$text)
d2
```

    ##   id                drug                     text
    ## 1 11           vitamin E                     <NA>
    ## 2 22     vitamin ESTER-C                     <NA>
    ## 3 33          vitamin E  3 times a day after meal
    ## 4 44 vitamin E(ointment)               once a day
    ## 5 55                                         <NA>
    ## 6 66          vitamin E              one per day 
    ## 7 77      provitamin E\n                     <NA>
    ## 8 88               vit E                     <NA>

``` r
# EXAMPLE : GET ALL STRINGS WITH vitamin E
grep(pattern = "( +)vitamin( +)e( +)|
     ^( *)vitamin( +)e( +)|
     ( *)vitamin( +)e( +)$)|
     ^( *)vitamin( +)e( *)$" ,x = d$drug,value = TRUE,ignore.case = TRUE)
```

    ## [1] " vitamin E "

``` r
# better implementation
grep(pattern = "([^a-z]+|^)vitamin([^a-zA-Z]+)e($|[^a-zA-Z])|
     ([^a-z]+|^)vit([^a-zA-Z]+)e($|[^a-zA-Z])" ,
     x = d$drug, ignore.case = TRUE, value = TRUE)
```

    ## [1] "vitamin E"           " vitamin E "         "vitamin E(ointment)"
    ## [4] "vitamin E "
