# 라이브러이 호출
library(tidyverse)
library(car)
library(vcd)


# 단순회귀모형의 적합


# 반응변수 Y와 설명변수 X 사이의 선형관계 가정
# 일차적인 관심 : 회귀계수의 추정
# 오차항에 대한 가정 : 서로 독립, 동일분포


# 예제 데이터프레임
# women : 변수 weight와 height의 관계 탐색
# 첫번째 작성 산점도 작성


str(women)
head(women,n=3)


# base graphics에 의한 산점도 작성
plot(weight~height, women)


# ggplot2에 의한 산점도 작성
# aes() 라는 함수에 수학적 변수들을 지정
# ggplot 함수는 그리기위한 준비작업
# 실제로 점을 찍는 것은 geom_point()
ggplot(women,aes(x=height,y=weight)) + geom_point()


# 산점도를 보면 선형관계가 있어보임...


# 점 대신에 선을 긋고 싶으면
ggplot(women,aes(x=height,y=weight)) + geom_line()


# 그 외 여러가지들...
# geom_smooth() : 비모수 회귀곡선???
# geom_smooth(mehtod="lm") : 회귀직선도 그려줌.


# 회귀모형 적합 : 함수 lm()
fit <- lm(weight ~ height, women)
summary(fit)


# 변수 이름 확인
names(fit)


# 사용자마다 필요한 정보가 서로 다를 수 있음
# 필요한 정보를 각자 선택해서 추출
# 모든 결과를 한번에 출력하는 SAS와 SPSS와는 다른 접근 방식


fit$coef
fit[6]


# 두 변수의 산점도
# 패키지 car의 함수 scatterplot()
library(car)
scatterplot(weight ~ height, women)


# 양쪽에 있는 박스플롯이 중요한 역할을 한다.


# 두 변수의 산점도 / 두 변수의 박스플롯
# 회귀직선 / 비모수 회귀곡선
# 자료의 분산 추정과 관련된 두개의 비모수 회귀곡선


# 데이터프레임 mtcars에서 mpg와 wt 적용
mtcars
scatterplot(mpg ~ wt, mtcars)


# 회귀직선 : 실선(lty=1)
# 비모수 곡선 : dashed line (lty=2)
# 분산추정관련 두 비모수 곡선 (lty=4)













# 다중선형회귀모형 적합 


# 반응변수 Y와 설명변수들 사이에 선형 관계 가정
# 오차항 가정 : 서로 독립, 같은 분포


# 가우스-마르코프 정리...


# Sampling Distribution...


# BLUE : BEST LINEAR UNBIASED ESTIMATION [최소선형불편추정량]


# 선형 및 오차항 가정
# 회귀모형의 추정 및 추론의 정당성 보장
# 가정 위반 시 추론 결과가 부정확하게 나올 수 있음


# 함수 lm의 기본적인 사용법
# lm(fomula, data, subset, weights, ...)
# fonula : 회귀모형 설정을 위한 R 공식
# data : 어떤 데이터를 쓸것인가?
# subset : 데이터의 일부부만 골라서 사용 할 때
#          lm(y ~ x, subset=1:100)  1~100의 자료만 사용
#          lm(y ~ x, subset= z>=0)  z가 0보다 큰 자료만 사용
# weight : 관측치의 가중치를 줄 수 있음


# fomula
# 물결표(~) : 반응변수 ~ 설명변수                                   y ~ x
# 플러스(+) : 설명변수 구분                                         y ~ x1 + x2 + x3
# 콜론(:) : 설명변수 사이의 상호작용                                y ~ x1 + x2 + x1:x2
# 별표(*) : 모든 가능한 상호작용                                    y ~ x1*x2   =   y ~ x1 + x2 + x1:x2
# 마침표(.) : 반응변수를 제외한 데이터 프레임에 있는 모든 변수      y  ~ .
# 마이너스(-) : 모형에서 제외되는 변수                              y ~ . - x1
# -1 또는 +0 : 절편 제거                                            y ~ x1 + x2 - 1
# I() : 괄호 안의 연산자를 수학 연산자로 인식                       y ~ I(x1+x2)   =    y ~ B0 + B1(x1+x2)
# poly(x,n) : 변수 x의 n차 다항회귀모형

# 예제 행렬 state.x77
state.x77
# 미국 50개의 주와 관련된 8개 변수로 구성된 행렬
# 반응변수 : Murder
# 설명변수 : Population, Illiteracy, Income, Frost
states <- as.data.frame(state.x77)
states <- subset(states, select=c(Murder, Population, Illiteracy, Income, Frost))
head(states, n=5)

