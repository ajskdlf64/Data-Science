library(tidyverse)

# 범주형 데이터 정리


# 일변량 범주형 자료의 도수분포표 작성
# 이변량 범주형 자료의 2차원 분할표 작성
# 일변량 범주형 자료를 위한 그래프
# 이변량 범주형 자료를 위한 그래프


# 양적자료 : 연속형자료, 키, 몸무게, 소득, 강수량, 자녀의 수
# 질적자료 : 범주형자료, 명목형(성별구분,지역구분), 순서형(강의평가,등급)


# 이항자료 : Binary Data, 두 개의 범주를 갖고 있는 범주형 자료


# 예제데이터 : 패키지 vcd의 데이터프레임 Arthritis
# install.packages("vcd")
library(vcd)
Arthritis


# 데이터에 대한 설명
str(Arthritis)


# 맨 앞의 5개의 데이터만 출력
head(Arthritis, n=5)


# 범주형 변수 : Treatment (placebo,Treated), sex(Male, Female)
#               Improved (None, Some, Marked)
# 연속형 변수 : age


# 설명변수 :Treatment, Sex, Age
# 반응변수 : Improved


# 범주형 변수 사이의 연관성 탐색
# 분석의 첫 단계 : 분할표 형태로의 정리


# 분할표 작성에 필요한 함수들...
# table(var1,var2,var3,.....) : N개의 범주형 변수로 N차원 분할표 작성
# prop.table(table) : 상대도수 분할표(두 변수의 결합 분포) 작성
# prop.table(table.margins) : margins로 정의된 방향으로 조건분포 작성


# Improved에 대한 분할표 작성
with(Arthritis, table(Improved))


# 소숫점 자리수 조정
options("digits")
options("digits"=7)


# Improved의 상대도수 분포표
my_table1 <- with(Arthritis, table(Improved))
prop.table(my_table1)


# Treatment의 상대도수 분포표
my_table1_1 <- with(Arthritis, table(Treatment))
prop.table(my_table1_1)


# Sex의 상대도수 분포표
my_table1_2 <- with(Arthritis, table(Sex))
prop.table(my_table1_2)


# Treatment와 Improved의 2차원 상대도수 분할표
my_table2 <- with(Arthritis, table(Treatment,Improved))
my_table2
prop.table(my_table2)


# 2차원 조건분포 분할표 작성
# prop.table(table, margin)
# table : 함수 table()로 작성된 분할표
# margin : 조건변수 지정 | margin=1 : 행변수가 조건변수, margin=2 : 열 변수가 조건변수


# 행을 기준으로 다 더하면 1
prop.table(my_table2, margin=1)


# 열을 기준으로 다 더하면 1
prop.table(my_table2, margin=2)


# 범주형 데이터를 위한 그래프
# 분할표 : 자료의 특성을 정확하게 판단하기 어려움
# 자료의 특성 파악을 위해 적절한 그래프 이용이 필수
# 범주형 데이터에 적합한 그래프 : 막대그래프 / 파이그래프 / Mosaic plot(이변량 이상의 경우 적합)


# 막대그래프 작성을 위한 함수
# graphics 패키지 : plot() : 요인을 자료로 입력 
#                   barplot() : 도수분포표를 자료 입력 
# ggplot2 패키지 : geom_bar() : 요인,도수분포표 모두 사용 가능


# 파이그래프 작성을 위한 함수
# graphics 패키지 : pie() : 도수분포표 자료로 입력 
# ggplot2 패키지 : geom_bar() and coord_polar() : 굳이 중요한 그래프는 아님.


# Mosaic plot 작성을 위한 함수
# vcd 패키지에 있는 함수를 사용.


# 예제 데이터 : state.region 미국 50개 주를 4개 지역 범주로 구분한 요인
head(state.region, n=5)


# 데이터 확인
str(state.region)


# 막대그래프 그리기
plot(state.region)


# x축의 이름 쓰기
plot(state.region, xlab="region")


# 색깔 넣어주기
plot(state.region, col="blue")
plot(state.region, xlab="region", col="steelblue")


# ggplot2로 막대그래프 그리기 (데이터프레임만 가능)
# 데이터프레임 지정
# 시각적 요소 변수 mapping
# aes : 시각적 요소 = 변수 이름
# 시각적 요소 : x축 변수 / y축 변수 / 점의 색, 크기, 모양 등등
# geom_bar() 의 기본 디폴트는 카운트
library(ggplot2)
ggplot(data.frame(state.region), aes(x=state.region)) + geom_bar()


# 90도 돌리고 싶다면...? : coord_flip()
ggplot(data.frame(state.region), aes(x=state.region)) + coord_flip() + geom_bar()


# base_graphics : 도수분포표가 자료로 주어진 경우 -> barplot으로 작성.
counts <- table(state.region)
barplot(counts, col="steelblue")


# ggplot2 : 도수분포표가 자료로 주어진 경우 -> 데이터프레임으로 전환 후 작성.
# geom_bar()의 디폴트 stat은 "count" 이다.
# stat = "indentity" : 데이터를 있는 그대로 그려라.
df_1 <- as.data.frame(counts)
ggplot(df_1, aes(x=state.region, y=Freq)) + geom_bar(stat="identity", fill="skyblue")


# 파이 그래프
# 면적으로 빈도수 구분
# 차이 구분의 정확성 : 길이 vs 면적
# 좋은 그래프는 아니다.
pie(counts)


# 각 파이 조각에 라벨 추가
pct <- prop.table(counts)*100
region <- paste0(names(pct), "(",pct,"%)")
region
pie(counts, labels=region)


# paste : 두 문자열을 이어라.
x1 <- paste("stat", 1:20)
head(x1, n=10)
# paste0 : 공백 없이 두 문자를 이어라.
x2 <- paste0("stat", 1:20)
head(x2, n=10)


# Fan Plot : pie 그래프보다 가독성이 높음.
library(plotrix)
fan.plot(counts, labels=region)













# 이변량 범주형 자료를 위한 그래프
# 막대그래프 : 쌓아올리거나 / 옆으로 나란히
# Mosaic 그래프


library(vcd)
my_table <- with(Arthritis, table(Treatment,Improved))
my_table


# 쌓아 올린 막대 그래프
# 설명변수 위주로 쌓아 올리는 것이 더 효과적
barplot(my_table)


# 함수 t() : 전치행렬 (행과 열을 바꿔준다.)
barplot(t(my_table))


# 각 조각의 면적은 두 변수의 결홥확률에 근거에서 쌓아진다.
prop.table(my_table)


# 쌓아 올려진 조각들의 범례가 필요하다. : legend.text=TRUE
barplot(t(my_table), legend.text=TRUE)


# 겹쳐져있는 legend를 안 겹치게 하고 싶으면... y축을 늘려보자.
barplot(t(my_table), legend.text=TRUE, ylim=c(0,60))


# ggplot2로 작성
# 도형에 색을 채울 때 : fill
# 변수 Improved의 범주별 조각이 쌓아 올려짐.
library(ggplot2)
ggplot(Arthritis, aes(x=Treatment, fill=Improved)) + 
  geom_bar()


# 분할표 사용
ggplot(as.data.frame(my_table), aes(x=Treatment, y=Freq, fill=Improved)) + 
  geom_bar(stat="identity")


# 옆으로 붙여 놓은 막대 그래프 : beside=TRUE
barplot(t(my_table), beside=TRUE, legend.text=TRUE, ylim=c(0,35))


# ggplot2로 그리기.
# geom_bar()의 position 디폴트는 : stacked
# dodge : 붙음 / dodge2 : 조금 떨어짐.
pp <- ggplot(Arthritis, aes(x=Treatment, fill=Improved))
pp + geom_bar(position="dodge")
pp + geom_bar(position="dodge2")


# position = "fill" 지정 : 
# prop.table(my_table,1)의 결과값을 가지고 그림. -> 행에 대한 조건부 확률을 가지고 그린 것.
pp + geom_bar(position="fill")
prop.table(my_table,1)


# Moasic plot
# 두 개 이상의 범주형 변수 관계 탐색에 유용한 그래프
# vcd의 함수 mosaic()으로 작성

# 분할표 입력
# 행 변수의 상대도수으 비율로 정사각형을 수직으로 분리 (direction="v") (direction="h"가 디폴트)
# 수직으로 분리된 두 조각을 행 변수를 조건으로 하는 열 변수의 조건부 확률에 비례하여 수평 방향으로 분리
mosaic(my_table, direction="v")


# 원자료 입력 : R 공식으로 변수 선언
# ~변수 + 변수 형태
mosaic(~ Treatment + Improved, data=Arthritis, direction="v")


# 반응변수-설명변수 형태 : 반응변수의 수준에 따라 조각이 다른 색으로 채워짐
mosaic(Improved ~ Treatment, data=Arthritis, direction="v")


