

# 연습문제 2.2


# 변수설명
#  y : 전문회계사의 도움 여부를  표시하는 변수
# x1 : 나이구분
# x2 : 총소득의 기대값
# x3 : 납세자의 사업구분
# x4 : 한계조세


# 데이터 불러오기
library(tidyverse)
p22 <- read.table("C:/Users/user/Desktop/학교/05. 범주형자료분석/data/p2-2.dat")
names(p22) <- c("id","y",paste0("x",1:4))


# 시드 고정 및 데이터 분리
set.seed(1234)
x.id <- sample(1:nrow(p22), nrow(p22)*0.2)
p22_test <- p22[x.id,]
p22_train <- p22[-x.id,]


# 로지스틱 회귀 모형 적합
fit <- glm(y ~ x1 + x2 + x3 + x4, family=binomial, data=p22_train)
summary(fit)


# 검정에 의한 전진선택법
library(carData)
library(MASS)
fit.full <- glm(y ~ x1 + x2 + x3 + x4, family="binomial", data=p22_train)
fit.0 <- glm(y ~ 1 , family="binomial", data=p22_train)
addterm(fit.0, fit.full, test="Chisq")
fit.0 <- update(fit.0, . ~ . + x2)
addterm(fit.0, fit.full, test="Chisq")
fit.0 <- update(fit.0, . ~ . + x3)
addterm(fit.0, fit.full, test="Chisq")     # x2,x3 포함된 모형


# 검정에 의한 후진소거법
fit.full <- glm(y ~ x1 + x2 + x3 + x4, family="binomial", data=p22_train)
dropterm(fit.full, test="Chisq")
fit.full <- update(fit.full, . ~ . - x1)
dropterm(fit.full, test="Chisq")
fit.full <- update(fit.full, . ~ . - x4)
dropterm(fit.full, test="Chisq")     # x2,x3 포함된 모형


# 검정에 의한 단계별선택법
fit.full <- glm(y ~ x1 + x2 + x3 + x4, family="binomial", data=p22_train)
fit.0 <- glm(y ~ 1 , family="binomial", data=p22_train)
addterm(fit.0, fit.full, test="Chisq")
fit.0 <- update(fit.0, . ~ . + x2)
dropterm(fit.0, test="Chisq")
addterm(fit.0, fit.full, test="Chisq")
fit.0 <- update(fit.0, . ~ . + x3)
dropterm(fit.0, test="Chisq")
addterm(fit.0, fit.full, test="Chisq")     # x2,x3 포함된 모형


# AIC 기준의 변수 선택
library(bestglm)
p22_train <- p22_train %>% dplyr::select(x1:x4,y)
fit.aic <- bestglm(p22_train, family=binomial, IC="AIC")
fit.aic     # x2,x3 포함된 모형


# BIC 기준의 변수 선택
fit.bic <- bestglm(p22_train, family=binomial, IC="BIC")
fit.bic     # x2 포함된 모형


# stepAIC 기준의 변수 선택
library(MASS)
fit.0 <- glm(y ~ 1, family="binomial", Mroz)
fit.full <- glm(y ~ x1 + x2 + x3 + x4, family="binomial", p22_train)
stepAIC(fit.0, scope=formula(fit_full), k=2, direction="both", trace=FALSE)     # x2,x3 모형 선택


# stepBIC 기준의 변수 선택
stepAIC(fit.full, k=log(nrow(p22_train)), trace=FALSE)     # x2 포함된 모형


# 잠정모형 비교
fit.1 <- glm(y ~ x2 + x3, family=binomial, data=p22_train)
fit.2 <- glm(y ~ x2, family=binomial, data=p22_train)
AIC(fit.1) ; AIC(fit.2)
BIC(fit.1) ; BIC(fit.2)


# 잠정모형
fit.1 <- glm(y ~ x2 + x3, family=binomial, data=p22_train)


# 이상값 탐지
influencePlot(fit.1)


# 가정 만족 확인 (선형관계 여부)
residualPlots(fit.1)


# 다중공선성의 문제 확인
car::vif(fit.1)


# 최종 모형
fit.1 <- glm(y ~ x2 + x3, family=binomial, data=p22_train)


# CCR
my_table <- mutate(p22_test,y_hat=if_else(predict(fit.1,newdata=dplyr::select(p22_test,-id),type="response")>=0.5,"1","0")) %>% 
  with(.,table(y,y_hat))
addmargins(my_table)
sum(diag(my_table)) / sum(my_table) * 100


# adj_CCR
y_max <- max(addmargins(my_table,2))
(sum(diag(my_table)) - y_max) / sum(my_table) * 100


# ROC curve
library(pROC)aQ2
library(carData)
pred <- predict(fit.1,newdata=p22_test, type="response")
roc(with(p22_test,y), pred, percent=TRUE, plot=TRUE)

