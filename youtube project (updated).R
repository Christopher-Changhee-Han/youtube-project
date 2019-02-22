library(dplyr)
library(car)
library(caret)
youtube <- read.csv("youtube_response.csv", stringsAsFactors = FALSE)

youtube <- youtube %>%
    slice(-5) %>% # remove bad response
    transmute(id = 1:42,
        age = Age.,
        gender = as.factor(Gender),
        credit.hr = Number.of.credit.hours.you.re.taking.in.college.this.semester.,
               
        # Preprocess the variable college
        college = What.college.is.your.major.under.,
        college = sub("^Natural.*|CNS|^Computer.*|^Maritime.*", 
                      "Natural Science", college), # remove variation in Natural Science
        college = sub("Engineering ", "Engineering", college), # fix spacing error
        college = sub("^[Bb]usiness.*|McCombs", "Business", college), # remove variation in Business
        college = sub("COLA", "Liberal Arts", college), # remove variation in Liberal Arts
        college = sub("^Arts.*|Communication|Education|Undecided|Fine Arts", "Other", college), # Combine other majors into a single category
        college = as.factor(college),  
        netflix = grepl("Netflix", Are.you.subscribed.to.any.of.these.services.),
        hulu = grepl("Hulu", Are.you.subscribed.to.any.of.these.services.),
        amazonprime = grepl("Amazon", Are.you.subscribed.to.any.of.these.services.),
        
        # Preprocess the variable timespent
        timespent = How.much.time.do.you.spend.on.Youtube.per.day.,
        timespent = sub(" ?(hr|hrs|hour|hours) ?", "hr", timespent), # remove variation in hours
        timespent = sub(" ?(min|mins|minute|minutes) ?", "min", timespent), # remove variation in minutes
        timespent = sub(".*?([0-9]hr([0-9]+min)?).*", "\\1", timespent), # remove unnecessary text
        timespent = sub("([0-9])$", "\\1hr", timespent), # fix id = 17 which had no hr/min specification
        timespent = sub("^([0-9]+min)", "0hr\\1", timespent), # for those without an hr specification, add 0hr
        timespent = sub("([0-9]hr)$", "\\10", timespent), # for those without a min specification, add 0 min
        timespent = sub("min", "", timespent), # remove the word 'min' to make converting to time easier
        # Convert time characters into numeric minute values
        timespent = sapply(strsplit(timespent, "hr"), function(x){
                        x <- as.numeric(x)
                        x[1] * 60 + x[2]
                    })
    )


lm.youtube <- lm(timespent ~ ., data = youtube)
summary(lm.youtube)
anova(lm.youtube)

par(mfrow= c(2,2))
plot(lm.youtube) # there seems t


# check conditions on the linear model, fix as needed
hist(youtube$timespent, breaks = 10) # hmm right skewed, try log and sqrt
plot(x = youtube$timespent)
hist(log(youtube$timespent), breaks = 10)
hist(sqrt(youtube$timespent), breaks = 10)
#try log 
loglm.youtube <- lm(log(timespent + 1) ~ ., data = youtube)
summary(loglm.youtube)
par(mfrow= c(2,2))
plot(loglm.youtube)

#try sqrt

sqrtlm.youtube <- lm(sqrt(timespent) ~., data = youtube)
summary(sqrtlm.youtube)
plot(sqrtlm.youtube)

# answer the main question, whether addition of netflix/hulu/amazonprime affects time spent on youtube

anova(sqrtlm.youtube)

# seems like not, but credit.hr may be a significant predictor

fit2 <- lm(sqrt(timespent) ~ credit.hr, data = youtube)
summary(fit2) #not significant by itself, try adding age

fit3 <- lm(sqrt(timespent) ~ credit.hr + age, data = youtube)
summary(fit3) # both significant now, maybe an interaction?

fit4 <- lm(sqrt(timespent) ~ credit.hr + age + credit.hr * age, data = youtube)
summary(fit4) #nope

#fit3 seems to be the best, and we doubt adding other predictors will improve the fit

plot(fit3) # diagnostics look fine

# divide into train and testing set, try other prediction models

library(caret)
set.seed(401)
inTrain <- createDataPartition(y = youtube$timespent, p = 0.75, list = FALSE)
training <- youtube[inTrain,]
testing <- youtube[-inTrain,]

lmFit <- train(sqrt(timespent) ~ credit.hr + age, data = training, method = "lm")
summary(lmFit$finalModel)
print(lmFit)

lmpred <- predict(lmFit, testing)
plot(lmpred)
RMSE(lmpred, sqrt(testing$timespent))