# tidyverse를 이용하여 추출하기
library(dplyr)
states <- as.data.frame(state.x77)
states <- select(states, Murder, Population, Illiteracy, Income, Frost)
head(states, n=3)

# 모형에 포함된 변수들의 관계 탐색
# 상관계수
# 산점도 행렬

# 상관계수 계산 : 함수 cor()
# cor(x, y=NULL, use="everything", method=c("pearson", "kendall", "spearman"))
# x, y : 벡터, 행렬, 데이터프레임
# x 만 있는 경우 : x에 있는 모든 변수들 사이의 상관계수를 계산
# x와 y가 있는 경우 : x에 있는 변수와 y에 있는 변수를 하나씩 짝을 지어 상관계수 계산
# use : 결측값 처리 방식 everything : 결측값이 있으면 NA, 
#                          pariwise : 상관계수가 계산되는 변수만을 대상으로 NA가 있는 케이스 제거.
# method : 상관계수의 종류

# states의 상관계수 구하기
cor(states, use="pairwise", method="pearson")

# 상관계수 행렬을 그래프로 표현 : 패키지 GGally의 함수 ggcorr()
# ggcorr(data, method=c("pairwise", "pearson"), label=FALSE, label_round=1,....)
library(GGally)
ggcorr(states, label=TRUE, label_round=2)

# 산점도 행렬
# 여러 변수로 이루어진 자료에서 두 변수끼리 짝을 지어 작성된 산점도를 행렬 형태로 배열
# 회귀분석에서 필수적인 그래프
# 패키지 graphics의 함수 pairs()
# 패키지 GGally의 함수 ggpairs()
# 패키지 car의 함수 scatterplotMatrix()

# 함수 pairs()
# 입력된 데이터프레임의 모든 변수에 대한 산점도 행렬 작성
# 변수가 많은 경우에는 의미 없는 그래프
pairs(mtcars)
pairs(~mpg+wt+disp, data=mtcars)
mtcars_1 <- select(mtcars,mpg,wt,disp,cyl,am)
pairs(mtcars_1)

# 패널 함수 이용
# panel에 패널 함수 지정
# panel.smooth : 로버스트 국소선형회귀 곡선을 그리는 패널 함수
pairs(~mpg+wt+disp, data=mtcars, panel=panel.smooth)

# 함수 ggpairs()
# 사용될 변수만으로 이루어진 데이터 프레임 입력
# columns를 사용하면 원하는 것만 보여줌.
ggpairs(mtcars_1)
ggpairs(mtcars_1, columns=1:3)

# 모든 변수가 숫자형 -> 변수 cyl과 am을 요인으로 전환하고 다시 작성
library(dplyr)
mtcars_2 <- mutate(mtcars_1, am=factor(am), cyl=factor(cyl))
ggpairs(mtcars_2)

# 함수 scatterplotMatrix()
# 데이터프레임 입력
# 산점도의 색, 모양 조절 가능 : col, pch
# 패널에 나타나는 회귀직선 조절 : regLine에 리스트로 지정
# 패널에 나타나는 비모수 회귀곡선 조절 : smooth에 리스트로 지정
library(car)
scatterplotMatrix(states, col="black", pch=19, regLine=list(lty=1, col="blue"),
                  smooth=list(spread=FALSE, lty.smooth=1, col.smooth="red"))

# 비모수회귀곡선
# x와 y의 관계를 가정(ex.선형)하지 않고, 데이터의 관계를 찾는다.

# states에 대한 회귀모형 적합
fit <- lm(Murder ~ Population + Illiteracy + Income + Frost, states)
fit

# 함수 lm()으로 생성된 객체(회귀분석 결과)의 내용 확인을 위한 함수
# anova() : 분산분석표
# coefficients() : 추정된 회귀계수
# confint() : 회귀계수 신뢰구간
# fitted() : 반응변수 적합값
# residuals() : 잔차. resid()도 가능
# summary() : 중요한 적합 결과 요약
summary(fit)


# 예제 데이터 : women
# 데이터프레임 women의 변수 weight와 height의 관계
# 선형보다는 2차가 더 작합한 것으로 보임
# 다항회귀 모형이 적합함...
# 차수를 너무 높이면 다중공선성의 문제가 발생할 수 있음. -> 3차를 넘지 않는 것이 일반적
# R 함수 : poly(x, degreee=1, raw=FALSE)
#          degree = 차수 지정
#          raw = 직교다항회귀 여부. 일반적인 다항 회귀의 경우는 TRUE

