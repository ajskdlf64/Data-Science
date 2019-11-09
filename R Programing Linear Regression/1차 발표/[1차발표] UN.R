# 패키지 로딩
library(tidyverse)
library(car)
library(GGally)
library(forecast)
library(MASS)
library(scales)
library(leaps)


# 데이터 소개
summary(UN)
str(UN)


# 결측값 확인 및 제거
un <- UN %>% filter(region!=is.na(region) & infantMortality!=is.na(infantMortality))
head(un)


# 데이터 분할 및 시드 고정
set.seed(2014)
x.id <- sample(1:nrow(un), size=13)
df_test <- un[x.id,]
df_train <- un[-x.id,]


# 산점도 확인
# ggpairs(df_train)


# region과 group의 관계
ggplot(df_train) + geom_bar(aes(x=region, fill=group),position="fill")


# region과 group의 독립성 검정
with(df_train, chisq.test(region, group))


# group과 infantMortality의 관계
df_train %>% summarise(Freq=n(),m=mean(infantMortality, na.rm=TRUE))
df_train %>% group_by(group) %>% summarise(Freq=n(),m=mean(infantMortality, na.rm=TRUE)) %>% mutate(pct=paste0(round(m,2),"%")) %>% 
  ggplot(aes(x=group,y=m,fill=group)) + geom_bar(stat="identity") + 
  geom_text(aes(label=pct), size=5, position=position_stack(vjust=0.5)) + 
  labs(x="group", y="mean of infnatMortaliy")


# fertility와 infantMortality의 관계
df_train %>% group_by(group) %>% summarise(m=mean(fertility))
df_train %>% summarise(m=mean(fertility))
ggplot(df_train,aes(x=fertility,y=infantMortality)) + 
  geom_smooth(se=FALSE,method="lm",col="black") + 
  geom_point(aes(col=group),size=2)


# lifeExpF와 infantMortality의 관계
df_train %>% group_by(group) %>% summarise(m=mean(lifeExpF))
df_train %>% summarise(m=mean(lifeExpF))
ggplot(df_train,aes(x=lifeExpF,y=infantMortality)) + 
  geom_smooth(se=FALSE,method="lm",col="black") + 
  geom_point(aes(col=group),size=2)


# pctUrban과 infantMortality의 관계
df_train %>% group_by(group) %>% summarise(m=mean(pctUrban))
df_train %>% summarise(m=mean(pctUrban))
ggplot(df_train,aes(x=pctUrban,y=infantMortality)) + 
  geom_point(aes(col=group),size=2)


# ppgdp과 infantMortality의 관계
df_train %>% group_by(group) %>% summarise(m=mean(ppgdp))
df_train %>% summarise(m=mean(ppgdp))
ggplot(df_train,aes(x=ppgdp,y=infantMortality)) + 
  geom_point(aes(col=group),size=2)


# ppgdp의 변수변환 여부
boxTidwell(infantMortality ~ ppgdp, data=df_train)
df_train %>% group_by(group) %>% summarise(m=mean(ppgdp^-0.3))
df_train %>% summarise(m=mean(ppgdp^-0.3))
ggplot(df_train,aes(x=ppgdp^-0.3,y=infantMortality)) + 
  geom_point(aes(col=group),size=2) + 
  geom_smooth(se=FALSE,method="lm",col="black")


# 변수 선택	1. 후진소거법
fit <- lm(infantMortality ~ group + fertility + lifeExpF + I(ppgdp^-0.3) + pctUrban, df_train)
MASS::dropterm(fit, test="F")
fit <- update(fit, . ~ . - pctUrban)
MASS::dropterm(fit, test="F")
fit <- update(fit, . ~ . - group)
MASS::dropterm(fit, test="F")


# 변수 선택	2. BIC에 의한 선택
fit_all <- regsubsets(infantMortality ~ group + fertility + lifeExpF + I(ppgdp^-0.3) + pctUrban, df_train)
plot(fit_all)
subsets(fit_all, statistic="bic", legend=FALSE)


# 변수 선택	3. Cp에 의한 선택
plot(fit_all, scale="Cp")
subsets(fit_all, statistic="cp", legend=FALSE)
abline(a=1,b=1,lty=3)


# 변수 선택	4. adjr2에 의한 선택
plot(fit_all, scale="adjr2")
subsets(fit_all, statistic="adjr2", legend=FALSE)


