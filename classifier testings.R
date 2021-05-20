
rm(list = ls())


#setwd('C:\Users\User\Desktop\Study\FIT3162\Files\User classification program\classifier')

library(tree)
library(e1071)
library(adabag)
library(randomForest)

options(digits = 4)
DS <- read.csv("(prepared data)csv_output classified prepared.csv")






################       Data exploration      ######################



#show summary of dataset
summary(DS)

#use unique to see what value classification column may take
unique(DS$Classification)


#use unique to see all unique data for each columns, to check for insights
apply(DS,2,unique)


head(DS)




################       Dataset Pre-processing      ######################


# convert columns [Response 1b,2b,3b,4b,5b,6b,7b,Score and Classification] into factors
DS[,c(3, 6, 9, 12, 15, 18, 21, 23,24)] <- lapply( DS[,c(3, 6, 9, 12, 15, 18, 21, 23,24)], factor) 

# we dont use ID for classification so exclude it
# we exclude Response 1c,2c,3c,4c,5c,6c,7c as well, because participants need context to actually understand the text, in a sentence, they arent useful for our classification.
preProcessedDS <- DS[,c(2,3, 5,6, 8,9, 11,12, 14,15, 17,18, 20,21, 24)]




################       Dataset Separation      ######################
#separate into training and test dataset
set.seed(613343293) #random seed
train.row = sample(1:nrow(DS), 0.7*nrow(preProcessedDS))
data.train = preProcessedDS[train.row,]
data.test = preProcessedDS[-train.row,]





################       building classifiers    ######################




#build tree with training data, with classification as target, and others as predictors
#and calculate its accuracy
dtreefit <- tree(Classification ~. ,data = data.train)
treepredict <- predict(dtreefit, data.test, type = "class")

v <- table(observed = data.test$Classification , predicted = treepredict)
v
accuracy <- (v[1,1] + v[2,2] + v[3,3] + v[4,4] + v[5,5])/(sum(v))
accuracy










#build Naive Bayes classifier, and calculate accuracy
dbayesfit <- naiveBayes(Classification ~. ,data = data.train)
bayespredict <- predict(dbayesfit, data.test)

v <- table(observed = data.test$Classification , predicted = bayespredict)
v
accuracy <- (v[1,1] + v[2,2] + v[3,3] + v[4,4] + v[5,5])/(sum(v))
accuracy







#build classifier via bagging, and calculate accuracy
dbagfit <- bagging(Classification ~. ,data = data.train, mfinal = 10)
bagpredict <- predict.bagging(dbagfit, newdata = data.test)

v <- table(observed = data.test$Classification , predicted = bagpredict$class)
v
accuracy <- (v[1,1] + v[2,2] + v[3,3] + v[4,4] + v[5,5])/(sum(v))
accuracy






#build classifier via boosting, and calculate accuracy
dboostfit <- boosting(Classification ~. ,data = data.train, mfinal = 100)
boostpredict <- predict.boosting(dboostfit, newdata = data.test)

v <- table(observed = data.test$Classification , predicted = boostpredict$class)
v
accuracy <- (v[1,1] + v[2,2] + v[3,3] + v[4,4] + v[5,5])/(sum(v))
accuracy






#build random forest classifier, and calculate accuracy
drandomforestfit <- randomForest(Classification ~. ,data = data.train)
randomforestpredict <- predict(drandomforestfit, newdata = data.test)

v <- table(observed = data.test$Classification , predicted = randomforestpredict)
v
accuracy <- (v[1,1] + v[2,2] + v[3,3] + v[4,4] + v[5,5])/(sum(v))
accuracy





















################       checking what are the most important variables      ######################

#get root node, which gives the most imformation gain, which is the most important for a tree classifier
dtreefit


#print summary and importance data, to determine most important variables for each classifier
summary(dtreefit)
dbagfit$importance
dboostfit$importance
drandomforestfit$importance











#save random seed
x<- .Random.seed




################       testing random forest classifier with only the more important variables      ######################
# to see if we it is overfitting



set.seed(x)



#make a random forest classifier, with omitted variables
# it should include only the more important variables, with importance of more than 3, in the random forest classifier
new.treefit <- randomForest(Classification ~ Response1a + Response1b + Response2a + Response2b + Response3a + Response4a + Response4b + Response5a + Response6a + Response6b + Response7a, data = data.train)
new.treepredict <- predict(new.treefit, data.test,type = "class")


#calculate accuracy and print

v <- table(observed = data.test$Classification , predicted = new.treepredict)
v
accuracy <- (v[1,1] + v[2,2] + v[3,3] + v[4,4] + v[5,5])/(sum(v))
accuracy





#save random seed
y<- .Random.seed


































################       building linear regression classifier and testing it      ######################

set.seed(y)


# convert relevant columns into numeric for use in training linear regression classifier
data.train[,c(1,3,5,7,9,11,13, 15)] = lapply(data.train[,c(1,3,5,7,9,11,13, 15)], as.numeric)
data.test[,c(1,3,5,7,9,11,13)] = lapply(data.test[,c(1,3,5,7,9,11,13)], as.numeric)

# fit linear regression
fit = lm(Classification ~ Response1a + Response2a + Response3a + Response4a + Response5a + Response6a + Response7a, data = data.train)


#predict using the learned linear regression model model
linearregressgion.predict = predict(fit, data.test)

#pre=process data for calculating accuracy
linearregressgion.predict = round(linearregressgion.predict)
linearregressgion.predict = as.factor(linearregressgion.predict)
linearregressgion.predict = as.data.frame(linearregressgion.predict)

#set and initialise data for calculating accuracy
linear.val <- data.frame(table(linearregressgion.predict))
test.val <- data.frame(table(data.test$Classification ))
correctpredictions <- 0
totalnumberoftest_cases <- length(data.test$Classification)

#count number of correct predictions
for (value in seq(nrow(linear.val))){
  if (linear.val[value,1] == test.val[value,1]){
    adding <- min(linear.val[value,2], test.val[value,2])
    correctpredictions <- correctpredictions + adding
    
  }
}

# calculate accuracy, and print the number of correct predictions and the model's accuracy
correctpredictions
accuracy <- correctpredictions/totalnumberoftest_cases
accuracy



