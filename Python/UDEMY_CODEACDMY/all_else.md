SECTION 3 : FUNDAMENTALS of PYTHON
Data structures - LISTS
# A data structure in Python. List is like the vector data strucure in R, except that in can store multiple data types
# A list can be defined as ordered set of elements, where elements could be integers,floats,strings, logical or event lists
# Indexing in Python starts from 0, unlike in R where it starts from1
# One method of creating list is using [] brackets
lis=["Hello",10,32.5,True]
type(lis)
list

lis2=["why python",2,lis]
lis2
['why python', 2, ['Hello', 10, 32.5, True]]
lis2[0]
'why python'

# Common functions :Sequence generator function range()
x=range(5)
x
range(0, 5)

type(x)
range

y=list(range(1,10,1))
[1, 2, 3, 4, 5, 6, 7, 8, 9]
# you can use list and function range to generate a sequence with a desired start and interval. 
Range () : Return an object that produces a sequence of integers from start (inclusive)
to stop (exclusive) by step.  range(i, j) produces i, i+1, i+2, ..., j-1.
start defaults to 0, and stop is omitted!  range(4) produces 0, 1, 2, 3.
These are exactly the valid indices for a list of 4 elements.
When step is given, it specifies the increment (or decrement)

Initializing a list
A list of a specific size can be defined by filling it with None – which is a special character in Python like NULL in R
a=[None]*6
You can append to a list by using append() function
 a.append("test")



# Indexing and accessing elements of a list
y[len(y)-1] 
9
# Negative indexing , Python has a negative indexing context, the last element is indexed -1 and index increases towards the left
y[-1] 
9
Slicing (with lists)
#Slicing is same as subsetting in R
# Let us look at subsetting lists , we use [] and : to create subsets
# Three components that could be specified – 
1. Starting index, this could use positive indexing/negative indexing 
2. targeted end index, the actual element targeted is the (specified -1) index
3. jump interval
lis=["a","b",1,"d","e","f","g"]
lis[1:]
['b', 1, 'd', 'e', 'f', 'g']
lis[:6]
['a', 'b', 1, 'd', 'e', 'f']
lis[0::2]
['a', 1, 'e', 'g']

# If using negative indexation, the returned list will be ordered from last elements of parent list
lis[-1::-1]
['g', 'f', 'e', 'd', 1, 'b', 'a']

# you could also think of indexation while slicing as ‘from’ to ‘to’ , and then ‘step’
if you use 6:1,-1 this will work
lis[5:0:-1]
['f', 'e', 'd', 1, 'b']

# Remember slicing with positive as well as negative indexation does not take the last index specified but index-1

Tuples
# Tuples are another data structure,they are called immutable lists, i.e once defined the elemnts of tuples cannot be changes/overwritten
# their declaration is same as list except we use parentheses ()
#Their indexing and element access is same as that of lists
# Oftern lists are passed to functions and we want to be sure the elements of those lists are not changed
x=(23,"a",'34',34)
type(x)
tuple

x[-4]  23
x[-4]=21 throws an error




Lists Comprehensions
Lists comprehensions provides a concise way of 
a.	Creating lists on top of another sequence/s or list/s by applying an operation on them
b.	Applying a function on each element of a list/s
Syntax:  
•	Square bracket 
•	An expression/function followed by a single /multiple for statements on sequences/lists followed by if clause
Examples:
# create a new list with the values doubled
vec = [-4, -2, 0, 2, 4]
[x*2 for x in vec]
# filter the list to exclude negative numbers
[x for x in vec if x>=0]
This is equivalent to achieving this with filter() function
# apply a function to all the elements
new=["Sumad",'at','work']
[len(x) for x in new]
# create a list of 2-tuples like (number, square)
[(i,i**2) for i in vec]
Nested List Comprehensions
The initial expression in a list comprehension can be any arbitrary expression, including another list comprehension.
matrix = [
...     [1, 2, 3, 4],
...     [5, 6, 7, 8],
...     [9, 10, 11, 12],
... ]

