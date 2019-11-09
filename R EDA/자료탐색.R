

# Tibble
# 개선된 형태의 데이터 프레임


# Tibble의 생성
install.packages("tidyverse")


# core tidyverse의 로딩
library(tidyverse)


# filter()와 lag()가 충돌됨... stats::fiter() 이런식으로 다 쳐줘야 함


# core tidyverse에 속하지 않는 라이브러리들은 따로 따로 불러와야 함. 함수 library() 사용


# 패키지 ggplot2의 mpg 데이터 Tibble 형태
mpg


# 전통적 데이터프레임 : 최대한 출력할 수 있는 만큼 출려해줌
MASS::Cars93


# 데이터 형태의 구조를 설명해줌
str(MASS::Cars93)


# 전통적인 데이터 프레임의 출력 형태와 많이 다른 모습.
# Tidyverse에 속한 패키지가 공통적으로 사용하는 개선된 데이터 프레임


# 기존의 데이터프레임을 Tibble로 변환하기. 함수 as_tibble() 사용
cars
as_tibble(cars)


# 개별 벡터를 이용한 tibble의 생성 : 함수 tibble()
# 길이가 1인 스칼라만 순환법칙 적용 (만약, z=1:2가 입력되면...?)
# 함께 입력되는 변수를 이용한 다른 변수의 생성 가능
# 열(변수) 단위로 입력
tibble(x=1:3,y=x+1,z=1:2)


# 기존의 데이터프레임은 안되는 기능 : 함께 입력되는 변수를 이용한 다른 변수의 생성
data.frame(x=1:3, y=x+1)


# 문자형 벡터를 요인으로 전환하지 않음 -> 문자를 chr로 받아들임
# stringsAsFactors=FALSE 을 넣어주면 요인으로 안바꿔줌
tibble(x=1:3, y=letters[1:3])
str(data.frame(x=1:3, y=letters[1:3]))
str(data.frame(x=1:3, y=letters[1:3], stringsAsFactors=FALSE))


# 함수 tribble()
# 첫 줄 : 변수 이름은 "~" 로 시작
# 각 자료는 "," 로 구분
tribble(
       ~x,~y,
        1,"a",
        2,"b",
        3,"c"
)


# 기존의 데이터프레임과 Tibble의 차이점
# 1. 데이터프레임의 출력 방식
# 2. 인덱싱 방법
# 3. Row names를 다루는 방식


# 기존의 인덱싱 방법
pop <- c("Seoul"=1000,"Suwon"=100,"Busan"=90)
pop_1 <- c(1000,100,90)
names(pop_1) <- c("Seoul","Suwon","Busan")
pop[1:2]
pop[c("Seoul","Busan")]


# 표준정규분포에서 난수 발생
x <- rnorm(n=100, mean=0, sd=1)
mean(x[x>=0])
sd(x[x>=0])


# 전통적 데이터 프레임 : 가능한 모든 자료를 화면에 출력. 대규모 자료의 경유 내용 확인에 어려움
MASS::Cars93


# 보기 좋게 나옴
as_tibble(MASS::Cars93)


# 모든 변수를 보고싶으면...
print(mpg, n=20, width=Inf)


# 맨 왼쪽이 row_names 이다
# 데이터 프레임은 row_names를 출력되지만, Tibble은 생략시켜버린다.
# Tibble에서 row_names를 보고싶으면 변수로 변환한 뒤 Tibble에 집어 넣어야 한다.
head(mtcars)
mtcars_t <- as_tibble(mtcars)
print(mtcars_t,n=5)
mtcars_t <- rownames_to_column(mtcars_t, var="rowname")
print(mtcars_t,n=5)


# 전통적 데이터프레임의 인덱싱
# 열(변수) 선택
# df[[a]] or df[a] : 벡터 a는 숫자형 또는 문자형
# df[[a]] : 한 변수의 선택, 결과는 벡터
# df[a] : 하나 또는 그 이상의 변수 선택. 결과는 데이터프레임
df2 <- data.frame(x=c(2,4,6),y=c("a","b","c"))
df2[1]
df2[[1]]
df2["x"]
df2[["x"]]
df2$x


# 행렬의 인덱싱 사용방법
df2[c(1,2),1]
df2[c(1,2),]


# 전통적 데이터프레임의 부분매칭은 허용한다.
df1 <- data.frame(xyz=1:3, abc=letters[1:3])
df1$x


# Tibble은 부분 매칭을 불허한다.
tb1 <- as_tibble(df1)
tb1$x
tb1$xyz


# 연습문제 1
df1 <- tibble(x=1,y=1:9,z=rep(1:3,each=3),w=sample(letters,9))
df1


# 연습문제 2-1 
df1$y
df1[[2]]
df1[["y"]]

# 연습문제 2-2
df1[c(1:5),2]


# 연습문제 2-3
df2 <- as.data.frame(df1)
df2[1:5,2]





#####################################################################################################################################
#####################################################################################################################################







# dplyr
# 데이터프레임 다루기, tidyverse의 핵심 패키지
# 통계 데이터 세트 : 변수가 열, 관찰값이 행을 이루는 2차원 구조. 데이터프레임으로 입력
# 입력된 대부분의 데이터 프레임 : 바로 분석할 수 있는 상태가 아님
#                                 분석에 필요한 적절한 변수가 없음
#                                 특정 조건을 만족하는 관찰값만을 선택
#                                 관찰값의 순서 변경

# 데이터 다듬기에 사용되는 함수
# filter() : 조건에 따라 관찰값을 선택
# arrange() : 특정 변수를 기준으로 관찰값을 정렬
# select() : 변수를 선택
# mutate() : 새로운 변수를 생성
# group_by() : 그룹을 생성 
# summarize() : 자료를 요약

# filter()
# 특정 조건을 만족하는 관찰값 선택 
# 기본적인 형태 : filter(df, condition)
# df : 데이터프레임
# contition : 관찰값 선택 조건 : 비교연산자(>,>=,<,<=,!=,==), 논리연산자(&,|,!), 연산자(%in%)

# 예제 데이터 Tibble로 변환
mtcars_t <- as.tibble(mtcars)

# filter로 mpg의 값이 30 이상인 자동차를 선택
filter(mtcars_t, mpg>=30)

# mpg 30 이상, wt가 1.8 미만인 자동차를 선택
filter(mtcars_t, mpg>=30 & wt<1.8)

# mpg가 30 이하, cyl은 6 or 8, am은 1 인 자동차 선택
filter(mtcars_t, mpg <= 30 & cyl %in% c(6,8) & am == 1)

# 변수 mpg의 값이 mpg의 중앙값과 Q3(제3사분위수) 사이에 있는 자동차를 선택.
# quantile(mpg,probs=0.75) 를 통해 사분위수 계산.
filter(mtcars_t, mpg >= median(mpg) & mpg <= quantile(mpg,probs=0.75))

# 벡터가 특정 두 숫자 사이에 있는지를 확인하는 방법 : x>=left & x<=right     or     between(x,left,right)
filter(mtcars_t, between(mpg, median(mpg), quantile(mpg,probs=0.75)))

# 예제 데이터 ; airquality
airs <- as.tibble(airquality)

# Ozone 과 Solar.R이 결측값인 관찰값만 선택
filter(airs, is.na(Ozone) | is.na(Solar.R))

# arrange()
# arrange(df, var_1, var_2, ---)
# df : 데이터프레임
# var_1 : 제1 정렬 기준 변수
# var_2 : var_1의 값이 같은 관찰값들의 정렬 기준
# 오름차순이 디폴트 / desc()를 입력하면 내림차순

# mpg(연비)가 제일 안 좋은 차부터 재배열
mtcars_t <- as_tibble(mtcars)
arrange(mtcars_t, mpg)

# mpg의 값이 가장 좋지 않은 자동차부터 배열하되, mpg의 값이 같은 경우에는 wt 값이 높은 자동차부터 배열.
arrange(mtcars_t, mpg, desc(wt))

# airquality를 tibble로 변환하고, 5월 1일 ~ 5월 10일 사이의 자료만을 대상으로 Ozone 값이 가장 낮았던 날부터 다시 재배열
airs_1 <- arrange(filter(airs, Month==5, Day<=10), Ozone)

# 위의 결과를 보면 NA 값이 가장 아래로 내려가 있다. 이걸 바꾸고 싶으면... : !is.na(Ozone)
arrange(airs_1, !is.na(Ozone))

# airs_1을 Ozone의 값이 가장 높은 날부터 다시 배열 하되, 결측값을 가장 앞으로 배열하여라.
arrange(airs_1, !is.na(Ozone), desc(Ozone))

# 변수선택 : select()
# 데이터 세트의 크기 증가, 변수의 개수가 수백 또는 수천이 되는 경우 발생, 분석에 필요한 변수 선택으로 데이터 세트 크기 감소
# 기본적인 사용법 : select(df, 변수 이름 or 문자열 매칭 함수)
# df : 데이터프레임
# 변수 이름 나열 : 나열된 변수만 선택
# 문자열 매칭 함수 : 변수 선택을 효과적으로 할 수 있는 함수

# mtcars의 row names를 변수 rowname으로 전환하고, 변수 rowname과 mpg 선택
mtcars_t <-  as_tibble(mtcars)
mtcars_t <- rownames_to_column(mtcars_t, var="rowname")
select(mtcars_t, rowname, mpg)

# 두 번째 변수 mpg 부터 여섯 번째 변수 wt 까지 모두 선택 -> ":" 연산자를 이용
select(mtcars_t, mpg:wt)

# 특정 변수를 제거할 때 -> "-" 기호를 이용
select(mtcars_t, -(rowname),-(qsec:carb))

# 문자열 매칭 함수
# 변수가 많은 경우 선택하고자 하는 변수의 이름을 일일이 나열하는 것은 상당히 비효율적
# starts_with("x") : 이름이 "x"로 시작하는 변수 선택.
# ends_with("x") : 이름이 "x"로 끝나는 변수 선택.
# contains("x") : 이름에 "x"가 있는 변수 선택.
# num_range("x",1:10) : x1,x2,...,x10 과 동일. 

# mtcars에서 "m" 으로 시작하는 변수 선택
select(mtcars_t, starts_with("m"))
select(mtcars_t, ends_with("p"))
select(mtcars_t, contains("a"))

