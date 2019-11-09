# 데이터 확인
library(car)
mroz <- Mroz
str(mroz)
summary(mroz)
head(mroz)

# 첫번째 모형
library(tidyverse)
model_1 <- mroz %>% dplyr::mutate(lwg_2 = I(lwg^2)) %>% dplyr::select(lfp, inc, wc, lwg, lwg_2, age, k5, k618)

# 단계별 선택법
library(MASS)
fit_full <- glm(lfp ~ ., family="binomial", data=Mroz)    # FULL Model
fit <- glm(lfp ~ 1, family="binomial", data=Mroz)         # MAIN Model
addterm(fit, fit_full, test="Chisq")                      # LRT 통계량이 가장 큰 값 K5
fit <- update(fit, . ~ . + k5)                            # MAIN Model 에 K5 변수 추가
dropterm(fit, test="Chisq")                               # MAIN Model 에서 K5에 대한 유의성 검정 실시
addterm(fit, fit_full, test="Chisq")                      # LRT 통계량이 가장 큰 값  age
fit <- update(fit, . ~ . + age)                           # MAIN Model 에 age 변수 추가
dropterm(fit, test="Chisq")                               # MAIN Model 에서 age에 대한 유의성 검정 실시
addterm(fit, fit_full, test="Chisq")                      # LRT 통계량이 가장 큰 값 lwg
fit <- update(fit, . ~ . + lwg)                           # MAIN Model 에 lwg 변수 추가
dropterm(fit, test="Chisq")                               # MAIN Model 에서 lwg에 대한 유의성 검정 실시
addterm(fit, fit_full, test="Chisq")                      # LRT 통계량이 가장 큰 값 inc
fit <- update(fit, . ~ . + inc)                           # MAIN Model 에 inc 변수 추가
dropterm(fit, test="Chisq")                               # MAIN Model 에서 inc에 대한 유의성 검정 실시
addterm(fit, fit_full, test="Chisq")                      # LRT 통계량이 가장 큰 값 wc
fit <- update(fit, . ~ . + wc)                            # MAIN Model 에 wc 변수 추가
dropterm(fit, test="Chisq")                               # MAIN Model 에서 wc에 대한 유의성 검정 실시
addterm(fit, fit_full, test="Chisq")                      # 단계별 선택법 종료

# 두번째 모형
model_2 <- mroz %>% dplyr::select(lfp, k5, age, lwg, inc, wc)

# rattle 실행
library(rattle)
rattle()

# 4개의 모델에 대한 정분류율
data.frame(model = c("model_1", "model_2", "model_1", "model_2"),
           data = c("Full","Full","Test","Test"),
           ccr = c(0.7436919, 0.690571, 0.7079646, 0.6946903)) %>% 
  ggplot(aes(x=model, y=ccr, fill=data)) + 
  geom_bar(stat="identity", position="dodge2") + 
  labs(title="정분류표") + 
  theme(legend.position = "none")