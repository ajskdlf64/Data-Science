# 2018년 12월 20일 14시 30분 <통계자료분석실습 기말고사 R 코드>


# 데이터 확인
library(tidyverse)
library(faraway)
library(car)
head(chredlin)
str(chredlin)
summary(chredlin)


# 데이터 분리
set.seed(201452024)
x.id <- sample(1:nrow(chredlin), size=nrow(chredlin)*0.2)
df_test <- chredlin[x.id,]
df_train <- chredlin[-x.id,]


# 산점도 행렬
library(GGally)
ggpairs(df_train)


# 소수인종비율과 plan가입수와의 관계
ggplot(df_train,aes(x=race,y=involact)) + 
  geom_point() + 
  geom_smooth(aes(col="lm"),method="lm",se=FALSE) + 
  geom_smooth(aes(col="loess"),se=FALSE) + 
  labs(col="")


# 화재건수와 plan가입수와의 관계
ggplot(df_train,aes(x=fire,y=involact)) + 
  geom_point() + 
  geom_smooth(aes(col="lm"),method="lm",se=FALSE) + 
  geom_smooth(aes(col="loess"),se=FALSE) + 
  labs(col="")


# 절도건수와 plan가입수와의 관계
ggplot(df_train,aes(x=theft,y=involact)) + 
  geom_point() + 
  geom_smooth(aes(col="lm"),method="lm",se=FALSE) + 
  geom_smooth(aes(col="loess"),se=FALSE) + 
  labs(col="")


# 오래된건물과 plan가입수와의 관계
ggplot(df_train,aes(x=age,y=involact)) + 
  geom_point() + 
  geom_smooth(aes(col="lm"),method="lm",se=FALSE) + 
  geom_smooth(aes(col="loess"),se=FALSE) + 
  labs(col="")


# 소득과 plan가입수와의 관계
ggplot(df_train,aes(x=income,y=involact)) + 
  geom_point() + 
  geom_smooth(aes(col="lm"),method="lm",se=FALSE) + 
  geom_smooth(aes(col="loess"),se=FALSE) + 
  labs(col="")


# 지역과 plan 가입수와의 관계
ggplot(df_train,aes(x=side,y=involact,fill=side)) + 
  geom_boxplot()


# 모델 적합
fit <- lm(involact ~ ., data=df_train)
summary(fit)
AIC(fit); BIC(fit) ; forecast::accuracy(fit)


# 검정에의한 변수선택 (전진선택법)
fit.full <- lm(involact ~ . , df_train)         
fit.0 <- lm(involact ~ 1, df_train)              
MASS::addterm(fit.0, fit.full, test="F")
fit.0 <- update(fit.0, . ~ . + race)
MASS::addterm(fit.0, fit.full, test="F")
fit.0 <- update(fit.0, . ~ . + age)
MASS::addterm(fit.0, fit.full, test="F")    # race + age


# 검정에의한 변수선택 (후진소거법)
fit.full <- lm(involact ~ . , df_train)   
MASS::dropterm(fit.full, test="F")
fit.full <- update(fit.full, . ~ . - income)
MASS::dropterm(fit.full, test="F")
fit.full <- update(fit.full, . ~ . - side)
MASS::dropterm(fit.full, test="F")          # race + fire + theft + age 


# 검정에의한 변수선택 (단게적선택법)
fit.full <- lm(involact ~ . , df_train)         
fit.0 <- lm(involact ~ 1, df_train)              
MASS::addterm(fit.0, fit.full, test="F")
fit.0 <- update(fit.0, . ~ . + race)
MASS::dropterm(fit.0, test="F")
MASS::addterm(fit.0, fit.full, test="F")
fit.0 <- update(fit.0, . ~ . + age)
MASS::dropterm(fit.0, test="F")
MASS::addterm(fit.0, fit.full, test="F")    # race + age


# 모형 선택 기준에 따른 변수 선택
library(leaps)
fits <- regsubsets(involact ~ ., df_train)
plot(fits, main="BIC")                             # race + fire + theft + age
plot(fits, scale="adjr2", main="adjr2")            # race + fire + theft + age
plot(fits, scale="Cp", main="Cp")                  # race + fire + theft + age


# AIC, BIC 기준에 따른 변수 선택
fit <- lm(involact ~ ., data=df_train)
step(fit, direction="both", trace=FALSE)           # race + fire + theft + age
step(fit, k=log(nrow(df_train)),trace=FALSE)       # race + fire + theft + age


# 잠정모형 비교
fit.1.1 <- lm(involact ~ race + age, data=df_train)
fit.1.2 <- lm(involact ~ race + fire + theft + age, data=df_train)
AIC(fit.1.1) ; AIC(fit.1.2)
BIC(fit.1.1) ; BIC(fit.1.2)


# 잠정모형 선택
fit.1.2 <- lm(involact ~ race + fire + theft + age, data=df_train)


# 이상값 확인
influencePlot(fit.1.2)


# 이상값 제거여부 판단
df_train_out <- df_train %>% rownames_to_column(var="id") %>% 
  filter(id==60610|id==60621|id==60607)
ggplot(df_train,aes(x=race,y=involact)) + 
  geom_point() + 
  geom_text(data=df_train_out,aes(label=id),nudge_y=0.05)