# 예제 데이터 : Titanic
# 반응변수 : Survived
# 설명변수 : Class, Sex, Age
str(Titanic)
mosaic(Survived ~ Sex + Age , data=Titanic, direction="v")
mosaic(Survived ~ Class + Sex , data=Titanic, direction="v")
mosaic(Survived ~ Class + Age , data=Titanic, direction="v")
mosaic(Survived ~ . , data=Titanic, direction="v")


# 예제 데이터 : 부모와 어린 자녀의 안전벨트 착용 여부에 대한 조사 데이터
# 반응변수 : 아이의 안전벨트 착용 여부
# 설명변수 : 부모의 안전벨트 착용 여부
belt <- matrix(c(58,8,2,16), nrow=2, ncol=2)
dimnames(belt) <- list(parent=c("Yes","No"),child=c("Yes","No"))


# base_graphics
barplot(t(belt), legend.text=TRUE, xlab="parent", ylab="child", col=c("steelblue","rosybrown"))
barplot(t(belt), besid=TRUE, legend.text=TRUE, xlab="parent", ylab="child", col=c("steelblue","rosybrown"))


# ggplot2 
df_1 <- data.frame(parent=c("Yes","Yes","No","No"), child=c("Yes","No","Yes","No"), Freq=c(58,8,2,16))
p <- ggplot(df_1, aes(x=parent, y=Freq, fill=child))
p + geom_bar(stat="identity")
p + geom_bar(stat="identity",position="dodge2")
p + geom_bar(stat="identity",position="fill")


# Mosaic
mosaic(belt, gp=gpar(fill=c("steelblue","rosybrown")),dirction="v")


# 독립성 검정
# 2X2 분할표의 연관성 측도 : 오즈비(Odds Ratio)
# 2차원 분할표에 대한 독립성 검정


# Odds Ratio
# 이항변수 : 두 개의 범주를 갖는 범주형 변수
# 두 이항변수의 연간성 측도 : 오즈비(Odds Ratio)
# 오즈(Odds) : 어떤 사건이 일어날 확률을 일어나지 않을 확률로 나눈 값 P(A) / 1- P(A)


#    X          Y
#        Success  Failure
#    1      n11     n12
#    2      n21     n22


# X=1 인 경우 P(Y=Success)=ㅠ1, X=2dls ruddn P(Y=Success)=ㅠ2
# X=1 인 경우 Y의 Success Odds : ㅠ1 / 1 - ㅠ1
# X=2 인 경우 Y의 Success Odds : ㅠ2 / 1 - ㅠ2
# 두 Odds의 비율인 Odds Ratio : (ㅠ1 / 1 - ㅠ1) / (ㅠ2 / 1 - ㅠ2)
# 0 < Odds Ratio < 양의 무한대
# 두 변수 X,Y 가 서로 독립이면, ㅠ1 = ㅠ2, Odds_Ratio = 1
# Odds_Ratio > 1 : ㅠ1 > ㅠ2, X=1 에서의 성공 가능성이 더 높다.
# Odds_Ratio < 1 : ㅠ1 < ㅠ2, X=1 에서의 성공 가능성이 더 낮다.


# Odds_Ratio = 0.5 : 첫 행의 Odds가 둘째 행 Odds의 0.5배
# -> 둘째행의 Odds가 첫 행의 Odds의 2(1/0.5)배


# Odds_Ratio의 추정량 = [P1 / 1 - P1] / [P2 / 1 - P2] =  n11n22 / n12n21
# P1 =n11 / n11 + n12,   P2 =n21 / n21 + n22 


# 추정량 Odds_Ratio 의 분포 : 오른쪽으로 심하게 치우쳐진 상태
# 효과적인 추론을 위해 추정량의 로그변환이 필요한 상황


# 로그 오즈비 추정량의 점근적인 분포
# log(Odds_Ratio의 추정량) = N(log(Odds_Ratio,1/n11+1/n12+1/n21+1/n22))


# log(Odds_Ratio) 에 대한 100(1-a)% CI
# lod(Odds_Ratio의 추정량) +- z(1-a/2)SE(log(Odds_Ratio의 추정량))


# 오즈비에 대한 신뢰구간
# log(Odds_Ratio) 신뢰구간의 하한과 상한에 지수 역변환을 적용하여 계산
# 두 이항변수의 독립성 검정(H0:Odds_Ratio=1, H0:Odds_Ratio!=1)


# 예제 데이터 : Aspirin 복용 여부가 Heart Attack에 미치는 영향 분석
#     Group     Heart Attack
#               Yes      No         Total
#    Placebo    189     10845       11034
#    Aspirin    104     10933       11037


# Placebo 그룹의 Odds : (189 / 11034) / (10845/11034) = 0.01742739
# Aspirin 그룹의 Odds : (104 / 11037) / (10933/11037) = 0.009512485
# Odds Ratio 추정값 : 0.01742739 / 0.009512485 = 1.832054
# 로그 Odds Ratio 의 추정값 : log(1.832054) = 0.6054377
# 로그 Odds Ratio 의 95% 신뢰구간
#                    log(1.832054)+1.96*(0.123) ~ log(1.832054)+1.96*(0.123) : 0.3643577 ~ 0.8465177
# Odds Ratio의 95% 신뢰구간 : exp(0.3643577) ~ exp(0.8465177) : 1.439589 ~ 2.331514


# vcd 패키지의 oddsration() 를 이용
# 사용방법
# oddsratio(x,log=TRUE)
# x ; 2X2 행렬 혹은 table 객체
# log=TRUE : 로그 오즈비 계산 (디폴트)
# log=FALSE : 오즈비 계산
library(vcd)
aspirin <- matrix(c(189,104,10845,10933), nrow=2, ncol=2,
                  dimnames=list(Group=c("Placebo","Aspirin"),HeartAttack=c("Yes","No")))
my_odd1 <- oddsratio(aspirin)


# 두 이항변수의 독립성 검정
# 함수 oddsratio() 로 생성된 객체에 함수 summary() ㄸ는 confint() 를 적용
summary(my_odd1)
confint(my_odd1)


# Odds Ratio의 95% 신뢰구간
my_odd2 <- oddsratio(aspirin,log=FALSE)
confint(my_odd2)


# 2차원 분할표에 대한 독립성 검정
# 두 범주형 변수의 독립성 검정
# Pearson 카이제곱 검정(대표본일 경우)
# Fisher의 정확검정(소표본의 경우)


# 결합분포(Joint Distribution)
# ㅠij = P(X=i, Y=j)
# 한계분포(Marginal Distribution)
# ㅠi+ = P(X=i),   ㅠ+j = P(Y=j)


# 독립성
# 사건의 독립성 : P(A교집합B) = P(A)p(B)
# 확률변수의 독립성 : P(X=x,Y=y) = P(X=x)P(Y=y)
# 두 범주형 변수 X와 Y의 독립성 : ㅠij = (ㅠi+)(ㅠ+j)


# Pearson 카이제곱 독립성 검정
# 관찰 빈도수 : nij
# 귀무가설에서의 기대 빈도수 : uij = nㅠij
# H0 : 두 범주형 변수는 서로 독립            ㅠij = (ㅠi+)(ㅠ+j)
# H1 : 두 범주형 변수는 서로 독립이 아님     ㅠij != (ㅠi+)(ㅠ+j)


# 함수 chisq.test()의 사용법
# chisq.test(x, y=NULL, simulate.p.value=FALSE)
# x, y : 두 범주형 변수를 나타내는 벡터, 만일 x가 행렬 또는 table 객체이면 y는 무시됨.
# simulate.p.value=FALSE : 검정통계량의 근사분포로 카이제곱 분포를 사용하여 p값 계산.
# simulate.p.value=TRUE : 모의실험을 통하여 p값 계산. 소규모의 표본에 적합.


aspirin
chisq.test(aspirin)


# Yate's continuity correction
# 2x2 분할표에서만 적용
# 이산형인 이항분포를 연속형인 카이제곱 분포로 근사할 때의 오류 감소 효과.
# 표본 수가 너무 작은 경우에는 생략.


# vcd::Arthritis의 Treatment와 Improved의 독립성 검정.
library(vcd)
my_table <- with(Arthritis, table(Treatment,Improved))
chisq.test(my_table)


# 이 방법도 가능.
with(Arthritis, chisq.test(Treatment, Improved))


# Fisher의 정확검정
# Pearson 카이제곱 검정은 표본크기가 충분히 큰 경우 적용 가능한 방법
# 표본크기가 작은 경우 근사분포를 사용하지 않는 방법이 필요


# 초기하분포의 p값 계산-> 함수 dhyper() 사용
# m=4, n=4 의 바구니에서 k=4의 공을 꺼내는 경우, x = 3,4 의 확률을 계산
dhyper(x=3,m=4,n=4,k=4) + dhyper(x=4,m=4,n=4,k=4)