# 반응변수 weight에 대한 height의 2차 다항회귀모형 적합
fit_w <- lm(weight ~ poly(height, degree=2, raw=TRUE), women)
fit_w

# I() 함수를 이용해도 동일한 결과가 나온다.
fit_w <- lm(weight ~ height + I(height^2), women)
fit_w

# 회귀모형에서 사용되는 변수 형태
# 반응변수 : 연속형(정규분포 가정 필요)
# 설명변수 : 연속형(정규분포 가정은 필요없으나, 가능한 좌우 대칭)
#            범주형(가변수 필요)

# 가변수 회귀모형 : 2개 범수(Yes or No) -> 1개 가변수 사용.   D = 0 or D =1 
# D = 0 인 기준 범주
# 회귀계수 : yes 범주와 기준 범주의 차이
# 일반적으로 가변수 개수 = 범주 개수 - 1
# 만일 가변수 개수 = 범주 개수이면 회귀계수 추정이 불가능.
# => 절편을 제거하면 추정 가능
# => 회귀계수의 해석이 달라짐.
# => 두 개 이상의 범주형 변수가 포함되는 경우에는 적용이 어려움.

# 패키지 carData의 데이터프레임 : Leinhardt
# 1970년대 105개의 나라의 신생아 사망률,소득,지역, 원유수출여부
# 반응변수 : 신생아 사망률(infant)
# 설명변수 : 소득(income), 지역(region, 4개수준:Africa,Americas,Asia,Europe), 원유수출(oil, 2개수준:no,yes)

# 회귀모형 적합
# 기준범주 : 알파벳 첫 번째 범주인 Africa
# 회귀계수 regionAmericas는 범주 Americas와 기준 범주 Africa의 차이

# 함수 lm() 요인 입력 : 자동으로 필요한 개수의 가변수 포함.
lm(infant ~ income + region, data=Leinhardt)
lm(infant ~ income + region + 0 , data=Leinhardt)

# 두 범주형 변수(region,oil) 포함.
lm(infant ~ income + region + oil, data=Leinhardt)
lm(infant ~ income + region + oil + 0 , data=Leinhardt)

# 회귀모형의 추론
# 회귀계수에 대한 가설
# H0 : 회귀계수가 모두 다 0 이다.      B1 = B2 = ... = Bk = 0
# H0 : 일부분의 회귀계수들이 0 이다.   Bi = Bi+1 = Bi+2 = ... = Bk = 0
# H0 : 각각의 계수들이 다 0 이다.      Bi = 0

# 회귀계수의 신뢰구간
# 회귀모형 적합 정도에 따른 통계량 : 결정계수, 수정된 결정계수, MSE,...
# 예측 : 반응변수의 평균값에 대한 예측, 반응변수의 개별 관찰값에 대한 예측

fit1 <- lm(Murder ~ Population + Illiteracy + Income + Frost , states)
summary(fit1)

# 적절하게 fitting 되었다면 Residuals가 0을 기준으로 어느정도 대칭을 이루었는가...?

# Residual standard error : RMSE

# 만일 ANOVA TABLE 을 보고 싶다면...?
anova(fit1)

# 두 회귀모형 비교
# 확장모형 : 변수가 많은 모형
# 축소모형 : 변수가 적은 모형 (확장모형의 일부분...)
# 여러가지 모형이 있을 경우 성능이 비슷하다면 단순화된 모형이 더 좋다.
# 확장모형의 SSR 과 축소모형의 SSR을 비교했을 때 비슷하다면 축소모형
# 차이가 많이 난다면, 확장모형을 선택하는 것이 바람직 하다.

# 축소모형의 잔차제곱합 - 확장모형의 잔차제곱합
# 이 값이 작다면, 축소모형이 확장모형만큼 좋다는 의미
# 모수절약의 원칙에 따라 축소모형 선택 가능

# 두 회귀모형의 비교
fit1 <- lm(Murder ~ ., states)
fit2 <- lm(Murder ~ Population + Illiteracy, states)
# anova(축소모형, 확장모형)
anova(fit2,fit1)
# 귀무가설의 기각이 어려움
# 축소모형이 더 낫다.

# 함수 confint()
# 모형에 포함된 회귀계수의 신뢰구간 추정
# 사용법 : confint(object, level=0.95)
confint(fit1, level=0.95)
confint(fit1, level=0.90)