# 잠정 모형 1
fit_1 <- lm(infantMortality ~ fertility + lifeExpF + I(ppgdp^-0.3), df_train)
summary(fit_1)


# 잠정 모형 2
fit_2 <- lm(infantMortality ~ group + fertility + lifeExpF + I(ppgdp^-0.3), df_train)
summary(fit_2)


# 변수 선택 : 초기상태에서의 후진소거법
fit_original <- lm(infantMortality ~ region + group + fertility + lifeExpF + ppgdp + pctUrban, df_train)
MASS::dropterm(fit_original, test="F")
fit_original <- update(fit_original, . ~ . - ppgdp)
MASS::dropterm(fit_original, test="F")
fit_original <- update(fit_original, . ~ . - group)
MASS::dropterm(fit_original, test="F")
fit_original_all <- regsubsets(infantMortality ~ region + group + fertility + lifeExpF + ppgdp + pctUrban, df_train)
plot(fit_original_all,scale="bic")
plot(fit_original_all,scale="Cp")


# 잠정 모형 3
fit_3 <- lm(infantMortality ~ region + fertility + lifeExpF + pctUrban, df_train)
summary(fit_3)


# 잠정 모형 4
fit_4 <- lm(infantMortality ~ group + ppgdp + pctUrban, df_train)
summary(fit_4)


# 잠정 모형 비교 : RMSE
rmse <- data.frame(case=c("model1", "model2", "model3", "model4"),rmse=c(8.651,8.604,8.751,16.53))
ggplot(rmse,aes(x=case,y=rmse,fill=case)) + geom_bar(stat="identity") + 
  geom_text(aes(label=rmse), size=5, position=position_stack(vjust=0.5)) + 
  labs(x="Model", y="rmse2") + ggtitle("RMSE") +
  theme(plot.title = element_text(hjust = 0.5))


# 잠정 모형 비교 : adj r2
adjr2 <- data.frame(case=c("model1", "model2", "model3", "model4"),adjr2=c("90.95%","91.05%","90.74%","66.96%"))
ggplot(adjr2,aes(x=case,y=adjr2,fill=case)) + geom_bar(stat="identity") + 
  geom_text(aes(label=adjr2), size=5, position=position_stack(vjust=0.5)) + 
  labs(x="Model", y="adjr2") + ggtitle("adj R2") +
  theme(plot.title = element_text(hjust = 0.5))


# 첫 번째 잠정 모형
fit_1 <- lm(infantMortality ~ fertility + lifeExpF + I(ppgdp^-0.3), df_train)
summary(fit_1)
spreadLevelPlot(fit_1)
qqPlot(fit_1) 
shapiro.test(fit_1$resid) 
durbinWatsonTest(fit_1)
checkresiduals(fit_1)
crPlots(fit_1)
summary(powerTransform(fit_1))
fit_1 <- lm(infantMortality^0.5 ~ fertility + lifeExpF + I(ppgdp^-0.3), df_train)
infIndexPlot(fit_1)


# 두 번째 잠정 모형
fit_2 <- lm(infantMortality ~ group + fertility + lifeExpF + I(ppgdp^-0.3), df_train)
summary(fit_2)
spreadLevelPlot(fit_2)
qqPlot(fit_2)
checkresiduals(fit_2)
crPlots(fit_2)
summary(powerTransform(fit_2))
fit_2 <- lm(infantMortality^0.5 ~ group + fertility + lifeExpF + I(ppgdp^-0.3), df_train)
infIndexPlot(fit_2)


# 세 번째 잠정 모형
fit_3 <- lm(infantMortality ~ region + fertility + lifeExpF + pctUrban, df_train)
summary(fit_3)
spreadLevelPlot(fit_3)
qqPlot(fit_3)
checkresiduals(fit_3)
crPlots(fit_3)
infIndexPlot(fit_3)


# 네 번째 잠정 모형
fit_4 <- lm(infantMortality ~ group + ppgdp + pctUrban, df_train)
summary(fit_4)
spreadLevelPlot(fit_4)
qqPlot(fit_4)
checkresiduals(fit_4)
crPlots(fit_4)
summary(powerTransform(fit_4))
fit_4 <- lm(log(infantMortality) ~ group + ppgdp + pctUrban, df_train)
infIndexPlot(fit_4)


