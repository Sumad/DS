Basic Visualization
================
Sumad Singh
September 7, 2017

### BASIC GRAPHIC SYSTEM IN R

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
plot(x = hp ,y = mpg,type = "p") # PLOT IS A HIGH LEVEL FUNCTION IN R, WHICH CAN MAKE DIFFERENT TYPE OF PLOTS
# BASED ON THE 'TYPE' ARGUMENT
abline(reg = lm(mpg~hp))
detach(mtcars)
#help(abline)
```

``` r
#2. KEY PLOTTING FUNCTIONS
# 2.1 PLOT
#PLOT FUNCTION WORKS DIFFERENTY ON OBJECTS LIKE DATA FRAMES, DENSITY, PLOT.DEFAULT WORKS 
#FOR SCATTERPLOT B/W X AND Y
attach(mtcars)
plot(x= hp, y= mpg,type = "p",xlab = "log (horsepower)",ylab = "log(Miles per gallon)",log = "xy" ,main = " Log Linear relationship?"  ,
     sub =  "log mpg vs log hp" ,frame.plot = TRUE,asp = 1)
```

![](Basic_Viz_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-2-1.png)

``` r
detach(mtcars)
# xlim, ylim are limits on the axes
# main title
# sub - subtitle of the plot
# xlab/ylab -  x , y axis labels
# axes - used "xaxt" or "yaxt to suppresss one of the axes"
# frame.plot - logical to choose if plot to be enclosed in a box
# asp - aspect ration i.e y/x

# 2.2 
#lines()

#2.3 
#abline(v = seq()) can give horizontal and vertical points where to draw lines
```

``` r
# Plot function operates on a data frame with all numeric columns to give
# bivariate scatter plots
plot(mtcars)
```

![](Basic_Viz_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-3-1.png)

``` r
#3. GRAPHICAL PARAMETERS - COLOR, LINE/POINT/BAR TYPE, LENGTH,WIDTH ,TEXT ETC
#A. GENERAL FUNCTION TO SPECIFY GRAPHICAL PARAMETERS
#par() # return a list of current graphical paramters
par.default <- par(no.readonly = TRUE) # return the current setting of parameters that can be modified, use of no.readonly=T
par(lty = 2, lwd = 2, pch= 2 ,cex= 1.2) # new settings
attach(mtcars)
plot(x= hp, y= mpg,type = "p",xlab = "horsepower",ylab = "Miles per gallon" ,main = " Linear relationship?"  ,
     sub =  "mpg vs hp" ,frame.plot = TRUE)
abline(reg = lm(mpg ~ hp))
```

![](Basic_Viz_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-4-1.png)

``` r
detach(mtcars)
par(par.default) # return to original settings


#B. GRAPHICAL PARAMETERS WITHIN HIGH LEVEL FUNCTIONS (NOT ALL ARE AVAILABLE THOUGH!, 
#SO USE A OPTION AS NEEDED )
# plot() and abline() for example have ... argument to specify graphical parameters,
# these settings are used only for the current plot
```

### GRAPHICAL PARAMETERS SUMMARY & DETAILS

<table style="width:22%;">
<colgroup>
<col width="5%" />
<col width="5%" />
<col width="5%" />
<col width="5%" />
</colgroup>
<thead>
<tr class="header">
<th>GEOM</th>
<th>PARAMETER/AESTHETIC</th>
<th>KEYWORD USED FOR SETTING AESTHETIC FOR GEOM</th>
<th>REALIZATION-AES.GEOM</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>TEXT - TITLE, SUBTITLE,AXIS LABELS,AXIS VALUES</td>
<td>FONT FAMILY,FONT,SIZE,COLOUR</td>
<td>family,font,cex,col</td>
<td>family,</td>
</tr>
<tr class="even">
<td>font.main, font.sub, font.lab, font.axis AND col.main, col.sub etc AND cex.main, cex.sub etc</td>
<td></td>
</tr>
<tr class="odd">
<td>POINT</td>
<td>SIZE, TYPE, COLOR</td>
<td>cex,pch</td>
<td>cex, pch, col</td>
</tr>
<tr class="even">
<td>LINE</td>
<td>TYPE, WIDTH, COLOR</td>
<td>lty,lwd</td>
<td>lty,lwd, col</td>
</tr>
<tr class="odd">
<td>PLOT DIM</td>
<td>DIM</td>
<td>dim(wdth,hght)</td>
<td>same</td>
</tr>
<tr class="even">
<td>MARGIN</td>
<td>MARGIN IN INCHES OR LINES</td>
<td>mar(vector of 4) or mai(vector of 4)</td>
<td>same</td>
</tr>
</tbody>
</table>

``` r
#C.  PARAMETERS/AESTHEICS FOR POINTS AND LINES(GEOMS)
# pch -  point type, goes from 0 to 24
# cex - size zooming relative to default of 1, expressed as 1.<x>
# lty - line type goes from 1 to 6
# lwd - line width ,elative to default of 1, expressed as 1.<x>