# 예측
# 회귀모형 적합 후
# 새롭게 주어진 설명변수 자료에 대해 반응변수의 값 예측
# 반응변수의 평균값에 대한 예측 or 개별 관찰값에 대한 예측

# 함수 predict()
# 사용법 : predict(object, newdata, interval=c("confidence","prediction"), level=0.95)
# object : lm 객체
# newdata : 새롭게 주어진 설명변수 자료, 데이터 프레임
# interval : 반응변수 평균 예측(confindence), 개별 관찰값 예측(prediction)
# level : 예측 수준

# 모형 fit2 에 대하여 두 변수(Population,Illiteracy) 에 대한 새로운 관찰값(15000,0.8),(10000,1.5),(5000,2.5)
# 반응변수 Murder의 평균값 및 개별 관찰값 예측
x0 <- data.frame(Population=c(15000,10000,5000),Illiteracy=c(0.8,1.5,2.5))
predict(fit2, newdata=x0, interval="confidence", level=0.95)
predict(fit2, newdata=x0, interval="prediction", level=0.95)















# 회귀 진단
# 회귀모형에 대한 진단 : 회귀모형의 가정 사항 만족 여부 확인 / 적합 및 추론 결과의 신빙성 확보
# 관찰값에 대한 진단 : 개별 관찰값이 모형 추정 과정에 미치는 영향력 파악

# [회귀모형의 가정 만족 여부 확인] : 다중회귀모형 가정 사항
# 오차항의 평균은 0, 분산은 모두 동일
# 오차항의 분포는 정규분포
# 오차항은 서로 독립
# 반응변수와 설명변수의 관계는 선형

# 예 : women의 변수 weight와 height의 회귀모형 가정 만족 여부 확인
# 가장 기본적인 방법은 lm 객체를 함수 plot에 적용
fit_w <- lm(weight ~ height, women)
par(mfrow=c(2,2))           # 그래프 4개를 한 화면에 출력 시켜줌.
plot(fit_w)
par(mfrow=c(1,1))           # 그래프 1개를 원상복구 시켜줌.


# 1번 그래프만 잔차 / 나머지는 표준화 잔차


# 첫 번째 그래프 : 가장 일반적인 잔차 산점도
# 동일 분산, 평균0, 선형관계 확인
# 디폴트 옵션으로 가장 극단적인 3 case 룰 표시
# 빨간선은 비모수회귀곡선
plot(fit_w, which=1)


# 두 번째 그래프 : Normal Q-Q (정규 분위수-분위수 그림)
# 표준화 잔차의 표본 분위수와 정규분포의 이론 분위수의 산점도
# 정규분포와의 분위수 간격을 비교하여 직선을 띌수록 정규분포에 가깝다.
# 대체적으로 가운데는 직선과 비슷하기 때문에, 양 사이드를 비교해봐야 함.
plot(fit_w, which=2)


# 세 번째 그래프 : Sacle-Loaction plot
# 동일분산인지 확인
# 점들이 체계적으로 증가하거나 감소하는 경향이 있는지 확인
plot(fit_w, which=3)


# 네 번째 그래프 : Residuals VS Leverage
# 관찰값 진단에 사용되는 그래프
# Cook's distance : 최소 자승 회귀 분석을 수행 할 때 데이터 요소의 영향 에 대해 일반적으로 사용되는 추정치
plot(fit_w, which=5)


# 패키지 car에는 plot 보다 더 많은 정보를 주는 그래프들이 있다.


# 오차항의 동일 분산 가정
# 함수 plot으로 생성된 그래프 중 옵션 which=1, which=3의 그래프
# 패키지 car의 함수 spredLevelPlot()에 생성되는 그래프
# 패키지 car의 함수 ncvTest()로 실행되는 score 검정


# 패키지 car의 함수 spreadLevelPlot()에 생성되는 그래프
# 실행결과 : 스튜던트화(Studentized) 잔차와 추정값의 산점도
# [i번째 자료를 빼고 모델을 추정하고 비교]
# 분산 안정화를 위한 반응변수의 변환짓의 p값 제안
# 스튜던트화 잔차가 크다는 거슨 i번째 관찰값이 이상값으로 분류될 가능성이 높다는 의미이다.


# 패키지 car의 함수 ncvTest()에 의한 확인
# 귀무가설 : 오차의 분산이 일정
# 대립가설 : 오차의 분산이 추정값의 수준에 따라 변한다.


# 연습
library(car)
spreadLevelPlot(fit_w)
# 점들의 체계적인 증가 혹은 감소 여부
# 파란 직선 : 로버스트 회귀 직선
# 빨간 곡선 : 국소다항회귀 곡선
# 제안된 지수가 1과 큰 차이가 있는가???


