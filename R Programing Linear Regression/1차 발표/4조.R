# 데이터 소개
library(tidyverse)
library(car)
head(Leinhardt)
summary(Leinhardt)
str(Leinhardt)


# 데이터 셔플
Leinhardt <- Leinhardt[sample(1:nrow(Leinhardt),nrow(Leinhardt)),]



# 결측값 확인 및 제거
sum(is.na(Leinhardt))
Leinhardt <- na.omit(Leinhardt)


# 시드 고정
set.seed(1234)


# 데이터 분할
x <- sample(1:nrow(Leinhardt), size=10)
df_1 <- Leinhardt[x,]
df_2 <- Leinhardt[-x,]


# 회귀 모형 적합
fit <- lm(infant ~ log(income) + region + oil, data=df_2)
summary(fit)


# 잔차의 동일 분산과 독립성 확인
spreadLevelPlot(fit)
library(forecast)
checkresiduals(fit)

