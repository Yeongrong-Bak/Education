rm(list=ls())
gc()

setwd("D:/Dropbox/�����ڷ�/����뵿��_��õ_201710/recommender_�ǽ��ڷ�")

#install.packages("Matrix")
#install.packages("FactoRizationMachines")

#########################################
# Factorization machines                #
#########################################

# Practice 1
ml100k = read.csv("ml100k.csv")
colnames(ml100k) = c("user","item","rating","time")
head(ml100k)

library(Matrix)
user=ml100k[,1] #943��
items=ml100k[,2]+max(user) #1682��
wdays=(as.POSIXlt(ml100k[,4],origin="1970-01-01")$wday+1)+max(items) 
#POSIX �ð� �Ǵ� Unix �ð� (1970�� 1�� 1�� 00:00:00 ���� �����(UTC) ������ ��� �ð��� �ʷ� ȯ���Ͽ� ������ ��Ÿ��)
#as.POSIXlt : POSIX �ð��� ����, ��, ��, ��, ��, �ʷ� �ٲ��ִ� �Լ�

data=sparseMatrix(i=rep(1:nrow(ml100k),3),j=c(user,items,wdays),giveCsparse=F)
target=ml100k[,3]

#100000�� �ڷ��� 20% �� ���� 
set.seed(123)
subset=sample.int(nrow(data),nrow(data)*.2)
subset=sort(subset)
data.train=data[-subset,]
data.test=data[subset,]
target.train=target[-subset]
target.test=target[subset]


# Predict ratings with second-order Factorization Machine
# with second-order 10 factors (default) and regularization
library(FactoRizationMachines)
set.seed(1)
#10�� second-order factor ����(K)
model=FM.train(data.train,target.train,regular=0.1, c(1,10), iter=200) 
model

# RMSE resulting from test data prediction
pre=predict(model,data.test)
summary(pre)
sqrt(mean((pre-target.test)^2)) #RMSE of test set
sqrt(mean((predict(model,data.train)-target.train)^2)) #RMSE of train set


# Practice 2 : RC data :Restaurant & consumer data Data Set
#https://archive.ics.uci.edu/ml/datasets/Restaurant+%26+consumer+data#
#���� �غ�����!