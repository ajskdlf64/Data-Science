# 데이터 소개
library(tidyverse)
library(car)
head(Salaries)
summary(Salaries)
str(Salaries)

# 결측값 확인
sum(is.na(Salaries))

# 시드 고정
set.seed(1234)

# 데이터 분할
x <- sample(1:nrow(Salaries), size=40)
df_1 <- Salaries[x,]
df_2 <- Salaries[-x,]

# 회귀모형 적합
fit <- lm(salary ~ rank + discipline + yrs.since.phd + yrs.service + sex, data=df_2)
summary(fit)

# 반응변수 변환 여부
library(MASS)
bc <- boxcox(fit)
names(bc)
bc$x[which.max(bc$y)]
summary(powerTransform(fit))

# 로그변환
fit <- update(fit, log(.) ~ .)
summary(fit)

# 변수선택 (후진소거법)
dropterm(fit, test="F")
fit <- update(fit, . ~ . - sex)
dropterm(fit, test="F")
fit_1 <- lm(log(salary) ~ rank + discipline + yrs.since.phd  + yrs.service, data=df_2)

# Cp 통계량 기준
library(leaps)
fits <- regsubsets(log(salary) ~ . , df_2)
plot(fits, scale="Cp")

# BIC 통계량 기준
fits <- regsubsets(log(salary) ~ . , df_2)
plot(fits)
fit_1 <- lm(log(salary) ~ rank + discipline, data=df_2)

# 예측
pred_all <- exp(predict(fit,newdata=df_1,type="response"))
pred_1 <- exp(predict(fit_1,newdata=df_1,type="response"))
pred <- cbind(real=df_1$salary,pred_all,pred_1)

# 예측 그래프
pred <- pred %>% as.tibble() %>% rownames_to_column(var="id") %>% mutate(num=as.numeric(id))
ggplot(pred) + geom_line(aes(x=num,y=real),size=1.5,col="rosybrown") + 
  geom_line(aes(x=num,y=pred_all),size=1.5,col="steelblue") + 
  geom_line(aes(x=num,y=pred_1),size=1.5,col="darkgreen")

# 질문
# 대부분의 잠정모형에서 모두 등분산성을 위반
# EDA 에서 반응변수의 분산이 증가하는 경향을 보였는데, 변수변환을 하고 변수 선택을 통한 잠정모형 고려?
