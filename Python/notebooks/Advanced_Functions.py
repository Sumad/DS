import numpy as np
#Seasons
Seasons = ["2005","2006","2007","2008","2009","2010","2011","2012","2013","2014"]
Sdict = {"2005":0,"2006":1,"2007":2,"2008":3,"2009":4,"2010":5,"2011":6,"2012":7,"2013":8,"2014":9}

#Players
Players = ["KobeBryant","JoeJohnson","LeBronJames","CarmeloAnthony","DwightHoward","ChrisBosh","ChrisPaul","KevinDurant","DerrickRose","DwayneWade"]
Pdict = {"KobeBryant":0,"JoeJohnson":1,"LeBronJames":2,"CarmeloAnthony":3,"DwightHoward":4,"ChrisBosh":5,"ChrisPaul":6,"KevinDurant":7,"DerrickRose":8,"DwayneWade":9}

#Salaries
KobeBryant_Salary = [15946875,17718750,19490625,21262500,23034375,24806250,25244493,27849149,30453805,23500000]
JoeJohnson_Salary = [12000000,12744189,13488377,14232567,14976754,16324500,18038573,19752645,21466718,23180790]
LeBronJames_Salary = [4621800,5828090,13041250,14410581,15779912,14500000,16022500,17545000,19067500,20644400]
CarmeloAnthony_Salary = [3713640,4694041,13041250,14410581,15779912,17149243,18518574,19450000,22407474,22458000]
DwightHoward_Salary = [4493160,4806720,6061274,13758000,15202590,16647180,18091770,19536360,20513178,21436271]
ChrisBosh_Salary = [3348000,4235220,12455000,14410581,15779912,14500000,16022500,17545000,19067500,20644400]
ChrisPaul_Salary = [3144240,3380160,3615960,4574189,13520500,14940153,16359805,17779458,18668431,20068563]
KevinDurant_Salary = [0,0,4171200,4484040,4796880,6053663,15506632,16669630,17832627,18995624]
DerrickRose_Salary = [0,0,0,4822800,5184480,5546160,6993708,16402500,17632688,18862875]
DwayneWade_Salary = [3031920,3841443,13041250,14410581,15779912,14200000,15691000,17182000,18673000,15000000]
#Matrix
Salary = np.array([KobeBryant_Salary, JoeJohnson_Salary, LeBronJames_Salary, CarmeloAnthony_Salary, DwightHoward_Salary, ChrisBosh_Salary, ChrisPaul_Salary, KevinDurant_Salary, DerrickRose_Salary, DwayneWade_Salary])


import numpy as np
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
        
        plotfun(Salary,["JoeJohnson","ChrisBosh","KevinDurant"])
        
import matplotlib.pyplot as plt
#Functional Programming aspects
# Vectorizing function by making use of filter, map, recuce functions
def fun(x):
    y=(x>2) and (x**2>9)
    return y
filter(fun,[1,3,5])

def fun2(x):
    y=[(x/2),(x**2)]
    return y
    map(fun2,[1,3,5])
    
def fun3(x,y):
  return(x+y)
    
reduce(fun3,[1,5,2,5])
    
x = ['Sumad','Sudarshan','Manju','Bhanu','Rock','Rochana','ab','abc']
    
filter(lambda x:len(x)>4,x)
     
z=[12, 15, 18, 20, 21, 24]
     
t=map(lambda x:x**3, z)
print t
print (type(t))

ip=[12, 15, 18, 20, 21, 24]

reduce(lambda x, y: x+y, ip)    