[[row[i] for row in matrix] for i in range(4)]
[[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]

How does it work:
[expr for  item1 in  seq1 for item2 in seq2 ... for itemx in seqx if condition]
This list expression has the same effect as:
output_sequence = []
for item1 in seq1:
    for item2 in seq2:
        ...
            for itemx in seqx:
                if condition:
                    output_sequence.append(expr)

So, expression gets evaluated inside last loop



Function and packages
# Common used functions in Python
#range, list,type,len,max, min
# Python has less number of packages, For more functions we utilize packages with inbuilt functions
##Packages
# Packages are a collection of functions
# Module and Packages
# Module: is a file with Python statements, definitions , functions
# Package: is a tree like structre with modules as its constituents
# When you load a package, the functions are available in the Python session
## Installing packages
# 1. Find package
# github is a good place
#2. Install package
# Using anaconda command prompt for anaconda distributions of python - conda install <> or pip install <>
# 3. import package or just import specific functions
# use -  from <package name> import <function name>
import numpy
#numpy. and then press tab to see available functions/classes/methods etc

One can also just load some specific modules from a package
Eg: from math import cos,pi

# TO see help on in-built functions, if they have doc strings, use help
help(mt.cos)
or to see help for a package
Eg: help(math)

Data Structures: Arrays
# We will use array from numpy package , they are more versatile than what is available in base python
import numpy as np
# Defining array, is like passing a list to the function np.array
# Like vectors in R, array can hold elements of only one data type, if multiple data types are specified, then coercion occurs
x=np.array([1,2,"a"])
print(x)
['1' '2' 'a']
# arrays can have more than i dimensions
y=np.array([[1,2],[4,5]],ndmin=2)
print(y)
[[1 2]
 [4 5]]

# In python, an object of a class, inherits all methods defined for the class. This is a very useful property of an Object Oriented language
# y is an object of class 'array', we can readily access and apply methods defined for np.array for y.
y.flatten()
array([1, 2, 4, 5])
y.mean()
3

Slicing Arrays
# Similar to slicing/subsetting lists, we can slice arrays
import numpy as np
x=np.array([1,2,5,78,90])
x
array([ 1,  2,  5, 78, 90])

# Arrays can be copied over using explicit function np.copy(), simple assignment to another array just creates as view of the same array. And if you edit any of the views, the array gets edited. This behavior is not with lists in python, and is designed to preserve memory
y=x
y[3]=100
y
array([  1,   2,   5, 100,  90])

Matrices
# Matrices can be defined in a couple of ways
# 1. Combining lists and using np.array()
# 2. Using np.reshape(arg1,arg2,arg3), where arg 1 can be the data elements, arg2 can be the dimensions specified as a tuple, 
#arg3 is about the order in which matrix is to be filled, 'F' is fortran indicaitng a column wise fill, 'C' indicating C like
# row wise fill
import numpy as np
names=["Sonu","Monue","Rinki"]
ages=[12,20,23]
family=np.array([names,ages])
family
array([['Sonu', 'Monue', 'Rinki'],
       ['12', '20', '23']], 
      dtype='<U5')

# np.arange() function produces a sequence from 'start' to a 'target' less than the 'stop' argument. The resulting data type is 
#an array 
x=np.arange(0,8,0.5)
x
array([ 0. ,  0.5,  1. ,  1.5,  2. ,  2.5,  3. ,  3.5,  4. ,  4.5,  5. ,
        5.5,  6. ,  6.5,  7. ,  7.5])

family2=np.reshape(np.arange(0,9),(3,3),order='C')
family2
array([[0, 1, 2],
       [3, 4, 5],
       [6, 7, 8]])

# Indexing a matrix
family2[1,:] is same as family2[1,]
array([3, 4, 5])

# Other means of indexing arrays
Salary[1,3] is same as Salary[1][3]

14232567



# Using OOP design of python
# If you create an object of array class, the you can use reshape, which is a pre-defined function available for the object to 
# create a matrix out of it
data=np.arange(0,30)
data.reshape((5,6))

array([[ 0,  1,  2,  3,  4,  5],
       [ 6,  7,  8,  9, 10, 11],
       [12, 13, 14, 15, 16, 17],
       [18, 19, 20, 21, 22, 23],
       [24, 25, 26, 27, 28, 29]])


Dictionaries

# Unlike R, in python matrices we have not seen column or row names, so indexing relies on using index numbers
# One way to get around that problem is using dictionaries, esp. if a many matrices are constructed using same variables
# Example in the NBA data set, there is several data on Players, Years in matrices like data on points scores, salaries, games played 
# etc
# To access these matrices one can use dictionaries
# Dictionaries are a separate object consisting of key value pairs, define using curly braces {}
dict1={'name1':2,'name2':'Hero','city':3}
dict1
{'city': 3, 'name1': 2, 'name2': 'Hero'}

Dictionary does not have the elements ordered, to access a value from a list, one needs to use the key. When you print a list, the order of print reflects how key:value pairs are stored internally which is based on storage efficiency
Dictionary is still access by [] brackets and passing the key
# Example of using a dictionary to be able to access data from matrices in the NBA data set would be to define dictionary with
# names of players, and years becuase data on salries, games, points is organized by these

#Seasons
Seasons = ["2005","2006","2007","2008","2009","2010","2011","2012","2013","2014"]
Sdict = {"2005":0,"2006":1,"2007":2,"2008":3,"2009":4,"2010":5,"2011":6,"2012":7,"2013":8,"2014":9}

#Players
Players = ["KobeBryant","JoeJohnson","LeBronJames","CarmeloAnthony","DwightHoward","ChrisBosh","ChrisPaul","KevinDurant","DerrickRose","DwayneWade"]
Pdict = {"KobeBryant":0,"JoeJohnson":1,"LeBronJames":2,"CarmeloAnthony":3,"DwightHoward":4,"ChrisBosh":5,"ChrisPaul":6,"KevinDurant":7,"DerrickRose":8,"DwayneWade":9}

Then access elements like:
Salary[Pdict['JoeJohnson'],Sdict['2011']]
18038573

Points[Pdict['JoeJohnson']]
array([1653, 1426, 1779, 1688, 1619, 1312, 1129, 1170, 1245, 1154])

Matrix Operations
# Scalar Operation like division, additon, subtraction in python are simple, unlike operations on lists
salary_yr1=[10,20,30]
salary_yr2=[20,30,40]
salary_total=salary_yr1+salary_yr2
salary_total
[10, 20, 30, 20, 30, 40]

# lists were concatenated
salary_total=salary_yr1+salary_yr2
array([30, 50, 70])

# Division Operation
salary_div=salary_yr1/salary_yr2
array([ 0.5       ,  0.66666667,  0.75      ])

# Rounding off can be done using a function within 
salary_div.round(2)
array([ 0.5 ,  0.67,  0.75])

salary_mul=salary_yr1*salary_yr2
array([ 200,  600, 1200])

# Other way around is use a function matrix.round within np
np.matrix.round(salary_yr1/salary_yr2,2)
# Good thing is you can again use dictionaries to access resulting matrix out of operation on matrices who have labels defined by a dictionary
successRate=np.matrix.round(FieldGoals/FieldGoalAttempts,2)
successRate[Pdict["KevinDurant"],Sdict["2011"]]

   Data Frames
# For Working with data frame, pandas is one of the best packages heresy
import pandas as pd
# How to work with working directory
# import package of
import os
# To get curent working directory
os.getcwd()
# Note the use of double backslashes in specifying path in jupytetr
# To change working directory
os.chdir("C:\\Users\\ssioj\\Documents\\External Learning\\Udemy Python")
os.chdir("C:\\Users\\ssioj\\Documents\\Fractal docs\\R Training")
# csv files can be read using read_csv function available in pandas
data=pd.read_csv("car_data.csv")
type(data)
pandas.core.frame.DataFrame

---- Exploration of Data Set----
# Getting to know basic information about the data set
#1. Dimenstions of data set, len function give no. of rows
len(data)
#2. No. of columns. An object of type data frame carries functions with it, one being columns
len(data.columns)
#3. Getting the list of headers, notice the data type of what is returned is called index
print(data.columns)
type(data.columns)
Index(['Unnamed: 0', 'mpg', 'cyl', 'disp', 'hp', 'drat', 'wt', 'qsec', 'vs',
       'am', 'gear', 'carb'],
      dtype='object')
Out[28]:
pandas.indexes.base.Index

#4. getting to see some rows of the data set
data.head()
data.tail(6)
# 5. get to know information on column types, non-NULL records can be sone using info() function
# It give you information on dimensions of dataset, class of dataset object, columnames, each column's data type. where
# float,integer are evident, column with string values is called object
# info() is similar to str() in R
data.info()
<class 'pandas.core.frame.DataFrame'>
RangeIndex: 32 entries, 0 to 31
Data columns (total 12 columns):
Unnamed: 0    32 non-null object
mpg           32 non-null float64
cyl           32 non-null int64
disp          32 non-null float64
hp            32 non-null int64
drat          32 non-null float64
wt            32 non-null float64
qsec          32 non-null float64
vs            32 non-null int64
am            32 non-null int64
gear          32 non-null int64
carb          32 non-null int64
dtypes: float64(5), int64(6), object(1)
memory usage: 3.1+ KB

# 6. Similar but not same to summary() in R, you can get summary statistics of integer/float columns in pythong using describe()
data.describe()
type(data.describe())
pandas.core.frame.DataFrame

So, you can do a transpose
data.describe().transpose()

# Changing column names of a data frame required accessing colnames and passing a list of names
# By the method below, you cannot change one of the column names
data.columns[[0,2,3]]
Index(['Unnamed: 0', 'cyl', 'disp'], dtype='object')

data.columns=['SN', 'mpg', 'cyl', 'disp', 'hp', 'drat', 'wt', 'qsec', 'vs',
       'am', 'gear', 'carb']
data.columns[0]='sn'  --------------- throws an error

# Accessing rows and columns of a data frame
#1. Accessing rows
#Rows of a dat frame can be accessed by using the splicing rules discussed in lists using [from:to:increment]
# NOTE: single brace with colon for columns as [,:] which used to
# work for a matrix does not work for data frames
data[0:5]
# selecting rows from start till end by skipping one row
data[0::2]
# negative indexing will work as well
data[-1:-33:-1]
#the class that is returned is a data frame
type(data[-1:-33:-1])
pandas.core.frame.DataFrame

#2. Accessing columns
# COlumns can be accessed by passing column names as a list of character or by passing list of indices as column names
# Order of columns will be in the order the columns are rferenced, in R it is partially similar as in you can pass a vector of names or indices
# like data[,c(1,2,3)] or data[,c('disp,'mpg)]
data[[1,3]]
data[['disp','mpg']].head()
# This accessing of columns also returns a pandas data frame object
type(data[[1]])
#Quick access method using $ like access method as in R,eg: data $mpg
data.mpg
# This required name to be one work i.e no spaces in between
# The other part is the data type returned by this method is pandas series
type(data.mpg)
pandas.core.series.Series

## 3. Doing both, subsetting a data frame. These are two operations in sequence and hence the order does not matter, both yield same result
data[0:10][['mpg','cyl','disp']]
data[['mpg','cyl','disp']][0:10]

# Creating a new columns by just referencing it as if it exists, works like in R. Here quick access method won/r work though
data['disp.per.cyl']=data['disp']/data['cyl']
# Dropping columns. Use built in method drop, and specify that a columns has to be dropped. The method returns a new object
data.drop('disp.per.cyl',axis=1)
# Dropping more than one column required passing list of column names to be dropped, axis argument conveys that columns need to be dropped
data.drop(['disp.per.cyl','carb'],axis=1)
Use shift + tab to see the method arguments in Jupyter notebooks

Filtering a data frame
# Filtering data frames
# Python lets you work like R in comparing a list with a number, with every number compared against the number and a logical value is returned
Eg: data.gear<2
# You can put logical conditions inside [], which return a boolean series. Joining of conditions can be done using  bitwise operators that operate on element by element basis
type(data.gear>3)
	boolean
Eg: data[(data.gear>3) & (data.carb==4)]

# The conditions need to be computed first and then a bitwise operation needs to be performed, we need to specify that by
# folding conditons in () and then apply a bit wise operation
data[(data.gear>3) | (data.carb==4)]
** and , or are not bitwise operators in python

Getting Unique values
# To get unique values of a column a function unique() can be used with an object of type series , but not with data frames
data.carb.unique()
type(data.carb)
pandas.core.series.Series

# Will not work
data[['carb','gear']].unique()
# This will work, filtering and column selection
data[data.gear>2][['cyl','disp']]

#Accessing specific element of a data frame
#1. using indexing methods we have discussed, remember row indexing will need two inputs - from,to- to carve out a single ow
data[2:3]['cyl']

#2. The second approach is using pandas function .iat which lets you specify row and columns index or .at which lets you specify , but use [] braces
# row and column label
data.iat[4,5]
data.at[3,'disp']

Functions in Python
•	Define using def keyword
•	Must have a return statement to return a value
Example:
def cube (x):
    y=x*x*x
    return y

Passing arbitrary arguments to functions
Arbirary arguments can be passes into a function by defining a tuple and dictionary in the arguments. Tuple name should have a * and dictionary name should have a **. Tuple and dictionary declarations must follow the formal arguments, and tuple should preceed dictionary.
An example of defining function and passing arguments
def arb (x,y,*tup,**dic):
    print (x)
    print (y)
    for i in tup:
        print (i)
    keys=dic.keys()
    for j in sorted(keys):
        print (j,":",dic[j])
arb (23,"Bhanu", "How are you there", "I am fine",
Name="Sumad",Age = 32)


Argument Unpacking/ Calling functions using tuples and dictionaries
Some times arguments are available in a sequence, they can be passed using * and ** meaning using a tuple unpacking or a dictionary unpacking.
def mtp (x,y):
    return (x+y)
# calling function with * in front of sequence
x= [2,5]
mtp (*x)

This is similar to the concept of sequence unpacking in Python or multiple assignments	
Eg: x=[2,4,5,7,10,"Bhanu"]
a,b,c,d,e,f=x
print (a)
print (b)
print (c)
print (d)
print (e)
print (f)
2
4
5
7
10
Bhanu

Example of unpacking argument with a dictionary
>>> def parrot(voltage, state='a stiff', action='voom'):
...     print "-- This parrot wouldn't", action,
...     print "if you put", voltage, "volts through it.",
...     print "E's", state, "!"
...
>>> d = {"voltage": "four million", "state": "bleedin' demised", "action": "VOOM"}
>>> parrot(**d)
-- This parrot wouldn't VOOM if you put four million volts through it. E's bleedin' demised !


Functional programming tools
There are three functions filter(), map() and reduce() in python that are useful when used with lists.
Recall, that performing operations on lists like squaring each element or dividing each element of a list with that of another is not possible
The above functions, give ability like apply family of functions in R, as these require defining a function as first argument and a list or a sequence as the second argument.
Filter() – filter applies the function, which should be a logical operation on the sequence and returns sequence elements that meet the logical operation
def fun(x):
    y=(x>2) and (x**2>9)
    return y
filter(fun,[1,3,5])


Map() – applies function to each element of sequence and returns a sequence
def fun2(x):
    y=[(x/2),(x**2)]
    return y
map(fun2,[1,3,5])
Reduce () - applies the function to two elements at a time, starting from first element of the sequence, replacing operated elements with their result, and continuing till the end of sequence. It then returns a single data point
def fun3(x,y):
    return(x+y)
reduce(fun3,[1,5,2,5])

Lambda Expressions
Lambda expressions are used to create arbitrary functions, without having to name the functions. Use keyword lambda
They do not need a return statement, they involve evaluating an expressions and returning it
G=lambda x: x**3
G(4)

Lambda functions are useful when used with these functional programming tools
Example of filter():
def f(x): return x % 3 == 0 or x % 5 == 0
list(filter(f, range(2, 25)))  ---- list is needed in version 3 of python
using a lambda function
x= ['Sumad','Sudarshan','Manju','Bhanu','Rock','Rochana','ab','abc']
x=filter(lambda x:len(x)>=3,x)
list(x)
Example of map():
z=[12, 15, 18, 20, 21, 24]
list(map(lambda x:x**3, z))
Example of reduce():
ip=[12, 15, 18, 20, 21, 24]
reduce(lambda x, y: x+y, ip)    ---- giving error on python 3.4

Classes and Modules
# Class is a collection of variables (attributes)  and methods (functions) that performs different but related operations
# One can create objects of a defined class, whereby the object inherits the methods of the class, which can then be used

# class is defined like a function but with the keyword class
# Each method in the class has first argument as self, for self reference
# methods starting with __init__ are initiated when an object of the class is first created
#  methods starting with __str__ are used when string representation of the class is needed
Example: class for addition of two vars.
class newadd:
    '''The class is contains methods for addition’’’
    x=0
    y=0
    
    def __init__(self,x,y):
        self.x=x
        self.y=y
        
    def nadd(self,x,y):
        self.x+=x
        self.y+=y
        return (self.x+self.y)
    
    def __str__(self):
        return("The add of %f and %f is %f" %(self.x,self.y,self.x+self.y))
        
Modules
# Modules: A module is a file consisting of variables, methods/functions and classes in python
# It provides provision of importing variables and methods or full module to be imported into a session using import commnad
# Module is a higher construct than class to kee related functionality together, which includes keeping classes, variables, methods
# that are related together
%%file mymodule.py
"""
Example of a python module. Contains a variable called my_variable,
a function called my_function, and a class called MyClass.
"""

my_variable = 0

def my_function():
    """
    Example function
    """
    return my_variable
    
class MyClass:
    """
    Example class.
    """

    def __init__(self):
        self.variable = my_variable
        
    def set_variable(self, new_value):
        """
        Set self.variable to a new value
        """
        self.variable = new_value
        
    def get_variable(self):
        return self.variable

Subclasses, Inheritance of a class from another class, Overriding initializaton
http://www.jesshamrick.com/2011/05/18/an-introduction-to-classes-and-inheritance-in-python/
Handling Exceptions
Exceptions can be handled using try and except statements
Try:
 {normal code}
Except:
{what to print/do if above part is not executed}
Use of raise statmenet, which takes an argument as object of class BaseException
raise Exception (“print exception”)
Example:
try:
    print(test)
    print("test")
except Exception as e:
    print (e)



Visualization
# The library for visualization is matplotlib, it comes pre installed with Anaconda distribution
import matplotlib.pyplot as plt
# To plot the plots cleanly within a cell in the jupyter notebook we need to put a one time line as follows
%matplotlib inline
# To set parameters for the size of plot, need a one time setting of params
plt.rcParams["figure.figsize"]=10,6
PPG=np.matrix.round(Points/MinutesPlayed,2)
# Use plot function, the arguments are data to be plotted, color of line, line style, marker, marker size
plt.plot(PPG[Pdict["KobeBryant"]],c="red",ls="--",marker="s",ms=9)
# To change the x axis to have seasons information, use xticks function , provide what you are replacing and with what
plt.xticks(list(range(0,10)),Seasons,rotation="vertical")
plt.show()


## Adding a label lets you prepare a legend later
plt.plot(PPG[Pdict["KobeBryant"]],c="red",ls="--",marker="s",ms=9,label="KobeBryant")
plt.plot(PPG[Pdict["DwightHoward"]],c="blue",ls="--",marker="d",ms=9,label="DwightHoward")
plt.plot(PPG[Pdict["DerrickRose"]],c="yellow",ls="--",marker="o",ms=9,label="DerrickRose")
# Adding a legend can be done by using plt.legend function and argument bbbox_to_anchor, passsing it a tuple which can take a max
#value of (1,1) which is distance from 0,0 coordinates,loc tells where to fix the anchor but bbox_to_anchor overrides it
plt.legend(loc="upper left",bbox_to_anchor=(1,1))
plt.show()

## We can extend this as a function which takes names of the player, and a matrix and then does dotted line plots with markers for each player 
We’ll have to define a dictionary of line colors and markers for each player
# Plotting can be define by using functions
# The syntax for defining functions in python used def, colon and indentaton
# The idea here would be to pass the names of players for which we need to plot let us say salaries
%matplotlib inline
# To set parameters for the size of plot
plt.rcParams["figure.figsize"]=10,6
def plotfun (data,nameslist):
        cdict = {"KobeBryant":"red","JoeJohnson":"yellow","LeBronJames":"green","CarmeloAnthony":"black","DwightHoward":"blue","ChrisBosh":"pink","ChrisPaul":"grey","KevinDurant":"magenta","DerrickRose":"brown","DwayneWade":"purple"}
        mdict = {"KobeBryant":0,"JoeJohnson":"D","LeBronJames":"s","CarmeloAnthony":"x","DwightHoward":"^","ChrisBosh":"o","ChrisPaul":"s","KevinDurant":"^","DerrickRose":"D","DwayneWade":"o"}
        import matplotlib.pyplot as plt
        for i in nameslist:
            plt.plot(data[Pdict[i]],c=cdict[i],ls="--",marker=mdict[i],ms=9,label=i)
        plt.xticks(list(range(0,10)),Seasons,rotation="vertical")
        plt.legend(loc="upper left",bbox_to_anchor=(1,1))
        plt.show()    

** Interesting Analysis of Baskeball data **
-	Top  10 paid basket players, their salaries, and in field stats over seaons
Some questions you think would have been asked:
1.	Are salaries increasing to reflect on field performance
-	Points scored per game played
-	Minutes played per game

2.	How is shooting accuracy improving
3.	Points score/minute spent on court
4.	Style – average points per game 
