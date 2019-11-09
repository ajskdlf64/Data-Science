# 2017년에 국내에 개봉한 10만 이상의 관객을 기록한 152개의 영화 데이터
# 자료 출처 : 영화진흥위원회에서 추출한 데이터를 바탕으로 직접 작성


# 분석 목표 : 영화 개봉 전 영화의 관객수 예측


# Name : 유니크, 영화 공식 이름
# Distributor : 배급사. 4대 메이져 배급사에서 배급한 영화 Major, 그 외의 배급사 : Minor
# Month : 영화 개봉 월
# Country : 영화 제작 국가
# Genre : 영화 장르
# Runtime : 영화 런타임
# Garde : 관람 등급
# Screen_Type : 상영하는 스크린의 타입
# Story : 영화 이야기의 원작 존재 여부
# Series : 시리즈물의 여부
# Audience_Reviews : 시사회 관객 평점
# Critic_Reviews : 시사회 평론가 평점
# Preview : 시사회 관객 수
# Screen : 스크린수 
# Audience : 최종 관객 수


# 데이터 확인
library(tidyverse)
set.seed(1234)
movie <- read.csv("C:/Users/user/Desktop/학교/04. 통계자료분석실습/2차 발표/data/Movie.csv")
movie <- as.tibble(movie) %>% mutate(Name=as.character(Name),Month=as.factor(Month))
movie <- movie[sample(1:nrow(movie),nrow(movie)),]
sum(is.na(movie))
str(movie)


# 데이터 분리
x.id <- sample(1:nrow(movie), size=15)
df_test <- movie[x.id,]
df_train <- movie[-x.id,]


# Distributor
df_train %>% group_by(Distributor) %>% 
  summarise(n=n()) %>% 
  ggplot(aes(x=Distributor,y=n,fill=Distributor)) + 
  geom_bar(stat="identity") +
  geom_text(aes(label=n),size=10) + 
  labs(x="배급사",y="작품수")


df_train %>% ggplot(aes(x=Audience, fill=Distributor)) + 
  geom_histogram(bins=20, alpha=0.6)


# Month
df_train %>% group_by(Month) %>% 
  summarise(n=n()) %>% 
  ggplot(aes(x=Month,y=n,fill=Month)) + 
  geom_bar(stat="identity") +
  geom_text(aes(label=n),size=5) + 
  labs(x="개봉시기",y="작품수")


df_train %>% ggplot(aes(x=Month, y=Audience)) + 
  geom_boxplot() + 
  labs(x="개봉 시기", y="관객 수")


# Country
df_train %>% group_by(Country) %>% 
  summarise(n=n()) %>% 
  ggplot(aes(x=Country,y=n,fill=Country)) + 
  geom_bar(stat="identity") +
  geom_text(aes(label=n),size=5) + 
  labs(x="제작국가",y="작품수")


df_train %>% ggplot(aes(x=Audience, fill=Country)) + 
  geom_histogram(bins=20, alpha=0.6) + 
  labs(x="제작국가",y="작품수")


# Genre
df_train %>% group_by(Genre) %>% 
  summarise(n=n()) %>% 
  ggplot(aes(x=Genre,y=n,fill=Genre)) + 
  geom_bar(stat="identity") +
  geom_text(aes(label=n),size=5) + 
  labs(x="장르",y="작품수")


# Runtime
df_train %>% ggplot(aes(x=Runtime)) + 
  geom_histogram(bins=20,fill="steelblue") + 
  labs(x="상영시간",y="작품수")


df_train %>% ggplot(aes(x=Runtime, y=Audience)) + 
  geom_point(size=3) + 
  geom_smooth(aes(col="loess"),se=FALSE,size=2) + 
  geom_smooth(aes(col="lm"),se=FALSE,method="lm",size=2) + 
  geom_smooth(data=filter(df_train,Name!="블레이드 러너 2049"),aes(col="lm for Outlier"),se=FALSE,method="lm",size=2) + 
  geom_text(data=filter(df_train,Name=="블레이드 러너 2049"),aes(label=Name),size=5,col="steelblue",nudge_x=-5, nudge_y=-500000) + 
  labs(col="method")