# 연습
ncvTest(fit_w)
# p값이 0.36954로 귀무가설이 기각되지 못하였다.
# 그러나 귀무가설을 기각하지 못했다고 해서 반드시 등분산이라는 보장은 없다.


# 진단에 100%는 없다. 여러가지 결과들을 보고... 분석가가 판단해야 한다.


# 연습 states 회귀모형의 동일 분산 가정 확인
states <- as.data.frame(state.x77)
states <- select(states, Murder, Population, Illiteracy, Income, Frost)
fit_s <- lm(Murder ~ .,states)
plot(fit_s,which=1)
plot(fit_s,which=3)
spreadLevelPlot(fit_s)
ncvTest(fit_s)


# 오차항의 정규분포 가정
# 확인방법
# 그래프에 의한 확인 : Q-Q plot 작성
# 그래프에 의한 확인 :  패키지 car의 함수 qqPlot() : 스튜던트화 잔차의 t-분포 분위수-분위수 그래프.
# 가정이 만족되면 ti ~ t(n-k-2)
# 검정에 의한 확인 : 함수 shapiro.test()에 의한 Shapiro-wilk 검정


# 연습 women 자료 회귀 모형의 정규 분포 가정 확인
plot(fit_w, which=2)
qqPlot(fit_w)             # 점선 : 모수적 Bootstrap에 의한 95% 신뢰구간,  1과15는 가장 극단값
shapiro.test(residuals(fit_w))
shapiro.test(fit_w$resid)          # 위의 방법과 같은 방법


# 연습 states 자료 회귀 모형의 정규분포 가정 확인
plot(fit_s,which=2)
qqPlot(fit_s)
shapiro.test(residuals(fit_s))


# 오차항의 독립성 가정
# 독립성 가정을 해야하는 경우
# 시간의 흐름에 따라 관측된 시계열 자료
# 공간에 따라 관측된 공간 자료


# 독립성 가정의 위반 형태 : 매우 다양함
# k차 자기상관 계수
# Durbin-Watson 검정의 귀무가설 : 1차 자기 상관계수 = 0
# Breusch-Godfrey 검정의 귀무가설 : 여러 자기 상관계수 = 0


# Hartnagel 데이터
# 1931년부터 1968년까지 캐나다 범죄율 자료
# 반응변수 : 여성 범죄율 (fconvict)
# 설명변수 : 출산율(tfr), 여성고용률(partic)


# Durbin-Watson 검정
library(car)
fit_h <- lm(fconvict ~ tfr + partic, data=Hartnagel)
durbinWatsonTest(fit_h)


# Women 데이터의 Durbin-Watson 검정
durbinWatsonTest(fit_w)


# forcast의 함수 checkresiduals()
library(forecast)
checkresiduals(fit_h)


# 선형관계 가정사항 확인
# 단순회귀 : 두 변수의 산점도로 간단하게 확인 가능
# 다중회귀 : 다른 변수의 영향력으로 인하여 X1,Y 혹은 X2,Y 의 산점도는 큰 의미가 없음


# 변수 X1의 부분잔차 (Partial Residual)
# 모형에 포함된 다른 설명변수의 영향력이 제거된 잔차
# X1와 부분잔차의 산점도 작성


# 선형관계 확인 : crPlots()
# 각 변수의 부분 잔차에 대한 회귀직선과 국소다항회귀곡선 추가
# 선형 관계에는 문제가 없음.
# 변수 Income, Frost 의 영향력이 매우 적음을 확인.
crPlots(fit_s)


# 선형관계 확인 : residualPlots()
# Curvaure Test : 모형에 하나씩 포함된 각 변수의 제곱항의 유의성 검정
residualPlots(fit_s)


# 다중공선성
# 설명변수 사이에 강한 상관관계가 존재하는 경우
# 회귀모형의 가정과 직접적인 연관은 없음
# 추정량의 분산이 크게 증가 : 회귀모형 추정에 영향을 줄 수 있음


# VIF에 의한 다중공선성 존재 여부 확인
# 분산팽창계수(VIF)
# VIF 값이 크면 각 계수의 분산이 커짐 -> 불안정해짐
# vIF 값이 10 이상이면 문제가 크다


# 다중공선성 연습하기
# library(car) 패키지의 함수 vif()
# library(faraway) 패키지의 함수 vif()
library(car)
vif(fit_s)
faraway::vif(fit_s)


