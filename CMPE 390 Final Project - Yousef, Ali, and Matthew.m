%% 
% 
% 
% *CMPE 390*
% 
% *Introduction to Machine Learning and Data Analytics*
% 
% *Final Project: Comparing Suitable Machine Learning Algorithms for Predicting 
% Bank Marketing*

% Names and IDs: Yousef Elsonbaty (A00138), Ali Abdulla (A00786), & Matthew
% Fisher (A00166)
%% 
% *Part 01: Data Quality Reports and Issues*
% 
% 1- Balance the data and provide a summary of all features in the dataset.

bnkNo = bnkOriginal(bnkOriginal.y == "no",:)
bnkYes = bnkOriginal(bnkOriginal.y=="yes",:)
part = cvpartition(height(bnkNo),"HoldOut",0.265)
idx2 = test(part)
bnkNo2 = bnkOriginal(idx2,:)
bnk = [bnkYes;bnkNo2]

summary(bnk)
%% 
% 2- Find the number of records in the dataset.

height(bnk)
%% 
% 3- Find the number of features in the dataset.

width(bnk)
%% 
% 4- Split the dataset into the following sub datasets:
% 
% a. Continuous dataset.

n = vartype("numeric")
bnkN = bnk(:,n)
%% 
% b. Categorical dataset.

c = vartype("categorical")
bnkC = bnk(:,c)
%% 
% 4- Generate the data quality report for continous features 'bnkN', and save 
% the information in a separate table named 'QRbnkN'.

columnName = cell(width(bnkN),1)
Count = zeros(width(bnkN),1)
Missing = zeros(width(bnkN),1)
Cardinality = zeros(width(bnkN),1)
Minimum = zeros(width(bnkN),1)
Maximum = zeros(width(bnkN),1)
Mean = zeros(width(bnkN),1)
Median = zeros(width(bnkN),1)
firstQuartile = zeros(width(bnkN),1)
thirdQuartile = zeros(width(bnkN),1)
standardDeviation = zeros(width(bnkN),1)

for col = 1: width (bnkN)
	columnName(col,1) = bnkN.Properties.VariableNames(col)
	Count(col,1) = height(bnkN.(col))
	Missing(col,1) = sum(ismissing(bnkN.(col))) / height(bnkN) * 100
    Cardinality(col,1) = height(groupsummary(bnkN,col))
	Minimum(col,1) = min(bnkN.(col))
    Maximum(col,1) = max(bnkN.(col))
	Mean(col,1) = mean(bnkN.(col))
	Median(col,1) = median(bnkN.(col))
    firstQuartile(col,1) = prctile(bnkN.(col), 25)
	thirdQuartile(col,1) = prctile(bnkN.(col), 75)
	standardDeviation(col,1) = std(bnkN.(col))
	
end

QRbnkN = table(columnName, Count, Missing, Cardinality, Minimum, Maximum, Mean, Median, firstQuartile, thirdQuartile, standardDeviation)
%% 
% 5- Generate the data quality report for categorical features 'bnkC', and save 
% the information in a separate table named 'QRbnkC'.

columnName = cell(width(bnkC),1)
Count = zeros(width(bnkC),1)
Missing = zeros(width(bnkC),1)
Cardinality = zeros(width(bnkC),1)
firstMode = categorical(width(bnkC),1)
firstModeFrequency = zeros(width(bnkC),1)
firstModePercentage = zeros(width(bnkC),1)
secondMode = categorical(width(bnkC),1)
secondModeFrequency = zeros(width(bnkC),1)
secondModePercentage = zeros(width(bnkC),1)

for col = 1 : width(bnkC) 
        columnName(col,1) = bnkC.Properties.VariableNames(col)
        Count(col,1) = height(bnkC.(col))
        Missing(col,1) = sum(ismissing(bnkC.(col))) / height(bnkC) * 100
        Cardinality(col,1) = height(groupsummary(bnkC,col))
        [firstMode(col,1), firstModeFrequency(col,1)] = mode(bnkC.(col))
        firstModePercentage(col,1) = (firstModeFrequency(col,1)) / height(bnkC) * 100
        [secondMode(col,1), secondModeFrequency(col,1)] = mode(bnkC.(col)((bnkC.(col)~= mode(bnkC.(col)))))
        secondModePercentage(col,1) = secondModeFrequency(col,1) / height(bnkC) * 100

end

QRbnkC = table(columnName, Count, Missing, Cardinality, firstMode, firstModeFrequency, firstModePercentage, secondMode, secondModeFrequency, secondModePercentage)
%% 
% 6- Visualize all features in the dataset.

% Feature 01: Age
histogram(bnk.age)
ylabel("Density")
title("Age")

% Feature 02: Occupation
histogram(bnk.job)
ylabel("Density")
title("Occupation")

% Feature 03: Marital Status
histogram(bnk.marital)
ylabel("Density")
title("Marital Status")

% Feature 04: Education Level
histogram(bnk.education)
ylabel("Density")
title("Education Level")

