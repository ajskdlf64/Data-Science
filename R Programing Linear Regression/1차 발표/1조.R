# 패키지 로딩
library(tidyverse)
library(car)
library(GGally)
library(forecast)
library(MASS)
library(scales)
library(leaps)


# 데이터 소개
summary(Hartnagel)
str(Hartnagel)
head(Hartnagel)


# 결측값 삭제
new_Hartnagels <- Hartnagel[-c(1:4),]


# 데이터 분할 및 시드 고정
set.seed(1234)
x.id <- sample(1:nrow(new_Hartnagels), size=4)
df_test <- new_Hartnagels[x.id,]
df_train <- new_Hartnagels[-x.id,]


# 산점도 확인
ggpairs(df_train)


# 반응변수 확인
ggplot(df_train) + geom_point(aes(x=as.factor(year),y=ftheft))


# 회귀모형 적합
fit <- lm(ftheft ~ . ,data=df_train)
summary(fit)


# 변수선택
fit<- lm(ftheft ~ . , df_train)
MASS::dropterm(fit, test="F")
fit <- update(fit, . ~ . - mconvict)
MASS::dropterm(fit, test="F")
fit <- update(fit, . ~ . - year)
MASS::dropterm(fit, test="F")
fit <- update(fit, . ~ . - tfr)
MASS::dropterm(fit, test="F")


# 후진소거법에의한 잠정 모델 선정
fit_1 <- lm(ftheft ~ . - mconvict - year - tfr, data=df_train)
summary(fit_1)


# 가정 만족 여부 확인
spreadLevelPlot(fit_1)
qqPlot(fit_1) 
shapiro.test(fit_1$resid) 
durbinWatsonTest(fit_1)
checkresiduals(fit_1)
crPlots(fit_1)
summary(powerTransform(fit_1))
vif(fit_1)


# 예측
pred <- predict(fit_1,newdata=df_test)
pred <- cbind(real=df_test$ftheft,pred)
pred <- pred %>% as.tibble() %>% rownames_to_column(var="id") %>% mutate(num=as.numeric(id))
ggplot(pred) + geom_line(aes(x=num,y=real),size=2,col="red") + geom_line(aes(x=num,y=pred),size=2,col="blue")


# 시계열 데이터에서 Train과 Test를 랜덤으로 나눈 이유는? 일반적으로 맨 뒤의 데이터를 때서 미래를 예측
# 5번,6번 설명변수 변환 후 3차 모형은 고려하지 않았는지? 등분산가정 위배 -> 반응변수 변환 ?



