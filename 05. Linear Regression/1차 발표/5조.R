# 데이터 소개
library(tidyverse)
library(car)
str(SLID) ; head(SLID) ; summary(SLID)

# 결측값 제거
SLID_omit <- SLID %>% na.omit() %>% as.tibble()

# 시드 고정
set.seed(1234)

# 데이터 분할
x.id <- sample(1:nrow(SLID_omit), size=400)
df_1 <- SLID_omit[x.id,]
df_2 <- SLID_omit[-x.id,]

# 회귀모형 적합
fit <- lm(wages ~ ., data=df_2)
summary(fit)

# 반응변수의 그래프 확인
ggplot(df_2, aes(x=age,y=wages,col=age)) + geom_point()

# 질문 거리





