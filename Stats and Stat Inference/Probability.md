
### Random Experiment : An activity that has an element of chance  with more than one outcome possible
### Sample Space : Set of elementary outcomes of the random experiment
### Event : A set defined from the elementary outcomes
### Probability of an event is then defined. Probability of an elementary outcome is simply 
 > the no. of favorable outcomes/total possible outcomes

### Mutually Exclusive events : Occurence of one rules out the occurence of another in a single trial of an experiment.
### Independent Events : If the outcome of one event does not affect the outcome of the other than the events are independent.
P(A ∩ B) = P(A) x P(B) for independent events
> Example : Event A, roll of dice yields an odd number i.e A = {1,3,5}. Event B is the roll of a dice yields 1 i.e B= {1}. A and B are not
independent , as they do not satisy the condition.
### Logical Operations to compute probability of a complex event
  ##### Break the event to elementary events, compute probability and join the probability with logical operations of AND, OR, NOT.
  
##### Conditional Probability : In case of dependent events, the conditional probability is defined as P(A|B) i.e probability of event A,
#### given that B has occured. Example: Given roll of a dice yielded odd number, what is the probability of getting 1.
> Rule : P(A|B) = P(A ∩ B)/P(B) if P(B) is not 0.

> Example:  coin is tossed four times. Given at least one head appears, what is probability of getting 4 heads.
B= {
 httt, thtt, ttht, ttth
 hhtt, htht, htth, thht,thth, tthh
 thhh,hthh,hhth, hhhht
 hhhh
}
A= {hhhh}
P(A ∩ B) = P(1) = 1/16
P(B) = 15/16
So, Ans = 1/15