# 예제 데이터 : iris
head(iris,n=5)
names(iris)
iris <- as_tibble(iris)

# "pe" 가 이름에 있는 변수 선택
select(iris,contains("pe", ignore.case=FALSE))

# "pe" 가 이름에 있는 변수 제거
select(iris,-(contains("pe", ignore.case=FALSE)))

# "Sp" 로 이름이 시작되는 변수 제거
select(iris,-(starts_with("Sp",ignore.case=FALSE)))

# "th" 로 끝나는 변수 제거
select(iris,-(ends_with("th",ignore.case=FALSE)))

# iris 에서 Species를 첫 번째 변수로 재배열
select(iris, Species, everything())

# select() 로 변수 이름을 변경 -> 선언하지 않은 변수들이 자동으로 제거(비효율적).
select(mtcars_t, Model=rowname)

# 변수이름을 변경 : rename()
rename(mtcars_t, Model=rowname)

# 새로운 변수의 추가 : mutate()
# 데이터프레임을 구성하고 있는 변수를 이용하여 새로운 변수 생성
# 기본적인 사용법 : mutate(df, 새로운 변수 생성 표현식)
# df : 데이터프레임
# 다수의 변수 생성 표현식은 "," 로 구분한다.
# 새로운 변수는 가장 마지막에 추가가 된다.

# 변수 kml과 gp_kml 을 생성하고 데이터 프레임의 처음 두 변수로 추가
# kml : 1mpg 는 0.43kml
# gp_kml : kml이 10 이상이면 "good", 10 미만이면 "bad"
mtcars_t <- as_tibble(mtcars)
mtcars_t <- rownames_to_column(mtcars_t, var="rowname")
mtcars_t <- mutate(mtcars_t, kml=mpg*0.43, gp_kml=if_else(kml>=10,"good","bad"))
select(mtcars_t, kml, gp_kml, everything())

# 만일 새로운 변수만 유지하고, 나머지 변수를 모두 삭제하려면, 함수 transmute() 를 사용하면 된다.
transmute(mtcars_t, kml=mpg*0.43, gp_kml=if_else(kml>=10,"good","bad"))

# 그룹 생성 및 그룰별 자료 요약 : group_by(), summarize()

# 요약통계량 계산 : summarize()
# 기본적인 사용법 : summarize(df, name=fun)
# 결과는 tibble 로 나옴. name 은 계산된 통계랑 값의 이름이다.

# 데이터프레임 mpg의 변수 hwy의 평균 계산
summarize(mpg, mean_hwy=mean(hwy))

# summarize() 에서 사용되는 함수
# 결과가 숫자 하나로 출력되는 함수만 사용 가능 : mean(), sd(), min(), max()
# 결과가 벡터인 함수는 사용 불가 : range()
# 유용한 함수 : 개수 새기 n(), 서로 다른 숫자의 개수 n_distinct()

# 연습하기
summarize(mpg, n=n(), n_hwy=n_distinct(hwy), avg_hwy=mean(hwy), sd_hwy=sd(hwy))
          
# 함수 group_by()
# 한 개 이상의 변수로 데이터프레임을 그룹으로 구분
# 기본적인 사용법 : group_by(df. var)

# 연습하기
by_cyl <- group_by(mpg,cyl)
summarize(by_cyl, n=n(), avg_mpg=mean(hwy))

# pipe 기능
# 한 명령문의 결과물을 바로 다음 명령문의 입력요소로 직접 사용할 수 있도록 명령문들을 서로 연결하는 기능을 의미한다.
# 이것의 장점은, 분석 중간 단계에 생성되는 많은 객체들을 따로 저장할 필요가 없기 때문에 프로그래밍이 매우 깔끔해지며,
# 분석 흐름을 쉽게 이해할 수 있다.
# Pipe 연산자 "%>%"는 tidyverse에 속한 패키지인 magrittr에 정의되어 있다.
# 기본적인 형태 : lhs %>% rhs
# lhs : 객체
# rhs : lhs를 입력요소로 하는 함수
# 예를들어 x %>% f 는 객체 x를 함수 f()의 입력요소로 하는 f(x)를 의미한다.
# 만일 rhs에 다른 요소가 있다면 lhs는 rhs의 첫 번째 입력요소가 된다.
# 따라서 x %>% f(y) 는 f(x,y,)를 의미한다.
# lhs가 rhs의 첫 번째 요소가 아닌 경우에는 원하는 위치에 마침표(.)를 찍어야한다 
# x %>% f(y,.) : f(y,x)

# 연습하기
mpg %>% group_by(cyl) %>% summarize(n=n(), avg_mpg=mean(hwy))

airs_Month <- airquality %>% group_by(Month)
# 연습문제1 : 월별 변수 Ozone의 평균값
airs_Month %>% summarize(avg_Ozone=mean(Ozone, na.rm=TRUE))
# 연습문제 2 : 월별 날수, 변수 Ozone에 결측값이 있는 날수 및 실제 측정이 된 날수
airs_Month %>% summarize(n_total=n(), n_miss=sum(is.na(Ozone)), n_obs=sum(!is.na(Ozone)))
# 연습문제 3 : 월별 첫날과 마지막 날 변수 Ozone의 값
airs_Month %>% summarize(First_Oz=first(Ozone), Last_Oz=last(Ozone))
# 연습문제 4 : 월별로 Ozone의 가장 큰 값과 가장 작은 값
airs_Month %>% summarize(Max_Oz=max(Ozone, na.rm=TRUE), Min_Oz=min(Ozone, na.rm=TRUE))
# 연습문제 5 : 월별로 Ozone의 개별 값이 전체 기간 동안의 평균값보다 작은 날수
m_Oz <- with(airquality, mean(Ozone, na.rm=TRUE))
airs_Month %>% summarize(low_Oz=sum(Ozone<m_Oz, na.rm=TRUE))

# 유용한 기능
x <- c(2,4,6,8,10)
x
first(x)
last(x)
first(x, order_by=order(-x))
nth(x,2)
nth(x,-2)
nth(x,6)
nth(x,6,default=99)

# 진짜 연습문제
air_sub1 <- as.tibble(airquality) %>% filter(Wind >= mean(Wind, na.rm=TRUE), Temp < mean(Temp, na.rm=TRUE)) %>% select(Ozone, Solar.R)
air_sub2 <- as.tibble(airquality) %>% filter(Wind < mean(Wind, na.rm=TRUE), Temp >= mean(Temp, na.rm=TRUE)) %>% select(Ozone, Solar.R)
air_sub1 %>% summarise(n=n(), m_oz=mean(Ozone, na.rm=TRUE), m_solar=mean(Solar.R, na.rm=TRUE))
air_sub2 %>% summarise(n=n(), m_oz=mean(Ozone, na.rm=TRUE), m_solar=mean(Solar.R, na.rm=TRUE))








#####################################################################################################################################
#####################################################################################################################################





library(tidyverse)


# ggplot2
# 함수 ggplot() : 데이터 프레임 data 지정. 그래프가 작성될 비어있는 좌표계 작성
# geom_point() : 실질적인 그래프, 레이어를 작성하는 geom 함수 중 하나
# mapping : geom 함수 내에서 함수 aes()와 함께 데이터와 시각적 요소를 서로 연결


# 반드시 필요한 3가지
# ggplot(data = <Data>) +
#   <Geom_Function>(mapping = aes(<Mappings>)

                  
# mapping과 setting
# mapping : 데이터 값과 연결되어 결정. 함수 aes() 안에서 연
# setting : 사용자가 일정한 값을 지정

                  
# [disp:엔진크기, hwy:고속도로연비] 산점도
ggplot(data=mpg) + 
  geom_point(mapping=aes(x=displ, y=hwy))


# 산점도에 색 변경
ggplot(data=mpg) +
  geom_point(mapping=aes(x=displ, y=hwy, color=class))


# 산점도의 점의 모양 변경
ggplot(data=mpg) +
  geom_point(mapping=aes(x=displ, y=hwy, shape=drv))


# 산점도의 점의 크기를 변경
ggplot(data=mpg) +
  geom_point(mapping=aes(x=displ, y=hwy, size=cyl))


# 산점도의 점의 모양과 색과 크기를 동시에 변경
ggplot(data=mpg) +
  geom_point(mapping=aes(x=displ, y=hwy, color=class, shape=drv, size=cyl))


# 하나의 변수로 여러 시각적 요소로 표현
ggplot(data=mpg) +
  geom_point(mapping=aes(x=displ, y=hwy, color=drv, shape=drv, size=drv))


# 사용자가 임의로 지정 -> 모든 점을 빨간색으로...(사용자 지정)
ggplot(data=mpg) +
  geom_point(mapping=aes(x=displ, y=hwy), color="red")


# 사용자가 임의로 지정 -> 모든 점을 크기가 3 으로...(사용자 지정)
ggplot(data=mpg) +
  geom_point(mapping=aes(x=displ, y=hwy), size=3)


# 여러 요소를 동시에 setting
ggplot(data=mpg) +
  geom_point(mapping=aes(x=displ, y=hwy), color="red", shape=21, size=3, fill="blue", stroke=2)


# 함수 aes() 안에서 시각적 요소에 특정 값을 setting 한 경우의 결과
# mappging은 시각적요소와 변수를 연결하는 것이므로 새로운 변수 color 가 생성된다.
ggplot(data=mpg) +
  geom_point(mapping=aes(x=displ, y=hwy),color="blue")
ggplot(data=mpg) +
  geom_point(mapping=aes(x=displ, y=hwy, color="blue"))


# 그룹별 그래프 작성 : Facet
# 범주형 변수가 다른 변수에 미치는 영향력을 그래프로 확인하는 방법
# 시각적 요소에 범주형 변수를 mapping
# 범주형 변수로 그룹을 구성하고, 각 그룹별 그래프 작성 : faceting


# facet을 적용하기 위한 함수
# 1. facet_wrap() : 한 변수에 의한 facet
# 2. facet_grid() : 한 변수 또는 두 변수에 의한 facet


# facet_wrap()에 의한 faceting
# 사용법 : facet_wrap(~x)


# 데이터 프레임 mpg에 변수 displ과 hwy의 산점도를 class의 범주별로 작성
ggplot(data=mpg) + 
  geom_point(mapping=aes(x=displ,y=hwy))+ 
  facet_wrap(~class)


