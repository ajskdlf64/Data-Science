# 데이터 불러오기
library(sas7bdat)
library(tidyverse)
set.seed(2014)
data <- read.sas7bdat("C:/Users/user/Desktop/학교/05. 범주형자료분석/발표/data.sas7bdat")


# 결측값 제거
data <- na.omit(data)


# 비율 확인
data %>% group_by(SIU_CUST_YN) %>% summarise(n=n())


# 데이터 샘플링
N_id <- sample(1:2172,size=800)
Y_id <- sample(1:278,size=200)
data1 <- filter(data,SIU_CUST_YN=="N")
data1 <- data1[N_id,]
data2 <- filter(data,SIU_CUST_YN=="Y")
data2 <- data2[Y_id,]
data <- rbind(data1,data2)


# 데이터 셔플
data <- data[sample(1:nrow(data),nrow(data)),]


# 변수 위치 조정
data <- dplyr::select(data, -CUST_ID, -CDSAS9, -RCBASE_HSHD_INCM, -JPBASE_HSHD_INCM)
data <- dplyr::select(data, HOSP_SPEC_DVSN:AGE,FP_CAREER:duration_max,SIU_CUST_YN)


# 데이터 변환
data <- mutate(data, CDSAS6=factor(CDSAS6),HOSP_SPEC_DVSN=factor(HOSP_SPEC_DVSN),CAUSECODE=factor(CAUSECODE))


# 데이터 분할
x_id <- sample(1:nrow(data),size=nrow(data)*0.2)
df_train <- data[-x_id,]
df_test <- data[x_id,]


# 비율 확인
df_train %>% group_by(SIU_CUST_YN) %>% summarise(n=n())
df_test %>% group_by(SIU_CUST_YN) %>% summarise(n=n())


# EDA
str(df_train)


# 진단서 상의 병원의 등급
table(df_train$HOSP_SPEC_DVSN)
df_train %>% ggplot(aes(x=HOSP_SPEC_DVSN,fill=SIU_CUST_YN)) + 
  geom_bar(show.legend=FALSE) + 
  labs(x="",y="",fill="")
df_train %>% ggplot(aes(x=HOSP_SPEC_DVSN,fill=SIU_CUST_YN)) + 
  geom_bar(show.legend=FALSE,position="fill") + 
  labs(x="",y="",fill="")
df_train %>% filter(HOSP_SPEC_DVSN==2) %>% group_by(SIU_CUST_YN) %>%summarise(n=n())



# 직업
table(df_train$ACCI_OCCP_GRP1)
df_train %>% ggplot(aes(x=ACCI_OCCP_GRP1,fill=SIU_CUST_YN)) + 
  geom_bar(show.legend=FALSE) + 
  labs(x="",y="",fill="")
df_train %>% ggplot(aes(x=ACCI_OCCP_GRP1,fill=SIU_CUST_YN)) + 
  geom_bar(show.legend=FALSE,position="fill") + 
  labs(x="",y="",fill="")
df_train %>% filter(ACCI_OCCP_GRP1==2) %>% group_by(SIU_CUST_YN) %>%summarise(n=n())


# 사고원인
table(df_train$CAUSECODE)
df_train %>% ggplot(aes(x=CAUSECODE,fill=SIU_CUST_YN)) + 
  geom_bar(show.legend=FALSE) + 
  labs(x="",y="",fill="")
df_train %>% ggplot(aes(x=CAUSECODE,fill=SIU_CUST_YN)) + 
  geom_bar(show.legend=FALSE,position="fill") + 
  labs(x="",y="",fill="")
df_train %>% filter(CAUSECODE==2) %>% group_by(SIU_CUST_YN) %>%summarise(n=n())


# 보험설계사 변경 횟수
df_train %>% ggplot(aes(x=SIU_CUST_YN,y=ccllt,fill=SIU_CUST_YN)) + 
  geom_boxplot(show.legend=FALSE) + 
  labs(x="",y="",fill="")
df_train %>% ggplot(aes(x=ccllt,fill=SIU_CUST_YN)) + 
  geom_density(bins=7,alpha=0.5,show.legend=FALSE) + 
  xlim(0,15) + 
  labs(x="",y="",fill="")


