### Random Experiment 
* An activity that has an element of chance  with more than one outcome possible
### Sample Space 
* Set of  outcomes of the random experiment
### Event 
* A set defined from the elementary outcomes
* Probability of an event is then defined. Probability of an elementary outcome is simply 
 > the no. of times outcome occured/total possible outcomes
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

### Baye's Theorem  
Baye's theorem extends to the situations of conditional events and thus conditional probabilities.  
It connects the current conditional probabilities (which is usually the question that drives the thought ), to known
prior conditional probabilities.  
![eq1](https://user-images.githubusercontent.com/8353134/29589695-cc61194c-875b-11e7-8b6c-9b94a5ec6845.png)

**Example**:  Email phishing could result from opening an attachment from an unknown email id, or clicking a url in the email.    
A question of interest could be - If a user is a victim of email phishing, what are the chances he/she opened the email with an 
attachement.So, P(Attachment|Phished)?  
Usually, at the outset of phishing incidences, you would expect the metrics to be computed to to support the following -  
* P(Phishing|Attachment) i.e Given an email had an attachment, what is the probability of it being phishing email. This in turn requires-  
a. P(Attachment ∩ Phishing) i.e the probability of intersection of -
     event of an email coming with an attchment, and the event of email phishing.  
b. P(Attachment) i.e Probability of an email with attachment  

**Example**
60% of people in a company do DS training in an year from joining. 10% of those who do the training get promotion in an year of their joining. 1% of those who got promoted in an year had not done the training. What is the probability of getting promoted,
having not done the training.  
**Solution**  
T be event of someone having done the training.  
P is the event of getting promoted.  
P(P|T) is conditional probability of getting promoted, having done the training.
Question is P(T|P) i. e a conditonal probability relating to a know prior.  
P(T)=0.6 , P(P|T) = 0.1 , P(P|Tc) = .01  
P(T|P) = (0.1 * 0.6) / P(P)  
P(P) = 0.6 * 0.1 + .01 * 0.4  
Ans = 93.75%  

---
#### Birthday Paradox  
What is the probability that any two people in a room of 23 share their birth date?  
* First, the probability of two people sharing their birthday.
* Consider non leap year, the random experiment is to chooe two dates out of 365, event is two dates are same,
 so P(E) = 365*1/ 365*365 i.e 1/365  
 * For probability of a group of 2 among 23 people to share b'day, we are looking at 253 groups.
 * We can solve this as -  
 Only one group shares :1st group sharing and 252 not sharing, or 2nd sharing other 252 not and so on so, 253 * ((1/365) * (364/365)^252 )
 Two groups share - and so on, the computation will be complex  
 * A simple way is 1- P(No group shares b'date) = 1 - (364/365)^253 = 0.500477  
 The paradox is that the probability is > 50% , and this is attributed due to repeat multiplication i.e 1- (0.99726)^253.  
 As number of people increases, the probability increases
---
** Example **  
Rare Event are ones having very less incident rate, say 1%. If we design a test to predict the rare event focussing on an 
accuracy of 95%, it may not give us a good precision.Why?  
** Solution **  
Let outcome of rare event - P, N. P(P) =.01 P(N) =0.99.  
Let outcome of the test be Pp,Pn i.e predicted positive and predicted negative.
Accuracy of 95% means,both P(Pp|P) = 0.95, P(Pn|N) = 0.95, P(P) = 0.01 , P(N) = 0.99  

|         | Pp | Pn |**Total**|
|      ---|---|---|---      |  
|P       |  TP|FN  |TP+FN      |
|N       |  FP|TN  |FP+TN      |. 

Question - what is the precision of this test i.e, give the test identifies a positive, what is the probability of being
actually positive?  
P(P|Pp) = TP/ (TP+FP)=?  
> P(P|Pp) = [P(Pp|P). P(P)]/[P(Pp)]  = [P(Pp|P). P(P)]/[P(Pp ∩ P) U P(Pp ∩ N)]. 
= 0.95 * 0.01 / [0.95 * 0.01 + 0.05 * 0.99] = 0.16. 
So, although accuracy is high, the precision is very low.  
If precision is to be increased, accuracy has to go up.  

>Accuracy	Precision. 

>0.95	0.161016949152542    
>0.96	0.195121951219512    
>0.97	0.246192893401015   
>0.98	0.331081081081081   
>0.99	0.5   
>0.995	0.667785234899329.    

** Example ** 
Four football players take shots at goal froma team, chances of their taking shots are. 
P(Sa) = 0.1, P(Sb) = 0.2, P(Sc) = 0.3, P(Sd) = 0.4. 
Chances of them scoring are 1,0.4,0.4, 0.25. Given a goal has been scored, what are the chances D scored it?  
** Solutions **  
An experiment is that shot is taken by one of the four, so S = {Sa, Sb, Sc, Sd} and second event is Result = {G, NG}.
Conditional probabilities are given -  
P(G|Sa) = 1, P(G|Sb)=0.4, P(G|Sc)=0.4, P(G|Sd)= 0.25.  
P(Sd|G) = ?  
= 0.25 * 0.4 / (P(G) ,  
now, P(G) = P(G ∩ Sa) + P(G ∩ Sb) + P(G ∩ Sc) + P(G ∩ Sd) = 1 * 0.1 + 0.4 * 0.2 + 0.4 * 0.3 + 0.25 * 0.4  ,  
Ans = 0.25