# 일반적으로 fisher.test() 를 이용한다.
# fisher.test(x, y=NULL, or=1, alternative="two.sided", conf.int=TRUE, simulate.p.value=FALSE)
# x : 요인 객체 혹은 행렬, table 객체 
# y : 요인 객체, x가 행렬이면 무시
# simulate.p.value : 분할표가 2x2 보다 큰 경우, p값을 모의실험을 통해 계산할 것인지 여부
# 나머지 옵션은 2x2 분할표에서만 적용
# or=1 : 귀무가설에서 설정되는 Odds ratio 값
# alternative : 대립가설, 디폴트 값 외에 "less", "greater" 가능
# confint : Odds ratio에 대한 신뢰구간


# Fisher의 밀크티 문제
TeaTaste <- matrix(c(3,1,1,3), nrow=2, ncol=2, dimnames=list(Guess=c("Milk","Tea"),Truth=c("Milk","Tea")))
TeaTaste
fisher.test(TeaTaste, or=1, alternative="greater", conf.int=TRUE, simulate.p.value=FALSE)


# 직업만족도와 수입의 연관성
# 범주에 비해 카운트가 너무 적다...
Job <- matrix(c(1,2,1,0,  3,3,6,1,  10,10,14,9,  6,7,12,11), ncol=4,
                    dimnames=list(income=c("<15k","15-25k","25-40k",">40k"),
                                  satisfaction=c("VeryD","LitleD","LittleS","veryS")))
Job
chisq.test(Job)
job.t <- chisq.test(Job)


# 기대빈도수 확인
job.t$expected


# 분할표의 전체 칸 중 50% 칸의 기대 빈도수가 5 미만 => 카이제곱 분포를 사용하는데 문제가 있음.


# 대안 1 : p-값을 카이제곱 분포가 아닌 모의실험을 통해 계산. (모의실험에 의한 것이기 때문에 실행마다 p값에 약간의 차이가 날 수 있음.)
chisq.test(Job,simulate.p.value=TRUE)


# 대안 2 : Fisher의 정확검정 적용.
fisher.test(Job, or=1, alternative="two.sided", conf.int=TRUE, simulate.p.value=FALSE)


# 대안 3 : 두 범주형 변수의 범주 개수 축소하여 카이제곱 검정 적용.
# 범주의 개수를 줄이면 각 칸의 기대도수가 증가하여 카이제곱 분포 근사의 부정확성 문제 해결


# 변수 Income 범주 2개로 축소
# <15k + 15-25k : <25k
# 25k-40K + >40k : >25k
# 변수 Satisfaction 범주 2개로 축소
# VeryD + LittleD : D
# Moderates + VeryS : S
library(vcdExtra)
Job <- matrix(c(1,2,1,0,  3,3,6,1,  10,10,14,9,  6,7,12,11), ncol=4,
              dimnames=list(income=c("<15k","15-25k","25-40k",">40k"),
                            satisfaction=c("VeryD","LitleD","LittleS","veryS")))
Job.r <- collapse.table(as.table(Job), income=c("<25k","<25k",">25k",">25k"),
                        satisfaction=c("D","D","S","S"))
Job.r
chisq.test(Job.r)


# 카이제곱의 근사 부정확성 문제는 해결
# 범주의 개수 축소 : 몇 개의 범주를 결합시켜 새로운 범주를 만드는 작업
# 범주의 특성을 그대로 유지할 수 있도록 하는 것이 중요


# 일반화 선형모형 (Generalized Linear Model)


# 통상적인 선형회귀모형
# 반응변수 : 연속형(정규분포 가정)
# 설명변수 : 연속형, 범주형 가능


# 반응변수가 연속형이 아닌 예
# 이항변수(성공/실패), 다항변수(상/중/하)
# Count data(특정도로 통과 차량 대수)


# 일반화 선형 모형
# 반응변수 : 연속형 및 범주형 변수 등이 가능
# 매우 포괄적인 선형모형


# 통상적인 선형모델의 경우 포아송 분포등의 경우는 설명이 불가...


# GLM의 세가지 성분
# Random component : 반응변수(Y)
# systematic component : 설명변수로 이루어진 조합
# Link function : Random component와 systematic component 를 연결시켜주는 함수


# Random Component
# 반응변수 Y의 확률분포 규정
# GLM에서 반응변수는 exponential family 중 하나여야 함.


# Systematic Component
# 반응변수에 대한 설명변수의 영향력을 표현
# 설명변수의 선형결합


# Link function
# 반응변수 Y의 평군 "E(Y)=뮤" 가 설명변수의 선형결합 "에타"와 어떻게 연결되어 있는지를 규정하는 함


# 반응변수의 분포에 따라 대표적으로 사용되는 link function이 존재
# 정규분포 : identitiy link,   뮤=에타
# 포아송분포 : Log Link   log 뮤 = 에타
# 이항분포 : Logit link,   log(뮤/1-뮤) = 에타           로짓 : 로그+오즈,      로지스틱 : 로짓 + 링크


# 이항 반응변수에 대한 선형회귀모형
# 이항 반응변수 : 두 가지 범주만을 갖는 변수, 일반적으로 1 or 0 의 값을 부여한다.
# 이항 반응변수의 분포 : Bernoulli 분포
# Y = 0,1 : 오차항의 가정을 만족시킬 수 없음
# Random Component와 Systematic Component의 범위가 다름


# 이항반응변수에서는 Classsical Linear Regression Model 을 적용시킬 수 없음.


# 예제 데이터 : Mroz
# 결혼한 미국 백인 여성의 직업참여 여부 분석
# 반응변수 : lfp (labor-force-participation) : no,yes
# 설명변수: 
#           k5 : 5세 이하 자녀 수
#         k618 : 6~18세 자녀 수
#          age : 부인 나이
#           wc : 부인 대학 교육 여부(no,yes)
#           hc : 남편 대학 교육 여부 (no,yes)
#          lwg : 부인의 기대 소득의 로그값, 직업이 없는 경우, 다른 변수를 통한 예측값
#          inc : 부인 소득을 제외한 가계 소득 
library(carData)
str(Mroz)
summary(Mroz)


# Mroz 데이터를 통한 선형회귀모형 적용
# 먼저 k5만 설명변수로 사용
# 추정대상은 lfp가 yes일 확률
# 변수 lfp는 factor with 2 levels(no,yes)
# 함수 lm()에서는 반응변수는 반드시 숫자형
# 변수 lfp를 숫자형으로 변환 no:1, yes:1
mroz <- mutate(Mroz, lfp=as.numeric(lfp)-1)
head(mroz, n=3)
fit <- lm(lfp~k5, data=mroz)
summary(fit)


# 매우 낮은 결정계수
# 회귀계수는 유의함


# 추정된 회귀직선 및 반응변수의 관찰값
ggplot(data=mroz, aes(x=k5, y=lfp)) + 
  geom_point() + 
  geom_smooth(method="lm", se=FALSE)


# 관찰값의 개수는 753개이다. 점이 7개만 찍힌 것이 아니라 겹쳐있는 것이다.


# 겹쳐있는 점을 흐트리기 : geom_jitter()
ggplot(data=mroz, aes(x=k5, y=lfp)) + 
  geom_jitter(height=0.01, width=0.1) + 
  geom_smooth(method="lm", se=FALSE)


# k5=4 인 데이터 예측해보기
predict(fit, newdata=data.frame(k5=c(4)), interval="confidence", level=0.95)


# k5=4 인 경우, 확률값이 음수로 추정된다 -> 회귀모형의 적합성에 중대한 문제


# 모든 설명변수 포함된 회귀모형 적합
fit <- lm(lfp~., data=mroz)
summary(fit)


# 설정된 회귀모형은 유의적. 그러나 지나치게 낮은 설명력
# -> 잘못 설정된 회귀모형의 함수 형태가 원인일 가능성이 높음.



# 일반화된 선형 모형 적용 (GLM)
# logit link function 
# probit link function (누적정규분포의 역함수)


# logit link function
# 여기서는 결정계수가 의미가 없다.
# 모형의 데이터의 설명력은 연속형일 떄와 다르다.


# 로지스틱 회귀 (Logistic Regression)
# 이항 반응변수에 logit link function을 적용시킨 GLM


# 설명변수가 1개인 로지스틱 회귀식의 특성
# beta0 가 증가함에 따라 왼쪽으로 그래프가 이동 -> 고정된 x 수준에서 확률 증가
# beat1 가 증가함에 따라 그래프의 기울기가 증가


# 설명변수가 1개인 프로빗 회귀식의 특성
# beta0 가 증가함에 따라 왼쪽으로 그래프가 이동 -> 고정된 x 수준에서 확률 증가
# beat1 가 증가함에 따라 그래프의 기울기가 증가


# logit 과 probit의 link function 선택
# Probit 모형이 더 앞서 도입되었으나 최근에는 Logit 모형이 더 선호됨


