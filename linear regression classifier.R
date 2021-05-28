
rm(list = ls())





options(digits = 4)
DS <- read.csv("(prepared data)csv_output classified prepared.csv")


################       Dataset Pre-processing      ######################

# we dont use ID for classification so exclude it
# we exclude Response 1c,2c,3c,4c,5c,6c,7c as well, because participants need context to actually understand the text, in a sentence, they arent useful for our classification.
preProcessedDS <- DS[,c(2,3, 5,6, 8,9, 11,12, 14,15, 17,18, 20,21, 24)]




################       Dataset Separation      ######################
# NOTE: There is no dataset separation, since in linear regression models, they are just used for testing the classifier's accuracy.
#       In our program, due to low amount of training data(only 150 rows of them), we are using all of them for training purposes.








################       Classifier creation      ######################

# convert relevant columns into numeric for use in training linear regression classifier
preProcessedDS[,c(1,3,5,7,9,11,13, 15)] = lapply(preProcessedDS[,c(1,3,5,7,9,11,13, 15)], as.numeric)

# fit linear regression
fit = lm(Classification ~ Response1a + Response2a + Response3a + Response4a + Response5a + Response6a + Response7a, data = preProcessedDS)




# fit
#         - would be our linear regression classifier
#         - to use it to predict, simply call 
#                                               "predict(fit, input_predictor_variables)"
#                                                 where input_predictor_variables,
#                                                          and it will return the predicted values.  




################       Tests      ######################
# the below are tests for expected output of the classifier purely to see if its working as intended.
# these tests here are not meant for assessing accuracy of the classifier.

test_classifier <- function(a,b,c,d,e,f,g,equivalent){
  input <- data.frame(Response1a  =c(a),
                      Response2a = c(b),
                      Response3a = c(c),
                      Response4a = c(d),
                      Response5a = c(e),
                      Response6a = c(f),
                      Response7a = c(g))
  
  round(predict(fit, input)) == equivalent
}



test_classifier(1,1,1,1,1,1,1,5)
test_classifier(2,2,2,2,2,2,2,4)
test_classifier(3,3,3,3,3,3,3,3)
test_classifier(4,4,4,4,4,4,4,2)
test_classifier(5,5,5,5,5,5,1,1)
test_classifier(5,5,5,5,5,5,5,0)

test_classifier(2,4,3,4,3,2,1,3)
test_classifier(2,4,3,4,5,5,5,1)
test_classifier(1,1,1,1,1,2,2,5)

# all tests gave TRUE, therefore we can conclude the classifier is working as intended.