# 예제 데이터 : Duncan에서 반응변수 prestige, 설명변수 income, education, type의 회귀 모형 설정
fit_1 <- lm(prestige ~ income + education + type, data=Duncan)
summary(fit_1)
vif(fit_1)
faraway::vif(fit_1)


# 개별 더미변수에 대한 VIF 값 계산은 큰 의미가 없다.
# 범주형 변수 type에 대한 VIF가 더 의미가 있다.


# GVIF : 범주형 변수에도 적용 가능한 VIF
#              GVIF Df     GVIF^(1/(2*Df))
#income    2.209178  1        1.486330
#education 5.297584  1        2.301648
#type      5.098592  2        1.502666
# 젤 마지막 열을 제곱을 해서 일반적인 VIF와 비교

















# 특이한 관찰값 탐지


# - 특이한 관찰값
#    (1) 이상값 : 추정된 회귀모형으로 설명이 잘 안되는 관찰값
#    (2) 영향력이 큰 관찰값 : 회귀게수 추정에 과도한 영향을 미치는 관찰값


# - 특이한 관찰값 탐지
#     유용한 통계량 : DFBETAS, DFFITS, Covariance ratio, Cook's distance
#     유용한 R 함수 : influence.measures(), infindexPlot(), dfbetePlots(), avPlots(), influencePlot(), outlierTest()


# R 함수의 활용 : influence.measures()
fit_w <- lm(weight~height,data=women)
influence.measures(fit_w)


# R 함수의 활용 : infIndexPlot()
infIndexPlot(fit_s)


# R 함수의 활용 : dfbetaPlots()
dfbetaPlots(fit_s, id.method="identify")


# R 함수의 활용 : avPlots()
avPlots(fit_s)


# R 함수의 활용 : influencePlot()
influencePlot(fit_s)


# R 함수의 활용 : outlierTest()
# pt : 확률분포의 확률값 구해줌.
# rstudent : Studentized residual 구해줌.
# df=fit_s$df.resid-1 : 자유도 계산.
# lower.tail=FALSE : 확률분포의 왼쪽확률이 아닌 오른쪽 확률을 계산해줌.
2*pt(max(rstudent(fit_s)), df=fit_s$df.resid-1, lower.tail=FALSE)


# Bonferroni correction 하기
outlierTest(fit_s)














# 대안 탐색
library(tidyverse)

# 변수 변환


# states 자료에 대한 회귀모형
library(dplyr)
states <- as.data.frame(state.x77) %>% select(Murder, Population, Illiteracy, Income, Frost)
fit_s <- lm(Murder~., data=states)


# 함수 MASS::boxcox()에 의한 변환 탐색.
library(MASS)
bc <- boxcox(fit_s)
names(bc)
bc$x[which.max(bc$y)]


# 함수 car::powerTransform()에 의한 변환 탐색
library(car)
summary(powerTransform(fit_s))


# states 자료의 모형 fit_s에서 Population, Illiteracy 변환 여부 확인.
library(car)
boxTidwell(Murder~Population+Illiteracy, other.x=~Frost+Income, data=states)


# women 자료의 fit_w에서 height의 변환 필요 여부 확인
boxTidwell(weight~height, data=women)


# women 자료에 4차 다항회귀모형 적합
mod1.fit_W <- lm(weight~poly(height,degree=4,raw=TRUE),data=women)
summary(mod1.fit_W)


# women 자료에 3차 다항회귀모형 적합
mod2.fit_W <- lm(weight~poly(height,degree=3,raw=TRUE),data=women)
summary(mod2.fit_W)
par(mfrow=c(2,2))         
plot(mod2.fit_W)
par(mfrow=c(1,1))  














# 변수선택
# 반응변수의 변동을 설명할 수 있는 많은 설명변수 중 "최적"의 변수를 선택하여 모형에 포함시키는 절차


# 검정에 의한 방법
# - 변수의 유의성 검정을 이용하여 단계적으로 모형 선택
# - 후진소거법, 전진선택법, 단계별 선택법


# 모형 선택 기준에 의한 방법
# - 모형의 적합도 등을 측정하는 통계량을 기반으로 모형 선택
# - 결정계수, 수정결정계수, 잔차제곱법, Cp 통계량, AIC, BIC 등등


# 어떤 모형이 "최적" 모형인가?


