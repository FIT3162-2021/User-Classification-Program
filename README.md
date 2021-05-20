# User-Classification-Program
Program for calculating user's ARI. 


- The Linear Regression Classifier has the best performance given our limited training data, with an accuracy of 0.8444
- **Note** that it produces decimals, to get exact user ARI classifaction, round it to the nearest integer.





<br /><br /><br /><br /><br />
### About the classifications:
- Classification of ARI scores:
                -- ARI score of <4:beginner is,       stored as integer #  If we use every 3 lv is a new lv,:
                -- ARI score of <4:beginner ->stored as integer 1
                # ARI score of 4~6.9999:intermediate->stored as integer 2
                # ARI score of 7~9.9999: competent>stored as integer 3
                # ARI score of 10~12.9999:advanced>stored as integer 4
                # ARI score of 13+:expert  ->stored as integer 5

### About the files:

- **[linear regression classifier.R]** contains the codes for creating the linear regression classifier.
- **[classifier testings.R]** contains the codes for creating and testing the classifiers.
- **[(prepared data)csv_output classified prepared.csv]** contains the data used for training and testing our classifier in all our programs.






### About the tested classifiers:

- decision tree classifier accuracy: 0.5333
- Naive Bayes classifier accuracy: 0.4889
- bagging classifier accuracy: 0.6
- boosting classifier accuracy: 0.5778
- random forest classifier accuracy: 0.6889
- random forest classifier made-with-only-the-more-important-variables classifier accuracy: 0.6222
- **linear regression made using using only the 7 most important variables classifier accuracy: 0.8444**
