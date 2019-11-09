# 데이터 소개
library(tidyverse)
library(car)
str(Duncan) ; head(Duncan) ; summary(Duncan)


# 반응변수 : prestige
# 설명변수 : type, income, education


# 결측값 없음 
sum(is.na(Duncan))


# 시드 고정
set.seed(2013)


# 데이터 분할
duncan <- sample(1:nrow(Duncan), size=4)
df_1 <- Duncan[duncan,]
df_2 <- Duncan[-duncan,]


# 41개의 traing data, 4개의 test data로 분리


# 이상값 확인하기
out <- df_2 %>% rownames_to_column(var="name")
ggplot(df_2,aes(x=income, y=prestige, col=type)) + geom_point() + 
  geom_text(data=filter(out,prestige>75&income<25),aes(label=name), nudge_x=5)


# 잠정모형
fit <- lm(prestige ~ type + income + education, data=df_2)
summary(fit)
fit <- lm(prestige ~ income + education, data=df_2)
summary(fit)
fit <- lm(prestige ~ type + income, data=df_2)
summary(fit)


# Test 데이터
df_1





