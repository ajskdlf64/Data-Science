# 데이터 불러오기
cust_data <- read.csv("../01. data/BGCON_CUST_DATA.csv", fileEncoding="UTF-16", stringsAsFactors=FALSE)
cntt_data <- read.csv("../01. data/BGCON_CNTT_DATA.csv", fileEncoding="UTF-16", stringsAsFactors=FALSE)
claim_data <- read.csv("../01. data/BGCON_CLAIM_DATA.csv", fileEncoding="UTF-16", stringsAsFactors=FALSE)
fmly_data <- read.csv("../01. data/BGCON_FMLY_DATA.csv", fileEncoding="UTF-16", stringsAsFactors=FALSE)
fpinfo_data <- read.csv("../01. data/BGCON_FPINFO_DATA.csv", fileEncoding="UTF-16", stringsAsFactors=FALSE)

# 데이터 고객 아이디, Train&Test 구분, Traget 변수 불러오기
data <- data.frame(CUST_ID = cust_data$CUST_ID, DIVIDED_SET = cust_data$DIVIDED_SET, SIU_CUST_YN = cust_data$SIU_CUST_YN)

# Train and Test 구분짓기
library(tidyverse)
data <- data %>% mutate(DIVIDED_SET = if_else(DIVIDED_SET == 1, "Train", "Test"))

# Target 변수 구분짓기
data <- data %>% mutate(SIU_CUST_YN = if_else(SIU_CUST_YN == "Y", "YES", if_else(SIU_CUST_YN == "N", "NO", "Test")))

# 콘테스트용 Test 데이터 제거하기
data <- data %>% filter(DIVIDED_SET == "Train") %>% select(-DIVIDED_SET)

# 데이터 80:20 으로 분리하기
set.seed(1234)
x.id <- sample(1:nrow(data), size=nrow(data)*0.2)
train_df <- data[-x.id,]
test_df <- data[x.id,]

# 범주화
train_df <- train_df %>% mutate(SIU_CUST_YN = as.factor(SIU_CUST_YN))
test_df <- test_df %>% mutate(SIU_CUST_YN = as.factor(SIU_CUST_YN))

######################################################################################################################################################

# CONTRACT_COUNT

# 고객별 계약 건수
temp <- cntt_data %>% group_by(CUST_ID) %>% summarise(CONTRACT_COUNT = n())

# 기존 데이터와 Merge
train_df <- merge(train_df, temp, by="CUST_ID", all=FALSE)
test_df <- merge(test_df, temp, by="CUST_ID", all=FALSE)

# 평균 계약 건수
train_df %>% group_by(SIU_CUST_YN) %>% summarise(COUNT = mean(CONTRACT_COUNT))

# 히스토그램
train_df %>% ggplot(aes(x=CONTRACT_COUNT)) + geom_histogram(bins=40, fill="steelblue")

# 기존 데이터와 merge
train_df <- train_df %>% select(-CONTRACT_COUNT)
test_df <- test_df %>% select(-CONTRACT_COUNT)
train_df <- merge(train_df, temp, by="CUST_ID", all=FALSE)
test_df <- merge(test_df, temp, by="CUST_ID", all=FALSE)

# 범주화
train_df <- train_df %>% mutate(CONTRACT_COUNT = cut(CONTRACT_COUNT, breaks = c(1,2,3,4,5,6,7,8,9,10,20,1000),
                                                   labels = c("01","02","03","04","05","06","07","08","09","10~19","20~"), right = FALSE))
test_df <- test_df %>% mutate(CONTRACT_COUNT = cut(CONTRACT_COUNT, breaks = c(1,2,3,4,5,6,7,8,9,10,20,1000),
                                                   labels = c("01","02","03","04","05","06","07","08","09","10~19","20~"), right = FALSE))

# 분할표
CONTRACT_COUNT_TABLE_TRAIN <- with(train_df, table(SIU_CUST_YN, CONTRACT_COUNT))
CONTRACT_COUNT_TABLE_TRAIN

# 카이제곱 검정
chisq.test(CONTRACT_COUNT_TABLE_TRAIN)