# 패널 "2seater"의 경우 2개의 데이터만 존재 -> 케이스를 제거 후 다시 작성
pp <- ggplot(data=filter(mpg, class!="2seater")) + 
  geom_point(mapping=aes(x=displ,y=hwy))
pp + facet_wrap(~class)


# 패널들의 배치 조절
# 열의수 :  ncol=
# 행의 수 : nrow=
# 배치 순서 : 행단위(디폴트), 열단위(dir="v")


# 2x3 형태로 재작성
pp + facet_wrap(~class, ncol=2)
pp + facet_wrap(~class, ncol=2, dir="v")


# facet_grid()
# 한 변수에 의한 faceting
# 하나의 행으로 패널 배치 : facet_grid(.~x)
# 하나의 열으로 패널 배치 : facet_grid(x~.)
# 두 변수에 의한 faceting
# facet_grid(y~x)
# 행 범주 : y의 범주
# 열 범주 : x의 범주


# 데이터 프레임 mpg에서 데이터 변수 div와 cyl로 구분항 displ과 hwy의 산점도 작성
# 단 drv가 "r" 인 자료와 cyl이 5인 자료 제거
pp <- mpg %>% filter(drv!="r" & cyl!=5) %>% ggplot(mapping=aes(x=displ,y=hwy)) + geom_point() 
pp + facet_grid(drv~.)
pp + facet_grid(~cyl)
pp + facet_grid(drv~cyl)


# 연속형 변수를 범주형 변수로 변환 후 faceting
# cut_interval(x,n) : 벡터 x를 n개의 같은 길이의 구간으로 구분
# cut_width(x,width) : 벡터 x를 길이가 width인 구간으로 구분
# cut_number(x,n) : 벡터 x를 n개의 구간으로 구분하되 각 구간에 속한 데이터의 개수가 비슷하게 구분


# 데이터 프레임 airquality에서 변수 Ozone, Solar.R, Wind의 관계 탐색
# 1. 변수 Wind를 4개 구간으로 구분하되 속한 자료의 개수가 비슷하도록
# 2. 4개의 구간에서 Ozone과 Solor.R의 산점도 작성
airquality %>% mutate(Wind_d=cut_number(Wind, n=4)) %>%
  ggplot() + 
  geom_point(mapping=aes(x=Solar.R, y=Ozone)) +
  facet_wrap(~Wind_d)


# 변수가 큰 값을 가질수록 두 변수의 관계는 점점 미약해지고 있음.
# 세 연속형 변수의 관계 탐색 방법 중 하나


# 기하 객체 : Geometric object
# Base_graphics에서 그래프 작성 방식 : pen on paper
# 높은 수준의 그래프 함수 : 좌표축과 주요 그래프 작성
# 낮은 수준의 그래프 함수 : 점,선,문자 등을 추가하여 원하는 그래프 작성
# ggplot2에서 그패르 작성 방식
# 작성하고자 하는 그래프 : 몇몇 유형의 그래프(점,선 등등)
# 몇몇 유형의 그래프를 각기 따로 작성
# 작성된 그래프를 겹쳐 놓음으로써 원하는 그래프 작성


# 원하는 유형의 그래프(점,선 등등) 작성
# = 해당되는 기하 객체(geom)을 사용하여 그래프 작성


# 기하 객체의 사용
# 해당되는 geom 함수의 실행
# geom 함수 실행 -> 해당 유형의 그래프가 작성된 layer 작성
# 여러 개의 geom 함수 실행 : 여러 layer 생성되고 이것들이 겹쳐져서 원하는 그래프 작성


# mpg의 displ과 hwy를 대상으로 point geom과 smooth geom 적용
# point geom : 점 그래프 작성
# smooth geom : 비모수 회귀곡선 작성
ggplot(data=mpg) + 
  geom_point(mapping=aes(x=displ,y=hwy))
ggplot(data=mpg) + 
  geom_smooth(mapping=aes(x=displ,y=hwy))
ggplot(data=mpg) + 
  geom_smooth(mapping=aes(x=displ,y=hwy), se=FALSE)        # se=FALSE : 신뢰구간 삭제
ggplot(data=mpg) + 
  geom_smooth(mapping=aes(x=displ,y=hwy), method="lm")     # mehtod="lm" : 회귀곡선 그리기


# geom 함수 리스트
# 현재 대략 30개 이상의 geom 함수가 있다.
# 한 변수에 대한 함수 : geom_bar(), geom_hisogram(), geom_density(), geom_dotplot() 등등
# 두 변수에 대한 함수 : geom_point(), geom_smooth(), geom_text(), geom_line(), geom_boxplot() 등등
# 세 변수에 대한 함수 : geom_contour(), geom_tie() 등등
# 메뉴 -> help -> Cheatsheets -> Data Visualiztaion with ggplot2 에서 확인 가능


# 글로벌 매핑과 로컬 매핑
# 글로벌 매핑 : 함수 ggplot() 에서의 매핑, 해당 그래프 작성에 참여한 모든 geom 함수에 적용
# 로컬 매핑 : geom 함수에서의 매핑 해당 geom 함수로 작성되는 layer 에만 적용. 해당 layer 에서는 글로벌 매핑보다 우선해서 적용됨.


# 산점도와 비모수 회귀곡선 함께 그리기
ggplot(data=mpg,mapping=aes(x=displ,y=hwy)) + 
  geom_point() + 
  geom_smooth()


# 연습문제 : mpg의 변수 displ과 hwy의 비모수 회귀곡선 작성. 그 위에 산점도 추가하되 drv의 값에 따라 점의 색을 구분.
ggplot(data=mpg,mapping=aes(x=displ,y=hwy)) + 
  geom_smooth(se=FALSE) + 
  geom_point(mapping=aes(color=drv))


# 연습문제 : mpg의 변수 displ과 hwy의 비모수 회귀 곡선과 산점도를 drv에 따라 각각 작성.
ggplot(data=mpg,mapping=aes(x=displ,y=hwy,color=drv)) + 
  geom_smooth(se=FALSE) + 
  geom_point()


# 연습문제 : 비모수 회귀곡선의 선의 종류를 다르게 하고, 산점도의 점의 색을 구분짓고, 점을 확대해 보자.
ggplot(data=mpg,mapping=aes(x=displ,y=hwy)) + 
  geom_smooth(mapping=aes(linetype=drv),se=FALSE) + 
  geom_point(mapping=aes(color=drv),size=2)


# 연습문제 : drv의 그룹별로 따로 비모수 회귀곡선 작성하되, 선의 색과 종류는 같은 것을 사용
ggplot(data=mpg,mapping=aes(x=displ,y=hwy)) +
  geom_point() + 
  geom_smooth(mapping=aes(group=drv),se=FALSE)


# 각 geom 함수에서 다른 데이터 사용
# 각 geom 함수로 작성되는 layer마다 다른 데이터로 그래프 작성 가능


# 연습문제 : mpg의 변수 displ과 hwy의 산점도 drv에 따라 점의 색 구분하고, 비모수 회귀곡선 추가하되, drv=4 인 데이터만 추정.
ggplot(data=mpg,mapping=aes(x=displ,y=hwy)) + 
  geom_point(mapping=aes(color=drv)) + 
  geom_smooth(data=filter(mpg,drv==4),se=FALSE, color="red")


# 통계적 변환 : Statistical transformation
# 그래프에 사용되는 자료 : 산점도
# 입력된 자료를 대상으로 통계적 변환 과정을 거져 생성된 자료 : 비모수 회귀곡선 그래프


# 통계적 변환 : stat
# 입력된 데이터 프레임 자료의 변환을 의미
# 각 그래프 유형별 대응되는 stat 존재
# 산점도 : stat="identity"
# 비모수 회귀곡선 : stat="smooth"
# 막대 그래프 : stat="count"
# 각 geom 함수마다 대응되는 디폴트 stat 존재
# geom_point() -> geom_point(stat="identity")
# geom_smooth() -> geom_smooth(stat="smooth")
# geom_bar() -> geom_bar(stast="count")


# stat 함수
# geom 함수 대신 stat 함수로 그래프 작성 가능
# stat_identity = stat_identity(geom="point")
# stat_smooth = stat_smooth(geom="smooth")
# stat_count = stat_count(geom="bar")


# 연습문제 : mpg의 trans의 막대 그래프 작성
ggplot(data=mpg, mapping=aes(x=trans)) + 
  geom_bar()
ggplot(data=mpg, mapping=aes(x=trans)) + 
  stat_count()


# stat으로 계산된 변수의 이용
# stat 함수 : 입력된 데이터 프레임을 대사으로 변환을 실시하여 그래프 작성에 필요한 변수로 이루어진 데이터 프레임을 내부적으로 생성
# 생성된 변수를 사용자가 직접 지정해서 사용 가능
# 예 : 함수 geom_bar() 혹은 stat_count() 에서 계산된 변수
#      변수 count : 각 범주의 빈도
#      변수 prop : 그룹별 비율
#      계산된 변수를 사용자가 지정할 때에는 변수를 "." 기호로 감싸야 함 -> 원래 데이터 프레임에 있는 변수와 혼동 방지
#      ..count.. 혹은 ..prop..


# 상대빈도수로 그래프 그리기
# 모든 범주를 하나의 변수로 잡기 위해 group=1 (아무 숫자나 문자 상관없다.)
ggplot(data=mpg, mapping=aes(x=trans,y=..prop..,group=1)) + 
  geom_bar()


# auto 끼리 manual 끼리 묶어서 막대 그래프를 그려보자.
mpg %>% mutate(am=substr(trans,1,nchar(trans)-4)) %>%
  ggplot() + 
  geom_bar(mapping=aes(x=am,group=1))


# 통합된 범주의 도수분포 tibble 작성
mpg_am <- mpg %>% mutate(am=substr(trans,1,nchar(trans)-4)) %>% 
  group_by(am) %>% summarize(n=n())
mpg_am


# mpg_am 을 가지고 그래프 그리기 => stat="identity" 사용하기
ggplot(data=mpg_am) + 
  geom_bar(mapping=aes(x=am, y=n),stat="identity")


# 위치 조정 : Position adjustments
# 그래프 요소들의 위치 조정
#  - 연속형 자료 : 산점도의 점이 겹쳐지는 경우
#  - 범주형 자료 : 이변량 막대 그래프 작성