# 검정에 의한 방법
# - SAS 등에서 일반적으로 이루어지는 변수 선택 방법.
# - 장점 : 선택 과정에 비교적 단순하여 대규모의 설명변수에서의 중요 변수 선택 시 유용함.
# - 단점 :  "한 번에 하나씩"의 선택 절차 : "최적" 모형을 찾지 못 할 수도 있음.
#           일종의 다중 검정 : 일종 오류 확률 증가.
#           모형 수립 목적이 예측인 경우, 모형 수립 과정이 목적과 어울리지 않는다.
# SAS 에서와는 다르게 한 번의 실행으로 최종 모형을 얻는 방법이 없다.
# 패키지 MASS의 addterm() 혹은 dropterm() 을 반복적으로 사용하여 사용자가 직접 변수 선택.


# 연습하기 : state.x77
state_df <- as.data.frame(state.x77)
state_df <- rename(state_df, Life.Exp="Life Exp", HS.Grad="HS Grad")


# 전진선택법
# - 절편만 있는 모형에 시작하여 영향력이 큰 변수를 각 단계마다 한 개씩 모형에 추가
# - 영향력이 큰 변수 : 해당 변수가 모형에 추가됨으로써 증가하는 회귀제곱합(SSR)의 증가분이 가장 큰 변수
# - 변수가 유의하면 집어 넣음.
# MASS::addtren()
# addterm(object, scope, test="F")
# - object : lm 객체
# - scope : 모든 설명변수가 포함된 모형
# - test="F" : 증가분에 대한 F-검정 실시


# 전진선택법 실시
full.fit <- lm(Murder ~ . , state_df)         # 모든 변수가 포함
fit <- lm(Murder ~ 1, state_df)               # 절편만 포함 
MASS::addterm(fit, full.fit, test="F")


# Sum of Sq : 해당 변수가 추가됨으로써 증가되는 회귀제곱합
# RSS, AIC : 각 개별 변수가 포함된 모형의 잔차제곱합, AIC
# Pr(F) : 회귀제곱합 증가분에 대한 p-value


# 첫 번째 변수 Life.Exp 선택
# 현재 모델에 추가
fit <- update(fit, . ~ . + Life.Exp)
MASS::addterm(fit, full.fit, test="F")


# 두 번째 변수 Frost 선택
fit <- update(fit, . ~ . + Frost)
MASS::addterm(fit, full.fit, test="F")


# 세 번째 변수 Population 선택
fit <- update(fit, . ~ . + Population)
MASS::addterm(fit, full.fit, test="F")


# 네 번째 변수 Area 선택
fit <- update(fit, . ~ . + Area)
MASS::addterm(fit, full.fit, test="F")


# 다섯 번째 변수 Illiteracy 선택
fit <- update(fit, . ~ . + Illiteracy)
MASS::addterm(fit, full.fit, test="F")


# 남은 2개의 변수는 유의하지 않다.


# 후진소거법
# 모든 설명변수가 포함된 모형에서 영향력이 미약한 변수를 하나씩 제거
# 영향력이 미약한 변수 : 회귀제곱합의 증가분이 가장 작은 변수
# 비유의적인 경우 모형에서 제거


# 함수 : MASS::dropterm()
# dropterm(object, test="F")
fit <- lm(Murder ~ ., state_df)
MASS::dropterm(fit, test="F")


# 첫 번째 변수 제거 Income
fit <- update(fit, . ~ . - Income)
MASS::dropterm(fit, test="F")


# 두 번째 변수 제거 HS.Grad
fit <- update(fit, . ~ . - HS.Grad)
MASS::dropterm(fit, test="F")


# 유의수준 10% 에서 더 이상 뺄 변수가 없다.


# 단계별 선택법
# 전진선택법은 모형에 포함된 변수에 대한 추가적 검정이 없다.
# 이후 단계에서 추가된 변수의 영향으로 비유의적이 될 가능성이 있다.
# 모형에 포함되 변수에 대한 추가적인 검정이 필요하다.
# (1) 전진선택법과 동일하게 시작
# (2) 변수가 모형이 추가되면 모형에 있는 모든 변수를 대상으로 후진 소거법
# addterm() -> update() -> dropterm()
# 종료 조건 : 더 이상 추가할 변수가 없을 때
#             바로 전 단계에서 제거된 변수가 다시 추가될 때
full.fit <- lm(Murder ~ . , state_df)
fit <- lm(Murder ~ 1, state_df)
MASS::addterm(fit, full.fit, test="F")


# Life.Exp 추가, 제거할 변수 없음.
fit <- update(fit, . ~ . + Life.Exp)
MASS::dropterm(fit, test="F")
MASS::addterm(fit, full.fit, test="F")


