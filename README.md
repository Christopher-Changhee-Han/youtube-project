# Youtube Poster Project
Christopher Han  

## Introduction
The objective of this project is to investigate whether the addition of the variable 'number of subscriptions to a monthly video service' such as Netflix, Amazon prime, or Hulu, account for a significantly greater proportion of the variance in the amount of time spent on YouTube per day. The nuisance variables included are age, gender, number of credit hours currently being taken, and the college classification. This project was a final assignment in the class SDS 358 at UT Austin in Spring 2018.  
  
Hypothesis: The addition of the variable of interest will account for a significantly greater proportion of the variance in the amount of time spent on YouTube per day.

## Methodology

**Sample**  
The sample data was gathered via a Google Form Survey from 43 current college students. The survey collected data about their age (years), gender (male, female), number of credit hours being taken, college classification (Business, Engineering, Liberal Arts, Natural Science, Others), the subscription services they use (Netflix, Amazon Prime, Hulu, none of the above), and time spent on YouTube (minutes). One value was removed due to high Cook’s Distance. 

Analysis Method: Sequential Multiple Regression with both Categorical and Quantitative predictors

**Assumptions**

Homoscedasticity was checked and confirmed by the Residuals vs. Fitted graph. We found one outlier through observing Cook’s Distance. Normality of residuals was also checked through a histogram.

## Results

The overall model was significant and could account for 42.57% of the variance (F(9,32) =2.635, p = 0.021). The initial model without the variable of interest was also significant and could account for 38.77% of the variance in the outcome. This 3.79% change in R2 was tested through ANOVA and was shown to be not significant (F(2,32) = 1.06, p = 0.3594). Moreover, Gender, College Classification, and Number of subscriptions all proved to be not significant. However, age (t(32) = -2.602, p < 0.01) and number of credit hours (t(32) = -3.735, p < 0.001) were significant predictors of time spent on YouTube per day. Based on the small number of N and the insignificance of Gender and College Classification (two categorical variables influencing the df), the model was run again excluding these two control variables. The result was similar with no significant change in R2 in the sequential regression and the number of subscriptions was still not significant. 

**Limitations**  

The sample size was small (N=43) with a possible response bias. The question was not leaded but average person may underestimate/overestimate or skew the time spent on YouTube. Therefore, the data may not be accurate. Moreover, the data had slightly right skewed residuals. A possible confounding variable is subscription to YouTube Red, as that was not considered. 

**Implications**  

One thing I would change is to change the method from a survey in which they reflect and estimate the time spent on YouTube to a more active survey where each participant logs the time spent on YouTube for 3 days to gain more accurate data. Moreover, the data was collected specifically on current college students or recent college graduates from The University of Texas at Austin. Therefore, we cannot extend the conclusion beyond this university.

**References**  
Information about survey bias: http://stattrek.com/survey-research/survey-bias.aspx 