# 산점도의 점이 겹치는 문제 : 산점도 작성의 가장 큰 문제
# -> 반올림 처리 등으로 같은 값이 많은 자료의 경우 : 자료에 약간의 난수를 더해 점의 위치 조정. jittering
# -> 대규모의 자료가 좁은 구역에 몰려서 한 무리를 형성하는 경우 : 추후에 다룰 예정


# 이변량 막대 그래프
# -> 쌓아 올린 막대 그래프 / 옆으로 붙여 놓은 막대 그래프 / mosaic plot


# jittering 을 활용하기
# 1. mpg에서 변수 cty와 hwy의 산점도 작성
ggplot(data=mpg) + 
  geom_point(mapping=aes(x=cty,y=hwy))
# 2. 총 데이터는 234개 이지만 그래프의 점의 개수는 몇 개 안된다. 
# -> Position="jitter" 를 적용
ggplot(data=mpg) + 
  geom_point(mapping=aes(x=cty,y=hwy),position="jitter")


# 함수 geom_jitter() 사용하기
ggplot(data=mpg,mapping=aes(x=cty,y=hwy)) + 
  geom_jitter(width=0.4, height=0.05)
ggplot(data=mpg,mapping=aes(x=cty,y=hwy)) + 
  geom_jitter(width=0.05, height=0.4)


# 회귀직선 추가하기
ggplot(data=mpg,mapping=aes(x=cty,y=hwy)) + 
  geom_jitter(width=0.4, height=0.05) + 
  geom_smooth(mehtod="lm", se=FALSE)


# 예제 데이터 diamonds에서 변수 carat과 price의 산점도
ggplot(data=diamonds) + 
  geom_point(mapping=aes(x=carat,y=price))


# 점이 너무 많아서 산점도의 구분이 안간다. -> 산점도 내에서는 해결이 불가능하다.


# 이변량 막대 그래프 작성
# 막대 그래프 작성 : geom_bar()
# 이변량 막대 그래프 함수 geom_bar()에서 시각적 요소 x와 fill,position 사용


# mpg에서 trans의 범주를 auto와 manual로 통합한 변수 am 생성.
# 변수 cyl이 5인 케이스를 제거후 am과 cyl의 이변량 막대 그래프 작성
# as.factor(cyl) 를 안넣어주면 x축이 3,4,5,6,... 다 생긴다.
mpg_1 <- mpg %>% mutate(am=substr(trans,1,nchar(trans)-4)) %>% filter(cyl!=5)
p1 <- ggplot(data=mpg_1,mapping=aes(x=as.factor(cyl),fill=am)) + 
  xlab("Number of Cylinders")


# 위로 쌓아 올린 막대 그래프 : position="stack" 이 디폴트값
p1 + geom_bar(position="stack")


# 옆으로 쌓아 올린 막대 그래프
p1 + geom_bar(position="dodge")
p1 + geom_bar(position="dodge2")


# 조건부 확률로 막대그래프 쌓아 올리기 : position="fill"
p1 + geom_bar(position="fill")


# 나란히 서 있는 상자그림
# - geom_boxplot()
# - 필요한 시각적 요소 : x = 그룹을 구성하는 변수(요인)
#                        y = 연속형 변수


# mpg_1에서 cyl 마다 hwy의 상자그림 그리기. (cyl=5는 제외)
mpg_1 <- mpg %>% mutate(am=substr(trans,1,nchar(trans)-4)) %>% filter(cyl!=5) %>% group_by()
ggplot(data=mpg_1) + 
  geom_boxplot(mapping=aes(x=as.factor(cyl),y=hwy)) + 
  xlab("Number of Cylinders")


# 그룹을 구성하는 변수가 두 개인 경우의 상자그림
# 변수 am에 따라 다른 색이 채워져있 두 상자그림이 옆에 붙어있다.
# 필요한 시각적 요소 : x,y,fill,position
# position="dodge"가 디폴트로 적용됨.
ggplot(data=mpg_1,mapping=aes(x=as.factor(cyl),y=hwy)) + 
  geom_boxplot(mapping=aes(fill=am)) + 
  xlab("Number of Cylinders")


# 중간고사 연습하기 #


library(tidyverse)


# [연습문제 1번]
lattice::barley %>% as.tibble() %>%
  ggplot(mapping=aes(x=yield,y=variety,color=year)) + 
  geom_point() + 
  facet_wrap(~site)


# [연습문제 2번]
lattice::barley %>% as.tibble() %>%
  ggplot(mapping=aes(x=yield,y=variety,color=site)) + 
  geom_point(mapping=aes(shape=year))


# [연습문제 3번]
lattice::barley %>% as.tibble() %>%
  group_by(variety) %>%
  summarise(mean_yield=mean(yield)) %>%
  arrange(desc(mean_yield))


# [연습문제 4번]
mpg %>% group_by(fl) %>%
  summarise(n=n())


# [연습문제 5번]
mpg %>% mutate(am=substr(trans,1,nchar(trans)-4)) %>% 
  filter(fl=="r"|fl=="p") %>% 
  ggplot() + 
  geom_bar(mapping=aes(x=fl,y=..prop..,group=1))


# [연습문제 6번]
mpg %>% group_by(trans) %>%
  summarise(n=n())


# [연습문제 7번]
mpg %>% mutate(am=substr(trans,1,nchar(trans)-4)) %>% 
  filter(fl=="r"|fl=="p") %>% 
  ggplot(mapping=aes(x=fl,fill=am))+
  geom_bar(position = "fill")


# [연습문제 8번]
mpg %>% filter(fl %in% c("p","r")) %>% 
  ggplot() +
  geom_boxplot(mapping=aes(x=fl,y=hwy))


# [연습문제 9번]
mpg %>% filter(fl %in% c("p","r")) %>% 
  mutate(am=substr(trans,1,nchar(trans)-4)) %>% 
  ggplot(mapping=aes(x=fl,y=hwy)) + 
  geom_boxplot() +
  facet_wrap(~am,ncol=1)


# 중간고사 문제풀이
library(tidyverse)


# 문제 1번
airquality %>% as.tibble() %>% print(n=5)


# 문제 2번
airquality %>% as.tibble() %>% group_by(Month) %>% 
  summarise(Oz_mean=mean(Ozone,na.rm=TRUE)) %>%
  ggplot(mapping=aes(x=Month,y=Oz_mean)) + 
  geom_bar(stat="identity",fill="steelblue") + 
  ylab("Month Ozone")


# 문제3번
airquality %>% as.tibble() %>% 
  mutate(group=if_else(Wind>=mean(Wind,na.rm=TRUE),"High Wind","Low wind")) %>% 
  ggplot(mapping=aes(x=Solar.R,y=Ozone)) + 
  geom_point() + 
  facet_wrap(~group,ncol=2)


# 문제4번
mtcars_t <- mtcars %>% as.tibble() %>% rownames_to_column(var="model") %>% 
  select(model,mpg,disp,wt) %>% arrange(mpg,desc(disp))
print(mtcars_t,n=5)


# 문제5번
mtcars_t %>% mutate(gp_wt=if_else(wt>=median(wt),"Heavy","Not Heavy")) %>% 
  ggplot(mapping=aes(x=disp,y=mpg,color=gp_wt)) + 
  geom_point() + 
  geom_smooth(se=FALSE,method="lm")
  
# 문제6번
mtcars_t %>% mutate(gp_wt=if_else(wt>=median(wt),"Heavy","Not Heavy")) %>% 
  ggplot(mapping=aes(x=disp,y=mpg)) + 
  geom_point() + 
  geom_smooth(se=FALSE,method="lm") + 
  facet_wrap(~gp_wt,ncol=2)


# 패키지 로딩
library(tidyverse)
library(car)


# Coordinate System
# 좌표계 : 시각적 요소 x와 y를 근거로 그래프의 각 요소의 2차원 위치를 결정하는 체계
# 좌표계의 종류
# - coord_cartesian() : 디폴트
# - coord_flip() : cartesian 에서 x축, y축을 돌림
# - coord_polar() : 극좌표


# coord_cartesian() 의 활용 : XY축 범위 조정
# mpg에서 displ과 hwy에 비모수 회귀곡선 추가한 그래프 작성
# X축의 범위를 (3,6)으로 축소한 그래프 작성
p <- mpg %>% ggplot(mapping=aes(x=displ,y=hwy)) + 
  geom_point() + 
  geom_smooth(se=FALSE)
p + coord_cartesian(xlim=c(3,6))


# scale에 의한 XY축 범위 조정
# - scale : 자료와 시각적 요소의 매핑 및 XY축과 범례 등의 내용 조정을 의미
# - 대부분의 경우 디폴트 상태에서 그래프 작성
# - XY축 범위 조정, XY축 라벨 변경이 필요한 경우네는 scale 함수를 사용하며 조정
# - scale 함수의 일반적인 형태 : scale_*1*_*2*()
#   - *1* : 수정하고자 하는 시각적 요소 : color, x, y, fill 등등
#   - *2* : 적용되는 scale 지정 : discrete,continous 등등


# 예 : 연속형 X 변수의 범위 (3,6)으로 수정 : scale_x_continous(limits=c(3,6))
# 예 : 연속형 X축의 라벨 변경 : scale_x_continous(name="Engine")


# 간편함수
# - XY축 범위 조정 : xlim(3,6), ylim(0,1)
# - XY축 라벨 변경 : xlab("Engine"), ylab(), labs(x="Engine")


# 데이터를 아예 자름. (NA 처리)
p + xlim(3,6) + xlab("Engine Displacement")
# 데이터는 전체가 다 있지만 보여주는게 다름.
p + coord_cartesian(xlim=c(3,6)) + xlab("Engine Displacement")


# 함수 coord_flip()의 활용 : 평행한 상자그림 작성
# - 대부분의 geom 함수 : 주어진 X값에 대한 분포 표현
# - 상자그림 : 수직 방향의 작성되는 것이 디폴트
# - 수평 방향 상자 그림 : 디폴트 방향으로 작성하고, 그래프의 좌표를 90도 회전
# - 함수 coord_flip() : 작성된 그래프의 좌표 회전


# mpg에서 class의 그룹별로 hwy의 상자그림 작성
mpg %>% ggplot(mapping=aes(x=class,y=hwy)) + 
  geom_boxplot() + coord_flip()