% Feature 05: Default
histogram(bnk.default)
ylabel("Density")
title("Default")

% Feature 06: Balance
histogram(bnk.balance)
ylabel("Density")
title("Balance")

% Feature 07: Housing
histogram(bnk.housing)
ylabel("Density")
title("Housing")

% Feature 08: Loan
histogram(bnk.loan)
ylabel("Density")
title("Loan")

% Feature 09: Contact
histogram(bnk.contact)
ylabel("Density")
title("Contact")

% Feature 10: Month
histogram(bnk.month)
ylabel("Density")
title("Month")

% Feature 11: Number of Days
histogram(bnk.day)
ylabel("Density")
title("Number of Days")

% Feature 12: Duration
histogram(bnk.duration)
ylabel("Density")
title("Duration")

% Feature 13: Campaign
histogram(bnk.campaign)
ylabel("Density")
title("Campaign")

% Feature 14: Days Passed
histogram(bnk.pdays)
ylabel("Density")
title("Days Passed")

% Feature 15: Before the Campaign
histogram(bnk.previous)
ylabel("Density")
title("Before the Campaign")

% Feature 16: Outcome of the Previous Campaign
histogram(bnk.poutcome)
ylabel("Density")
title("Outcome of the Previous Campaign")

% Feature 17: Subscribed (Yes/No)
histogram(bnk.y)
ylabel("Density")
title("Subscribed (Yes/No)")
%% 
% 7- Explain the main data quality issues in the dataset.

% Issue 01: There is a category in several features that is called
% 'unknown'. The features that have the 'unknown' category are:
% 'Occupation', 'Education Level', 'Contact'.
% Issue 02: The 'Outcome of the Previous Campaign' feature also has the 'unknown'
% category. However, most of the data lies under the category.
%% 
% 8- Explain the strategies you used to handle the above data quality issue.

% Issue 01: Remove the 'unknown' category in the following features:
% 1- 'Occupation'
% 2- 'Education Level'
% 3- 'Contact'
% Issue 02: Remove the 'Outcome of the Previous Campaign' feature since
% most of the data lies in the 'unknown' category.
%% 
% 9- Write appropriate scripts to handle the above issues.

% Feature 01: Age
histogram(bnk.age)
ylabel("Density")
title("Age")

% Feature 02: Occupation
table(bnk.job)
bnk.job = removecats(bnk.job,"unknown")
histogram(bnk.job)
ylabel("Density")
title("Occupation")

% Feature 03: Marital Status
histogram(bnk.marital)
ylabel("Density")
title("Marital Status")

% Feature 04: Education Level
table(bnk.education)
bnk.education = removecats(bnk.education,"unknown")
histogram(bnk.education)
ylabel("Density")
title("Education Level")

% Feature 05: Default
histogram(bnk.default)
ylabel("Density")
title("Default")

% Feature 06: Balance
histogram(bnk.balance)
ylabel("Density")
title("Balance")

% Feature 07: Housing
histogram(bnk.housing)
ylabel("Density")
title("Housing")

% Feature 08: Loan
histogram(bnk.loan)
ylabel("Density")
title("Loan")

% Feature 09: Contact
table(bnk.contact)
bnk.contact = removecats(bnk.contact,"unknown")
histogram(bnk.contact)
ylabel("Density")
title("Contact")

% Feature 10: Month
histogram(bnk.month)
ylabel("Density")
title("Month")

% Feature 11: Number of Days
histogram(bnk.day)
ylabel("Density")
title("Number of Days")

% Feature 12: Duration
histogram(bnk.duration)
ylabel("Density")
title("Duration")

% Feature 13: Campaign
histogram(bnk.campaign)
ylabel("Density")
title("Campaign")

% Feature 14: Days Passed
histogram(bnk.pdays)
ylabel("Density")
title("Days Passed")

% Feature 15: Before the Campaign
histogram(bnk.previous)
ylabel("Density")
title("Before the Campaign")

% Feature 16: Outcome of the Previous Campaign
bnk.poutcome = []

% Feature 17: Subscribed (Yes/No)
histogram(bnk.y)
ylabel("Density")
title("Subscribed (Yes/No)")
%% 
% *Part 02: Training and Testing Datasets*
% 
% 1- Use appropriate scripts to split the dataset into training (*tbltrain*) 
% and testing (*tbltest*) datasets (70% training, 30% testing).

part = cvpartition(height(bnk), "HoldOut", 0.3)
idxtrain = training(part)
tbltrain = bnkOriginal(idxtrain,:)

idxtest = test(part)
tbltest = bnk(idxtest,:)
%% 
% 
%% 
% 2- Do boxplots for the ML algorithms used in the datasets.

