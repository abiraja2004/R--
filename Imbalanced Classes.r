closeAllConnections()
rm(list=ls())
setwd("/Volumes/16 DOS/R_nbs")
logitML<-read.csv("questao1.csv",sep=";",header=TRUE,fileEncoding="latin1")
dim(logitML)
head(logitML)
summary(logitML)
head(logitML,2)
sum(is.na(logitML[,2]))
apply(is.na(logitML),2,sum)

unique(logitML$Avaliação.de.desempenho)
c(unique(logitML$Avaliação.de.desempenho))
logitML$Avaliação.de.desempenho<-factor(logitML$Avaliação.de.desempenho, labels =c(unique(logitML$Avaliação.de.desempenho)))
logitML$Avaliação.de.desempenho<-as.numeric(logitML$Avaliação.de.desempenho)

unique(logitML$Sexo)
logitML$Sexo<-factor(logitML$Sexo, labels = c(0,1))
logitML$Sexo<-as.numeric(logitML$Sexo)


c(unique(logitML$Área))
logitML$Área<-factor(logitML$Área, labels =c(unique(logitML$Área)))
logitML$Área<-as.numeric(logitML$Área)

# WORK REPLACE "," por "."
head(logitML$Turnover.mercado)
head((as.numeric(logitML$Turnover.mercado)+1)/100)
# OR
logitML$Turnover.mercado<-as.numeric(gsub("\\,",".",factor(logitML$Turnover.mercado)))

# WORK TIRAR R$
head(logitML$Salário.mensal.médio)
head(factor(logitML$Salário.mensal.médio))
f1<-gsub('[R$ ]','',factor(logitML$Salário.mensal.médio))
head(f1)
head(f2<-gsub("\\.","",f1))
logitML$Salário.mensal.médio<-as.factor(f2)
names(logitML)

# WORK DATAS PEGAR ANO
head(logitML$Data.de.nascimento)
p1<-as.Date(logitML$Data.de.nascimento,"%d/%m/%Y")
p2<-format(p1,'%Y')
logitML$Data.de.nascimento<-as.numeric(p2)

head(logitML$Data.de.admissão)
p12<-as.Date(logitML$Data.de.admissão,"%d/%m/%Y")
p22<-format(p12,'%Y')
logitML$Data.de.admissão<-as.numeric(p22)

logitML$Data.de.nascimento
p123<-as.Date(logitML$Data.de.nascimento,"%d/%m/%Y")
p223<-format(p1,'%Y')
logitML$Data.de.nascimento<-as.numeric(p223)

logitML$X<-NULL

# Imbalanced Classes for Target Variable
sum(logitML[1]==1)

cor(logitML[,c(1,2,3,4,5,6,7,9,10)])

par(mfrow=c(3,4))
for (i in c(1,2,3,4,5,6,7,9,10,11,12,14)){
    hist(logitML[,i],col="green",main=names(logitML)[i])
    }

#TESTE T
t.test(logitML$Desligamento[logitML$Ex.trainee==0],logitML$Desligamento[logitML$Ex.trainee==1])
par(mfrow=c(1,1))
dim(logitML)

for (i in c(1,2,3,4,5,6,7,9,10,11,12,13,14)){print(c(i,mean(logitML[c(which(logitML$Desligamento==0)),i])-
        mean(logitML[c(which(logitML$Desligamento==1)),i])))
    }

dim(logitML)

x_train<-logitML[,c(6,7,10)]
y_train<-logitML[,1]
x<-data.frame(cbind(x_train,y_train))

logistic<-glm(y_train~x_train[,1]+x_train[,2]+x_train[,3],data=x,family="binomial")
summary(logistic)
names(logistic)
logistic$residuals

x_test<-logitML[1500:2000,c(6,7,10)]
x_train<-x_test
y_train<-logitML[1500:2000,1]
length(which(y_train==1))/length(y_train)

  
predicted<-predict(logistic,newdata = data.frame(cbind(x_train,y_train)))
predicted

m=predicted
dim(data.frame(predicted))