# 시각화
data.frame(CONTRACT = c("01","02","03","04","05","06","07","08","09","10~19","20~"),
            PERCENT = c(0.0794, 0.0807, 0.0903, 0.0875, 0.0937, 0.0889, 0.0922, 0.0976, 0.0894, 0.0993, 0.1292)) %>%
            ggplot(aes(x=CONTRACT, y=PERCENT, fill=CONTRACT)) + 
            geom_bar(stat="identity", show.legend = FALSE) + 
            geom_text(aes(label = paste0(PERCENT*100,"%")), size=5) + 
            scale_fill_brewer(palette = "Spectral") + 
            labs(x="계약 건수", y="보험 사기자 비율")

train_df %>% group_by(CONTRACT_COUNT) %>% summarise(n=n())

######################################################################################################################################################

# CLAIM_COUNT

# 고객별 보험 청구 건수
temp <- claim_data %>% group_by(CUST_ID) %>% summarise(CLAIM_COUNT = n())

# 기존 데이터와 Merge
train_df <- merge(train_df, temp, by="CUST_ID", all=FALSE)
test_df <- merge(test_df, temp, by="CUST_ID", all=FALSE)

# 평균 청구 건수
train_df %>% group_by(SIU_CUST_YN) %>% summarise(COUNT = mean(CLAIM_COUNT))

# 총 청구 건수
train_df %>% group_by(SIU_CUST_YN) %>% summarise(SUM=sum(CLAIM_COUNT))

# 박스플랏
train_df %>% ggplot(aes(x=SIU_CUST_YN, y=CLAIM_COUNT, fill=SIU_CUST_YN)) + 
             geom_boxplot(show.legend = FALSE) + 
             scale_fill_brewer(palette = "Spectral") + 
             labs(x="계약 건수", y="보험 사기자 비율")

# 보험 청구 건수 정규화
summary(train_df$CLAIM_COUNT)
train_df <- train_df %>% mutate(CLAIM_COUNT = ((CLAIM_COUNT - 1)/92))
summary(train_df$CLAIM_COUNT)

# 박스플랏
train_df %>% ggplot(aes(x=SIU_CUST_YN, y=CLAIM_COUNT, fill=SIU_CUST_YN)) + 
             geom_boxplot(show.legend = FALSE) + 
             scale_fill_brewer(palette = "Spectral") + 
             labs(x="보험 사기자 여부", y="보험 청구 건수")

# 보험 사기에 따른 평균 청구 건수
train_df %>% group_by(SIU_CUST_YN) %>% summarise(COUNT = mean(CLAIM_COUNT))

######################################################################################################################################################

# DANGER_FP

# 담당 FP별 보험 사기자 비율

# 보험 사기자 고객 아이디 추출해서 벡터로 변환
temp <- train_df %>% filter(SIU_CUST_YN== "YES") %>% select(CUST_ID) %>% mutate(CUST_ID = as.numeric(CUST_ID))
temp <- as.vector(temp[,1])

# 계약건별로 보험 사기자의 계약인 경우 SIU 변수에 1 을 지정, 일반 고객일 경우 0
temp1 <- cntt_data %>% mutate(SIU = if_else(CUST_ID %in% temp, 1, 0)) %>% select(POLY_NO, CLLT_FP_PRNO, SIU)

# FP별로 담당한 사기자의 수를 카운트
temp2 <- temp1 %>% group_by(CLLT_FP_PRNO) %>% summarise(SIU_COUNT = sum(SIU), N=n())

# FP별 담당고객 대비 사기자의 비율 계산
temp3 <- temp2 %>% mutate(DANGER_FP = SIU_COUNT / N)

# 계약건 별 FP의 위험도 표시
temp4 <- merge(cntt_data %>% group_by(CLLT_FP_PRNO), temp3, by="CLLT_FP_PRNO", all=FALSE) %>% select(POLY_NO, CUST_ID, SIU_COUNT, N, DANGER_FP)

# 고객별 FP 위험도의 평균값 계산
temp5 <- temp4 %>% group_by(CUST_ID) %>% summarise(DANGER_FP = mean(DANGER_FP))

# 기존 데이터와 Merge
train_df <- merge(train_df, temp5, by="CUST_ID", all=FALSE)
test_df <- merge(test_df, temp5, by="CUST_ID", all=FALSE)

# 보험 사기자 여부에 따른 평균 FP 위험도
train_df %>% group_by(SIU_CUST_YN) %>% 
             summarise(DANGER_FP_MEAN = mean(DANGER_FP))