# D. COLOR PARAMETER/AESTHETICS FOR TEXT BASED GEOMS
# col - color of lines or points in the plot, can be given as a vector, the values of which are recycled
# col.axis - color of axes
# col.lab - color of label of axes
# col.main , col.sub 
#fg, bg - foreground and background color

# FUNCTIONS TO GET A VECTOR OF COLORS, COLOR VALUES CAN BE SPECIFIED AS NAMES, OR INTS
#OR HEXADECIMALS
x <- colors(5)
y <- rainbow(5)
z <- heat.colors(5)
cvec <- c(rgb(0.2,1,0.5), rgb(0.5,1,0),rgb(0.5,0.5,0.2),rgb(0.1,0.3,0.4),rgb(0.4,.2,0.1)) 
# rgb lets you create  vector of colors using red green blue
hvec <- c(hsv(0.2,1,0.5), hsv(0.5,1,0),hsv(0.5,0.5,0.2),hsv(0.1,0.3,0.4),hsv(0.4,.2,0.1))
# hsv is another function
pie(x = c(100,20,30,40,10),radius = 1 ,clockwise = TRUE ,col = y ,labels = y)
```

![](Basic_Viz_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-5-1.png)

``` r
# function to create a pie chart
```

``` r
#D. PARAMETERS FOR TEXT (contd.) -
#SIZE : params for font size
# cex - specify how much text enlargement is needed for plotted text
# same paramter govern point size
# cex. axis - for text on the axis
# cex.lab - axes labels
# cex.main - main title
# cex.sub - subtitle


#FONT FAMILY, STYLE
# family - for drawing text,
  #by default there are three families - serif, sans, mono
# font - integer for specifying bold  -2, italic-3 ,plain - 1, bold italic - 4  
 # for plotted text
# font.axis - for text on the axis, i.e values marked on axes
# font.lab - axes labels
# font.main - main title
# font.sub - subtitle

# ps - font point size (1/72 inch). text size =  cex * ps


#E. GRAPH DIMESNIONS AND MARGINS (GEOM)
#pin(width, height) to fix plot dimensios in inches
#mar() - vector of 4 to fix margins in lines in order (bottom, left, top, right) 
#mai() - same but this is in inches, default  is c(5,4,4,2) + 0.1 

# Example , draw a simple scatter and line chart 
# fix dim of plot, fix margins, note the margins are taken from the plot are and out
attach(mtcars)
par.default <- par(no.readonly = TRUE)
par(pin=c(5,3), mai = c(1,1,0.5,0.5)) # 33% of y dim as margin in bottom, 20% on left

# EXAMPLE:
# fix point type/size,
# Font family, font bolded for title, italics for axis, bold italics for labels
plot(x = wt, y= mpg, type = "p" ,main = "Scatter Plot with regression line" ,
     frame.plot = TRUE, pch = 2,col= "blue",xlab = "Weight", ylab = "Mpg",
     font.axis = 3, font.main = 2,font.lab = 4, 
     cex = 1.2, cex.main = 1.2, cex.lab= 0.8, cex.axis = 0.9)

# fix color/type/width of line
abline(reg=lm(mpg~wt), lty = 2, lwd = 1.2, col ="red")
```

![](Basic_Viz_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-6-1.png)

``` r
detach(mtcars)
par(par.default)
```

``` r
# F. ADDING TEXT ON CHART, LEGENDS, CUSTOMIZING AXES SEPARATELY
# Only some of the high level functionslike plot() let you specify
# the graphical parameters, in other cases separate function can be used

#F.1 TITLE LETS setting OF TEXT RELATED AESTHETICS LIKE 
# TEXT SIZE, FONT, COLOR, FAMILY
#title(main = ,sub = ,xlab = ,ylab = , # Adding titles - main, sub, labels
#      col.main =,col.sub, col.lab =,  # Adjust color
#      cex.main =, cex.sub, cex.lab)  # Adjust size

#F.2 AXIS LETS CUSTOMIZATION OF AXES
# USE TO DRAW GRAPHS WITH MORE THAN 2 AXES
#PLOTS ONE AXIS AT A TIME
# axis(side = ,    which side of the plot to draw axis (1-b,2-l,3-u,4-r)
#      at = ,  num vector, where to put tick marks on the axis
#      labels = ,  char vec, what labels to give to ticks
#      tick = , length of tick as fraction of plotting area
#      pos = ,  point on the other axis where it crosses
#      font = ,
#      las = labels parallel or perpendicular to axis
#      lty = ,lwd = ,lwd.ticks = ,col = ,col.ticks = )

