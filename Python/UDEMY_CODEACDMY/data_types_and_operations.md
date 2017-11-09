# Commenting
Use '#' for a single line of comment, Anything within three quotes is a comment ‘’’ ‘’’

# Libraries
#importing some libraries and using them  
import math  
math.sqrt(F)  

# Types of variables/fundamental data types
Four types considered for being relevant to Data science:  
1.	Integer  
2.	Float/Double, long . Long not discussed here  
3.	String: Single and double quotes can be used interchangably  
4.	Logical/Boolean: True or False are recognized as logical values, values are case sensitive  
• 	Declaration like in C is not required, assigning value to a variable leads to an auto declaration of variable.  
•	 type() can be used to check type of variable, ‘=’ is used for assignment   
•	 function to coerce int(), long(),float(),str()  

# Arithmetic Operations  
A=3  
B=5  
C= A+B  
print (C) # print command is proper way to print  
E= 2.345  
F= 4.69  
G=F/E returns quotient , F//E returns floored value of quotient , F % E returns remainder  
Pow(F,E) or F ** E is F exponential to E.   
print (F)  
print (G) # Using print () function lets you print multiple output together  
Python 2.7 requires print to be used as print G  
Python 2.7 also auto rounds off the result, when a integer is divided by integer  
Logical Operators and Boolean variables  
a=4  
b=5  
c=a>b  
type(c)  
bool  

# Logical operations
'#==,!= or <>'  for comparison  
'#>,< ,<=,>='  
'# and, or, not' are logical operators, unlike &,| in R  

# Operations on strings
i="I"  
l="Love You"  
i+" "+l  

The statements in python need not be separated by , or ;
Indexing Strings to get a character  
x="Monday"  
x[4]  
Converting to string data type, case conversion  
Function str() can be used to convert a data type into string  
An object with string data type, can use methods upper() and lower() for case conversion  

Printing a string with variable names  
Use %s,and then specify variables using %().  
name="sumad"  
print ("My name is %s" %name)  
Escape characters : characters that cannot be printed  
''' Use of escape characters like \n , \t ,\scan work in strings'''   
print ('The newline \n will expand')     
'''Use of an ' needs a \   '''   
print ('i\'ll be back')  
a='Sumad'  
b='Singh'  
print ('My name is \t' + a )  

Strings can be accessed using indexing methods used for lists  
Strings are immutable through  

Strings can be compared with the standard operators listed above: ==, !=, <, >, <=, and >=.  
x='Sumad Singh'  
y='Sumad'  
x!=y  
in and not in can be used to test string membership i.e if a charcter exists in a string  
String Functions/methods  
Join(), lower(), upper(),find(),split(),startWith(),endsWith(),count() can be used  
http://www.tutorialspoint.com/python/python_strings.htm  
String formatting using operator %  
Like %s was used to print variables that were of string data type,  
%c, %i,%d ,%ecan be used to print charcter, interger and decimal data and exponential notation  

Date time class and object  
Use datetime library in python  
from datetime import datetime  
now=datetime.now()  
type(now)  
datetime.datetime  

To get a string output of dates, you can do  
date="%s-%s-%s" %(now.month,now.day,now.year)  
Similarly to get time:  
time= '%s:%s:%s' %(now.hour, now.minute, now.second)  
