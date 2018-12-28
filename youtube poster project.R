#Christopher Han
#Poster project for SDS358, Applied Regression Analysis
#Professor Michael Mahometa
#April 27, 2018

#read in data
library(SDSRegressionR)
youtube <- read.csv("data/youtube.csv", stringsAsFactors=FALSE)

names(youtube)

#factor categorical variables manually with dummy variables
table(youtube$Gender)
youtube$Gender_f <- factor(youtube$Gender, labels= c("Female", "Male"))

table(youtube$Major2) #combine communication, education, fine arts, maritime, undecided into others)
youtube$Major2_f <- factor(youtube$Major2, levels= c(1,2,3,4,5), labels= c("Business", "Engineering", "Liberal Arts", "Natural Science", "Others"))

table(youtube$SubNum)
youtube$SubNum_f <- factor(youtube$SubNum, levels= c(0,1,2,3), labels= c("None", "One", "Two", "Three"))

#dummy code to combine levels 2 and 3 into two or more for SubNum
youtube$Sub_none <- NA
youtube$Sub_none[!is.na(youtube$SubNum) ] <- 0
youtube$Sub_none[youtube$SubNum == "0"] <- 1

youtube$Sub_one <- NA
youtube$Sub_one[!is.na(youtube$SubNum) ] <- 0
youtube$Sub_one[youtube$SubNum == "1"] <- 1

youtube$Sub_two_or_more <- NA
youtube$Sub_two_or_more[!is.na(youtube$SubNum) ] <- 0
youtube$Sub_two_or_more[youtube$SubNum == "2"] <- 1
youtube$Sub_two_or_more[youtube$SubNum == "3"] <- 1

#check some basic statistics
mean(youtube$YT)
sd(youtube$YT)
mean(youtube$Age)
sd(youtube$Age)
mean(youtube$Hrs)
sd(youtube$Hrs)

#linear model
full <- lm(YT ~ Age + Gender_f + Hrs + Major2_f + Sub_one + Sub_two_or_more, data=youtube)
summary(full)

#Look for any issues:
library(car)
vif(full)
hist(full$residuals)
residFitted(full)
cooksPlot(full, key.variable = "ID", print.obs = TRUE, sort.obs=TRUE, save.cutoff = TRUE)
cooksCutOff * 2
threeOuts(full)

#remove outlier
"%not in%" <- Negate("%in%")
g_youtube <- youtube[youtube$ID %not in% c("7"),]

#Re-run the final model
fullg <- lm(YT ~ Age + Gender_f + Hrs + Major2_f + Sub_one + Sub_two_or_more, data=g_youtube)
summary(fullg)


#Sequential Regression:
#Model 1:
m1_seq <- lm(YT ~ Age + Gender_f + Hrs + Major2_f, data=g_youtube)
summary(m1_seq)
summary(m1_seq)$r.squared
lmBeta(m1_seq)
pCorr(m1_seq)


#Model 2:
m2_seq <- lm(YT ~ Age + Gender_f + Hrs + Major2_f + Sub_one + Sub_two_or_more, data=g_youtube)
summary(m2_seq)
summary(m2_seq)$r.squared
lmBeta(m2_seq)
pCorr(m2_seq)

#Now the Sequential Results
anova(m1_seq, m2_seq)

42.56-38.77

#for further testing on the categorical predictors

Anova(m2_seq, type="III")

library(lsmeans)

m2_seq_f_mn <- lsmeans(m2_seq, "Major2_f")
ref.grid(m2_seq)
m2_seq_f_mn
pairs(m2_seq_f_mn, adjust="none") #Too little
pairs(m2_seq_f_mn, adjust="bonferroni") #Too much
pairs(m2_seq_f_mn, adjust="holm") #Just right

#try removing gender and major since they are not significant

m4_seq <- lm(YT ~ Age + Hrs, data = g_youtube)
summary(m4_seq)
m5_seq <- lm(YT ~ Age + Hrs + Sub_one + Sub_two_or_more, data=g_youtube)
summary(m5_seq)

anova(m4_seq, m5_seq)

#barely any difference

#table summary
library(stargazer) 
library(knitr) 
stargazer(m1_seq, m2_seq, title="Time Spent on YouTube Sequential Regression", 
          column.labels = c("First Model", "Second Model"), model.numbers = FALSE, 
          single.row=TRUE, header=FALSE, omit.stat="ser", out="table.txt") 

kable(anova(m1_seq, m2_seq), caption="YouTube Sequential Regression Results")

