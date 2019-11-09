# 데이터 소개
library(tidyverse)
library(car)
str(Highway1) ; head(Highway1) ; summary(Highway1)


# 범주형 변수 변환
Highway11 <- Highway1 %>% mutate(lwid=cut(lwid, breaks=c(0,11,12,13), labels=c("small","middle","large")), lwid=relevel(lwid,ref="middle"))


# 시드 고정 및 데이터 셔플
set.seed(1234)
Highway1_R <- Highway1[sample(1:nrow(Highway11),nrow(Highway11)),]


# 데이터 분할
x.id <- sample(1:nrow(Highway1_R), size=5)
Highway.test <- Highway1_R[x.id,]
Highway.train <- Highway1_R[-x.id,]


# 반응변수의 산점도
GGally::ggpairs(Highway.train, columns=c("rate"))


# 회귀 모델 적합
fit <- lm(rate ~ ., data=Highway.train)
summary(fit)


# 변수 변환할 필요 없음
fit <- lm(rate ~ ., data=Highway.train)
plot(fit, which=1)
fit.log <- lm(log(rate) ~ ., data=Highway.train)
plot(fit.log, which=1)