# 보험 가입 수
df_train %>% ggplot(aes(x=cpoly,y=ccllt,fill=SIU_CUST_YN)) + 
  geom_boxplot() + 
  labs(x="",y="",fill="")
df_train %>% ggplot(aes(x=cpoly,fill=SIU_CUST_YN)) + 
  geom_density(alpha=0.5,show.legend=FALSE) + 
  xlim(0,50) +
  labs(x="",y="",fill="")


# 나이
df_train %>% ggplot(aes(x=AGE,fill=SIU_CUST_YN)) + 
  geom_histogram(show.legend=FALSE) + 
  labs(x="",y="",fill="")


# 나이
df_train %>% ggplot(aes(x=AGE,fill=SIU_CUST_YN)) + 
  geom_histogram(bins=15) + 
  labs(x="",y="",fill="")


df_train %>% filter(SIU_CUST_YN=="Y") %>% summarise(mean=mean(AGE))
df_train %>% filter(SIU_CUST_YN=="N") %>% summarise(mean=mean(AGE))


# 보험설계사의 경력
table(df_train$FP_CAREER)
df_train %>% ggplot(aes(x=FP_CAREER,fill=SIU_CUST_YN)) + 
  geom_bar(position="fill",show.legend=FALSE) + 
  labs(x="",y="",fill="")


df_train %>% filter(FP_CAREER=="N") %>% group_by(SIU_CUST_YN) %>%summarise(n=n())
df_train %>% filter(FP_CAREER=="Y") %>% group_by(SIU_CUST_YN) %>%summarise(n=n())


# 보험료 총 납입액
df_train %>% ggplot(aes(x=TOTALPREM)) + 
  geom_density(alpha=0.5,show.legend=FALSE, fill="steelblue") + 
  xlim(0,100000000) + 
  labs(x="",y="",fill="")
df_train %>% ggplot(aes(x=log(TOTALPREM),fill=SIU_CUST_YN)) + 
  geom_density(alpha=0.5,show.legend=FALSE) + 
  labs(x="",y="",fill="")
  

# 결혼 유무
summary(df_train$WEDD_YN)
df_train %>% ggplot(aes(x=WEDD_YN,fill=SIU_CUST_YN)) + 
  geom_bar(show.legend=FALSE) + 
  labs(x="",y="",fill="")
df_train %>% ggplot(aes(x=WEDD_YN,fill=SIU_CUST_YN)) + 
  geom_bar(position="fill",show.legend=FALSE) + 
  labs(x="",y="",fill="")


df_train %>% filter(WEDD_YN=="Y") %>% group_by(SIU_CUST_YN) %>%summarise(n=n())
df_train %>% filter(WEDD_YN=="N") %>% group_by(SIU_CUST_YN) %>%summarise(n=n())


# 고객 추정 소득
summary(df_train$CUST_INCM)
df_train %>% ggplot(aes(x=CUST_INCM,fill=SIU_CUST_YN)) + 
  geom_density(alpha=0.5,show.legend=FALSE) + 
  labs(x="",y="",fill="")


df_train %>% group_by(SIU_CUST_YN) %>% filter(CUST_INCM==0) %>% summarise(n=n())
df_train %>% group_by(SIU_CUST_YN) %>% filter(CUST_INCM!=0) %>% summarise(n=n())


# 보험 해지 비율
summary(df_train$pb)
df_train %>% ggplot(aes(x=SIU_CUST_YN,y=pb,fill=SIU_CUST_YN)) + 
  geom_boxplot(show.legend=FALSE) + 
  labs(x="",y="",fill="")


# 입원 수
summary(df_train$SDMND_RESN_CODE)
df_train %>% ggplot(aes(x=SDMND_RESN_CODE,fill=SIU_CUST_YN)) + 
  geom_density(alpha=0.5,show.legend=FALSE) + 
  xlim(0,25) + 
  labs(x="",y="",fill="")


# 보험 청구 횟수
str(df_train$CDSAS6)
df_train %>% ggplot(aes(x=CDSAS6,fill=SIU_CUST_YN)) + 
  geom_bar(show.legend=FALSE) + 
  labs(x="",y="",fill="")
df_train %>% ggplot(aes(x=CDSAS6,fill=SIU_CUST_YN)) + 
  geom_bar(position="fill",show.legend=FALSE) + 
  labs(x="",y="",fill="")