% Accuracy
x1 = [accuracy.AccuracyTrainNB, accuracy.AccuracyTestNB, accuracy.AccuracyTrainLR, accuracy.AccuracyTestLR, accuracy.AccuracyTrainSVM, accuracy.AccuracyTestSVM, accuracy.AccuracyTrainNN, accuracy.AccuracyTestNN]
boxplot(x1)
title("Boxplots for the accuracy for the ML algorithms used")
xticklabels({'Accuracy Train (Naive Bayes)', 'Accuracy Test (Naive Bayes)', 'Accuracy Train (Logistic Regression)', 'Accuracy Test (Logistic Regression)', 'Accuracy Train (SVM)', 'Accuracy Test (SVM)', 'Accuracy Train (Neural Networks)', 'Accuracy Test (Neural Networks)'})

x2 = [accuracy2.AccuracyTrainNBR1, accuracy2.AccuracyTestNBR1, accuracy2.AccuracyTrainLRR1,  accuracy2.AccuracyTestLRR1, accuracy2.AccuracyTrainSVMR1, accuracy2.AccuracyTestSVMR1, accuracy2.AccuracyTrainNNR1, accuracy2.AccuracyTestNNR1]
boxplot(x2)
title("Boxplots for the accuracy for the ML algorithms used - First Random Sampling")
xticklabels({'Accuracy Train (Naive Bayes) - Random 1', 'Accuracy Test (Naive Bayes) - Random 1', 'Accuracy Train (Logistic Regression) - Random 1', 'Accuracy Test (Logistic Regression) - Random 1', 'Accuracy Train (SVM) - Random 1', 'Accuracy Test (SVM) - Random 1', 'Accuracy Train (Neural Networks) - Random 1', 'Accuracy Test (Neural Networks) - Random 1'})

x3 = [accuracy3.AccuracyTrainNBR2, accuracy3.AccuracyTestNBR2, accuracy3.AccuracyTrainLRR2, accuracy3.AccuracyTestLRR2, accuracy3.AccuracyTrainSVMR2, accuracy3.AccuracyTestSVMR2, accuracy3.AccuracyTrainNNR2, accuracy3.AccuracyTestNNR2]
boxplot(x3)
title("Boxplots for the accuracy for the ML algorithms used - Second Random Sampling")
xticklabels({'Accuracy Train (Naive Bayes) - Random 2', 'Accuracy Test (Naive Bayes) - Random 2', 'Accuracy Train (Logistic Regression) - Random 2', 'Accuracy Test (Logistic Regression) - Random 2', 'Accuracy Train (SVM) - Random 2', 'Accuracy Test (SVM) - Random 2', 'Accuracy Train (Neural Networks) - Random 2', 'Accuracy Test (Neural Networks) - Random 2'})

% Prediction speed
y1 = [speed.PredictionSpeedobssecNB, speed.PredictionSpeedobssecLR, speed.PredictionSpeedobssecSVM, speed.PredictionSpeedobssecNN]
boxplot(y1)
title("Boxplots for the prediction speed for the ML algorithms used")
xticklabels({'Naive Bayes', 'Logistic Regression', 'SVM', 'Neural Networks'})

y2 = [speed2.PredictionSpeedobssecNBR1, speed2.PredictionSpeedobssecLRR1, speed2.PredictionSpeedobssecSVMR1, speed2.PredictionSpeedobssecNNR1]
boxplot(y2)
title("Boxplots for the prediction speed for the ML algorithms used - First Random Sampling")
xticklabels({'Naive Bayes - Random 1', 'Logistic Regression - Random 1', 'SVM - Random 1', 'Neural Networks - Random 1'})

y3 = [speed3.PredictionSpeedobssecNBR2, speed3.PredictionSpeedobssecLRR2, speed3.PredictionSpeedobssecSVMR2, speed3.PredictionSpeedobssecNNR2]
boxplot(y3)
title("Boxplots for the prediction speed for the ML algorithms used - Second Random Sampling")
xticklabels({'Naive Bayes - Random 2', 'Logistic Regression - Random 2', 'SVM - Random 2', 'Neural Networks - Random 2'})

% Training time
z1 = [time.TrainingTimesecNB, time.TrainingTimesecLR, time.TrainingTimesecSVM, time.TrainingTimesecNN]
boxplot(z1)
title("Boxplots for the training time for the ML algorithms used")
xticklabels({'Naive Bayes', 'Logistic Regression', 'SVM', 'Neural Networks'})

z2 = [time2.TrainingTimesecNBR1, time2.TrainingTimeLRR1, time2.TrainingTimeSVMR1, time2.TrainingTimeNNR1]
boxplot(z2)
title("Boxplots for the training time for the ML algorithms used - First Random Sampling")
xticklabels({'Naive Bayes - Random 1', 'Logistic Regression - Random 1', 'SVM - Random 1', 'Neural Networks - Random 1'})

z3 = [time.TrainingTimesecNB, time.TrainingTimesecLR, time.TrainingTimesecSVM, time.TrainingTimesecNN]
boxplot(z3)
title("Boxplots for the training time for the ML algorithms used - Second Random Sampling")
xticklabels({'Naive Bayes - Random 2', 'Logistic Regression - Random 2', 'SVM - Random 2', 'Neural Networks - Random 2'})