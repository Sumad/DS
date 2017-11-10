Loops and IF Statements
While Loop:
# A note on difference b/w R and Python
# R is a vectorized language, vs Python which in an OO language, both have their pros and cons
# Vectorization lets R or Matlab handle matrix multiplications easily, we have apply functions that could be used to perform
## loop like tasks. R does have loop function available
# While loop syntax in Python
#While condition:
 #execute code1
 #execute code2
#execute code 3

# Differene from R

#while (condition)
#{execute code1
#execute code2
#}
# execute code 3

#Difference:
#1. Python does not have braces, the condition to be checked first is determined by anything before colon
#2. The executable code is separated from code that follows loop by indentation.
#3. Indentation is part of the syntax structure in Python!
x="I think i am doing well in Python"
i=0
while i!=32:
    print (x[i])
    i=i+1

For Loop:
It has similar structure as of While loop
i=0
for i in range (5):
    print(i)
    i=i+1
use of keyword ‘in’ is similar to that in R

Looping techniques
1.	Use of ‘in’ keywors. In and not in are keywords to check memberships, in loops they help a variable take on values from a sequence (lists, tuples) and dictionaries

2.	When looping over a sequence both index and values can be accessed using enumerate function
ip=[12, 15, 18, 20, 21, 24]
for i,j in enumerate(ip):
    print (i,j)

enumerate() is a pre-defined function in python, which returns an enumerate object. It takes argument of a sequence like lists, tuples etc. 
>>> seasons = ['Spring', 'Summer', 'Fall', 'Winter']
>>> list(enumerate(seasons))
[(0, 'Spring'), (1, 'Summer'), (2, 'Fall'), (3, 'Winter')]


3.	To loop over two sequences at a time, the sequences can be paired using zip() function
a=["a","b","c","d"]
b=[1,2,3,4]
for i,j in zip(a,b):
    print(i,j)
4.	To loop over dictionaries and access key and value values use .iteritems() or  items() method for dictionaries in Python 
for i in dic.items():
    print(i)

Lists: Lists are a data structure in Python, an example of for loop with a list is below. Notice that since list is of integers, we did not have to specify the length of list for iterations in for loop, it goes over the list of elements of the list and executes if element is not zero.
a=[10,20,30]
for j in a:
    print (j)
    
If, if else, nested if else, chained if else statements:
# If, If Else, nested if else, chained if else statment
Syntax:
    if condition:
        execute code
    else:
        execute code
#see the indentation, if and else need to be at same level of indentation
# numpy is a library in python having functions for scientific calculations
# Example of nested if else, 
import numpy as nm
from numpy.random import randn
x=randn()
if x<0:
    print("Negative")
else:
    if x>0:
        print ("Positive")
    else:
        print("zero")

# Example of chained if else 
import numpy
from numpy.random import randn
x=randn()
if x<0:
    print("Negative")
elif x>0:
    print ("Positive")
else:
    print("zero")