df_train %>% filter(CDSAS6==0) %>% group_by(SIU_CUST_YN) %>%summarise(n=n())
df_train %>% filter(CDSAS6==1) %>% group_by(SIU_CUST_YN) %>%summarise(n=n())



# 계약 후 보험까지 걸리는 최소 기간
summary(df_train$duration_min)
df_train %>% ggplot(aes(x=duration_min,fill=SIU_CUST_YN)) + 
  geom_density(alpha=0.5,show.legend=FALSE) + 
  labs(x="",y="",fill="") + 
  xlim(0,7500)


# 계약 후 보험까지 걸리는 최대 기간
summary(df_train$duration_max)
df_train %>% ggplot(aes(x=duration_max,fill=SIU_CUST_YN)) + 
  geom_density(alpha=0.5,show.legend=FALSE) + 
  labs(x="",y="",fill="") + 
  xlim(0,7500)


# 로그 변환
df_train <- mutate(df_train, cpoly=log(cpoly), TOTALPREM=log(TOTALPREM))


# 로지스틱 적합
fit <- glm(SIU_CUST_YN ~ ., family=binomial, data=df_train)
summary(fit)
AIC(fit)
BIC(fit)


# stepAIC
library(MASS)
fit <- glm(SIU_CUST_YN ~ 1, family="binomial", df_train)
fit_full <- glm(SIU_CUST_YN ~ ., family="binomial", df_train)
stepAIC(fit, scope=formula(fit_full), k=2, direction="both", trace=FALSE)
stepAIC(fit, scope=formula(fit_full), k=log(nrow(df_train)),  direction="both", trace=FALSE)   


# 검정에 의한 전진선택법
fit <- glm(SIU_CUST_YN ~ 1, family="binomial", df_train)
fit_full <- glm(SIU_CUST_YN ~ ., family="binomial", df_train)
addterm(fit,fit_full,test="Chisq")
fit <- update(fit, . ~ . + SDMND_RESN_CODE)
addterm(fit,fit_full,test="Chisq")
fit <- update(fit, . ~ . + CAUSECODE)
addterm(fit,fit_full,test="Chisq")
fit <- update(fit, . ~ . + duration_max)
addterm(fit,fit_full,test="Chisq")
fit <- update(fit, . ~ . + pb)
addterm(fit,fit_full,test="Chisq")
fit <- update(fit, . ~ . + ccllt)
addterm(fit,fit_full,test="Chisq")


# 검정에 의한 후진소거법
fit_full <- glm(SIU_CUST_YN ~ ., family="binomial", df_train)
dropterm(fit_full,test="Chisq")
fit_full <- update(fit_full, . ~ . - AGE)
dropterm(fit_full,test="Chisq")
fit_full <- update(fit_full, . ~ . - cpoly)
dropterm(fit_full,test="Chisq")
fit_full <- update(fit_full, . ~ . - FP_CAREER)
dropterm(fit_full,test="Chisq")
fit_full <- update(fit_full, . ~ . - CDSAS6)
dropterm(fit_full,test="Chisq")
fit_full <- update(fit_full, . ~ . - TOTALPREM)
dropterm(fit_full,test="Chisq")
fit_full <- update(fit_full, . ~ . - duration_min)
dropterm(fit_full,test="Chisq")
fit_full <- update(fit_full, . ~ . - ACCI_OCCP_GRP1)
dropterm(fit_full,test="Chisq")
fit_full <- update(fit_full, . ~ . - CUST_INCM)
dropterm(fit_full,test="Chisq")
fit_full <- update(fit_full, . ~ . - pb)
dropterm(fit_full,test="Chisq")


# 잠정 모형 후보
fit.M1 <- glm(SIU_CUST_YN ~ SDMND_RESN_CODE + CAUSECODE + duration_max + pb + ccllt, family=binomial, data=df_train)
fit.M2 <- glm(SIU_CUST_YN ~ SDMND_RESN_CODE + CAUSECODE + duration_max + WEDD_YN + ccllt + HOSP_SPEC_DVSN, family=binomial, data=df_train)
fit.M3 <- glm(SIU_CUST_YN ~ HOSP_SPEC_DVSN + CAUSECODE + ccllt + WEDD_YN + SDMND_RESN_CODE + duration_max + TOTALPREM + pb, family=binomial, data=df_train)
fit.M4 <- glm(SIU_CUST_YN ~ HOSP_SPEC_DVSN + CAUSECODE + SDMND_RESN_CODE + duration_max, family=binomial, data=df_train)
AIC(fit.M1) ; AIC(fit.M2) ; AIC(fit.M3) ; AIC(fit.M4)
BIC(fit.M1) ; BIC(fit.M2) ; BIC(fit.M3) ; BIC(fit.M4)