# 가정만족여부 확인
spreadLevelPlot(fit.1.2)
plot(fit.1.2, which=2)
forecast::checkresiduals(fit.1.2)
crPlots(fit.1.2)
residualPlots(fit.1.2)


# 예측
summary(fit.1.2)
pred <- data.frame(predict(fit.1.2, newdata=df_test, interval="confidence", level=0.95))
df <- data.frame(id=1:9,pred=pred$fit, real=df_test$involact)
forecast::accuracy(df_test$involact,pred$fit)


# 예측값 음수면 0 처리
df <- data.frame(id=c(1:nrow(df_test),1:nrow(df_test)),value=c(df$pred,df$real),group=rep(c("pred","real"),each=nrow(df_test)))
df <- mutate(df,value=ifelse(value<0,0,value))


# 예측 시각화
ggplot(df,aes(x=factor(id),y=value,fill=group)) + 
  geom_col(position="dodge") + 
  coord_flip() +
  labs(x="",y="",title="실제값 vs 예측값")


# 최종모형 해석
summary(fit.1.2)


# <부록> #

# 데이터가 0인 지점에 0.0000001 추가
df_train <- mutate(df_train, involact=ifelse(involact==0,involact+0.0000001,involact))
fit.1.2 <- lm(involact ~ race + fire + theft + age, data=df_train)


# 변수변환여부 확인
summary(powerTransform(fit.1.2))


# 로그변환 실시후 변수 선택


# 모형 선택 기준에 따른 변수 선택
library(leaps)
fits <- regsubsets(log(involact) ~ ., df_train)
plot(fits, main="BIC")                             # race + age
plot(fits, scale="adjr2", main="adjr2")            # race + age + income
plot(fits, scale="Cp", main="Cp")                  # race + age


# AIC, BIC 기준에 따른 변수 선택
fit <- lm(log(involact) ~ ., data=df_train)
step(fit, direction="both", trace=FALSE)           # race + age
step(fit, k=log(nrow(df_train)),trace=FALSE)       # race + age


# 잠정모형 비교
fit.2.1 <- lm(log(involact) ~ race + age, data=df_train)
fit.2.2 <- lm(log(involact) ~ race + age + income, data=df_train)
AIC(fit.2.1) ; AIC(fit.2.2)
BIC(fit.2.1) ; BIC(fit.2.2)


# 잠정모형 선택
fit.2.1 <- lm(log(involact) ~ race + age, data=df_train)


# 이상값 확인
influencePlot(fit.2.1)


# 이상값 제거 여부 판단
df_train_out_2 <- df_train %>% rownames_to_column(var="id") %>% 
  filter(id==37)
ggplot(df_train,aes(x=race,y=involact)) + 
  geom_point() + 
  geom_text(data=df_train_out_2,aes(label=id),nudge_y=0.05)


# 가정만족여부 확인
spreadLevelPlot(fit.2.1)
plot(fit.2.1, which=2)
forecast::checkresiduals(fit.2.1)
crPlots(fit.2.1)
residualPlots(fit.2.1)


# 2차항 추가 후 모형 선택
df_train <- mutate(df_train, race_2=race*race)


# 모형 선택 기준에 따른 변수 선택
library(leaps)
fits <- regsubsets(log(involact) ~ ., df_train)
plot(fits, main="BIC")                             # race + race_2 + age
plot(fits, scale="adjr2", main="adjr2")            # race + race_2 + age + income
plot(fits, scale="Cp", main="Cp")                  # race + race_2 + age


# AIC, BIC 기준에 따른 변수 선택
fit <- lm(log(involact) ~ ., data=df_train)
step(fit, direction="both", trace=FALSE)           # race + race_2 + age
step(fit, k=log(nrow(df_train)),trace=FALSE)       # race + race_2 + age


# 잠정모형 비교
fit.3.1 <- lm(log(involact) ~ race + race_2 + age, data=df_train)
fit.3.2 <- lm(log(involact) ~ race + race_2 + age + income, data=df_train)
AIC(fit.3.1) ; AIC(fit.3.2)
BIC(fit.3.1) ; BIC(fit.3.2)


# 잠정모형 선택
fit.3.1 <- lm(log(involact) ~ race + race_2 + age, data=df_train)


# 이상값 확인
influencePlot(fit.3.1)


# 가정만족여부 확인
spreadLevelPlot(fit.3.1)
plot(fit.3.1, which=2)
forecast::checkresiduals(fit.3.1)
crPlots(fit.3.1)
residualPlots(fit.3.1)


# 최종모형
fit.3.1 <- lm(log(involact) ~ race + race_2 + age, data=df_train)


# test에 2차항 추가
df_test <- mutate(df_test, race_2=race*race)


# 예측
pred <- data.frame(exp(predict(fit.3.1, newdata=df_test, interval="confidence", level=0.95)))
df <- data.frame(id=1:9,pred=pred$fit, real=df_test$involact)
forecast::accuracy(df_test$involact,pred$fit)

# 예측값 음수면 0 처리
df <- data.frame(id=c(1:nrow(df_test),1:nrow(df_test)),value=c(df$pred,df$real),group=rep(c("pred","real"),each=nrow(df_test)))
df <- mutate(df,value=ifelse(value<0,0,value))


# 예측 시각화
ggplot(df,aes(x=id,y=value,fill=group)) + 
  geom_col(position="dodge") + 
  coord_flip() +
  labs(x="",y="",title="실제값 vs 예측값")