# 한 변수의 상자그래프 작성
# - 함수 geom_boxplot()에는 x와y 모두 필요
# - x에는 하나의 값, y에는 연속형 변수 매핑
mpg %>% ggplot(mapping=aes(x="",y=hwy)) + 
  geom_boxplot() + xlab("")
mpg %>% ggplot(mapping=aes(x="",y=hwy)) + 
  geom_boxplot() + xlab("") + coord_flip()


# 함수 coord_polar()의 활용 : 파이 그래프 작성
# - 극좌표(polar coordinate) : 2차원 공간의 어느 한 점의 위치를 원점에서 거리와 각도로 표헌
# - 함수 coord_polar() : 데카르트 좌표를 극 좌표로 전환
# - 변수 theta : 시각적 요소 x와 y 중 각도로 전환할 요소 지정 (디폴트는 theta="x")


# 함수 cooord_polar()를 활용하여 막대 그래프에서 변형된 그래프
# - Coxcomb 또는 Wind rose 그래프
# - 파이 그래프
# - Bullseye


# mpg의 변수 class의 Coxcomb 그래프 작성
# 막대그래프 작성
# - 각 막대마다 다른 색 사용
# - 막대 사이 간격 제거
# - 범례 제거
b <-  mpg %>% ggplot(mapping=aes(x=class,fill=class)) + 
  geom_bar(show.legend=FALSE,width=1) + 
  labs(x="",y="")
b
# show.legen=FASLE : 범례 제거
# withd=90%를 차지하는 0.9가 디폴트


# Coxcomb 그래프
# - 막대그래프(데카르트 좌표)
# - x변수 : 막대의 폭 (같은 값)
# - y변수 : 막대의 높이(다른 값)
b + coord_polar()


# mpg의 변수 class의 파이 그래프 작성
# 막대그래프 작성
# - 각 막대마다 다른 색 사용
# - 쌓아 올린 형태로 작성
# - 막대의 폭을 X축 전체 구간으로 확장
b2 <- mpg %>% ggplot(mapping=aes(x="",fill=class)) + 
  geom_bar(width=1) + labs(x="",y="")


# 파이 그래프
# - 각 조각의 각도 ; 막대의 높이에 비례
# - 각 조각의 반지름 : 막대의 폭에 비례
b2 + coord_polar(theta="y")


# theta="x"로 함수 coord_polar() 실행 : Bullseye 그래프 작성
b2 + coord_polar()


# 도넛 그래프 작성
# - 파이 그래프의 가운데 부분이 없는 그래프
# - Donut 그래프 혹은 ring 그래프
b3 <- mpg %>% ggplot(mapping=aes(x=1, fill=class)) + 
  geom_bar(width=0.5) + labs(x="",y="") + xlim(0.5, 1.5)
b3 + coord_polar(theta="y")


# 일변량 자료탐색 #


# 범주형 자료를 위한 그래프
# - 막대 그래프
# - 파이 그래프
# - Cleveland의 점 그래프


# 연속형 자료를 위한 그래프
# - 줄기잎 그림
# - 상자그림
# - Violin plot
# - 히스토그램
# - 확률밀도함수 그래프
# - 도수분포다각형
# - 점그래프(dot plot)
# - 경험적 누적분포함수 그래프


# Input Data가 요인인 경우 - 막대 그래프 그리기 (데이터 : state.region)
str(state.region)
state.region[1:5]
ggplot(data.frame(state.region), aes(x=state.region)) + 
  geom_bar(fill="darkgreen") + labs(x="Region")
ggplot(data.frame(state.region), aes(x=state.region)) + 
  geom_bar(fill="orange") + labs(x="Region")+ coord_flip()


# Input Data가 도수분포표인 경우 - 막대 그래프 그리기 (데이터 : state.region)
counts <- table(state.region)
ggplot(data.frame(counts), aes(x=state.region, y=Freq)) + 
  geom_bar(stat="identity", fill="skyblue") + labs(x="Region")
ggplot(data.frame(counts), aes(x=state.region, y=Freq)) + 
  geom_bar(stat="identity", fill="skyblue") + labs(x="Region") + coord_flip()


# geom_col()은 geom_bar(stat="identity")와 같은 의미이다. 
ggplot(data.frame(counts), aes(x=state.region, y=Freq)) + 
  geom_col() + labs(x="Region")


# 파이그래프 그리기 (데이터 : state.region)
ggplot(data.frame(state.region), aes(x="", fill=state.region)) + 
  geom_bar(width=1) + labs(x="", y="") + coord_polar(theta="y")


# 파이그래프에 라벨을 넣기
pct <- paste0(100*counts/sum(counts),"%")


# 패키지 scales의 함수 percent() 이용하기
library(scales)
counts <- table(state.region)
df_2 <- as.data.frame(counts) %>% mutate(pct=percent(Freq/sum(Freq)))


# 조각의 백분율을 라벨로 추가한 막대 그래프 작성 후 파이그래프 그리기
# postion_stack() : 쌓아 올린 막대 그래프의 각 조각에 라벨 추가 시 매우 유용하게 사용
# vjust : 0(bottom), 0.5(middle), 1(top,디폴트)
bar <- df_2 %>% ggplot(aes(x="", y=Freq, fill=state.region)) + 
  geom_col(width=1) + 
  geom_text(aes(label=pct), size=5, position=position_stack(vjust=0.5))
bar + coord_polar(theta="y")


# 도넛 그래프 그리기
bar2 <- df_2 %>% ggplot(aes(x=1, y=Freq, fill=state.region)) + 
  geom_col(width=0.33) + xlim(0.5, 1.5) + 
  geom_text(aes(label=pct), size=5, position=position_stack(vjust=0.5))
bar2 + coord_polar(theta="y")


# Cleveland의 점 그래프
df_2 %>% ggplot(aes(x=Freq, y=state.region)) + geom_point(size=2) + 
  theme(panel.grid.major.y=element_line(linetype=2, color="darkgray")) + 
  labs(x="",y="")


# 연습하기
library(tidyverse)
library(scales)
cars <- mutate(as.tibble(MASS::Cars93), 
               group=cut(EngineSize,breaks=c(min(EngineSize),1.6, 2.0,max(EngineSize)),
                         labels = c("Small","Mid","Large"))) %>% 
  group_by(group) %>% summarise(Freq=n()) %>% mutate(pct=percent(Freq/sum(Freq)))
# 문제 1번
ggplot(cars) + geom_bar(aes(x=group,y=Freq),stat="identity") + labs(x="",y="")
# 문제 2번
ggplot(cars,aes(x="",y=Freq,fill=group)) + geom_bar(stat="identity") + 
  coord_polar(theta="y") + geom_text(aes(label=pct), size=5, position=position_stack(vjust=0.5)) + 
  labs(x="",y="")
# 문제 3번
ggplot(cars, aes(x=Freq, y=group)) + geom_point(size=2) + 
  theme(panel.grid.major.y=element_line(linetype=2, color="darkgray")) + labs(x="",y="")


# 연속형 자료를 위한 그래프


# 줄기-잎 그래프
# stem(x,scale=1)
# x : 숫자형 벡터
# scale : 그래프의 길이 조절. 줄기의 세분화 정도 조절


# women의 변수 height의 줄기-잎 그림
with(women, stem(height))


# 옵션 scale 조절이 필요한 경우
x <- c(98,102,114,122,132,144,106,117,151,118,124,115)
stem(x)
stem(x,scale=2)


# UsingR::alltime.movies의 변수 Gross의 상자그림
library(UsingR)
bp <- ggplot(alltime.movies, aes(x="",y=Gross)) + geom_boxplot() + labs(x="")
bp
bp + coord_flip()


# 상자 그림에 자료의 위치를 점으로 표시
# - geom_point() 추가
# - 상자 그림에서 이상값을 원으로 표시하는 것 중지 : 자료의 점과 겹쳐짐
# - outlier.shape=NA
bp1 <- ggplot(alltime.movies, aes(x="",y=Gross)) + geom_boxplot(outlier.shape=NA) + labs(x="")
bp1 + geom_point(col="red")

# 자료의 점이 겹쳐짐 -> geom_jitter() 사용이 필요하다.
bp1 + geom_jitter(width=0.02,col="red")


# 상자그림에 평균값 표시
# - 함수 stat=summary() : 자료의 요약 통계량을 그래프로 표시
#                         하나의 x값에 대하여 주어진 y값의 요약 통계량 값 계산
#                         원하는 요약 통계량 : 변수 fun.y 에 지정
#                         원하는 그래프 형태 : 변수 geom에 지정
ggplot(alltime.movies, aes(x="", y=Gross)) + geom_boxplot() + 
  stat_summary(fun.y="mean", geom="point", color="red", shape=3, size=4, stroke=2) + labs(x="")


# Max, Min, Mean 표시
ggplot(alltime.movies, aes(x="", y=Gross)) + geom_boxplot() + 
  stat_summary(fun.y="mean", geom="point", color="red", shape=3, size=4, stroke=2) + labs(x="") + 
  stat_summary(fun.y="min", geom="point", color="steelblue", shape=3, size=4, stroke=2) + 
  stat_summary(fun.y="max", geom="point", color="steelblue", shape=3, size=4, stroke=2)


# 이상값으로 표시된 자료 확인
# base graphics 함수인 boxplot() 결과물 이용
my_box <- with(alltime.movies, boxplot(Gross))
alltime <- as.tibble(alltime.movies) %>% rownames_to_column(var="Movie.title")
top_movies <- alltime %>% filter(Gross %in% my_box$out)
top_movies


# 연습문제 2-1
MASS::Cars93 %>% as.tibble() %>% ggplot(aes(x="",y=MPG.city)) + geom_boxplot() + coord_flip() + 
  stat_summary(fun.y="mean", geom="point", col="red", size=3)


# 연습문제 2-2
my_box_2 <- with(MASS::Cars93, boxplot(MPG.city))
df <- as.tibble(MASS::Cars93) %>% rownames_to_column(var="ROWNAME")
OUTLIER <- df %>% filter(MPG.city %in% my_box_2$out) %>% 
  select(Manufacturer, Model, MPG.city, Weight) %>% arrange(desc(Weight)) %>% print()