# Note: If using a plot function fto plot first, need to suppress
# the axis created using axes = FALSE or use xaxt, yaxt arguments

# F.3 USING MINOR TICKS IN A PLOT from Hmisc library
# library(Hmisc)
# minor.tick(nx = , ny = , no. of intevals to divide major ticks in on x and y axis
#            tick.ratio = ) size of minor tick to major tick

# F.4 LEGEND, KEY PARAMS
# legend(x= ,y = , # coordinates of legend or use xy.legend and "left", "right" etc
#        legend = , # charcter vector of labels 
#        fill = ,# causes boxes to be filled besides legend text
#        col = , # cause color of point or lines appearing besdides text
#        pch = ,lty = ,lwd = , point or line attributes appearing the legend
#        bty = ,bg =  box type, background color
#        box.lwd = ,box.lty = ,box.col = )

# EXERCISE : PLOT SCATTER AND REGRESSION LINE B/W WT AND MPG, FOR SUBSETS BASED
# ON CYL TO SEE WHERE THERE IS A LINEAR DEPENDENCE
#str(mtcars)
#data <- mtcars
#data$color <- ifelse(data$cyl==4,"red",ifelse(data$cyl==6,"green","blue"))
#install.packages("dplyr")
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
attach(mtcars)
par.default <- par(no.readonly = TRUE)
#colors <- rainbow(n = length(unique(cyl)))
plot(x = wt, y = mpg, type = "p", main = " mpg vs wt" ,frame.plot = TRUE, col = cyl)
abline(reg = lm(formula = mpg ~ wt,subset = (cyl==4)),lty = 1)
abline(reg = lm(formula = mpg ~ wt,subset = (cyl==6)), lty = 2)
abline(reg = lm(formula = mpg ~ wt,subset = (cyl==8)), lty = 3)
abline(reg = lm(formula = mpg ~ wt), lty = 6, col = "red")
legend(x = "topright",legend = c("cyl-4","cyl-6","cyl-8", "combined"),lty = c(1,2,3,6),
       col = c(rep("black",3),"red"))
```

![](Basic_Viz_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-7-1.png)

``` r
detach(mtcars)
par(par.default)
```

``` r
#F.5 ADDING TEXT ON CHART AT CUSTOM PLACES (FOR LABELING) AND ON MARGINS
#str(mtcars)
# TEXT(), MTEXT() FUNCTIONS
attach(mtcars)
plot(x = wt, y = mpg)
text(x = wt, y = mpg, # can be vectors specifying x,y coordinates to place text
     labels = rownames(mtcars), # labels of text to place
     cex = 0.6,col = "red", # size, color, font etc aesthetics of text
     pos =4 # relative position w.r.t x,y coordinates where to place text   
     )
mtext(text = "wt in '000 pounds" , # text to be put in margins
      side = 1 ,line = 2,adj = 1) # which side (1/2/3/4)
```

![](Basic_Viz_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-8-1.png)

``` r
                                  # how many lines of difference to be put from margin
                                  # adjustment to left of right, or top/bottom of text
detach(mtcars)
# math notation can also be added, details are spared for now.
# More on this with demo(plotmath) and help(plotmath)
```

``` r
# G. GRAPHICAL PARAMETERS TO COMBINE GRAPHS
#G.1 WITH PAR(), WE CAN SET MFROW() AND MFCOL() TO COMBINE PLOTS

par.default  <- par(no.readonly = TRUE)
par(mfrow = c(2,2))
attach(mtcars)

boxplot(x = wt, main = "Distribution of Weight using boxplot", 
        cex.main = 0.9)

hist(x = wt,density = TRUE, main = "Distribution of Weight using histogram",
     cex.main = 0.9)

plot(x = wt, y = mpg, main = "Scatter plot to visualize linear dependence", 
     cex.main = 0.9)

plot(x = wt, y = mpg, type = "p", main = " mpg vs wt" ,frame.plot = TRUE, 
     col = cyl, cex.main = 0.9)
abline(reg = lm(formula = mpg ~ wt,subset = (cyl==4)),lty = 1)
abline(reg = lm(formula = mpg ~ wt,subset = (cyl==6)), lty = 2)
abline(reg = lm(formula = mpg ~ wt,subset = (cyl==8)), lty = 3)
abline(reg = lm(formula = mpg ~ wt), lty = 6, col = "red")
legend(x = "topright",legend = c("cyl-4","cyl-6","cyl-8", "combined"),lty = c(1,2,3,6),
       col = c(rep("black",3),"red"),cex = 0.6)