# Logit 모형의 장점
# 1. 해석상의 편리함(odds 활용 가능)
# 2. Probit에 비해 수학적 처리가 단순






















# [로지스틱 회귀모형]
# 1. 모형의 추정 및 해석
# 2. 추론
# 3. 모형의 적합도 측정
# 4. 다중 로지스틱 회기모형 구축


# [로지스틱 회귀모형의 추정 및 해석]
# 모수 추정은 MLE(Maximum Likelihood Estimation)으로 추정한다.
# -> 정규분포의 경우와는 다르게 정확한 추정량을 구할 수 없다.
# 비선형 정규방정식 -> 반복 계산에 의한 추정


# [모수 추정에 실패하는 경우]
# 설정된 모형이 적절하다면 몇 번의 반복만으로도 모수 추정 가능
# 반복 계산 수렴 기준을 충족시키지 못해 추정에 실패하는 경우 발생 가능
# 1. 관측값의 크기가 충분히 크지 않았을 때
# 2. 독립변수의 측정 척도가 매우 다를 때
# 3. 성공 혹은 실패 중 한 범주의 발생 빈도가 매우 낮을 때


# GLM을 위한 R 함수 : glm()


# 이항 반응변수인 경우 함수 glm()의 일반적인 사용법
# glm(fomular, family=binomial, data, ...)
# fomular : resoinse ~ terms 형식의 R 공식
# - response : 숫자형 벡터 혹은 요인(첫 번째 범주가 실패, 두 번째 범주가 성공으로 처리됨)
# family : 반응변수의 분포 및 link function
# - 이항 반응변수 : binomail
# - link function : 디폴트는 logit
# - probit을 원하는 경우 : family=binomial(link="probit")


# 부인 직업 참여 여부 결정에 대한 로지스틱 회귀모형 분석.
# logistic 회귀곗 추정
library(carData)
with(Mroz, table(lfp))
fit1 <- glm(lfp~., family=binomial, Mroz)
summary(fit1)


# p-값을 정규분포에서 계산
# Number of Fisher Scoring iterations: 4 -> 반복 계산 횟수


# 비유의적인 변수 k618 과 hcyes 를 제거하고 다시 적합
fit2 <- glm(lfp~.-k618-hc, family=binomial, Mroz)
summary(fit2)


# update 함수를 사용하기
fit2 <- update(fit1, .~.-k618-hc)
summary(fit2)


# 직업참여 확률 P(lfp="Yes")의 추정
# 함수 predict()에 의한 추정
# predict(object, newdata=, type="response")
# object : 함수 glm() 으로 생성된 객체
# newdata : 새로운 설명변수 값으로 구성된 데이터 프레임. 생략시 기존 자료에 대한 확률 추정
# type="response" : 반응변수의 scale로 추정 -> P(lfp="Yes")의 추정


# 새로운 설명변수 값에 대한 직업 참여 확률 추정
# k5, k618, lwg, inc : 평균값       age : 30~60       wc,hc : 4가지 조합


# new data 만들기
library(tidyverse)
df1 <- summarize(Mroz,k5=mean(k5),k618=mean(k618),lwg=mean(lwg),inc=mean(inc))
df1 <- cbind(df1,age=30:60)


# hc와 wc의 조합 확인
levels(Mroz$wc)
levels(Mroz$hc)


# 예측
prob_1 <- predict(fit1,newdata=cbind(df1,wc="no",hc="no"),type="response")
prob_2 <- predict(fit1,newdata=cbind(df1,wc="no",hc="yes"),type="response")
prob_3 <- predict(fit1,newdata=cbind(df1,wc="yes",hc="no"),type="response")
prob_4 <- predict(fit1,newdata=cbind(df1,wc="yes",hc="yes"),type="response")
df_2 <- tibble(age=30:60, p1=prob_1, p2=prob_2, p3=prob_3, p4=prob_4)


# 그래프 그리기
ggplot(data=df_2) +
  geom_line(mapping=aes(x=age,y=p1,col="no & no"),size=2) + 
  geom_line(mapping=aes(x=age,y=p2,col="no & yes"),size=2) + 
  geom_line(mapping=aes(x=age,y=p3,col="yes & no"),size=2) + 
  geom_line(mapping=aes(x=age,y=p4,col="yes & yes"),size=2) + 
  ylim(0,1) + labs(y="Prob",col="WC & HC")


# 새로운 설명변수 값에 대한 직업 참여 확률 추정
# k5, k618, age, lwg : 평균값       inc : 0 ~ 100       wc,hc : 4가지 조합
df3 <- summarize(Mroz,k5=mean(k5),k618=mean(k618),age=mean(age),lwg=mean(lwg))
df3 <- cbind(df3,inc=0:100)
prob_1 <- predict(fit1,newdata=cbind(df3,wc="no",hc="no"),type="response")
prob_2 <- predict(fit1,newdata=cbind(df3,wc="no",hc="yes"),type="response")
prob_3 <- predict(fit1,newdata=cbind(df3,wc="yes",hc="no"),type="response")
prob_4 <- predict(fit1,newdata=cbind(df3,wc="yes",hc="yes"),type="response")
df_4 <- tibble(age=0:100, p1=prob_1, p2=prob_2, p3=prob_3, p4=prob_4)
ggplot(data=df_4) +
  geom_line(mapping=aes(x=age,y=p1,col="no & no"),size=2) + 
  geom_line(mapping=aes(x=age,y=p2,col="no & yes"),size=2) + 
  geom_line(mapping=aes(x=age,y=p3,col="yes & no"),size=2) + 
  geom_line(mapping=aes(x=age,y=p4,col="yes & yes"),size=2) + 
  ylim(0,1) + labs(y="Prob",col="WC & HC")


# 새로운 설명변수 값에 대한 직업 참여 확률 추정
# k5 : 0 ~ 4       k618, age, lwg, inc : 평균값      wc : yes      hc : yes
df5 <- summarize(Mroz,k618=mean(k618),age=mean(age),lwg=mean(lwg),inc=mean(inc),wc="yes",hc="yes")
df5 <- cbind(df5,k5=0:4)
prob_1 <- predict(fit1,newdata=df5,type="response")
df_6 <- tibble(k5=0:4,p1=prob_1)
ggplot(data=df_6) +
  geom_bar(mapping=aes(x=k5,y=p1),stat="identity") + 
  ylim(0,1) + labs(y="prob")


# 새로운 설명변수 값에 대한 직업 참여 확률 추정
# k5 : 0       k618 : 0 ~ 4        age, lwg, inc : 평균값      wc : yes      hc : yes
df7 <- summarize(Mroz,k5=0,age=mean(age),lwg=mean(lwg),inc=mean(inc),wc="yes",hc="yes")
df7 <- cbind(df7,k618=0:4)
prob_1 <- predict(fit1,newdata=df7,type="response")
df_8 <- tibble(k618=0:4,p1=prob_1)
ggplot(data=df_8) +
  geom_bar(mapping=aes(x=k618,y=p1),stat="identity") + 
  ylim(0,1) + labs(y="prob")


# 설명변수의 효과분석
# 선형회귀모형 : 다른 설명변수들의 수준을 고정시킨 상태에서 x를 한 단위 증가시키면 E(Y)는 계수만큼 변화
# 로지스틱 회귀모형 : 비선형 모형이기 때문에 선형회귀모형의 방식으로 효과분석 불가능
#                     - 확률의 부분변화 (생략)
#                     - 확률의 이산변화 (생략)
#                     - Odds ratio


# Odds ratio에 의한 효과분석
# (1)  로지스틱 회귀모형 및 회귀계수
fit1 <- glm(lfp~., family=binomial, data=mroz)
coef(fit1)


# log(Odds)에 관한 모형 => Odds에 관한 모형으로 변환 
exp(coef(fit1))


# Odds ratio에 대한 대략적인 해석
# 공통 가정 : 다른 설명변수의 수준은 고정
# 1보다 작은 값 : 해당 설명변수를 1단위 증가 시켯을 때 부인이 직업을 가질 odds 감소
# 1보다 큰 값 : 해당 설명변수를 1단위 증가 시켰을 때 부인이 직업을 가질 odds 증가
# 1과 큰 차이가 없다. : 설명변수의 효과가 크게 없다.


# k5를 한 단위 증가시키면 직업에 참여할 odds ratio는 exp(-1.46)=0.231 배 감소한다.
# -> 100*(0.232-1) = -76.8 즉 76.8% 감소 
# k5를 두 단위 증가시키면 직업에 참여할 odds ratio는 exp(-1.46*2)=0.0536 배 감소한다.
# -> 100*(0.0536-1) = -94.6 즉 94.6% 감소 


# lwg를 한 단위 증가시키면 직업에 참열할 odds ratio는 exp(0.6047)=1.831 배 증가한다.
# -> 100*(1.831-1)=831.1 즉 83.1 % 증가
# k5를 한 단위 증가시키면 직업에 참여할 odds ratio는 exp(0.6047*2)=3.35 배 감소한다.
# -> 100*(3.35-1) = 235.1 즉 235.1% 증가 