# 연습문제 2-3
OUTLIER_2 <- mutate(OUTLIER, FULL.NAME=paste(Manufacturer,Model))
MASS::Cars93 %>% as.tibble() %>% ggplot(aes(x=Weight,y=MPG.city)) + 
  geom_point() + geom_text(OUTLIER_2,mapping=aes(label=FULL.NAME),nudge_x=250,size=4)
  

# 연습문제 2-4
df_outlier <- df %>% mutate(FULL.NAME=paste(Manufacturer,Model)) %>% 
  filter(FULL.NAME != "Geo Metro" & FULL.NAME != "Suzuki Swift" & FULL.NAME != "Honda Civic")
MASS::Cars93 %>% as.tibble() %>% ggplot(aes(x=Weight,y=MPG.city)) + 
  geom_point() + geom_text(OUTLIER_2,mapping=aes(label=FULL.NAME),nudge_x=350,size=4) + 
  geom_smooth(data=df_outlier,aes(col="Exclude outliers"),method="lm",se=FALSE) + 
  geom_smooth(aes(col="Use all data"),method="lm",se=FALSE)


# Violin plot
# - 함수 geom_violin()으로 작성
# - 확률밀도함수 그래프를 대칭으로 작성한 그래프
# - 상자그림과 겹쳐서 작성하는 것이 일반적인 형태


# 연습 : UsingR::alltime.movies 변수 Griss의 violin plot 작성
vio <- ggplot(UsingR::alltime.movies, aes(x="",y=Gross)) + labs(x="")
vio + geom_violin()


# Violin plot에 분위수 위치 표시 : draw_quantiles에 원하는 분위수 지정
vio + geom_violin(draw_quantiles=c(0.25,0.5,0.75),fill="skyblue")


# Violin plot 에서 boxplot 추가하기
vio + geom_violin(draw_quantiles=c(0.25,0.5,0.75),fill="skyblue") + 
  geom_boxplot(fill="darkgreen",width=0.2)


# 함수 geom_boxplot() 과 geom_violin()의 순서를 바꿔서 그리면...?
vio + geom_boxplot(fill="darkgreen",width=0.2) + 
  geom_violin(draw_quantiles=c(0.25,0.5,0.75),fill="skyblue")


# 투명도를 높여준다. : 옵션 alpha
vio + geom_boxplot(fill="darkgreen",width=0.2) + 
  geom_violin(draw_quantiles=c(0.25,0.5,0.75),fill="skyblue",alpha=0.5)


# 히스토그램
# - 함수 : geom_histogram()
# - 히스토그램의 구간 조절 : bins(구간의 개수) 혹은 binwidth(구간의 폭)


# 연습 : faithful의 waiting의 histogram
h <- ggplot(data=faithful,aes(x=waiting))
h + geom_histogram()
h + geom_histogram(bins=20)
h + geom_histogram(binwidth=3)


# 확률밀도함수 그래프
# - 연속형 자료의 분포 표현에 가장 적합한 그래프
# - 함수 geom_density()로 작성


# 다른 그래프의 문제
# - 줄기-잎 그림 : 대규모 데이터에는 적합하지 않음
# - 상자그림 : 분포의 세밀한 특징이 나타나지 않음
# - 히스토그램 : 매끄럽지 않은 계단함수의 형태


# 연습 : faithful의 waiting의 확률밀도함수
h <- ggplot(data=faithful,aes(x=waiting))
h + geom_density(fill="steelblue")


# X의 구간을 확대 : 함수 xlim() 사용
h + geom_density(fill="steelblue") + xlim(30,110)


# 자료의 위치 추가 : 함수 geom_rug()
# 중복된 자료로 인해 모든 자료가 표현되지 않는다. -> jitter 로 해결 불가능(X,Y 둘 다 필요)
h + geom_density(fill="steelblue") + xlim(30,110) + geom_rug()


# 확률밀도함수와 히스토그램 동시에 작성
# 히스토그램을 빈도가 아닌 비율로 작성 : y=..density..
h <- ggplot(data=faithful,aes(x=waiting,y=..density..))
h + geom_histogram(fill="steelblue",binwidth=5) + 
  geom_density(col="red",size=1) + xlim(30,110)


# geom_density와 geom_histogram의 순서를 바꾸면...?
h + geom_density(col="red",size=1) + 
  geom_histogram(fill="steelblue",binwidth=5,alpha=0.75) + xlim(30,110)


# 도수분포다각형(Frequency polygon)
# - 히스토그램 : 각 구간에 속한 자료의 도수를 높이로 하는 막대
# - 도수분포다각형 : 각 구간의 도수를 선으로 연결
# - 함수 geom_freqpoly()
pp <- ggplot(data=faithful,aes(x=waiting))
pp + geom_freqpoly(binwidth=5)                        # 빈도수로 그림
pp + geom_freqpoly(aes(y=..density..),binwidth=5)     # 비율로 그림 


# 연습문제 1-1 
MASS::Cars93 %>% ggplot(aes(x=EngineSize,y=..density..)) + 
  geom_histogram(binwidth=0.4,fill="rosybrown") + 
  geom_density(col="blue",size=0.5) + 
  xlim(0,7)
MASS::Cars93 %>% ggplot() + 
  geom_boxplot(aes(x="",y=EngineSize)) + 
  coord_flip() + 
  labs(title="Boxplot of EngineSize", x="", y="")
  

# 연습문제 1-2
my_box_1 <- with(MASS::Cars93, boxplot(EngineSize))
df <- as.tibble(MASS::Cars93) %>% rownames_to_column(var="ROWNAME")
OUTLIER <- df %>% filter(EngineSize %in% my_box_1$out) %>% select(Manufacturer, Model)
print(OUTLIER)


# 연습문제 1-3
result <- MASS::Cars93 %>% filter(EngineSize!=5.7) %>% 
  summarise(mean=mean(EngineSize),sd=sd(EngineSize))
round(result,3)


# 연습문제 1-4
p <- MASS::Cars93 %>% 
  mutate(group=cut(EngineSize,breaks=c(0,1.6,2.0,10),labels=c("Small","Mid","Large"))) %>%
  filter(!is.na(group)) %>% 
  group_by(group) %>% 
  summarise(Freq=n()) %>% 
  mutate(pct=percent(Freq/sum(Freq)))
p %>% ggplot() + geom_bar(aes(x=group,y=Freq),stat="identity")
p %>% ggplot(aes(x="",y=Freq, fill=group)) + 
  geom_col(width=1) + 
  geom_text(aes(label=pct), size=5, position=position_stack(vjust=0.5)) + 
  coord_polar(theta="y")
p %>% ggplot(aes(x=Freq,y=group)) + geom_point(size=2) + 
  theme(panel.grid.major.y=element_line(linetype=2, color="darkgray")) + 
  labs(x="",y="")


# 이변량 자료 탐색
# (1) 각 변수의 개별 분포 파악
# (2) 두 변수의 분포 비교
# (3) 두 변수의 관계 탐색


# 이변량 범주형 자료
# 막대그래프 : 쌓아 올린 형태, 옆으로 붙여 놓은 형태
# Mosaic plot


# 이변량 연속형 자료
# 분포 비교를 위한 그래프
# 관계 탐색을 위한 그래프


# 연속형 변수의 분포를 비교하기 위한 그래프
# mpg의 변수 cyl에 따른 hwy의 분포 비교, cyl가 5 인 케이스는 매우 적으므로 제거
mpg_1 <- mpg %>% filter(cyl!=5)
ggplot(mpg_1, aes(x=hwy)) + 
  geom_histogram(binwidth=5) + 
  facet_wrap(~cyl)


# 3개의 히스토그램을 겹처서 그리기
ggplot(mpg_1,aes(x=hwy,fill=factor(cyl))) + 
  geom_histogram(binwidth=5, alpha=0.3)


# 도수분포다각형에 의한 그룹 자료의 분포 비교
ggplot(data=mpg_1,aes(x=hwy)) + 
  geom_freqpoly(binwidth=5) + 
  facet_wrap(~cyl)


# 도수분포다각형 겹처처 그리기
p <- ggplot(data=mpg_1,aes(x=hwy,col=factor(cyl))) 
p + geom_freqpoly(binwidth=5)
p + geom_freqpoly(aes(y=..density..),binwidth=5)


# 상자그림에 의한 그룹 자료의 분포 비교
ggplot(mpg_1,aes(x=factor(cyl),y=hwy)) + 
  geom_boxplot() + 
  labs(x="Number of Cylinders", y="MPG")


# 상자그림에 의한 그룹 자료의 분포 비교
# - 표준정규분포, t(3) 분포, Unif(-1,1)에서 각각 100개 난수 추출
# - 세 자료의 분포를 상자그림으로 비교
set.seed(1234)
x1 <- rnorm(n=100, mean=0, sd=1)
x2 <- rt(n=100, df=3)
x3 <- runif(n=100, min=-1, max=1)
data.frame(x=rep(1:3,each=100),y=c(x1,x2,x3)) %>%
  ggplot(aes(x=factor(x),y=y)) + 
  geom_boxplot() +
  scale_x_discrete(labels=c("N(0,1)","t(3)","Unif(-1,1)")) + 
  labs(x="Function",y="Distribution")


# mpg의 변수 hwy의 상자그림을 class의 수준별로 상자그림 작성
mpg %>% ggplot(aes(x=class,y=hwy)) + 
  geom_boxplot()


# hwy의 중앙값에 따라 배열하는 것이 분포 비교에 더 좋다.
mpg %>% ggplot(aes(x=reorder(class,hwy,FUN=median),y=hwy)) + 
  geom_boxplot()


# hwy의 평균값에 따라 배열한 상자그림
mpg %>% ggplot(aes(x=reorder(class,hwy,FUN=mean),y=hwy)) + 
  geom_boxplot() + 
  labs(x="",y="Hwy")


# 다중 점 그래프에 의한 그룹 자료의 분포 비교
# - 자료의 전 범위를 구간으로 구분
# - 각 구간에 속한 자료에 한 개당 하나의 점을 위로 쌓아 올리는 그래프
# - 소규모 자료에 적합
ggplot(mpg, aes(x=hwy)) + 
  geom_dotplot(binwidth=0.5)


# mpg의 변수 cyl에 따른 다중 점 그래프
# binaxis : 구간 설정 대상이 되는 축 (디폴트 : "x")
# stackdir : 점을 쌍하 가는 방향, "up","center","down"
mpg_1 <- filter(mpg,cyl!=5)
ggplot(mpg_1,aes(x=factor(cyl),y=hwy)) + 
  geom_dotplot(binaxis="y", binwidth=0.5, stackdir="center")


