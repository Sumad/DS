Evaluation\_Metrics
================
Sumad Singh
November 12, 2017

Evaluation Metrics for logistic regression
------------------------------------------

### Probability as Outcome

1.  AUC
2.  Conconrdance
3.  KS statistic
4.  Gains Curve, Cumulative Gains Curve
5.  Lift
6.  logloss

### Classification as Outcome

1.  Kappa
    When classification involves samples, where classes are imbalanced, Kappa is a better characteristic
    to look at than misclassification rate.
    Kappa accounts for the response rate, and evaluates how better the overall classification from a model
    is above the expected accuracy, which is the expected value bases on response rate.

**Kappa = (Observed Accuracy - Expected Accurancy) / (1- Expected Accuracy)**

Example:

Two models yeild the following confusion matrices -

| model 1 |     | 0    | 1   | total |
|---------|-----|------|-----|-------|
| Actual  | 0   | 2825 | 58  | 2883  |
|         | 1   | 349  | 152 | 501   |
| Total   |     | 3174 | 210 | 3384  |

| model 2 |     | 0    | 1   | total |
|---------|-----|------|-----|-------|
| Actual  | 0   | 2600 | 283 | 2883  |
|         | 1   | 200  | 301 | 501   |
| Total   |     | 2800 | 584 | 3384  |

**Note that the response rate is 15%**

Let us look at the below metrics :

|        | Misclass. | TPR  | TNR  | Accuracy | Exp. Accuracy | Kappa |
|--------|-----------|------|------|----------|---------------|-------|
| model1 | 0.12      | 0.30 | 0.98 | 0.88     | ?             | ?     |
| model2 | 0.14      | 0.60 | 0.90 | 0.6      | ?             | ?     |

**Model1 seems to be better based on overall classification, it does comparatively
well on TNR but not as well on TPR, it fares badly in predicting positive class, which has response rate of 15%**

**How to calculate Expected Accuracy**
Expected Accuracy is when the total predictionsfor each of 0 and 1 class were distributed in
the confusion matrix as per their actual proportions. This is equivalent to filling the
confusion matrices below:

| model 1 |     | 0    | 1   | total |
|---------|-----|------|-----|-------|
| Actual  | 0   | ?    | ?   | 2883  |
|         | 1   | ?    | ?   | 501   |
| Total   |     | 3174 | 210 | 3384  |

| model 2 |     | 0    | 1   | total |
|---------|-----|------|-----|-------|
| Actual  | 0   | ?    | ?   | 2883  |
|         | 1   | ?    | ?   | 501   |
| Total   |     | 2800 | 584 | 3384  |

| model 1 |     | 0                 | 1                | total |
|---------|-----|-------------------|------------------|-------|
| Actual  | 0   | (2883/3384)X 3174 | (2883/3384)\*210 | 2883  |
|         | 1   | (501/3384) X 3174 | (501/3384)\*210  | 501   |
| Total   |     | 3174              | 210              | 3384  |

So, the expected counts are computed as :

| model 1 |     | 0       | 1     | total |
|---------|-----|---------|-------|-------|
| Actual  | 0   | 2704.09 | 178.9 | 2883  |
|         | 1   | 467     | 31.1  | 501   |
| Total   |     | 3174    | 210   | 3384  |

| model 2 |     | 0      | 1     | total |
|---------|-----|--------|-------|-------|
| Actual  | 0   | 2385.5 | 497.5 | 2883  |
|         | 1   | 414.5  | 86.5  | 501   |
| Total   |     | 2800   | 584   | 3384  |

And the metrics can be computed as:

|        | Misclass. | TPR  | TNR  | Accuracy | Exp. Accuracy | Kappa |
|--------|-----------|------|------|----------|---------------|-------|
| model1 | 0.12      | 0.30 | 0.98 | 0.88     | 0.81          | 0.37  |
| model2 | 0.14      | 0.60 | 0.90 | 0.85     | 0.73          | 0.47  |

**Model2's difference b/w observed accuracy & expected accuracy compared to the difference of
expected accuracy from max. value (1) is better. We can say, that accounting for the
imbalance in classes, model 2 does a better job in overall classification**

1.  Confusion Matrix, Sensitivity, Specificity
2.  Precision, Recall
3.  Misclassification Rate
4.  Profit