# 부인 학력수준(wc)이 대졸인 경우가 고졸 이하의 경우와 빅하여 직업에 참여할 odds ratiosms 2.242배 증가
# -> 100*(2.241-1)=124.2 즉 124.2% 증ㄱ


# 각 설명변수 odds ratio에 대한 95% 신뢰구간
# 신뢰구간에 1이 포함되어 있는 변수
# - 비유의적 변수
# - summary(fit1) 결과와 비교
exp(confint(fit1))


# profile liklihood 방식에 의한 신뢰구간 계산
# - Wald 검정 방식에 의한 교재 표2.12 결과와는 약간 다름.
# - 신뢰구간이 odds ratio 점추정값에 대하여 좌우대칭이 아님.


# 참고
# lm 은 y 자리에 숫자만 들어오지만, glm 은 y 자리에 숫자,요인 뭐가 들어와도 상관없다.


# Probit 모형
# -> 누적 표준정규분포의 역함수


# 직업 참여자료에 대한 Probit 모형 적합
fit.p <- glm(lfp~., family=binomial(link="probit"), data=Mroz)
summary(fit.p)


# Logit 모형 vs Probit 모형 coef 값 비교
cbind(logit=round(coef(fit1),3),probit=(round(coef(fit.p),3)))


# 기존의 데이터에 대한 추정 
prob_1 <- predict(fit1,type="response")
prob_2 <- predict(fit.p,type="response")
df <- tibble(p1=prob_1, p2=prob_2)
head(df,n=10)
# 이렇게도 가능
cbind(logit=fit1$fitted.values,probit=fit.p$fitted.values)[1:10,]


# logit 이나 probit이나 그렇게 큰 차이는 없다.
# 회귀계수의 차이는 모형의 다름으로 인한 것이다.
# Probit 모형의 단점 : 개별 설명변수의 효과분석에서 로지스틱 회귀모형과는 다르게 odds ratio에 의한 분석 불가능 -> 상당한 불편함을 초래


# [적용 분야] 로지스틱 회귀분석의 주요 목적 : 판별분석과 거의 동일
# - 반응변수의 구분을 설명할 수 있는 모형 추정 : 두 가지 명목형 범주의 차이를 설명할 수 있는 비선형 모형 추정
# - 각 범주에 속할 확률 추정 : 추정된 모형을 근거로 주어진 설명변수 수준에서 각 범주에 속할 확률 추정
# - 범주에 대한 분류 : 추정된 확률을 근거로 각 관찰값의 범주를 예측


# [적용 예]
# - 중소기업의 부실 여부 예측
# - 신상품 구매의사 성향 예측
# - 특정 질환 판정 예측
# - 보험 부당 청구 탐지

















# 로지스틱 회귀모형에서 사용할 수 있는 검정
# (1) Wald Test
# (2) Likelihood Ratio Test(LTR) 
# (3) Score Test
# 세 검정 모두 likelihood function에 의한 방식
# 근사적으로(표본크기가 무한대로 커지는 경우) 세 검정은 모두 동일한 결과를 보인다.
# 실제 데이터를 대상으로 하는 경우 약간 다른 결과가 나올 수 있다.
# LTR이 가장 믿음직하다.


# Wald Test에 의한 개별회귀 계수 추론
# 예제 2.1에 대한 Wald Test
fit <- glm(lfp ~ ., family=binomial, data=Mroz)
summary(fit)


# Deviance를 이용한 추론


# 모형의 적합도(Goodness of fit)
# - 주어진 모형애 의하여 추정된 반응변수의 적합값과 반응변수의 실제 관찰값과의 일치 정도를 의미
# - 적합도를 나타내는 측도는 다수 존재
# - Likelhood function : 이항 반응변수의 로지스틱 회귀모형에 대한 적절한 적합도 측정 도구
#                        -> 단독적으로는 의미를 부여하기 어려움
#                        -> 현재 모형과 완전 모형(주어진 자료를 완전하게 설명하는 모형)의
#                           Likelihood function 값 비교로 현재 모형의 적합도를 추정


# Deviance의 값은 현재 모델이 완전모델처럼 설명을 잘하면 0에 가깝고, 설명력이 떨어지면 값이 커진다.


# Deviance : 현재 모형과 완전 모형과의 적합도 차이
#            현재 모형에 의한 반응변수의 추정값과 실제 관찰값과의 일치 정도를 표현
#            일반적으로 deviance D는 근사적인 카이제곱분포를 따른다.


# 이항반응변수의 경우 Deviance
# - 추정값만의 함수이다. 관찰값과의 비교가 불가능하다.
# - 현재 모형의 Deviance 만으로는 적합도 표현 불가능
# - 분포 : 일반적인 경우와 다르게 카이제곱 분포 사용 불가능


# dose response curve...????


# 두 nested 모형의 deviance 비교
# - nested 모형 : B 모형에 몇 개의 항을 추가된 것이 A 모형일 때 두 모형의 관계
# - 두 nested 모형의 deviance 차이 : 추가된 변수로 인한 적합도 향상 정도
# - 두 nested 모형의 deviance 차이가 검정통계량
# - Large 모형에 추가된 변수가 적합도 향상에 유의적인 효과가 있는지를 검정하는 것은 중요한 문제
# - 검정통계량의 분포 : 근사적으로 카이제곱 분포를 하며
#               자유도는 두 모형의 모수 개수 차이(이항반응변수의 경우에도 적용 가능)


# Deviance에 의한 가설 검정
# (1) 회귀모형의 유의성
# (2) 2개 이상의 회귀계수의 유의성
# (3) 개별 회귀계수의 유의성


# 예제 3.2 & 3.3
library(car)
fit <- glm(lfp ~ ., family=binomial, data=Mroz)
fit_0 <- glm(lfp ~ 1, family=binomial, data=Mroz)
anova(fit_0, fit, test="Chisq")


# D1-D2 = 124.48
# p-값 : 매우 작음


# 참고
summary(fit)


# 3.2 (2)
fit <- glm(lfp ~ ., family=binomial, data=Mroz)
fit_2_5 <- glm(lfp ~ . - k618 - hc, family=binomial, data=Mroz)
anova(fit_2_5, fit, test="Chisq")


# p-값이 0.5517 로  귀무가설을 기각하지 못하였다.
# k618과 hc는 적합도를 향상시키는데 도움이 안되는 변수이다.


# 3.2 (1)
fit <- glm(lfp ~ ., family=binomial, data=Mroz)
fit_1 <- glm(lfp ~ . - k5, family=binomial, data=Mroz)
anova(fit_1, fit, test="Chisq")


# Wald Test와의 비교.
summary(fit)


# Likelihood 함수에 기초한 개별 회귀계수의 신뢰구간 추정
# - 신뢰구간 추정방법 
#           (1) Wald Test에 의한 직접 계산
#           (2) LRT에 기초한 방법
#                      - 함수 confint()
#                      - 좌우대칭이 아닐 수 있다.
# - LRT에 기초한 방법이 더 안정적인 결과를 산출한다.


# 부인 직업 참여 자료
confint(fit, level=0.95)
confint(fit, level=0.90)


# 모형의 적합도 측정
# - Deviance : 현재 모형의 측정하는 유용한 도구
# - 이항반응변수의 경우, deviance로 적합도 측정이 어렵기 때문에 다른 측정 도구의 활용이 요구됨
# - 이항반응변수 상황에서 사용 가능한 적합도 측정 도구
#            (1) (유사) R2
#            (2) 정분류율
#            (3) AIC and BIC
#            (4) ROC Curve


# (유사) R2
# - 정규분포 회귀모형에서 모형의 적합도 측정하는 대표적인 도구
# - 로지스틱 회귀모형에 적용 가능하게 수정
# - 모형간의 적합도 비교 용도로 사용 가능 
library(pscl)
library(carData)
fit <- glm(lfp ~ . , family=binomial, Mroz)
# r2CU 보기
# 저 숫자가 높은 모델이 더 좋은 모델이다.
round(pR2(fit),3)


# 정분류율(Correct Classification Rate, CCR)
# - 어떤 임계값 d 보다 크면 1로 분류, 작으면 0으로 분류
# - 현재 모형에 의한 예측값이 관찰값과 동일한 범주로 분류된 비율
# - 모형의 적합 정도를 판단할 수 있는 중요한 도구
# - 문제점 
# - 관측 비율이 높은 범주로 단순 분류하더라도 정분류율은 50% 이상이 됨


# 수정된 CCR
# - 단순 추측으로 보장된 정분류율을 차감.
# - 음수면 모형을 만든 의미가 없다. 양수가 나와야 유의미한 모델
# - 모형에 의하여 분류했을 경우, 단순 추측에 의한 분류보다 얼마나 오류를 감소시킬 수 있는지 측정