# 확률밀도함수 그래프에 의한 그룹 자료의 분포 비교
ggplot(mpg_1,aes(x=hwy)) + 
  geom_density() + 
  xlim(5,50) + 
  facet_wrap(~cyl, ncol=1)

ggplot(mpg_1,aes(x=hwy,fill=factor(cyl))) + 
  geom_density(alpha=0.3) + 
  xlim(5,50)

ggplot(mpg_1,aes(x=hwy,color=factor(cyl))) + 
  geom_density() + 
  xlim(5,50)


# 평균 막대 그래프와 error bar에 의한 그룹 자료의 평균값 비교
# 그룹별 자료의 평균 비교에 막대 그래프 이용
# Error bar : 분포의 변동 혹은 신뢰구간을 표시하는 그래프


# mpg의 변수 cyl에 따른 hwy의 평균 및 신뢰구간
# 1. 그룹 자료의 평균과 신뢰구간이 주어진 경우
hwy_stat <- mpg %>% 
  filter(cyl!=5) %>% 
  group_by(cyl) %>%
  summarise(mean_hwy=mean(hwy),
            sd_hwy=sd(hwy),
            n_hwy=n(),
            ci_low=mean_hwy-qt(0.975,df=n_hwy-1)*sd_hwy/sqrt(n_hwy),
            ci_up=mean_hwy+qt(0.975,df=n_hwy-1)*sd_hwy/sqrt(n_hwy))
ggplot(hwy_stat, aes(x=factor(cyl),y=mean_hwy)) + geom_col(fill="skyblue") + 
  geom_errorbar(aes(ymin=ci_low,ymax=ci_up), width=0.5)


# 패키지 Hmisc
# 정규 분포 가정에서 모평균의 신뢰구간 계산
Hmisc::smean.cl.normal(mpg$hwy)


# mpg의 변수 cyl에 따른 hwy의 평균 및 신뢰구간
# 2. 원자료만 주어진 경우
mpg %>% filter(cyl!=5) %>% 
  ggplot(aes(x=factor(cyl),y=hwy)) + 
  stat_summary(fun.y="mean", geom="bar", fill="steelblue") + 
  stat_summary(fun.data="mean_cl_normal", geom="errorbar", width=0.3)


# 13장 연습문제 3번 - 1
UsingR::stud.recs %>% ggplot()  + 
  geom_freqpoly(aes(x=sat.v,color="verbal"),binwidth=50) + 
  geom_freqpoly(aes(x=sat.m,color="math"),binwidth=50) + 
  labs(color="SAT")


# 13장 연습문제 3번 - 2
UsingR::stud.recs %>% ggplot() +
  geom_density(aes(x=sat.v, fill="verbal"),alpha=0.3) + 
  geom_density(aes(x=sat.m, fill="math"),alpha=0.3) + 
  labs(fill="SAT")


# 13장 연습문제 3번 3~5
p <- data.frame(subject=rep(1:2,each=160), score=c(UsingR::stud.recs$sat.v,UsingR::stud.recs$sat.m)) %>% 
  mutate(subject=ifelse(subject==1,"verbal","math")) %>% ggplot(aes(x=subject,y=score))
p + geom_boxplot()
p + geom_dotplot(binaxis="y", binwidth=10, stackdir="center")
p + stat_summary(fun.y="mean", geom="bar", fill="skyblue") + 
    stat_summary(fun.data="mean_cl_normal", geom="errorbar", width=0.3)


# 13장 연습문제 4번 - 1
home <- data.frame(year=rep(1:2,each=6841), price=c(UsingR::homedata$y1970,UsingR::homedata$y2000)) %>%
  mutate(year=ifelse(year==1,"1970","2000"))
ggplot(home,aes(x=year,y=price)) + geom_boxplot()
ggplot(home,aes(x=year,y=price)) + geom_boxplot(outlier.shape=NA) + 
  geom_jitter(width=0.05, col="red")


# 13장 연습문제 4번 - 2
UsingR::homedata %>% mutate(group=if_else(y2000-y1970<0,"집값 하락","집값 상승")) %>% 
  select(group) %>% 
  table()


# 연속형 변수의 관계 탐색을 위한 그래프 : 산점도


# 패키지에서 데이터만 불러오기
data(Cars93, package="MASS")


# Cars93에서 Weight와 MPG.highway의 산점도
ggplot(Cars93,aes(x=Weight,y=MPG.highway)) + 
  geom_point(shape=21, size=3, color="blue", fill="red", stroke=2)


# 시각적 요소에 세 번째 변수 매핑 : 산점도에서 세 변수의 관계 탐색
ggplot(Cars93,aes(x=Weight,y=MPG.highway,color=Origin)) + 
  geom_point(size=3)
ggplot(Cars93,aes(x=Weight,y=MPG.highway,color=EngineSize)) + 
  geom_point(size=3)


# shapre에 요인 및 숫자형 변수 매핑 (연속형 변수는 shape에 매핑이 불가능하다.)
ggplot(Cars93,aes(x=Weight,y=MPG.highway,shape=Origin)) + 
  geom_point(size=3)
ggplot(Cars93,aes(x=Weight,y=MPG.highway,shape=EngineSize)) + 
  geom_point(size=3)


# size 요인 및 숫자형 변수 매핑
ggplot(Cars93,aes(x=Weight,y=MPG.highway,size=Origin)) + 
  geom_point()
ggplot(Cars93,aes(x=Weight,y=MPG.highway,size=EngineSize)) + 
  geom_point()


# 산점도에 회귀직선 추가
ggplot(Cars93, aes(x=Weight,y=MPG.highway)) + 
  geom_point(size=3) + 
  geom_smooth(method="lm",se=FALSE)
ggplot(Cars93, aes(x=Weight,y=MPG.highway)) + 
  geom_point(size=3) + 
  geom_smooth(se=FALSE)


# 회귀직선과 비모수 회귀곡선을 함께 산점도에 추가
ggplot(Cars93, aes(x=Weight,y=MPG.highway)) + 
  geom_point(size=3) + 
  geom_smooth(aes(color="lm"), se=FALSE) + 
  geom_smooth(aes(color="loess"), method="lm", se=FALSE) + 
  labs(color="Method", title="MPG.highway ~ Weight")
  

# 산점도에 수평선, 수직선 추가
# 직선 추가 함수 :  geom_abline(slope, intercept)
# 수직선 추가 함수 : geom_vline(xintercept)
# 수평선 추가 함수 : geom_hline(yintercept)


# 산점도에 수직선 그리기
ggplot(Cars93, aes(x=Weight,y=MPG.highway)) + 
  geom_point() + 
  geom_smooth(method="lm", se=FALSE) + 
  geom_vline(aes(xintercept=mean(Weight)), color="red") + 
  geom_hline(aes(yintercept=mean(MPG.highway)), color="darkgreen") + 
  labs(title="MPG.highway ~ Weight")


# 산점도의 점에 라벨 추가
# MPG.highway>40 인 점에 라벨 추가
# 라벨 내용 : Manufacturer와 Model의 값을 결합한 것
ggplot(Cars93,aes(x=Weight, y=MPG.highway)) + 
  geom_point() + 
  geom_text(data=filter(Cars93,MPG.highway>40),aes(label=paste(Manufacturer,Model)),color="red", nudge_x=100, nudge_y=1) + 
  labs(title="MPG.highway ~ Weight")


# 산점도에 주석 추가
fit <- lm(MPG.highway ~ Weight, Cars93)
r2 <- round(summary(fit)$r.squared,2)
pp <- ggplot(Cars93, aes(x=Weight, y=MPG.highway)) + 
  geom_point() + 
  geom_smooth(method="lm",se=FALSE)
pp + geom_text(label=paste("R^2=",r2),x=3500,y=45,size=7)
pp + geom_text(label=paste("R^2==",r2),x=3500,y=45,size=7,parse=TRUE)


# 연습문제 5
data(batting, package="UsingR")
GGally::ggpairs(batting,columns=c("HR","AB","SO"))
batting %>% ggplot(aes(x=AB,y=HR)) + 
  geom_point() + 
  geom_smooth(aes(col="lm"),method="lm",se=FALSE,size=2) + 
  geom_smooth(aes(col="loess"),se=FALSE,size=2)
batting %>% ggplot(aes(x=SO,y=HR)) + 
  geom_point() + 
  geom_smooth(aes(col="lm"),method="lm",se=FALSE,size=2) + 
  geom_smooth(aes(col="loess"),se=FALSE,size=2)
batting %>% ggplot(aes(x=SO,y=HR)) + 
  geom_point() + 
  geom_text(data=filter(batting,HR>=45),aes(label=playerID),nudge_x=15)
batting %>% ggplot(aes(x=SO,y=HR)) + 
  geom_point() + 
  geom_text(data=filter(batting,HR/AB==max(HR/AB)),aes(label=playerID),nudge_x=15)


# 산점도에서 점이 겹쳐지는 문제
# - 대규모 자료인 경우
# - 두 변수 중 한 변수가 이산형인 경우
# - 자료가 반올림된 경우


# 두 변수 중 한 변수가 이산형인 경우 -> jittering
ChickWeight %>% ggplot(aes(x=Time,y=weight)) + 
  geom_point()
ChickWeight %>% ggplot(aes(x=Time,y=weight)) + 
  geom_jitter(height=0,width=0.5)


# 두 변수 중 한 변수가 이산형인 경우 -> botplot
ChickWeight %>% ggplot(aes(x=factor(Time),y=weight)) + 
  geom_boxplot() + 
  labs(x="Time",y="weight")


# botplot + jitter
ChickWeight %>% ggplot(aes(x=factor(Time),y=weight)) + 
  geom_boxplot(outlier.shape=NA,fill=NA,col="blue") + 
  geom_jitter(height=0,width=0.1,col="red") + 
  labs(x="Time",y="weight",title="Boxplot + Jitter")


# 대규모 자료의 산점도
diamonds %>% ggplot(aes(x=carat,y=price)) + 
  geom_point()


# carat이 3이하인 데이터만 추출
diamond <- diamonds %>% filter(carat<3) %>% ggplot(aes(x=carat,y=price))
diamond + geom_point()