### # P logistic result

length(predicted)
d=1
k=c()
while(d<length(predicted)+1){
    k[[d]]<-2.71^m[[d]]/(1+2.71^m[[d]])
    d<-d+1
}
k

## HILL CLIMBING ALGORITHM
t=c()
r=1
for (i in seq(0.04,0.09,0.0001)){
    resultlogit<-k
    resultlogit[resultlogit>i]<-1
    resultlogit[resultlogit<1]<-0
    t[[r]]<-length(which(y_train+resultlogit==2))/length(which(y_train==1))+length(which(y_train+resultlogit==0))/length(which(y_train==0))
    r=r+1
}
plot(t,main="Hill Climbimg",col="red")
ii<-which.max(t)
resultlogit<-k
resultlogit[resultlogit>seq(0.04,0.09,0.0001)[[ii]]]<-1
resultlogit[resultlogit<1]<-0
resultlogit

### TRANSFORM TO SINGLE LIST
pred<-resultlogit
predict1<-as.numeric(pred)
y_train
predict1

j<-sum(y_train-predict1==0)/length(y_train-predict1)
table(y_train,predict1)
j
library(ROCR)
pred
y_train
p<-prediction(pred,y_train)
p

par(mfrow=c(1,1))
perform<-performance(p,measure="tpr",x.measure="fpr")
plot(perform,main="ROC")
auc<-performance(p,measure="auc")
auc@y.values[[1]]

#ACERTOS TRUE POSITIVE
length(which(y_train+resultlogit==2))
a<-length(which(y_train+resultlogit==2))/length(which(y_train==1))
a

#ACERTOS TRUE NEGATIVE
length(which(y_train+resultlogit==0))
b<-length(which(y_train+resultlogit==0))/length(which(y_train==0))
b
x_train<-logitML[,c(6,7,10)]
y_train<-logitML[,1]
x<-data.frame(cbind(x_train,y_train))
x_train[,1]

#BOOSTING
library("gbm")
gbm1<-gbm(x[,4]~x[,1]+x[,2]+x[,3], data=x, n.trees=1000,shrinkage=0.1,bag.fraction = 0.5,train.fraction = 0.8)
plot(gbm1)
names(gbm1)
mean(gbm1$valid.error)
gbm1$fit
z<-abs(gbm1$fit)

z[z<2]<-1
z[z>1]<-0
head(z)
z<-z[1500:2000]

#TRUE POSITIVE
a
length(which(y_train+z==2))/length(which(y_train==1))

#TRUE NEGATIVE
b
length(which(y_train+z==0))/length(which(y_train==0))

x_train<-logitML[1500:2000,c(6,7,10)]
y_train<-logitML[1500:2000,1]
x<-data.frame(cbind(x_train,y_train))

pred2<-gbm.perf(gbm1,plot.it = TRUE,oobag.curve = FALSE,overlay = TRUE,method="OOB")
pred2
print(pred2)
z-y_train
p2<-prediction(z,y_train)
perform2<-performance(p2,measure="tpr",x.measure="fpr")
auc2<-performance(p2,measure="auc")

summary(gbm1,n.trees=12)
par(mfrow=c(2,2))
plot(t,main="Hill Climbimg",col="red",pch=20,xlab="Cases",ylab="TP + TN")
plot(perform,main=c("AUC Logistic Regression",round(auc@y.values[[1]],digits=3)))
gbm.perf(gbm1,plot.it = TRUE,oobag.curve = FALSE,overlay = TRUE,method="OOB")
plot(perform2,main=c("Area Under Curve Boosting",round(auc2@y.values[[1]],digits=3)))
auc<-performance(p,measure="auc")

#TRUE POSITIVE
a
length(which(y_train+z==2))/length(which(y_train==1))
#TRUE NEGATIVE
b
length(which(y_train+z==0))/length(which(y_train==0))
# AREA UNDER CURVE LOGISTIC REGRESSION
auc@y.values[[1]]
# AREA UNDER CURVE BOOSTING
auc2@y.values[[1]]