# M4의 이상값 탐지
library(car)
influencePlot(fit.M4)


# 선형관계 확인
residualPlots(fit.M4)


# 이상값 확인
df_train %>% filter(duration_max==171 | CUST_INCM==4340)
summary(filter(df_train, SIU_CUST_YN=="Y"))
df_train %>% filter(SIU_CUST_YN=="Y") %>% 
  ggplot(aes(x=HOSP_SPEC_DVSN,fill=HOSP_SPEC_DVSN)) + 
  geom_bar(show.legend = F) +
  labs(x="",y="",fill="")


# 이상값 제거
df_train <- df_train %>% filter(duration_max!=171 & CUST_INCM!=4340)
fit.M4 <- glm(SIU_CUST_YN ~ HOSP_SPEC_DVSN + CAUSECODE + SDMND_RESN_CODE + duration_max, family=binomial, data=df_train)
influencePlot(fit.M4)


# stepAIC
library(MASS)
fit <- glm(SIU_CUST_YN ~ 1, family="binomial", df_train)
fit_full <- glm(SIU_CUST_YN ~ ., family="binomial", df_train)
stepAIC(fit, scope=formula(fit_full), k=2, direction="both", trace=FALSE)
stepAIC(fit, scope=formula(fit_full), k=log(nrow(df_train)),  direction="both", trace=FALSE)   


# 검정에 의한 전진선택법
fit <- glm(SIU_CUST_YN ~ 1, family="binomial", df_train)
fit_full <- glm(SIU_CUST_YN ~ ., family="binomial", df_train)
addterm(fit,fit_full,test="Chisq")
fit <- update(fit, . ~ . + SDMND_RESN_CODE)
addterm(fit,fit_full,test="Chisq")
fit <- update(fit, . ~ . + CAUSECODE)
addterm(fit,fit_full,test="Chisq")
fit <- update(fit, . ~ . + pb)
addterm(fit,fit_full,test="Chisq")
fit <- update(fit, . ~ . + duration_max)
addterm(fit,fit_full,test="Chisq")
fit <- update(fit, . ~ . + ccllt)
addterm(fit,fit_full,test="Chisq")


# 검정에 의한 후진소거법
fit_full <- glm(SIU_CUST_YN ~ ., family="binomial", df_train)
dropterm(fit_full,test="Chisq")
fit_full <- update(fit_full, . ~ . - AGE)
dropterm(fit_full,test="Chisq")
fit_full <- update(fit_full, . ~ . - cpoly)
dropterm(fit_full,test="Chisq")
fit_full <- update(fit_full, . ~ . - FP_CAREER)
dropterm(fit_full,test="Chisq")
fit_full <- update(fit_full, . ~ . - CDSAS6)
dropterm(fit_full,test="Chisq")
fit_full <- update(fit_full, . ~ . - TOTALPREM)
dropterm(fit_full,test="Chisq")
fit_full <- update(fit_full, . ~ . - duration_min)
dropterm(fit_full,test="Chisq")
fit_full <- update(fit_full, . ~ . - ACCI_OCCP_GRP1)
dropterm(fit_full,test="Chisq")
fit_full <- update(fit_full, . ~ . - CUST_INCM)
dropterm(fit_full,test="Chisq")
fit_full <- update(fit_full, . ~ . - pb)
dropterm(fit_full,test="Chisq")


