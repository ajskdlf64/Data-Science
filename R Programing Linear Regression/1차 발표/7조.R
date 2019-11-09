# 데이터 소개
library(tidyverse)
library(car)
str(Freedman) ; head(Freedman) ; summary(Freedman)


# 반응변수 : crime
# 설명변수 : population, nonwhite, density


# 결측값 제거
Freedman <- na.omit(Freedman)


# 시드 고정
set.seed(1234)


# 데이터 분할
x.id <- sample(1:nrow(Freedman), size=10)
df_1 <- Freedman[x.id,]
df_2 <- Freedman[-x.id,]


# 산점도
GGally::ggpairs(df_2)


# 회귀 모형 적합
fit <- lm(crime ~ ., data=df_2)
summary(fit)


# 등분산성 확인
plot(fit, which=1)


# 반응 변수의 변환 여부 확인 -> 변환할 필요 없어 보임
summary(powerTransform(fit))


# 설명 변수의 변환 여부 확인
boxTidwell(crime~., data=df_2)


# 모든 설명 변수에 대해 로그 변환
fit.2 <- lm(crime ~ log(population) + log(nonwhite) + log(density), data=df_2)
summary(fit.2)


# population의 이상값 제거
ggplot(df_2, aes(x=population,y=crime)) + geom_point()
df_2 <- filter(df_2, population<3000)
# nonwhite의 이상값 제거
ggplot(df_2, aes(x=nonwhite,y=crime)) + geom_point()
df_2 <- filter(df_2, nonwhite<40)
# density의 이상값 제거
ggplot(df_2, aes(x=density,y=crime)) + geom_point()
df_2 <- filter(df_2, density<2500)

GGally::ggpairs(df_2)
fit.3 <- lm(crime ~ ., df_2)
summary(fit.3)