# 히스토그램
train_df %>% filter(SIU_CUST_YN == "YES") %>% ggplot(aes(x=DANGER_FP)) + geom_histogram(show.legend = FALSE, fill="blue3")
train_df %>% filter(SIU_CUST_YN == "NO") %>% ggplot(aes(x=DANGER_FP)) + geom_histogram(show.legend = FALSE, fill="green3")

# 전체 FP 수
t <- cntt_data %>% group_by(CLLT_FP_PRNO) %>% summarise(n=n())
nrow(t)

# 사기에 관련된 담당자 수
t <- temp3 %>% filter(DANGER_FP != 0)
nrow(t)

# 파이차트
data.frame(GROUP = c("사기", "일반"), VALUE = c(2707, 31523-2707)) %>% 
  ggplot(aes(x="", y=VALUE,fill=GROUP)) +
  geom_bar(stat="identity",width=1, show.legend = FALSE) +
  labs(x="",y="") + coord_polar (theta="y") + 
  scale_fill_brewer(palette = "Spectral")

######################################################################################################################################################

# DANGER_HOSP

# 담당 병원별 보험 사기자 비율

# 보험 사기자 고객 아이디 추출해서 벡터로 변환
temp <- train_df %>% filter(SIU_CUST_YN== "YES") %>% select(CUST_ID) %>% mutate(CUST_ID = as.numeric(CUST_ID))
temp <- as.vector(temp[,1])

# 청구병원별로 보험 사기자의 청구인 경우 SIU 변수에 1 을 지정, 일반 고객일 경우 0
temp1 <- claim_data %>% mutate(SIU = if_else(CUST_ID %in% temp, 1, 0)) %>% select(HOSP_CODE, SIU)

# 병원별로 담당한 사기자의 수를 카운트
temp2 <- temp1 %>% group_by(HOSP_CODE) %>% summarise(SIU_COUNT = sum(SIU), N=n())

# 병원별 청구 건수 대비 사기자의 비율 계산
temp3 <- temp2 %>% mutate(DANGER_HOSP = SIU_COUNT / N)

# 청구건 별 병원의 위험도 표시
temp4 <- merge(claim_data %>% group_by(HOSP_CODE), temp3, by="HOSP_CODE", all=FALSE)

# 고객별 병원 위험도의 최댓값 계산
temp5 <- temp4 %>% group_by(CUST_ID) %>% summarise(DANGER_HOSP = max(DANGER_HOSP))

# 기존 데이터와 Merge
train_df <- merge(train_df, temp5, by="CUST_ID", all=FALSE)
test_df <- merge(test_df, temp5, by="CUST_ID", all=FALSE)

# 보험 사기자 여부에 따른 평균 병원 위험도
train_df %>% group_by(SIU_CUST_YN) %>%  summarise(DANGER_HOSP_MEAN = mean(DANGER_HOSP))
train_df %>% filter(SIU_CUST_YN == "YES", DANGER_HOSP == 1) %>% summarise(n=n())
train_df %>% filter(SIU_CUST_YN == "NO", DANGER_HOSP == 0) %>% summarise(n=n())

# 히스토그램
train_df %>% filter(SIU_CUST_YN == "YES") %>% ggplot(aes(x=DANGER_HOSP)) + geom_histogram(show.legend = FALSE, fill="blue3")
train_df %>% filter(SIU_CUST_YN == "NO") %>% ggplot(aes(x=DANGER_HOSP)) + geom_histogram(show.legend = FALSE, fill="green3")

# 전체 FP 수
t <- claim_data %>% group_by(HOSP_CODE) %>% summarise(n=n())
nrow(t)

# 사기에 관련된 담당자 수
t <- temp3 %>% filter(DANGER_HOSP != 0)
nrow(t)

# 파이차트
data.frame(GROUP = c("사기", "일반"), VALUE = c(3307, 12538 - 3307)) %>% 
  ggplot(aes(x="", y=VALUE,fill=GROUP)) +
  geom_bar(stat="identity",width=1, show.legend = FALSE) +
  labs(x="",y="") + coord_polar (theta="y") + 
  scale_fill_brewer(palette = "Spectral")

######################################################################################################################################################

# DANGER_DOCTOR

# 담당 의사별 보험 사기자 비율

# 보험 사기자 고객 아이디 추출해서 벡터로 변환
temp <- train_df %>% filter(SIU_CUST_YN== "YES") %>% select(CUST_ID) %>% mutate(CUST_ID = as.numeric(CUST_ID))
temp <- as.vector(temp[,1])