# 부인 직업 참여 자료
my_table <- mutate(Mroz,lfp_hat=if_else(fit$fitted>=0.5,"yes","no")) %>% with(.,table(lfp,lfp_hat))
addmargins(my_table)
# 정분류율(CCR)
sum(diag(my_table)) / sum(my_table) * 100            # diag : 대각원소
# 수정된 정분류율(adj_CCR)
y_max <- max(addmargins(my_table,2))
(sum(diag(my_table)) - y_max) / sum(my_table) * 100


# 모형 추정에 사용된 자료를 대상으로 계산된 정분류율로 모형의 예측력을 측정하는 것에는 한계가 있다.


# AIC, BIC : 모형에 적합도 비교에 사용되는 척도
# AIC : Akaike's Information Criterion.  
# -2log(현재 모형의 Maximized likelihood) + 2(포함된 변수의 개수 + 1)
# BIC : Bayesian Information Criterion.   
# -2log(현재 모형의 Maximized likelihood) + log(자료 개수)(포함된 변수의 개수 + 1)
# AIC, BIC 값이 작을수록 적합도가 더 높다고 판단.


# 모형 M1 : 설명변수가 모두 포함
# 모형 M2 : k5, age, wc 만 포함
fit_M1 <- glm(lfp ~ . , family=binomial, data=Mroz)
fit_M2 <- glm(lfp ~ k5 + age + wc, family=binomial, data=Mroz)
fit_M1$aic
fit_M2$aic
AIC(fit_M1) ; AIC(fit_M2)
BIC(fit_M1) ; BIC(fit_M2)


# ROC Curve
# Reciever Operating Characteristic Curve
# 주어진 모형의 분류 정확도에 대한 평가 도구


# 민감도(Sensiticity) : "Y=1" 로 관측된 자료 중 "Y=1" 로 분류된 자료의 비율
# 특이도(Specificity) : "Y=0" 로 관측된 자료 중 "Y=0" 로 분류된 자료의 비율


# large d : 대부분의 경우 Y=0 으로 분류
# small d : 대부분의 경우 Y=1 으로 분류


# AUC : Area Under the Curve. ROC 곡선 아래 부분의 면적
# - 뷴류 정확도를 나타내는 척도
# - 급격한 기울기의 ROC Curve는 분류 정확도가 높은 모형 -> 큰 값의 AUC
# - AUC의 범위는 0.5 ~ 1.0 사이. 큰 값이 좋다.


# ROC Curve 그리기
# 패키지 pROC의 함수 roc()
# roc(response, predictor, percent=TRUE, plot=TRUE, ci=TRUE)
# response : 이항 반응 변수 벡터
# predictor : 벡터. 함수 predict() 로 계산
# percent=TRUE : 민감도, 특이도, AUC 값을 백분율로 계산
# plot=TRUE : ROC 커브 작성


# ROC Curve
library(pROC)
library(carData)
fit <- glm(lfp ~ . , family=binomial, data=Mroz)
pred <- predict(fit, type="response")
roc(with(Mroz,lfp), pred, percent=TRUE, plot=TRUE)


# 연습문제 3-1
p31 <- read.table("p2-1.dat")
names(p31) <- c("id",paste0("x",1:5),"y")
p31 <-mutate(p31,y=factor(y))
p31 <- select(p31,-id)
head(p31,n=5)


# 3-1
fit <- glm(y ~ x1 + x2 + x3 + x4 + x5, family="binomial", data=p31)
summary(fit)


# 3-3
# Deviance 차이 3.68 / p-valyue : 0.1586 귀무가설 채택. x3,x4 는 의미없는 변수
fit_r <- update(fit, .~.-x3-x4)
anova(fit_r, fit, test="Chisq")


# 3-4
# 귀무가설 기각. 따라서 의미가 있는 모델
fit_n <- glm(y ~ 1, family="binomial", data=p31)
anova(fit_n, fit, test="Chisq")


# 3-5
y_hat <- (fit$fitted >= 0.5)*1
my_table <- table(p31$y,y_hat)
addmargins(my_table)
sum(diag(my_table)) / sum(my_table) * 100
y_max <- max(addmargins(my_table,2))
(sum(diag(my_table)) - y_max) / sum(my_table) * 100


# 3-6
# AIC, BIC 값이 더 낮은 M2를 선택
# 그러나 변수 2개 5개 차이면 변수의 개수가 더 적은 모델을 선택
fit_m1 <- glm(y ~ x1 + x2 + x3 + x4 + x5, family="binomial", data=p31)
fit_m2 <- glm(y ~ x2 + x5, family="binomial", data=p31)
AIC(fit_m1); AIC(fit_m2)
BIC(fit_m1); BIC(fit_m2)


# 3-7
# m1 : 97.07% vs m2 : 96.42%
# 두 모형 사이에 큰 차이가 없다. 단순한 M2 모형이 더 선호된다.
roc(with(p31,y), fit_m1$fitted, percent=TRUE, plot=TRUE, main="ROC curve for model M1")
roc(with(p31,y), fit_m2$fitted, percent=TRUE, plot=TRUE, main="ROC curve for model M2")


# 연습문제 3-4
#  Y : 정상적 기업(1), 파산된 기업(0)
# X1 : 현금흐름 대비 총부채비율
# X2 : 순이익 대 총자산비율
# X3 : 유동자산 대 유동부채 비율
# X4 : 유동자산 대 순매출액 비율
p34 <- read.table("p2-4.dat")
names(p34) <- c("id",paste0("x",1:4),"y")
p34 <-mutate(p34,y=factor(y))
p34 <- select(p34,-id)
head(p34,n=5)


# 3-4-1
fit <- glm(y ~ x1 + x2 + x3 + x4, family="binomial", data=p34)
summary(fit)


# 3-4-2
# x1와 x4는 의미가 없는 변수이다.
fit_2 <- update(fit, .~. - x1-x4)
anova(fit_2,fit, test="Chisq")


# 3-4-3
# x1,x2,x4 적어도 하나는 유의한 변수이다.
fit_3 <- update(fit, .~. - x1-x2-x4)
anova(fit_3,fit, test="Chisq")


# 3-4-4 (가장 먼저 해야함 -> 개별 2번째 -> 관심이 있는 변수)
# 유의한 영향을 미친다.
fit_4 <- glm(y ~ 1, family="binomial", data=p34)
anova(fit_4,fit, test="Chisq")


# 3-4-5
y_hat <- (fit$fitted >= 0.5)*1
my_table <- table(p34$y,y_hat)
addmargins(my_table)
sum(diag(my_table)) / sum(my_table) * 100               # 정분류율 : 91.30%
y_max <- max(addmargins(my_table,2))
(sum(diag(my_table)) - y_max) / sum(my_table) * 100     # 수정된 정분류율 : 36.96%


# 3-4-6
# AIC와 BIC 값이 더 낮고, 변수가 더 적게 포함되어 있는 모델을 선택 -> fit_6
fit_6 <- glm(y ~ x1 + x3 , family="binomial", data=p34)
AIC(fit); AIC(fit_6)
BIC(fit); BIC(fit_6)


# 3-4-7
# full : 94.1% vs x1,x3 : 93.71%
# full model 이 약간 더 높게 나왓다.
# 따라서 얼마차이가 안나기 때문에 변수의 개수가 더 적은 모델을 선택
roc(with(p34,y), fit$fitted, percent=TRUE, plot=TRUE, main="ROC curve for full model")
roc(with(p34,y), fit_6$fitted, percent=TRUE, plot=TRUE, main="ROC curve for x1,x3 model")


# 연습문제 3-5
# 변수 age와 lwt를 제외한 나머지 변수는 모두 범주형
# 변수 race는 3개 범주 : factor로 전환이 필수
# 나머지 변수는 모두 2개 범주 : 0 or 1 의 값을 갖고 있기 때문에 factor 로 전환하지 않아도 된다.
p25 <- read.table("p2-5.dat")
names(p25) <- c("id","low","age","lwt","race","smoke","ptl","ht","ui","ftv","bwt")
p25 <- mutate(p25,race=factor(race))
head(p25,n=5)


# 3-5-1
fit <- glm(low ~ . -id -bwt, family="binomial", data=p25)
summary(fit)
# 더미형 변수에서 기준(reference)을 바꾸고 싶다면...? : 함수 relevel
p25 <- mutate(p25, race=relevel(race,ref="3"))
fit <- glm(low ~ . -id -bwt, family="binomial", data=p25)
summary(fit)


# 3-5-3
fit_2 <- update(fit, .~.-age -ptl -ftv)
anova(fit_2, fit, test="Chisq")


# 3-5-4
fit_4 <- glm(low ~ 1, family="binomial", data=p25)
anova(fit_4, fit, test="Chisq")


