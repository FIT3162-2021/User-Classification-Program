
rm(list = ls())





options(digits = 4)
DS <- read.csv("csv_output classified prepared.csv")


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