# 담당의사별로 보험 사기자의 청구인 경우 SIU 변수에 1 을 지정, 일반 고객일 경우 0
temp1 <- claim_data %>% mutate(SIU = if_else(CUST_ID %in% temp, 1, 0)) %>% select(POLY_NO, CHME_LICE_NO, SIU)

# 담당의사별로 담당한 사기자의 수를 카운트
temp2 <- temp1 %>% group_by(CHME_LICE_NO) %>% summarise(SIU_COUNT = sum(SIU), N=n())

# 담당의사별 청구 건수 대비 사기자의 비율 계산
temp3 <- temp2 %>% mutate(DANGER_DOCTOR = SIU_COUNT / N)

# 청구건 별 의사의 위험도 표시
temp4 <- merge(claim_data %>% group_by(CHME_LICE_NO), temp3, by="CHME_LICE_NO", all=FALSE) %>% select(CHME_LICE_NO, CUST_ID, POLY_NO, DANGER_DOCTOR)

# 고객별 의사 위험도의 평균값  계산
temp5 <- temp4 %>% group_by(CUST_ID) %>% summarise(DANGER_DOCTOR = mean(DANGER_DOCTOR))

# 기존 데이터와 Merge
train_df <- merge(train_df, temp5, by="CUST_ID", all=FALSE)
test_df <- merge(test_df, temp5, by="CUST_ID", all=FALSE)

# 데이터 확인
train_df %>% group_by(SIU_CUST_YN) %>% summarise(DOCTOR = mean(DANGER_DOCTOR))
train_df %>% filter(SIU_CUST_YN == "YES", DANGER_DOCTOR == 1) %>% summarise(n=n())
train_df %>% filter(SIU_CUST_YN == "NO", DANGER_DOCTOR == 0) %>% summarise(n=n())

# 히스토그램
train_df %>% filter(SIU_CUST_YN == "YES") %>% ggplot(aes(x=DANGER_DOCTOR)) + geom_histogram(show.legend = FALSE, fill="blue3")
train_df %>% filter(SIU_CUST_YN == "NO") %>% ggplot(aes(x=DANGER_DOCTOR)) + geom_histogram(show.legend = FALSE, fill="green3")

# 전체 의사 수
t <- claim_data %>% group_by(CHME_LICE_NO) %>% summarise(n=n())
nrow(t)

# 사기에 관련된 의사 수
t <- temp3 %>% filter(DANGER_DOCTOR != 0)
nrow(t)

# 파이차트
data.frame(GROUP = c("사기", "일반"), VALUE = c(5306, 25702-5306)) %>% 
  ggplot(aes(x="", y=VALUE,fill=GROUP)) +
  geom_bar(stat="identity",width=1, show.legend = FALSE) +
  labs(x="",y="") + coord_polar (theta="y") + 
  scale_fill_brewer(palette = "Spectral")

######################################################################################################################################################

# 3D PLOT
library(plotly)
plot_ly(x = train_df$DANGER_FP, 
        y = train_df$DANGER_HOSP,
        z = train_df$DANGER_DOCTOR, 
        type = "scatter3d", mode = "markers", size = 2, color = train_df$SIU_CUST_YN)
# Cor
temp <- train_df %>% select(DANGER_FP, DANGER_HOSP, DANGER_DOCTOR)
cor(temp)

######################################################################################################################################################

# CAUSE_CODE

# 보험 청구 사유 코드

# 보험 사기자 고객 아이디 추출해서 벡터로 변환
temp <- train_df %>% filter(SIU_CUST_YN== "YES") %>% select(CUST_ID) %>% mutate(CUST_ID = as.numeric(CUST_ID))
temp <- as.vector(temp[,1])

# 각 청구건에 대하여 보험 사기자의 청구인 경우 SIU 변수에 1 을 지정, 일반 고객일 경우 0
temp1 <- claim_data %>% mutate(SIU = if_else(CUST_ID %in% temp, 1, 0)) %>% select(DMND_RESN_CODE, CUST_ID, SIU)

# 지급 청구 코드별로 보험 사기자의 청구 건수 카운트
temp2 <- temp1 %>% group_by(DMND_RESN_CODE) %>% summarise(SIU_COUNT = sum(SIU), N=n())

