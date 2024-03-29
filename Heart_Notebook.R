library(tidyverse)
dataset=read.csv('heart.data.csv')

#exploration of data set
view(dataset)
head(dataset)
glimpse(dataset)
length(dataset)
names(dataset)
summary(dataset)

#miss data entries
colSums(is.na(dataset))

#filling missing data for biking variable
ggplot(data=dataset, 
       aes(biking))+
  geom_histogram()

bike_median=median(dataset$biking, na.rm=TRUE)
dataset$biking=ifelse(is.na(dataset$biking),
                   bike_median, 
                   dataset$biking)
colSums(is.na(dataset))

#filling missing data for smoking variable
ggplot(data=dataset, 
       aes(smoking))+
  geom_histogram()

smoking_median=median(dataset$smoking, na.rm=TRUE)
dataset$smoking=ifelse(is.na(dataset$smoking),
                      smoking_median, 
                      dataset$smoking)
colSums(is.na(dataset))


#filling missing data for heart disease variable
ggplot(data=dataset, 
       aes(heart.disease))+
  geom_histogram()

heart_median=median(dataset$heart.disease, na.rm=TRUE)
dataset$heart.disease=ifelse(is.na(dataset$heart.disease),
                             heart_median, 
                             dataset$heart.disease)
colSums(is.na(dataset))


#Splitting data 
library(caTools)
set.seed(100)
split=sample.split(dataset$heart.disease, SplitRatio = 0.8) 
#80% training, 20% testing

training_set=subset(dataset,split=TRUE)
test_set=subset(dataset, split=FALSE)


#Multiple linear regression training
MLR=lm(formula=heart.disease~ .,
       data=training_set)
summary(MLR)
#14.958 + -0.200(biking) + 0.179(smoking)
#biking and smoking are statically significant for heart disease  


#Mean square error
summ=summary(MLR)
MSE=(mean(summ$residuals^2)) 
paste('Mean Square Error:', MSE)

#R-Squared
summary(MLR)


#Testing Set Prediction
y_pred=predict(MLR, newdata=test_set)
data=data.frame(test_set$heart.disease, y_pred)
head(data)


#Validation
new=read_csv("Heart_validation.csv")
new_x=new[c(1:2)]
new_x

data.frame(new[c(3)], predict(MLR, newdata = new_x))