# Garde
df_train %>% group_by(Grade) %>% 
  summarise(n=n()) %>% 
  ggplot(aes(x=Grade,y=n,fill=Grade)) + 
  geom_bar(stat="identity") +
  geom_text(aes(label=n),size=10) + 
  labs(x="상영등급",y="작품수")

df_train %>% ggplot(aes(x=Audience)) + 
  geom_density() + 
  facet_wrap(~Grade, ncol=1)


# Screen_Type
df_train %>% group_by(Screen_Type) %>% 
  summarise(n=n()) %>% 
  ggplot(aes(x=Screen_Type,y=n,fill=Screen_Type)) + 
  geom_bar(stat="identity") +
  geom_text(aes(label=n),size=10) + 
  labs(x="스크린 타입",y="작품수")


df_train %>% ggplot(aes(x=Screen, y=Audience, col=Screen_Type)) + 
  geom_point(size=5)


# Story
df_train %>% group_by(Story) %>% 
  summarise(n=n()) %>% 
  ggplot(aes(x=Story,y=n,fill=Story)) + 
  geom_bar(stat="identity") +
  geom_text(aes(label=n),size=10) + 
  labs(x="원작 혹은 사실의 존재 여부",y="작품수")


df_train %>% ggplot(aes(x=Audience, fill=Story)) + 
  geom_histogram(bins=20, alpha=0.6) + 
  labs(x="원작 혹은 사실의 존재 여부",y="작품수")


# Series
df_train %>% group_by(Series) %>% 
  summarise(n=n()) %>% 
  ggplot(aes(x=Series,y=n,fill=Series)) + 
  geom_bar(stat="identity") +
  geom_text(aes(label=n),size=10) + 
  labs(x="Series",y="작품수")


df_train %>% ggplot(aes(x=Audience, fill=Series)) + 
  geom_histogram(bins=20, alpha=0.6) + 
  labs(x="Series",y="작품수")


# Preview
df_train %>% ggplot(aes(x=Country,y=Preview,fill=Country)) + 
  geom_boxplot(outlier.shape=NA) + 
  ylim(0,20000)


# Audience_Reviews and Critic_Reviews
df_train %>% ggplot() + 
  geom_histogram(aes(x=Audience_Reviews,fill="관객"),bins=20,alpha=0.6) + 
  geom_histogram(aes(x=Critic_Reviews,fill="비평가"),bins=20,alpha=0.6) + 
  labs(x="평점",y="작품수",title="Audience_Reviews and Critic_Reviews")


df_train %>% summarise(Audience=mean(Audience_Reviews),Critic=mean(Critic_Reviews))


# Screen
df_train %>% ggplot(aes(x=Screen,y=Audience,col=Distributor)) + 
  geom_point(size=4)


# 회귀모형 적합
fit <- lm(Audience ~ . -Name, data=df_train)
summary(fit)
AIC(fit)
BIC(fit)
plot(fit, which=1)


# 반응변수 변환 확인
library(car)
summary(powerTransform(fit))


# 자연로그 변환
fit.1 <- lm(log(Audience) ~ . -Name, data=df_train)
summary(fit.1)
AIC(fit.1)
BIC(fit.1)
plot(fit.1,which=1)


# 상용로그 변환
fit.2 <- lm(log(Audience,base=10) ~ . -Name, data=df_train)
summary(fit.2)
AIC(fit.2)
BIC(fit.2)
plot(fit.2,which=1)
summary(powerTransform(fit.2))


# 이상값 확인
library(car)
influencePlot(fit.2)
df_train[22,]


df_train %>% ggplot(aes(x=Screen,y=Audience,col=Distributor)) + 
  geom_point(size=2) + 
  geom_text(data=filter(df_train,Screen>2000,Audience<10000000),aes(label=Name),col="black",size=7,nudge_x=-100,nudge_y=-500000)


# 모형 선택 기준에 따른 변수 선택
library(leaps)
fits <- regsubsets(log(Audience,base=10) ~ . -Name, df_train)
plot(fits, main="BIC")
plot(fits, scale="adjr2", main="adjr2")
plot(fits, scale="Cp", main="Cp")


# StepAIC
step(fit.2, direction="both", trace=FALSE)
step(fit.2, k=log(nrow(df_train)),trace=FALSE)