# 모든 청구 건에 각각의 가중치 부여
temp3 <- claim_data %>% select(POLY_NO,CUST_ID, DMND_RESN_CODE) %>% mutate(CAUSE_CODE = if_else(DMND_RESN_CODE == 1, 0.0015,
                                                                                        if_else(DMND_RESN_CODE == 2, 0.7790,
                                                                                        if_else(DMND_RESN_CODE == 3, 0.0678,
                                                                                        if_else(DMND_RESN_CODE == 4, 0.0111,
                                                                                        if_else(DMND_RESN_CODE == 5, 0.1015,
                                                                                        if_else(DMND_RESN_CODE == 6, 0.0389,
                                                                                        if_else(DMND_RESN_CODE == 7, 0.0002, 0.000))))))))

# 각 고객별 청구 코드 가중치의 평균을 계산
temp4 <- temp3 %>% group_by(CUST_ID) %>% summarise(CAUSE_CODE = mean(CAUSE_CODE))

# 기존 데이터와 Merge
train_df <- merge(train_df, temp4, by="CUST_ID", all=FALSE)
test_df <- merge(test_df, temp4, by="CUST_ID", all=FALSE)

# 평균 계산
train_df %>% group_by(SIU_CUST_YN) %>% summarise(MEAN = mean(CAUSE_CODE))

# Boxplot
train_df %>% ggplot(aes(x=SIU_CUST_YN, y=CAUSE_CODE, fill=SIU_CUST_YN)) + 
             geom_boxplot(show.legend = FALSE) + 
             scale_fill_brewer(palette = "Spectral")

######################################################################################################################################################

# CNTT_ROLE

# 계약 당시 고객 역할

# 보험 사기자 고객 아이디 추출해서 벡터로 변환
temp <- train_df %>% filter(SIU_CUST_YN== "YES") %>% select(CUST_ID) %>% mutate(CUST_ID = as.numeric(CUST_ID))
temp <- as.vector(temp[,1])

# 각 계약건에 대하여 보험 사기자의 청구인 경우 SIU 변수에 1 을 지정, 일반 고객일 경우 0
temp1 <- cntt_data %>% mutate(SIU = if_else(CUST_ID %in% temp, 1, 0)) %>% select(CUST_ID, CUST_ROLE, SIU)

# 역할 코드별로 보험 사기자의 계약 건수 카운트
temp2 <- temp1 %>% group_by(CUST_ROLE) %>% summarise(SIU_COUNT = sum(SIU), N=n(), WEGIHT = (SIU_COUNT / 8368))

# 모든 청구 건에 각각의 가중치 부여
temp3 <- cntt_data %>% select(POLY_NO, CUST_ID, CUST_ROLE) %>% mutate(CNTT_ROLE = if_else(CUST_ROLE == 0, 0.2540,
                                                                                  if_else(CUST_ROLE == 1, 0.4540,
                                                                                  if_else(CUST_ROLE == 2, 0.2040,
                                                                                  if_else(CUST_ROLE == 3, 0.0072,
                                                                                  if_else(CUST_ROLE == 4, 0.0083,
                                                                                  if_else(CUST_ROLE == 5, 0.0060, 0.0131)))))))

# 각 고객별 청구 코드 가중치의 평균을 계산
temp4 <- temp3 %>% group_by(CUST_ID) %>% summarise(CNTT_ROLE = mean(CNTT_ROLE))

# 기존 데이터와 Merge
train_df <- merge(train_df, temp4, by="CUST_ID", all=FALSE)
test_df <- merge(test_df, temp4, by="CUST_ID", all=FALSE)

# 평균 계산
train_df %>% group_by(SIU_CUST_YN) %>% summarise(MEAN = mean(CNTT_ROLE))

# Boxplot
train_df %>% ggplot(aes(x=SIU_CUST_YN, y=CNTT_ROLE, fill=SIU_CUST_YN)) + 
             geom_boxplot(show.legend = FALSE) + 
             scale_fill_brewer(palette = "Spectral")

######################################################################################################################################################

# Modeling
DATA <- rbind(train_df, test_df)

# Decsion Tree
library(rpart)
rpartmod<-rpart(SIU_CUST_YN ~. , data=DATA, method="class")
library(rpart.plot)
library(RColorBrewer)
fancyRpartPlot(rpartmod)

# Rattle
library(rattle)
rattle()