# 3-5-5
y_hat <- (fit$fitted >= 0.05)*1
my_table <- table(p25$low,y_hat)
addmargins(my_table)
sum(diag(my_table)) / sum(my_table) * 100               # 정분류율 : 33.86%
y_max <- max(addmargins(my_table,2))
(sum(diag(my_table)) - y_max) / sum(my_table) * 100     # 수정된 정분류율 : -34.92%


# 사용자 정의 함수 구축하기
CCR <- function(d,y,pred) {
  y_hat <- (pred >= d)*1
  my_table <- table(y,y_hat)
  ccr <- sum(diag(my_table)) / sum(my_table) * 100
  res <- c(d,ccr)
  return(res)
}
CCR(d=0.5, y=p25$low, pred=fit$fitted)


# 여러 d값에 대한 값 구하기
d <- seq(0.05,0.95,0.05)
res <- numeric(length(d)*2)
dim(res) <-  c(length(d),2)
for (i in seq_along(d)){
  res[i,]=CCR(d=d[i], y=p25$low, pred=fit$fitted)
}


# 그래프 그리기
colnames(res) <- c("d","ccr")
max_t <- max(table(p25$low))/sum(table(p25$low))*100
ggplot(data.frame(res),aes(x=d,y=ccr)) + 
  geom_point() + 
  geom_hline(yintercept=max_t, col="red") + 
  labs(x="d",y="CCR")


# [변수선택]
# 반응변수에 영향을 줄 수 있다고 생각되는 많은 설명변수 중에서 "최적"의 변수를 선택하여
# 모형에 포함시키는 절차


# 두 가지 방법으로 구분
# - 검정에 의한 방법
# - 모형 선택 기준에 의한 방법


# 어떤 모형을 "최적" 모형으로 정의할 것인가?
# 모수 절약의 원칙


# 검정에 의한 방법
# - 전진선택법, 후진소거법, 단계적 선택법


# 장점
# 계산과정이 비교적 단순
# 다수의 설명변수가 있는 대규모 자료에 손쉽게 적용 가능


# 단점
# 각 단계마다 여러 검정이 동시에 진행 -> 일종 오류의 증가
# 모형 수립 목적이 예측인 경우 -> 변수 선택과정이 목적과 잘 어울리지 않음
# 변수의 선택과 제거가 한번에 하나씩 이러우짐 -> 최적 모형을 놓치는 경우가 발생 가능


# 함수 addterm() / 함수 dropterm()


# addterm(object, scope, test="Chisq")
# dropterm(object, test="Chisq)
# object : 함수 glm()으로 생성된 객체
# scope : 고려되는 모든 설명변수가 다 포함된 모형
# test="Chisq" : LRT 검정에 의한 변수 추가 결정


# 전진 선택법
# 절편만 있는 모형에서 시작하여 영향력이 큰 변수를 각 단계마다 한 개씩 추가하는 방법
# - 
# - 변수 추가 : 영향력이 가장 큰 변수가 유의한 경우
# 일단 모형에 포함된 변수는 제거 불가


# 전진선택법에 의한 모형 선택
library(carData)
library(MASS)
fit_full <- glm(lfp ~ ., family="binomial", data=Mroz)
fit <- glm(lfp ~ 1 , family="binomial", data=Mroz)
addterm(fit,fit_full,test="Chisq")
fit <- update(fit, . ~ . + k5)
addterm(fit,fit_full,test="Chisq")
fit <- update(fit, . ~ . + age)
addterm(fit,fit_full,test="Chisq")
fit <- update(fit, . ~ . + lwg)
addterm(fit,fit_full,test="Chisq")
fit <- update(fit, . ~ . + inc)
addterm(fit,fit_full,test="Chisq")
fit <- update(fit, . ~ . + wc)
addterm(fit,fit_full,test="Chisq")


# 후진 소거법
# 고려 대상이 되는 모든 설명변수가 포함된 모형에서 시작하여 설명력이 미약한 변수를 하나씩 제거해 가는 방법
# 설명력이 가장 미약한 변수 : LRT
fit <- glm(lfp ~ ., family=binomial, Mroz)
dropterm(fit, test="Chisq")
fit <- update(fit, . ~ . - hc)
dropterm(fit, test="Chisq")
fit <- update(fit, . ~ . - k618)
dropterm(fit, test="Chisq")


# 단계별 선택법
# 일단 포함된 변수에 대한 추가적 검정이 없음
# 포함될 단계에서 유이적이어도 다른 변수가 포함되면 비유의적이 될 수 있음
# 모형에 포함된 변수에 대한 추가적 검정 필요
# 전진 -> 후진 -> 전진 -> 후진 -> 전진 -> 후진
# 종료 시점 : 1.전진 선택법으로 추가할 변수가 없는 경우
#             2. 이전 단계에서 제거된 변수가 바로 다음 단계에서 선택되는 경우
fit_full <- glm(lfp ~ ., family="binomial", data=Mroz)
fit <- glm(lfp ~ 1, family="binomial", data=Mroz)
addterm(fit, fit_full, test="Chisq")
fit <- update(fit, . ~ . + k5)
dropterm(fit, test="Chisq")
addterm(fit, fit_full, test="Chisq")
fit <- update(fit, . ~ . + age)
dropterm(fit, test="Chisq")
addterm(fit, fit_full, test="Chisq")
fit <- update(fit, . ~ . + lwg)
dropterm(fit, test="Chisq")
addterm(fit, fit_full, test="Chisq")
fit <- update(fit, . ~ . + inc)
dropterm(fit, test="Chisq")
addterm(fit, fit_full, test="Chisq")
fit <- update(fit, . ~ . + wc)
dropterm(fit, test="Chisq")
addterm(fit, fit_full, test="Chisq")    # 단계별 선택법 종료


# 모형 선택 기준에 의한 방법


# 모형의 수립 목적
# 주어진 모형이 목적을 어마나 잘 만족시키는지를 측정할 수 있는 통계량을 변수 선택 기준으로 활용하는 방법


# 일반적인 회귀모형에서 사용할 수 있는 통계량
# 결정계수, 수정된 결정계수, AIC, BIC, Cp...


# 로지스틱 회귀모형


# 모든 가능한 회귀
# 설명변수의 모든 가능한 조합에 대하여 모형 선택 기준이 되는 통계량 값을  계산하여 최적 모형 선택


# 로지스틱 회귀모형에 대한 함수 bestglm()의 일반적인 사용법
# bestglm(Xy, family=binomial, IC=c("AIC","BIC"))
# Xy : 데이터 프레임, 반응변수는 마지막 열
# IC : 모형 선택 기준 통계량, 디폴트는 BIC
library(bestglm)
mroz <- Mroz %>% select(k5:inc,lfp)
fit_aic <- bestglm(mroz, family=binomial, IC="AIC")
fit_bic <- bestglm(mroz, family=binomial, IC="BIC")


# 최종 모형의 개별 회귀계수 추정 및 검정
fit_aic
fit_bic


# 최종 모형의 유의성 검정
summary(fit_aic)
summary(fit_bic)


# Best subset model list
fit_aic$Subsets
fit_bic$Subsets


# 모형 선택 기준에 의한 단계적 선택법
# 함수 stepAIC()
# stepAIC(object, scope, k=2, direction=c("both","backward","forward"))
# direction : 단계적 탐색의 방향. 디폴트 both. scope 가 생략되면 backward가 디폴트
# k : 탐색에 사용되는 IC. k=2 : AIC, k=log(n) : BIC
library(MASS)
fit <- glm(lfp ~ 1, family="binomial", Mroz)
fit_full <- glm(lfp ~ ., family="binomial", Mroz)
stepAIC(fit, scope=formula(fit_full), k=2, direction="both")


# 후진소거에 의한 단계적 모형 탐색
stepAIC(fit_full)


# BIC에 의한 단계적 모형 탐색       trace=FALSE : 중간과정 생략         # n = 관측값의 개수
stepAIC(fit, scope=formula(fit_full), k=log(nrow(Mroz)), trace=FALSE)   # BIC 전진선택법
stepAIC(fit_full, k=log(nrow(Mroz)), trace=FALSE)                       # BIC 후진소거법


# 변수 선택 방법 적용 시 주의점
# 변수 선택 목적을 이루는 수단일 뿐 목적 자체가 아니다.
# 선택된 모형이 "최적" 모형을 의미하는 것은 아니다.
# 회귀진단, 변수 변환 등과 분리된 과정이 아니라 서로 연관된 분석 과정
# 이상값 등이 발견되어 분석에서 제외되거나 혹은 변수 변환이 이루어진 경우에는
# 반드시 변수 선택과정을 다시 실시해야 한다.