# 점의 크기를 줄이고 투명도를 높이기
diamond + geom_point(size=0.1,alpha=0.1)


# geom_bin2d() : 2차원 히스토그램 작성
# x축, y축을 각각 30개의 구간으로 구분 -> 900개의 공간으로 분할
# 자료의 개수를 색으로 표현
diamond + geom_bin2d()


# 색에 변화가 없어서 구분이 어렵다. -> 영역을 세분화, 색을 다양화
diamond + geom_bin2d(bins=100) + 
  scale_fill_gradient(low="steelblue",high="red")


# scale_*_gradient 의 활용
MASS::Cars93 %>% ggplot(aes(x=Weight,y=MPG.highway,col=Weight)) + 
  geom_point(size=3) + 
  scale_color_gradient(low="blue",high="red")


# x축 변수를 범주형으로 변환하고 상자그림 작성
# 시작점을 0, 간격을 0.1로 하는 구간으로 구분
# 각 구간의 자료를 대상으로 side-by-boxplot 작성
diamond + geom_boxplot(aes(group=cut_width(carat,width=0.1,boundary=0),y=price))


# 각 구간마다 동일한 개수의 자료가 들어가도록 조정
# 오른쪽으로 갈수록 박스플랏이 커진다.
diamond + geom_boxplot(aes(group=cut_number(carat,n=5),y=price))


# 이차원 결합확률밀도 그래프
# 두 연속형 변수의 관계 탐색에서 큰 역할을 할 수 있는 그래프


# faithful의 eruption와 waiting의 결합확률밀도 추정
# 등고선 그래프
# 각 등고선에 적절한 라벨이 필요
# 색으로 높이를 구분하는 방법
p3 <- ggplot(faithful, aes(x=eruptions, y=waiting)) + 
  xlim(1,6) + ylim(35,100)
p3 + geom_density_2d()


# 등고선에 색 넣기
# stat(levlel)은 ..level.. 과 동일
p3 + geom_density_2d(aes(color=..level..))


# 등고선 잘보이게 만들기
p3 + geom_density_2d(aes(color=..level..),size=2) + 
  scale_color_gradient(low="steelblue",high="red")


# 등고선에 점을 함께 표시하기
p3 + geom_density_2d(aes(color=..level..)) + 
  geom_point(shape=20) + 
  scale_color_gradient(low="steelblue",high="red")


# 등고선에서 높이가 같은 영역을 구분된 색으로 채우는 그래프
# 도형으로 그림
p3 + stat_density_2d(aes(fill=..level..), geom="polygon")
# 타일을 쪼개서 그림
p3 + stat_density_2d(aes(fill=..density..), geom="raster", contour=FALSE)


# 산점도 행렬
# 여려 변수로 이루어진 자료에서 두 변수끼리 짝을 지어 작성된 산점도를 행렬 형태로 표현한 그래프
# 자료 분석에서 필수적인 그래프
# Base R 의 pairs()
# 패키지 GGally의 ggpairs()


# MASS::Rubber의 세 변수 loss, tens, hard의 산점도 행렬
data(Rubber, package="MASS")
pairs(Rubber)


# 특정 변수만 지정하여 그리기 (순서도 조절 가능)
pairs(~loss + hard, data=Rubber)


# mtcars의 산점도
pairs(mtcars)


# mtcars의 mpg,wt,disp 산점도
pairs(~mpg + wt + disp, data=mtcars)


# 산점도에 국소선형회귀곡선 추가
pairs(~mpg + wt + disp, data=mtcars, panel=panel.smooth)


# 사용자가 패널 함수 정의
# mtcars의 변수 mpg, wt, disp의 산점도 행렬
# 변수 am이 0(automatic)이면 검은 점, 1(manual)이면 빨간 점으로 작성
my_panel_1 <- function(x,y) points(x,y,col=mtcars$am+1,pch=16)
pairs(~ mpg + wt + disp, data=mtcars, panel=my_panel_1)
legend("topleft", c("Automatic","manual"), pch=16, col=c(1,2), xpd=TRUE, horiz=TRUE, bty="n", y.intersp=-1)


# iris 데이터 산점도
my_panel_2 <- function(x,y) points(x,y,col=iris$Species,pch=c(1,2,3))
pairs(~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width, data=iris, panel=my_panel_2)
legend("topleft", c("setosa","vrsicolor","virginica"), pch=c(1,2,3), col=c(1,2,3), xpd=TRUE, horiz=TRUE, bty="n", y.intersp=-2)


# 교수님꺼
iris.panel <- function(x,y){ points(x, y, col=iris$Species, pch=as.numeric(iris$Species)) }
pairs(iris[1:4], panel=iris.panel)
legend("topleft", as.character(unique(iris$Species)), pch=unique(iris$Species), col=unique(iris$Species), 
       bty="n", horiz=TRUE, xpd=TRUE, y.intersp=-2)


# GGally::ggpairs()에 의한 산점도 행렬
library(GGally)
mtcars %>% dplyr::select(mpg,wt,disp,cyl,am) %>% 
  ggpairs()


# cyl 과 am 을 factor로 전환
mtcars %>% dplyr::select(mpg,wt,disp,cyl,am) %>% 
  mutate(cyl=factor(cyl),am=factor(am)) %>% 
  ggpairs()


# 대각선 위 아래 패널 : 옵션 upper, lower
# upper=list(continuous=, combo=, discrete=)
# lower=list(continuous=, combo=, discrete=)
# continuous : "points","smooth","smooth_loess","density","cor","blank"
# combo : "box","dot","facethist","facetdensity","denstrip","blank"
# discrete : facetbar,"ratio","blank"


# 대각선 패널 : 옵션 diag
# diag=list(continous=, discrete=)
# continous : "densityDiag","barDiag","blankDiag"
# discrete : "barDiag","blankDiag"


# am 변수를 color 요인으로 매핑
# 산점도에 회귀 직선 추가
# 히스토그램 막대수 조절
library(GGally)
mtcars %>% dplyr::select(mpg,wt,disp,cyl,am) %>% 
  mutate(cyl=factor(cyl),am=factor(am)) %>% 
  ggpairs(aes(color=am),lower=list(continuous=wrap("smooth",se=FALSE),combo=wrap("facethist",bins=10)))


# iris 활용하기
iris %>% ggpairs(aes(color=Species),upper=list(continuous="blank",combo="blank"),lower=list(combo=wrap("facethist",bins=20)))


# 범주형 자료 탐색을 위한 그래프


# 이변량 범주형 자료 정리
# - 이차원 분할표 작성
# - 이차원 조건분포 분할표 작성


# 막대 그래프
# - 쌓아 올린 막대 그래프
# - 옆으로 붙여 놓은 막대 그래프


# Mosaic plot
# - 두 개 이상의 범주형 변수 탐색에 유용한 그래프


# 데이터 : Arthitis
# 반응변수 : Imroved
# 설명변수 : Treatment, Sex, Age
data(Arthritis, package="vcd")
head(Arthritis, n=3)


# 분할표 만들기
my_table <- with(Arthritis, table(Treatment, Improved))
my_table


# 2차원 조건분포 분할표
round(prop.table(my_table, 1), 3)
round(prop.table(my_table, 2), 3)


# addmarings : 분할표에서 각 마진들의 합을 계산해준다.
addmargins(prop.table(my_table, 1))
addmargins(prop.table(my_table, 2))


# 요인의 범주 합치기 : Improved를 2개의 범주로 통합
df_1 <- mutate(Arthritis, Improved=factor(Improved, labels=c("No","Yes","Yes")))
with(df_1, table(Treatment,Improved))
round(prop.table(with(df_1, table(Treatment,Improved))),2)


# 원자료를 사용한 막대 그래프
Arthritis %>% ggplot(aes(x=Treatment,fill=Improved)) + 
  geom_bar()
Arthritis %>% ggplot(aes(x=Treatment,fill=Improved)) + 
  geom_bar(position="dodge")
Arthritis %>% ggplot(aes(x=Treatment,fill=Improved)) + 
  geom_bar(position="dodge2")
Arthritis %>% ggplot(aes(x=Treatment,fill=Improved)) + 
  geom_bar(position="fill")


# 분할표를 사용한 쌓아 올린 막대 그래프
my_table %>% as.data.frame() %>% 
  ggplot(aes(x=Treatment, y=Freq, fill=Improved)) + 
  geom_bar(stat="identity")
my_table %>% as.data.frame() %>% 
  ggplot(aes(x=Treatment, y=Freq, fill=Improved)) + 
  geom_bar(stat="identity", position="dodge")
my_table %>% as.data.frame() %>% 
  ggplot(aes(x=Treatment, y=Freq, fill=Improved)) + 
  geom_bar(stat="identity", position="dodge2")
my_table %>% as.data.frame() %>% 
  ggplot(aes(x=Treatment, y=Freq, fill=Improved)) + 
  geom_bar(stat="identity", position="fill")


# 다른 방법으로 상대도수 그래프 그리기 (미완성)
Arthritis %>% ggplot(aes(x=Treatment, y=..prop..)) + 
  geom_bar(aes(fill=Improved))


# 연습문제 - (1)
UsingR::grades %>% with(., table(prev,grade))


# 연습문제 - (2)
UsingR::grades %>% mutate(prev=factor(prev, labels=c("A","A","B","B","B","C","C","D&F","D&F")),
                         grade=factor(grade, labels=c("A","A","B","B","B","C","C","D&F","D&F"))) %>%
  with(., table(prev,grade)) %>% 
  addmargins()


# 연습문제 - (3)
UsingR::grades %>% mutate(prev=factor(prev, labels=c("A","A","B","B","B","C","C","D&F","D&F")),
                          grade=factor(grade, labels=c("A","A","B","B","B","C","C","D&F","D&F"))) %>%
  with(., table(prev,grade)) %>%
  prop.table(.,1) %>% 
  round(.,2)


# 연습문제 - (3)
my_plot <- UsingR::grades %>% mutate(prev=factor(prev, labels=c("A","A","B","B","B","C","C","D&F","D&F")),
                          grade=factor(grade, labels=c("A","A","B","B","B","C","C","D&F","D&F"))) %>% ggplot(aes(x=prev,fill=grade))
my_plot + geom_bar()
my_plot + geom_bar(position="dodge")

