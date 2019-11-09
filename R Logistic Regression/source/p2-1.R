

# 연습문제 2.1


# 설명변수 : 130개 기업 채권, 투자성 등급(Y=1), 투기성 등급(Y=0)


# 설명변수
# x1 : 총자산 규모(1억 달러)
# x2 : 레버리지 척도(장기부채/총자본)
# x3 : 수익성 척도(순이익/총자산)
# x4 : 불안정척도(순이익 변동계수)
# x5 : 주식등급(1~6 척도) 


# 데이터 불러오기
library(tidyverse)
p21 <- read.table("C:/Users/user/Desktop/학교/05. 범주형자료분석/data/p2-1.dat")
names(p21) <- c("id",paste0("x",1:5),"y")
set.seed(1234)
x.id <- sample(1:nrow(p21), nrow(p21)*0.2)
p21_test <- p21[x.id,]
p21_train <- p21[-x.id,]


# 로지스틱 회귀모형 적합
fit <- glm(y ~ 1, family=binomial, data=p21_train)
fit.full <- glm(y ~ . -id, family=binomial, data=p21_train)


# 이상값 확인
library(car)
influencePlot(fit.full)
infIndexPlot(fit.full)


# 변수 선택 (BIC 기준의 전진선택법)
MASS::stepAIC(fit, scope=formula(fit.full), k=log(nrow(p21_train)), trace=FALSE)


# 변수 선택 (AIC 기준의 전진선택법)
MASS::stepAIC(fit, scope=formula(fit.full), k=2, trace=FALSE)


# 잠정 모형
fit.1 <- glm(y ~ x2 + x5, family=binomial, data=p21_train)
fit.2 <- glm(y ~ x1 + x2 + x4 + x5, family=binomial, data=p21_train)


# CCR
my_table <- mutate(p21_test, y_hat=if_else(predict(fit.1,newdata=p21_test,type="response")>=0.5,"yes","no")) %>% with(.,table(y,y_hat))
sum(diag(my_table)) / sum(my_table) * 100            


# adj CCR
y_max <- max(addmargins(my_table,2))
(sum(diag(my_table)) - y_max) / sum(my_table) * 100


# ROC curve
library(pROC)
library(carData)
pred <- predict(fit.1, newdata=p21_test, type="response")
roc(with(p21_test,y), pred, percent=TRUE, plot=TRUE)


# 이상값 90
p21_train %>% group_by(y) %>%
  summarise(x2_m=mean(x2), x5_m=mean(x5))
filter(p21_train, id==90)


# 이상값 제거
p21_train_out <- filter(p21_train, id!=90)


# 로지스틱 회귀모형 적합
fit <- glm(y ~ 1, family=binomial, data=p21_train_out)
fit.full <- glm(y ~ . -id, family=binomial, data=p21_train_out)


# 변수 선택 (BIC 기준의 단계별선택법)
MASS::stepAIC(fit, scope=formula(fit.full), k=log(nrow(p21_train_out)), trace=FALSE)


# 변수 선택 (AIC 기준의 단계별선택법)
MASS::stepAIC(fit, scope=formula(fit.full), k=2, trace=FALSE)


# 잠정 모형
fit.3 <- glm(y ~ x2 + x5, family=binomial, data=p21_train_out)
fit.4 <- glm(y ~ x1 + x2 + x4 + x5, family=binomial, data=p21_train_out)


# 제거 전후 모형 비교
library(car)
compareCoefs(fit.1, fit.3)


# AIC 와 BIC 비교
AIC(fit.1) ; AIC(fit.3)
BIC(fit.1) ; BIC(fit.3)


# 다중공선성의 문제
# 값이 10이라면 변수의 변량이 나머지 변수의 선형결합으로 90% 설명이 된다는 의미
# 다중공선성이 매우 심각할 수 있음
# 그러나 검정의 대상은 아니다.
library(car)
vif(fit.3)


# 최종 모형
fit <- glm(y ~ x2 + x5, family=binomial, data=p21_train_out)
summary(fit)


# CCR
my_table <- mutate(p21_test, y_hat=if_else(predict(fit,newdata=p21_test,type="response")>=0.5,"yes","no")) %>% with(.,table(y,y_hat))
sum(diag(my_table)) / sum(my_table) * 100            


# adj CCR
y_max <- max(addmargins(my_table,2))
(sum(diag(my_table)) - y_max) / sum(my_table) * 100


# ROC curve
pred <- predict(fit, newdata=p21_test, type="response")
roc(with(p21_test,y), pred, percent=TRUE, plot=TRUE)

