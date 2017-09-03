RIA Ch1 - Getting Started
================

This is an [R Markdown](http://rmarkdown.rstudio.com) Notebook. When you execute code within the notebook, the results appear beneath the code.

Try executing this chunk by clicking the *Run* button within the chunk or by placing your cursor inside it and pressing *Cmd+Shift+Enter*.

``` r
options(echo=FALSE)
# Getting help
help.start()
```

    ## starting httpd help server ... done

    ## If the browser launched by '/usr/bin/open' is already running, it
    ##     is *not* restarted, and you must switch to its window.
    ## Otherwise, be patient ...

``` r
# Amazing links that include
#1. An introduction to R from CRAN
#2.A Search Engine 
#3. User Manuals, Technical Papers
#4. Mailing lists by SIGs (Special Interest Groups)
# 5. list out of packages and so on..

#The R Studio home also offer a lot of useful information -
 # 1. R Cheat Sheets for R Studio packages. 
 #  2. Learning R Online etc
 
RSiteSearch("probability distributions")
```

    ## A search query has been submitted to http://search.r-project.org
    ## The results page should open in your browser shortly

``` r
# The power of searching on Rsite is that it gives a full view of tasks list where the referecnes could be found.
# Instead of a google search, this is more relevant. One can see functions, packages, NEWS, if the packages has vignettes to refer to etc.

data()
# Gives summary of data sets of all loaded packages, can make it specific by giving packagename as an argument

vignette()

# Gives the vignettes of all available loaded packages in the session. Example of data.table - 
# datatable-reshape                Efficient reshaping using data.tables (source, html)
# datatable-faq                    Frequently asked questions (source, html)
# datatable-intro                  Introduction to data.table (source, html)
# datatable-keys-fast-subset       Keys and fast binary search based subset (source, html)
# datatable-reference-semantics    Reference semantics (source, html)
# datatable-secondary-indices-and-auto-indexing
#                                  Secondary indices and auto indexing (source, html)
                                 
vignette("datatable-intro")  

apropos("poisson",mode = "function")
```

    ## [1] "poisson"      "poisson.test" "quasipoisson"

``` r
# Lets you do a string search and return functions that have the string name
```

Add a new chunk by clicking the *Insert Chunk* button on the toolbar or by pressing *Cmd+Option+I*.

When you save the notebook, an HTML file containing the code and output will be saved alongside it (click the *Preview* button or press *Cmd+Shift+K* to preview the HTML file).
