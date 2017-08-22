
### Random Experiment 
* An activity that has an element of chance  with more than one outcome possible
### Sample Space 
* Set of elementary outcomes of the random experiment
### Event 
* A set defined from the elementary outcomes
* Probability of an event is then defined. Probability of an elementary outcome is simply 
 > the no. of favorable outcomes/total possible outcomes
### Mutually Exclusive events 
* Occurence of one rules out the occurence of another in a single trial of an experiment.
### Independent Events 
* If the outcome of one event does not affect the outcome of the other than the events are independent.
* P(A ∩ B) = P(A) x P(B) for independent events
> Example : Event A, roll of dice yields an odd number i.e A = {1,3,5}. Event B is the roll of a dice yields 1 i.e B= {1}. A and B are not
independent , as they do not satisy the condition.
### Logical Operations to compute probability of a complex event
  * ##### Break the event to elementary events, compute probability and join the probability with logical operations of AND, OR, NOT.
### Conditional Probability 
* In case of dependent events, the conditional probability is defined as P(A|B) i.e probability of event A,
  given that B has occured. Example: Given roll of a dice yielded odd number, what is the probability of getting 1.
> Rule : P(A|B) = P(A ∩ B)/P(B) if P(B) is not 0.
 Example:  coin is tossed four times. Given at least one head appears, what is probability of getting 4 heads.
 B= {  
 httt, thtt, ttht, ttth  
 hhtt, htht, htth, thht,thth, tthh  
 thhh,hthh,hhth, hhhht  
 hhhh  
 }
 SS = B U {tttt} 
 A= {hhhh}  
 P(A ∩ B) = P(hhhh) = 1/16  
 P(B) = 15/16  
 So, Ans = 1/15  
 
 >  Example : A couple has 3 children, given one is a boy, what is the probability, they have two boys  
 *Method 1 - Counting*:  
 SS has eight elements. Given one is a boy, it leaves the outcomes to 7 i.e {bgg, gbg, ggb , bbg, bgb, gbb, bbb}, 
 the favorable outcomes are 3, so Ans = 3/7  
 *Method 2 - Conditonal probability*: 
 Event B = {bgg, gbg, ggb , bbg, bgb, gbb, bbb} ; P(B) = 7/8
 Evebt A = {bbg, bgb, gbb}
 P(A ∩ B) = 3/8  
 P(A|B) = (3/8) / (7/8) = 3/7
 
 > Wrong way to approach: Fixing the given boy with an order i.e  
 B-- , 4 cases, 2 favorable  
 Bbg  
 Bgb  
 OR  
 -B- , 4 cases, 2 favorable  
 gBb  
 bBg  * dup *  
 OR  
--B , 4 cases, 2 favorable  
 bgB  * dup *  
 gbB  *dup*  
Here, we are making an assumption that the given Boy is distinct than the other boy, and in so we should treat  
bBg and Bbg differently. This is wrong assumption.

> Another way: For atleast one boy, we can have  
one boy i.e 1 boy and 2 girls to be arranged, 3! = 3 ways  
OR  
two boys - 3 ways  
OR  
three boys bbb - 1 way  
probability then is 3/7