# 잠정 모형 후보
fit.M5 <- glm(SIU_CUST_YN ~ SDMND_RESN_CODE + CAUSECODE + duration_max + pb + ccllt, family=binomial, data=df_train)
fit.M6 <- glm(SIU_CUST_YN ~ SDMND_RESN_CODE + CAUSECODE + duration_max + WEDD_YN + ccllt + HOSP_SPEC_DVSN, family=binomial, data=df_train)
fit.M7 <- glm(SIU_CUST_YN ~ HOSP_SPEC_DVSN + CAUSECODE + ccllt + WEDD_YN + SDMND_RESN_CODE + duration_max + CUST_INCM + pb, family=binomial, data=df_train)
fit.M8 <- glm(SIU_CUST_YN ~ HOSP_SPEC_DVSN + CAUSECODE + SDMND_RESN_CODE + duration_max, family=binomial, data=df_train)
AIC(fit.M5) ; AIC(fit.M6) ; AIC(fit.M7) ; AIC(fit.M8)
BIC(fit.M5) ; BIC(fit.M6) ; BIC(fit.M7) ; BIC(fit.M8)


# 이상값 제거의 효과
AIC(fit.M1) ; AIC(fit.M2) ; AIC(fit.M3) ; AIC(fit.M4)
AIC(fit.M5) ; AIC(fit.M6) ; AIC(fit.M7) ; AIC(fit.M8)
BIC(fit.M1) ; BIC(fit.M2) ; BIC(fit.M3) ; BIC(fit.M4)
BIC(fit.M5) ; BIC(fit.M6) ; BIC(fit.M7) ; BIC(fit.M8)


data.frame(Model=rep(c("A","B","C","D"),each=2), group=rep(c("before","after")),AIC=c(595.9,586.2,568.9,548.9,568.2,548.4,551.6,551.6),
           BIC=c(628.6,618.9,611.1,591.1,619.7,600,584.4,584.4)) %>% 
  mutate(group=relevel(group,ref="before")) %>% 
  ggplot(aes(x=Model,y=AIC,fill=group)) + geom_bar(position="dodge",stat="identity",show.legend = F) + ylim(0,700)


data.frame(Model=rep(c("A","B","C","D"),each=2), group=rep(c("before","after")),AIC=c(595.9,586.2,568.9,548.9,568.2,548.4,551.6,551.6),
           BIC=c(628.6,618.9,611.1,591.1,619.7,600,584.4,584.4)) %>%
  mutate(group=relevel(group,ref="before")) %>% 
  ggplot(aes(x=Model,y=BIC,fill=group)) + geom_bar(position="dodge",stat="identity",show.legend = F)


# 잠정 모형
fit.M8 <- glm(SIU_CUST_YN ~ HOSP_SPEC_DVSN + CAUSECODE + SDMND_RESN_CODE + duration_max, family=binomial, data=df_train)


# 모형 fit의 잔차 산점도 작성 및 curvature test 실시
# curvature test : 선형 관계 여부 확인, 제곱합에 대한 유의성 검정
library(car)
residualPlots(fit.M8)


# 잠정모형의 이상값 확인
influencePlot(fit.M8)


# 다중공선ㅅ
car::vif(fit.M8)


# 최종 모형
fit.M8 <- glm(SIU_CUST_YN ~ HOSP_SPEC_DVSN + CAUSECODE + SDMND_RESN_CODE + duration_max, family=binomial, data=df_train)


# 결정계수 확인
library(pscl)
round(pR2(fit.M8),3)


# Odds Ratio에 의한 효과 분석
coef(fit.M8)


# log(Odds)에 관한 모형 => Odds에 관한 모형으로 변환 
exp(coef(fit.M8))


# 예측 분할표
pred <- predict(fit.M8, newdata=df_test, type="response")
my_table <- mutate(df_test,SIU_CUST_YN_hat=if_else(pred>=0.95,"Y","N")) %>% with(.,table(SIU_CUST_YN,SIU_CUST_YN_hat))
addmargins(my_table)


# 정분류율(CCR)
sum(diag(my_table)) / sum(my_table) * 100  


# 수정된 정분류율(adj_CCR)
y_max <- max(addmargins(my_table,2))
(sum(diag(my_table)) - y_max) / sum(my_table) * 100



data.frame(D=seq(0.05,0.95,by=0.05),
           CCR=c(0.39,0.575,0.695,0.775,0.81,0.815,0.825,0.83,0.845,0.85,0.815,0.82,0.82,0.815,0.815,0.8,0.79,0.795,0.8)) %>%
  ggplot(aes(x=D,y=CCR)) + geom_line(size=2,col="steelblue") + 
  geom_point(size=3)



# ROC Curve
library(pROC)
library(carData)
roc(with(df_test,SIU_CUST_YN), pred, percent=TRUE, plot=TRUE)