# 연습문제 p2-2
p22 <- read.table("p2-2.dat")
names(p22) <- c("id","y",paste0("x",1:4))
p22 <- dplyr::select(-id)
fit <- glm(y ~ 1, family="binomial", data=p22)
fit_full <- glm(y ~ x1 + x2 + x3 + x4, family="binomial", data=p22)
# 전진선택법을 사용한 AIC에 의한 모형 선택
stepAIC(fit, scope=fit_full, k=2, trace=FALSE)  
# 후진소거법을 사용한 AIC에 의한 모형 선택
stepAIC(fit_full,  k=2, trace=FALSE)  
# 전진선택법을 사용한 BIC에 의한 모형 선택
stepAIC(fit, scope=fit_full, k=log(nrow(p22)),trace=FALSE)  
# 후진소거법을 사용한 BIC에 의한 모형 선택
stepAIC(fit_full, k=log(nrow(p22)), trace=FALSE)  
# 전진선택법에 의한 모형 선택
fit <- glm(y ~ 1, family="binomial", data=p22)
fit_full <- glm(y ~ x1 + x2 + x3 + x4, family="binomial", data=p22)
addterm(fit,fit_full,test="Chisq")
fit <- update(fit, . ~ . + x2)
addterm(fit,fit_full,test="Chisq")
fit <- update(fit, . ~ . + x3)
addterm(fit,fit_full,test="Chisq")
fit <- update(fit, . ~ . + x4)
addterm(fit,fit_full,test="Chisq")
# 후진소거법에 의한 모형 선택
fit <- glm(y ~ 1, family="binomial", data=p22)
fit_full <- glm(y ~ x1 + x2 + x3 + x4, family="binomial", data=p22)
dropterm(fit_full,test="Chisq")
fit_full <- update(fit_full, . ~ . - x1)
dropterm(fit_full,test="Chisq")
# 최종 선택 모형
fit_1 <- glm(y ~ x2 + x3 + x4, family="binomial", data=p22)
fit_2 <- glm(y ~ x2 + x3, family="binomial", data=p22)
fit_3 <- glm(y ~ x2, family="binomial", data=p22)
# 분류율 비교해보기
y_hat <- (fit_1$fitted >= 0.5)*1
my_table <- table(p22$y,y_hat)
addmargins(my_table)
sum(diag(my_table)) / sum(my_table) * 100               # x2,x3,x4 정분류율 : 62.5%
y_hat <- (fit_2$fitted >= 0.5)*1
my_table <- table(p22$y,y_hat)
addmargins(my_table)
sum(diag(my_table)) / sum(my_table) * 100               # x2,x3 정분류율 : 57.81%
y_hat <- (fit_3$fitted >= 0.5)*1
my_table <- table(p22$y,y_hat)
addmargins(my_table)
sum(diag(my_table)) / sum(my_table) * 100               # x2 정분류율 : 55.72%


# 연습문제 p2-4
rm(list=ls())
p24 <- read.table("p2-4.dat")
names(p24) <- c("id",paste0("x",1:4),"y")
p24 <- dplyr::select(p24,-id)
fit <- glm(y ~ 1, family="binomial", data=p24)
fit_full <- glm(y ~ x1 + x2 + x3 + x4, family="binomial", data=p24)
# 전진선택법을 사용한 AIC에 의한 모형 선택
stepAIC(fit, fit_full, k=2, trace=FALSE)  
# 후진소거법을 사용한 AIC에 의한 모형 선택
stepAIC(fit_full,  k=2, trace=FALSE)  
# 전진선택법을 사용한 BIC에 의한 모형 선택
stepAIC(fit, fit_full, k=log(nrow(p24)),trace=FALSE)  
# 후진소거법을 사용한 BIC에 의한 모형 선택
stepAIC(fit_full, k=log(nrow(p24)), trace=FALSE)  


# 진단
# 1. 모형 진단 : 모형의 가정만족여부 확인
# 2. 관찰값 진단 : 특이한 관찰값 (이상값 혹은 영향력이 큰 관찰값 탐지)


# 모형 진단
# link function(logit, probit 등)의 적절성 혹은 변수의 변환 필요성 등을 진단하는 단계


# 관찰값 진단
# 이상값 탐지 : 잔차, leverage 등
# 영향력이 큰 관찰값 탐지 : Cook 통계량, Dfbeta 등


# 로지스틱 회귀모형에 적합한 잔차
# Pearson 잔차
# Deviance 잔차


# Pearson 잔차
# 잔차값의 제곱합이 모형의 적합도를 평가하기 위한 Pearson 카이제곱 통계량과 같아지기 떄문
# 잔차가 큰 값을 갖게 되면 모형의 적합도에 나쁜 영향을 주는 관찰값이라는 것을 의미
# 큰 값의 기준 : 명확하지 않음. 산점도로 파악


# Deviance 잔차
# 잔차의 제곱희 합이 현재 모형의 deviance인 통계량 D가 되기 때문이다
# 잔차가 큰 값을 갖게 되면 모형의 적합도에 나쁜 영향을 주는 관찰값이라는 것을 의미


# 표준화 잔차
# Pearson잔차와 Deviance잔차들의 분산은 1보다 작음
# 잔차의 분산이 대략 1이 되도록 조정할 필요가 있음


# 표준화 과정
# Pearson : 잔차를 자신의 표본오차로 나눈다
# deviance : 잔차를 자신의 표본오차로 나눈다


# 잔차의 표본오차에는 모자행렬(Hat matrix)의 대각원소인 leverage,h 가 포함된다


# Leverage
# 뭔진 모르지만 중요한거 같음...


# 영향력이 큰 관찰값 탐지
# 회귀분석 결과에 큰 영향을 미치는 관찰값 탐색이 목적
# 기본개념 : 특정 관찰값을 포함한 분석결과와 포함하지 않은 분석결과의 비교


# 많이 사용되는 통계량
# DFbeta : 개별 회귀계수에 대한 영향력 탐지
# Cook's distance : 회귀계수 벡터에 대한 영향력 탐지


# DFbeta의 절대값이 크다면 i번째 곤찰값이 베타 추정에 큰 영향을 미쳤다고 할 수 있음


# Cook's distance
# i번째 관찰값을 포함시켰을 때와 제외시켰을 때 회귀계수 추정량 벡터의 차이를 표준화한 통계량
# 값이 크다면 i번째 관찰값이 회귀계수 추정에 큰 영향을 미쳤다고 볼 수 있음


# R에서 진단 실시
# (표준화) 잔차 : residuals(), rstandard()
# DFbeta, Cook's distance : dfbetas(), hatvalues(), cook.distance()


# 적절한 그래프 작성 (패키지 car)
# 잔차 그래프 : residualPlot()
# 영향력이 큰 관찰값 탐지 : dfbetasPlot(), infindexPlot(), influencePlot()


# 예제 4.2
library(car)
fit <- glm(lfp ~ . -k618 -hc, family=binomial, Mroz)


# 잔차
r1 <- residuals(fit, type="pearson")
r2 <- residuals(fit, type="deviance")    # default
cbind(pearson=r1[1:5],deivnace=r2[1:5])


# 표준화잔차
r3 <- rstandard(fit, type="pearson")
r4 <- rstandard(fit, type="deviance")
cbind(pearson=r3[1:5],deivnace=r4[1:5])


# leverage
hatvalues(fit)[1:5]


# DFbeta(표준화 DFbeta)
dfbetas(fit)[1:5]


# Cook's distance
cooks.distance(fit)[1:5]


# 효과적인 진단을 위해서는 적절한 그래프 작성이 필수적
# residualPlots() : residual plots 작성 및 curvature test 실시
# dfbetasPlots() : 표준화 Dfbeta의 index plot 작성
# infindexPlot() : Cook's distance, Studentized residual, leverage들의 개별 index plot 작성
# influencePlot() : Studentized residuall과 leverage의 산점도를 기반으로 Cook's distance 크기에 의해 작성된 bubble plot


# 모형 fit의 잔차 산점도 작성 및 curvature test 실시
# curvature test : 선형 관계 여부 확인, 제곱합에 대한 유의성 검정
library(car)
residualPlots(fit)


# lwg^2 항 추가
fit.1 <- update(fit, . ~ . + I(lwg^2))
summary(fit.1)
# 모형에 추가된 lwg^2 가 유의적
# 기존 변수인 wc가 비요의적이 됨
# 기존모형가 추가된 모형의 AIC, BIC 비교
fit$aic
fit.1$aic
fit.2 <- update(fit.1, . ~ . -wc)
fit.2$aic
# AIC 값은 큰 차이가 없다
# 부인 학력이 반드시 필요한 변수가 아니라면 제거하는 것이 바람직하다.


# 모형 fit.2의 잔차 산점도
residualPlots(fit.2)


# 모형 fit.2의 DFbeta plot
dfbetaPlots(fit.2)


# 모형 fit.2의 infIndexPlot
infIndexPlot(fit.2)


# 모형 fit.2의 influencePlot
influencePlot(fit.2)


# 종합적으로 볼 때 문제가 될만한 특이값은 없는 것으로 보여진다.




