Basic Visualization
================
Sumad Singh
September 7, 2017

BASIC GRAPHIC SYSTEM IN R
-------------------------

### PARAMETERS TO ANNOTATE GRAPHS

### COMBINE GRAPHS

``` r
## USING BASIC GRAPHIC SYSTEM IN R
#1.LAYERING 
#We want to build layers of plots on a single chart, R provides a system to do that
#help("dev.cur")
# IDEA IS TO OPEN A GRAPHICS DEVICE, R ALLOWS TO OPEN MULTIPLE DEVICES,
# DIRECT OUTPUT TO A CHOICE OF DEVICE
# FUNCTIONS LIKE PDF(), PNG(), JPEG() OPEN A DEVICE BY THEMSELVES
# HIGH LEVEL FUNCTIONS LIKE PLOT(), HIST() ETC ALSO OPEN A DEVICE

# USEFUL FUNCTIONS FOR OPENING AND MANAGING DEVICES
# a Null device is always open in a session, once a new device is opened Null does not show up
#dev.new() # Open a new device, 
# dev.cur() # lists the name and number of current active device
# dev.list() # lists the names and mumbers of all open devices
# dev.off() # shuts off a device
# dev.next() # shuffle to next device w.r.t the current
# dev.previous() # same, goes to previous
# graphics.off()  # closes all open devices

# EXAMPLE OF PLOTTING A SCATTER PLOT, AND A REGRESSION LINE
attach(mtcars)
dev.new()
plot(x = hp ,y = mpg,type = "p") # PLOT IS A HIGH LEVEL FUNCTION IN R, WHICH CAN MAKE DIFFERENT TYPE OF PLOTs
# BASED ON THE 'TYPE' ARGUMENTS,  IT TRIES TO FIGURE OUT THE TYPE BASED ON VARIABLES PROVIDED
abline(reg = lm(mpg~hp),)
detach(mtcars)
#help(abline)
```

R Markdown
----------

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:

``` r
summary(cars)
```

    ##      speed           dist       
    ##  Min.   : 4.0   Min.   :  2.00  
    ##  1st Qu.:12.0   1st Qu.: 26.00  
    ##  Median :15.0   Median : 36.00  
    ##  Mean   :15.4   Mean   : 42.98  
    ##  3rd Qu.:19.0   3rd Qu.: 56.00  
    ##  Max.   :25.0   Max.   :120.00

Including Plots
---------------

You can also embed plots, for example:

![](Basic_Viz_files/figure-markdown_github-ascii_identifiers/pressure-1.png)

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.