# Frost 추가, 제거할 변수 없음.
fit <- update(fit, . ~ . + Frost)
MASS::dropterm(fit, test="F")
MASS::addterm(fit, full.fit, test="F")


# 모형 선택 기준에 의한 변수 선택
# - 모형 수립 목적을 고려한 변수 선택 방법
# - 모형의 적합도 등을 나타내는 통계량을 선택 기준으로 사용
# - 사용되는 통계량 : 결정계수, 수정된 결정계수, MSE, Cp통계량, AIC, BIC
# - 선택방법 : 모든 가능한 회귀 (All possible regression)
#              단계별 선택법


# 모든 가능한 회귀
# - 설명변수의 모든 가능한 조합에 대하여 선택 기준으로 사용되는 통계량 계산
# - 특정 통계량을 기준으로 가장 최적인 모형을 보여주는 방식
# - leaps::regsubsets()로 실시
library(leaps)
state_df <- as.data.frame(state.x77)
state_df <- dplyr::rename(state_df, Life.Exp="Life Exp", Hs.Grad="HS Grad")
fits <- regsubsets(Murder ~ . , state_df)
fits


# 함수 plot에 의한 확인
# BIC(디폴트)를 기준으로 보겠다.
# 하나의 행들이 각각의 모델이다.
# 검은색은 그 변수가 그 모델에 들어가 있다라는 뜻이다.
# 젤 위에 BIC가 가장 작은 모델을 선택 : intercept, Population, Life.Exp, Frost, Area
plot(fits)


# r2 기준으로 보기
plot(fits, scale="r2")


# 수정된 r2 기준으로 보기
plot(fits, scale="adjr2")


# Cp통계량 기준으로 보기
plot(fits, scale="Cp")


# 가능한 경우의 수 : 2^7 = 128개의 경우의 수


# 그 중에서 7개만 나온 이유는 같은 독립변수의 개수일 때 가장 좋은 모델이 나온다.
# 독립변수가 1개일 때의 Best, 2개일 떄의 Best,... 7개일 때의 Best


# 각각 동일 독립변수 개수에서 2개씩 뽑고 싶으면...?
fits_2 <- regsubsets(Murder ~ . , state_df, nbest=2)


# summary로 확인하기
# 설명변수가 k개인 모형 중 결정계수가 가장 높은 모형 나열
summary(fits)


# 함수 car::subsets()에 의한 확인
# subsets(lm object, statiscs=c("bic", "cp", "adjr2", "rsq", "rss"), legend="interactive")
# 옵션 legend : 범례의 위치
# legend="intercept" : 디폴트, 마우스로 위치 지정 가능
# legend=FALSE : console 창에 범례 출력
subsets(fits, legend=FALSE)


# 옵션 statistics 활용 : Cp에 의한 모형 선택
# - Cp=p인 모형 선택
# - p는 모형에 포함된 모수의 개수 (절편 포함 여부 확인)
# - Cp=4 인 모형 P-L-F-A 선택
# - Cp 값이 최소인 모형 P-Il-L-F-A 도 함께 고려
subsets(fits, statistic="cp", legend=FALSE)
abline(a=1,b=1,lty=3)


# r2 기준으로 모형 선택
subsets(fits, statistic="rsq", legend=FALSE)


# 수정된 r2 기준으로 모형 선택
subsets(fits, statistic="adjr2", legend=FALSE)


# 선택한 모형의 적합 결과 확인
coef(fits, id=4)
summary(fits)$which


# 단계별 선택
# - AIC 혹은 BIC에 의한 단계별 선택
# - 변수의 개수가 많은 경우에 적용 가능
# - MASS::stepAIC()로 실시
# - 옵션 scope 생략 시 후진소거법이 디폴트로 적용
# - 변수의 개수가 정말 많은 경우에만 사용... 
fit.full <- lm(Murder ~ . , state_df)
fit_1 <- stepAIC(fit.full)
confint(fit_1)                   # 비유의적인 변수 Illiteracy와 Frost가 포함.


# 옵션 direction의 활용
# - 후진소거법에서는 일단 제거된 변수는 다음 단계부터 고려 대상이 되지 않는다.
# - 제거된 변수도 고려 대상에 포함시키고자 한다면, direction="both"
step(fit.full, direction="both")


# 중간과정의 생략 : 옵션 trace
step(fit.full, direction="both", trace=FALSE)


# BIC에 의한 모형 선택 : 함수 setpAIC()의 옵션 k
# 디폴트는 k-2(AIC)
stepAIC(fit.full, k=log(nrow(state_df)),trace=FALSE)