# 잠정 모형
fit.2.1 <- lm(log(Audience, base = 10) ~ Runtime + Grade + Screen_Type + Critic_Reviews + Screen, data=df_train)
summary(fit.2.1)
AIC(fit.2.1)
BIC(fit.2.1)
fit.2.2 <- lm(log(Audience, base = 10) ~ Critic_Reviews + Screen, data=df_train)
summary(fit.2.2)
AIC(fit.2.2)
BIC(fit.2.2)


# fit.2.1 가정 만족 확인
fit.2.1 <- lm(log(Audience, base = 10) ~ Runtime + Grade + Screen_Type + Critic_Reviews + Screen, data=df_train)
spreadLevelPlot(fit.2.1)
plot(fit.2.1, which=2)
forecast::checkresiduals(fit.2.1)
crPlots(fit.2.1)
residualPlots(fit.2.1)


# 제곱합을 추가하고 변수 선택
library(leaps)
fits <- regsubsets(log(Audience,base=10) ~ Distributor + Month + Country + Genre + Runtime +  I(Runtime^2) + 
                     Grade + Screen_Type + Story + Series + Audience_Reviews + Critic_Reviews + 
                     Trailer_views + Screen  + I(Screen^2), df_train)
plot(fits, main="BIC")
plot(fits, scale="adjr2", main="adjr2")
plot(fits, scale="Cp", main="Cp")


# 잠정 모형
fit.2.3 <- lm(log(Audience, base = 10) ~ Genre + Runtime + I(Runtime^2) + Grade + Screen_Type
              + Critic_Reviews + Screen + I(Screen^2), data=df_train)
summary(fit.2.3)
AIC(fit.2.3)
BIC(fit.2.3)
fit.2.4 <- lm(log(Audience, base = 10) ~Screen_Type + Critic_Reviews + Screen + I(Screen^2), data=df_train)
summary(fit.2.4)
AIC(fit.2.4)
BIC(fit.2.4)


# fit.2.3 가정 만족 확인
plot(fit.2.3, which=1)
plot(fit.2.3, which=2)
forecast::checkresiduals(fit.2.3)
crPlots(fit.2.3)
residualPlots(fit.2.3)


# fit.2.4 가정 만족 확인
plot(fit.2.4, which=1)
plot(fit.2.4, which=2)
forecast::checkresiduals(fit.2.4)
crPlots(fit.2.4)
residualPlots(fit.2.4)


# 예측
str(df_test)
pred <- data.frame(10^predict(fit.2.3, newdata=df_test, interval="confidence", level=0.95))
data.frame(id=1:15,pred=pred$fit, real=df_test$Audience, name=df_test$Name, error=df_test$Audience-pred$fit)
forecast::accuracy(df_test$Audience,pred$fit)


# 시각화
result <- data.frame(id=1:15,pred=pred$fit, real=df_test$Audience, name=df_test$Name, error=df_test$Audience-pred$fit)
ggplot(result) + geom_line(aes(x=id,y=pred,col="pred"),size=2) + 
  geom_line(aes(x=id,y=real,col="real"),size=2) + 
  labs(x="")
result %>% mutate(group=if_else(error>0,"plus","minus")) %>% 
  ggplot() + geom_bar(aes(x=id,y=error,fill=group),stat="identity",size=2) + 
  labs(x="")



# 결론
anova(fit.2.3)
16.2823 / (8.8439 + 4.0838 + 0.0842 + 3.0590 + 1.7228 +  0.9313 + 16.2823 + 0.5079 + 5.0087)
8.8439 / (8.8439 + 4.0838 + 0.0842 + 3.0590 + 1.7228 +  0.9313 + 16.2823 + 0.5079 + 5.0087)
4.0838 / (8.8439 + 4.0838 + 0.0842 + 3.0590 + 1.7228 +  0.9313 + 16.2823 + 0.5079 + 5.0087)
3.0590 / (8.8439 + 4.0838 + 0.0842 + 3.0590 + 1.7228 +  0.9313 + 16.2823 + 0.5079 + 5.0087)
1.72 / (8.8439 + 4.0838 + 0.0842 + 3.0590 + 1.7228 +  0.9313 + 16.2823 + 0.5079 + 5.0087)