```

![](Basic_Viz_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-9-1.png)

``` r
detach(mtcars)
par(par.default)
```

``` r
#G.2 LAYOUT() FUNCTION GIVES MORE FINE CONTROL IN PLOT SIZING
# LAYOUT FUNCTION TAKES FOLLOWING KEY ARGUMENTS
#1. MATRIX : MXN DIMENSIONS TO KNOW HOW TO DIVIDE THE DEVICE SPACE
#2. MATRIX : MATRIX ELEMENTS THAT SPECIFY WHICH CELL IS ASSIGNED
# TO WHICH FIGURE
par.default  <- par(no.readonly = TRUE)
layout(mat = matrix(c(1,1,0,2), # ASSIGN CELLS TO FIGURES
                    nrow =2 ,ncol =2 , byrow = TRUE)) # DEFINE CELLS
layout.show(n = 2)
```

![](Basic_Viz_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-10-1.png)

``` r
par(par.default)
```

``` r
par.default  <- par(no.readonly = TRUE)
layout(mat = matrix(c(1,2,3,3), # ASSIGN CELLS TO FIGURES
                    nrow =2 ,ncol =2 , byrow = TRUE),# DEFINE CELLS
                    heights = c(45,55)) # heights and widths
                      # used to specify relative/absolute dimesnions
                      # of rows and cols resp., here 45% to 55%
attach(mtcars)

boxplot(x = wt, main = "Distribution of Weight using boxplot", 
        cex.main = 0.9)

plot(x = wt, y = mpg, main = "Scatter plot to visualize linear dependence", 
     cex.main = 0.9)

plot(x = wt, y = mpg, type = "p", main = " mpg vs wt" ,frame.plot = TRUE, 
     col = cyl, cex.main = 0.9)
abline(reg = lm(formula = mpg ~ wt,subset = (cyl==4)),lty = 1)
abline(reg = lm(formula = mpg ~ wt,subset = (cyl==6)), lty = 2)
abline(reg = lm(formula = mpg ~ wt,subset = (cyl==8)), lty = 3)
abline(reg = lm(formula = mpg ~ wt), lty = 6, col = "red")
legend(x = "topright",legend = c("cyl-4","cyl-6","cyl-8", "combined"),lty = c(1,2,3,6),
       col = c(rep("black",3),"red"),cex = 0.6)
```

![](Basic_Viz_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-11-1.png)

``` r
detach(mtcars)

par(par.default)
```

``` r
# G.3 PAR () FUNCTION WITH PARAMETERS FIG AND NEW
# lets you combine plots with finest control
# FIG takes values as (x1,x2,y1,y2) to confine the boundary in which to draw the plot,
# each of x1,x2 & y1,y2 define a range on x-axis and y-axis b/w 0,1
# specifying par(fig =) starts a new plot on the graphic device, idea is to continue putting new plots
# using fig , and 
# NEW = TRUE ENSURES THE NEXT HIGH LEVEL PLOTTING FUNCTION DOES NOT CLEAN THE DEVICE/FRAME, AND
# PLOT AS IF IT WERE A NEW DEVICE, RATHER CONTINIUE WITH PREVIOUS PLOT ON THE FRAME
par.default  <- par(no.readonly = TRUE)
attach(mtcars)
par(fig=c(0,0.8,0,0.8))
plot(x = wt, y = mpg, type = "p", frame.plot = TRUE, 
     col = cyl, cex.main = 0.9)
abline(reg = lm(formula = mpg ~ wt,subset = (cyl==4)),lty = 1)
abline(reg = lm(formula = mpg ~ wt,subset = (cyl==6)), lty = 2)
abline(reg = lm(formula = mpg ~ wt,subset = (cyl==8)), lty = 3)
abline(reg = lm(formula = mpg ~ wt), lty = 6, col = "red")
legend(x = "topright",legend = c("cyl-4","cyl-6","cyl-8", "combined"),lty = c(1,2,3,6),
       col = c(rep("black",3),"red"),cex = 0.6)

# the use of latter two y values are experimental, need a bit of tuning 
par(fig=c(0,0.8,0.5,1), new = TRUE)

boxplot(x = wt, horizontal = TRUE,axes =FALSE, plot.frame = FALSE)

par(fig=c(0.6,1,0,0.8), new = TRUE)

boxplot(x = mpg, horizontal = FALSE,axes =FALSE, plot.frame = FALSE)
mtext(text = " Three plots combined using fig",side = 3 ,outer = TRUE, 
      line = -3, font = 2) 
```

![](Basic_Viz_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-12-1.png)

``` r
detach(mtcars)

par(par.default)
```