# 잠정 모형 비교 : RMSE
fit_1 <- lm(infantMortality^0.5 ~ fertility + lifeExpF + I(ppgdp^-0.3), df_train)
fit_2 <- lm(infantMortality^0.5 ~ group + fertility + lifeExpF + I(ppgdp^-0.3), df_train)
fit_3 <- lm(infantMortality ~ region + fertility + lifeExpF + pctUrban, df_train)
fit_4 <- lm(log(infantMortality) ~ group + ppgdp + pctUrban, df_train)
adjr2 <- data.frame(case=rep(c("model1", "model2", "model3", "model4")),
                    BeforeAfter=rep(c("before","after"),each=4),
                    adjr2=c("90.95%","91.05%","90.74%","66.96%","92.49%","92.67%","90.74%","77.15%"))
ggplot(adjr2,aes(x=case,y=adjr2,fill=BeforeAfter)) + geom_bar(stat="identity",position="dodge") + 
  labs(x="Model", y="adjr2")


# 잠정 모형 비교 : BIC
BIC(fit_1,fit_2,fit_3,fit_4)
BIC <- data.frame(case=c("model1", "model2", "model3", "model4"), BIC=c(396.4,400.5,1338.5,298.7))
ggplot(BIC,aes(x=case,y=BIC,fill=case)) + geom_bar(stat="identity") + 
  geom_text(aes(label=BIC), size=5, position=position_stack(vjust=0.5)) + 
  labs(x="Model", y="BIC")


# Test 예측
pred1 <- predict(fit_1,newdata=df_test)^2
pred2 <- predict(fit_2,newdata=df_test)^2
pred3 <- predict(fit_3,newdata=df_test)
pred4 <- exp(predict(fit_4,newdata=df_test))
pred <- cbind(real=df_test$infantMortality,pred1,pred2,pred3,pred4)
pred <- pred %>% as.tibble() %>% rownames_to_column(var="id")


# Test Accuracy 확인
forecast::accuracy(df_test$infantMortality,pred1)
forecast::accuracy(df_test$infantMortality,pred2)
forecast::accuracy(df_test$infantMortality,pred3)
forecast::accuracy(df_test$infantMortality,pred4)


# 예측 그래프
ggplot(data=pred) + geom_line(mapping=aes(x=as.numeric(id),y=pred1),size=2,col="red") + 
  geom_line(mapping=aes(x=as.numeric(id),y=pred2),size=2,col="yellow") + 
  geom_line(mapping=aes(x=as.numeric(id),y=pred3),size=2,col="orange") + 
  geom_line(mapping=aes(x=as.numeric(id),y=pred4),size=2,col="green") + 
  geom_line(mapping=aes(x=as.numeric(id),y=real),size=2,col="steelblue") + 
  labs(x="Test Data", y="Prediction") + ggtitle("Model1 vs Model2 vs Model3 vs Model4 vs Real") + 
  theme(plot.title = element_text(hjust = 0.5))


# Model1 vs real
ggplot(data=pred) + geom_line(mapping=aes(x=as.numeric(id),y=pred1),size=2,col="red") + 
  geom_line(mapping=aes(x=as.numeric(id),y=real),size=2,col="steelblue") + 
  labs(x="Test Data", y="Prediction") + ggtitle("Model1 vs Real") +
  theme(plot.title = element_text(hjust = 0.5))


# Model2 vs real
ggplot(data=pred) + geom_line(mapping=aes(x=as.numeric(id),y=pred2),size=2,col="orange") + 
  geom_line(mapping=aes(x=as.numeric(id),y=real),size=2,col="steelblue") + 
  labs(x="Test Data", y="Prediction") + ggtitle("Model2 vs Real") +
  theme(plot.title = element_text(hjust = 0.5))


# Model3 vs real
ggplot(data=pred) + geom_line(mapping=aes(x=as.numeric(id),y=pred3),size=2,col="darkgreen") + 
  geom_line(mapping=aes(x=as.numeric(id),y=real),size=2,col="steelblue") + 
  labs(x="Test Data", y="Prediction") + ggtitle("Model3 vs Real") +
  theme(plot.title = element_text(hjust = 0.5))


# Model4 vs real
ggplot(data=pred) + geom_line(mapping=aes(x=as.numeric(id),y=pred4),size=2,col="brown") + 
  geom_line(mapping=aes(x=as.numeric(id),y=real),size=2,col="steelblue") + 
  labs(x="Test Data", y="Prediction") + ggtitle("Model4 vs Real") +
  theme(plot.title = element_text(hjust = 0.5))


# 최종 결론
summary(fit_2)
anova(fit_2)