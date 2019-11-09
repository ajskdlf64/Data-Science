library(tidyverse)
mpg %>% ggplot(aes(x=displ,y=hwy)) + geom_point() +
  geom_smooth()
mpg %>% ggplot(aes(x=displ,y=hwy)) + geom_point() +
  geom_smooth() + coord_cartesian(xlim=c(3,6))


mpg %>% ggplot(aes(x=displ,y=hwy)) + geom_point() +
   geom_smooth() + xlim(3,6)
mpg %>% ggplot(aes(x=displ,y=hwy)) + geom_point() +
  geom_smooth() + coord_cartesian(xlim=c(3,6))


mpg %>% ggplot(aes(x=class,y=hwy)) + geom_boxplot()
mpg %>% ggplot(aes(x=class,y=hwy)) + geom_boxplot() + coord_flip()


mpg %>% ggplot(aes(x="",y=hwy)) + geom_boxplot() + xlab("")
mpg %>% ggplot(aes(x="",y=hwy)) + geom_boxplot() + xlab("") + coord_flip()


myplot <- mpg %>% ggplot(aes(x=class, fill=class)) + 
  geom_bar(show.legend=FALSE, width=1) + labs(x="",y="")
myplot + coord_polar()


myplot2 <- mpg %>% ggplot(aes(x="",fill=class)) + geom_bar(width=1) + labs(x="",y="")
myplot2 + coord_polar(theta="y")


myplot2 + coord_polar(theta="x")


mpg %>% 
  ggplot(aes(x=1, fill=class)) + 
  geom_bar(width=0.3) + 
  labs(x="",y="") + 
  xlim(0.5,1.5) + 
  coord_polar(theta="y")


#====================================================================================================
  

as.data.frame(state.region) %>% 
  ggplot(aes(x=state.region)) + 
  geom_bar() + 
  labs(x="Region")


as.data.frame(state.region) %>% 
  ggplot(aes(x=state.region)) + 
  geom_bar() + 
  labs(x="Region") + 
  coord_flip()


table(state.region) %>% as.data.frame() %>% ggplot(aes(x=state.region,y=Freq)) + 
  geom_bar(stat="identity",fill="steelblue")
table(state.region) %>% as.data.frame() %>% ggplot(aes(x=state.region,y=Freq)) + 
  geom_bar(stat="identity",fill="darkgreen") + coord_flip()


as.data.frame(state.region) %>% 
  ggplot(aes(x="",fill=state.region)) + 
  geom_bar(width=1) + 
  labs(x="",y="") + 
  coord_polar(theta="y")


pct <- table(state.region) %>% 
  as.data.frame() %>% 
  mutate(pct=scales::percent(Freq/sum(Freq)))


myplot3 <- ggplot(pct, aes(x="",y=Freq,fill=state.region)) + 
  geom_bar(width=1,stat="identity") + 
  labs(x="",y="") + 
  geom_text(aes(label=pct),size=5,position=position_stack(vjust=0.5))


myplot3 + coord_polar(theta="y")


table(state.region) %>% 
  as.data.frame() %>% 
  ggplot(aes(x=Freq,y=state.region)) + 
  geom_point() + 
  labs(x="",y="") + 
  theme(panel.grid.major.y=element_line(linetype=2,color="darkgray"))


car <- mutate(MASS::Cars93,carSize=cut(EngineSize, breaks=c(min(EngineSize),1.6,2.0,max(EngineSize)), labels=c("Small","Mid","Large"))) %>%
  filter(!is.na(carSize))


ggplot(car,aes(x=carSize)) + geom_bar()


group_by(car,carSize) %>% 
  summarise(Freq=n()) %>% 
  mutate(pct=scales::percent(Freq/sum(Freq))) %>% 
  ggplot(aes(x="",y=Freq,fill=carSize)) + 
  geom_bar(stat="identity") + 
  geom_text(aes(label=pct),size=5,position=position_stack(vjust=0.5)) + 
  coord_polar(theta="y")


group_by(car,carSize) %>% 
  summarise(Freq=n()) %>% 
  ggplot(aes(x=Freq,y=carSize)) + 
  geom_point() + 
  labs(x="",y="") + 
  theme(panel.grid.major.y=element_line(linetype=2,color="darkgray"))


#====================================================================================================


# 줄기-잎 그림
with(women, stem(height))
x <- c(98,102,114,122,132,144,106,117,151,118,124,115)
stem(x)
stem(x, scale=2)


# boxplot
data(alltime.movies,package="UsingR")
ggplot(alltime.movies, aes(x="",y=Gross)) + geom_boxplot(outlier.shape=NA) + labs(x="") + geom_point(col="red")
ggplot(alltime.movies, aes(x="",y=Gross)) + geom_boxplot(outlier.shape=NA) + labs(x="") + geom_jitter(col="red",width=0.01)


# Outlier 확인하기
my_box <- boxplot(alltime.movies$Gross, plot=FALSE)
my_box$out
alltime <- as_tibble(alltime.movies) %>% rownames_to_column(var="Movie.Title")
top_movies <- alltime %>% filter(Gross %in% my_box$out)
top_movies


# viloin plot
ggplot(alltime.movies, aes(x="",y=Gross)) + labs(x="") + geom_violin()
ggplot(alltime.movies, aes(x="",y=Gross)) + labs(x="") + geom_violin(draw_quantiles=c(0.25,0.5,0.75),fill="skyblue")


# viloin plot과 boxplot
ggplot(alltime.movies, aes(x="",y=Gross)) + labs(x="") + geom_violin(fill="steelblue") + geom_boxplot(width=0.1)
ggplot(alltime.movies, aes(x="",y=Gross)) + labs(x="") + geom_boxplot(width=0.1) + geom_violin(fill="steelblue",alpha=0.3)



# 히스토그램
ggplot(faithful, aes(x=waiting)) + geom_histogram()
ggplot(faithful, aes(x=waiting)) + geom_histogram(bins=20)
ggplot(faithful, aes(x=waiting)) + geom_histogram(binwidth=5)


# 확률밀도함수
p <- ggplot(faithful, aes(x=waiting)) + geom_density(fill="skyblue")
p + xlim(30,110)
p + xlim(30,110) + geom_rug()


# 확률밀도함수와 히스토그램
p <- ggplot(faithful, aes(x=waiting,y=..density..))
p + geom_histogram(fill="red", binwidth=5) + geom_density(col="blue",size=2) + xlim(30,110)
p + geom_density(col="blue",size=2) + geom_histogram(fill="red", binwidth=5) + xlim(30,110)


# 도수분포다각형
pp <- ggplot(faithful, aes(x=waiting))
pp + geom_freqpoly(binwidth=5)
pp + geom_freqpoly(aes(y=..density..),binwidth=5)


# 이변량 자료의 히스토그램
mpg_1 <- mpg %>% filter(cyl!=5)
ggplot(mpg_1, aes(x=hwy)) + geom_histogram(binwidth=5) + facet_wrap(~cyl)
ggplot(mpg_1, aes(x=hwy,fill=factor(cyl))) + geom_histogram(binwidth=5,alpha=0.5)
  

# 이변량 자료의 도수분포다각형
p <- ggplot(mpg_1, aes(x=hwy, col=factor(cyl)))
p + geom_freqpoly(binwidth=5)
p + geom_freqpoly(aes(y=..density..),binwidth=5)


# 이변량 자료의 상자그림
ggplot(mpg_1, aes(x=factor(cyl),y=hwy)) + geom_boxplot() + 
  labs(x="Number of Cylinders", y="MPG")


# 상자그림에 의한 그룹 자료의 분포 비교
set.seed(1234)
x1 <- rnorm(100, mean=0, sd=1)
x2 <- rt(100, df=3)
x3 <- runif(100, min=-1, max=1)
data.frame(x=rep(1:3,each=100), y=c(x1,x2,x3)) %>% 
  ggplot(aes(x=factor(x),y=y)) + geom_boxplot() + 
  scale_x_discrete(labels=c("N(0,1)","t(3)","Unif(-1,1")) + labs(x="",y="")


# 상자그림 배치정 순서 조정
ggplot(mpg, aes(x=class,y=hwy)) + geom_boxplot() + xlab("")
ggplot(mpg, aes(x=reorder(class,hwy,FUN=median),y=hwy)) + geom_boxplot() + xlab("")


# 다중 점 그래프
ggplot(mpg, aes(x=hwy)) + geom_dotplot(binwidth=0.5)
ggplot(mpg_1, aes(x=factor(cyl),y=hwy)) + geom_dotplot(binaxis="y",binwidth=0.5,stackdir="center")
ggplot(mpg_1, aes(x=factor(cyl),y=hwy)) + geom_dotplot(binaxis="y",binwidth=0.5,stackdir="up")
ggplot(mpg_1, aes(x=factor(cyl),y=hwy)) + geom_dotplot(binaxis="y",binwidth=0.5,stackdir="down")


# 확률밀도함수에 의한 그룹 자료의 분포 비교
ggplot(mpg_1,aes(x=hwy)) + geom_density() + xlim(5,50) + facet_wrap(~cyl, ncol=1)
ggplot(mpg_1,aes(x=hwy,fill=factor(cyl))) + geom_density(alpha=0.5) + xlim(5,50)
ggplot(mpg_1,aes(x=hwy,col=factor(cyl))) + geom_density(alpha=0.5) + xlim(5,50)


# 평균 막대 그래프 - 자료가 주어짐
hwy_stat <- mpg %>% filter(cyl!=5) %>% group_by(cyl) %>% 
  summarise(mean_hwy=mean(hwy), sd_hwy=sd(hwy), n_hwy=n(),
            ci_low=mean_hwy-qt(0.975,df=n_hwy-1)*sd_hwy/sqrt(n_hwy),
            ci_up=mean_hwy+qt(0.975,df=n_hwy-1)*sd_hwy/sqrt(n_hwy))
ggplot(hwy_stat, aes(x=factor(cyl), y=mean_hwy)) + 
  geom_bar(stat="identity",fill="skyblue") + 
  geom_errorbar(aes(ymin=ci_low,ymax=ci_up),width=0.5)


# 평균 막대 그래프 - 원자료
mpg_1 %>% ggplot(aes(x=factor(cyl),y=hwy)) + 
  stat_summary(fun.y="mean", geom="bar", fill="skyblue") + 
  stat_summary(fun.data="mean_cl_normal", geom="errorbar",width=0.5)


# 신뢰구간 계산하기
Hmisc::smean.cl.normal(mpg$hwy)


# 13장 연습문제 3번
data(stud.recs, package="UsingR")
stud.recs.df <- data.frame(SAT=rep(c("math","verbal"),each=160),
                           score=rep(c(stud.recs$sat.m,stud.recs$sat.v)))
ggplot(stud.recs.df,aes(x=score,col=SAT)) + geom_freqpoly(binwidth=50,size=2)
ggplot(stud.recs.df,aes(x=score,fill=SAT)) + geom_density(binwidth=50,alpha=0.5)
ggplot(stud.recs.df,aes(x=SAT,y=score)) + geom_boxplot() + xlab("Subject")
ggplot(stud.recs.df,aes(x=SAT,y=score)) + geom_dotplot(binaxis="y",binwidth=10,stackdir="center")
ggplot(stud.recs.df,aes(x=SAT,y=score)) + 
  stat_summary(fun.y="mean", geom="bar", fill="skyblue") + 
  stat_summary(fun.data="mean_cl_normal", geom="errorbar",width=0.5)


# 13장 연습문제 4번
data(homedata, package="UsingR")
homedata.df <- data.frame(year=rep(c("1970","2000"),each=6841), price=c(homedata$y1970,homedata$y2000))
ggplot(homedata.df,aes(x=year,y=price)) + geom_boxplot()
ggplot(homedata.df,aes(x=year,y=price)) + geom_jitter(col="red",width=0.05) + geom_boxplot(outlier.shape=NA,fill=NA)
homedata_t <- mutate(homedata,group=if_else(y2000-y1970<0,"집값 하락","집값 상승"), group=factor(group))
levels(homedata_t$group)=list("집값 하락"=1,"집값 상승"=2)
table(homedata_t$group)


# 산점도
data(Cars93, package="MASS")
ggplot(Cars93, aes(x=Weight,y=MPG.highway)) + 
  geom_point(shape=21,col="red",fill="blue",stroke=1.5,size=3)
ggplot(Cars93, aes(x=Weight,y=MPG.highway,col=Origin)) + geom_point()
ggplot(Cars93, aes(x=Weight,y=MPG.highway,col=EngineSize)) + geom_point()


ggplot(Cars93, aes(x=Weight,y=MPG.highway,shape=Origin)) + geom_point()
ggplot(Cars93, aes(x=Weight,y=MPG.highway,size=Origin)) + geom_point()
ggplot(Cars93, aes(x=Weight,y=MPG.highway,size=EngineSize)) + geom_point()


# 산점도에 회귀직선 추가
ggplot(Cars93, aes(x=Weight,y=MPG.highway)) + 
  geom_point() + 
  geom_smooth(aes(col="lm"),method="lm",se=FALSE) + 
  geom_smooth(aes(col="loess"),se=FALSE) + 
  labs(col="Method")
ggplot(Cars93, aes(x=Weight,y=MPG.highway)) + 
  geom_point() + 
  geom_smooth(method="lm",se=FALSE) + 
  geom_vline(aes(xintercept=mean(Weight)),col="red") + 
  geom_hline(aes(yintercept=mean(MPG.highway)))
  

# 산점도의 점에 주석 추가하기
ggplot(Cars93, aes(x=Weight,y=MPG.highway)) + 
  geom_point() + 
  geom_text(data=filter(Cars93,MPG.highway>40),
            aes(label=paste(Manufacturer,Model)),
            nudge_x=100,nudge_y=1)


# 산점도에 주석 추가하기
fit <- lm(MPG.highway ~ Weight, Cars93)
r2 <- round(summary(fit)$r.squared, 2)
p <- ggplot(Cars93, aes(x=Weight,y=MPG.highway)) + 
  geom_point() + geom_smooth(method="lm",se=FALSE)
p + geom_text(x=3500,y=45,size=7,label=paste("R^2=",r2))
p + geom_text(x=3500,y=45,size=7,label=paste("R^2==",r2),parse=TRUE)


# 산점도에 점이 겹치는 문제
p1 <- ggplot(ChickWeight, aes(x=Time,y=weight))
p1 + geom_point()
p1 + geom_jitter(width=0.2, height=0)
p1 + geom_boxplot(aes(group=Time))
p1 + geom_jitter(width=0.2, height=0, fill="red", shape=21) + 
  geom_boxplot(aes(group=Time),outlier.shape=NA, fill=NA, color="blue")


# 대규모 자료의 산점도
ggplot(diamonds, aes(x=carat,y=price)) + geom_point()
p2 <- ggplot(filter(diamonds,carat<3), aes(x=carat,y=price))
p2 + geom_point()
p2 + geom_point(alpha=0.1, shape=20)


# 2차원 히스토그램
p2 + geom_bin2d()
p2 + geom_bin2d(bins=100) + 
  scale_fill_gradient(low="skyblue",high="red")


# scale_*_gradient의 적용
ggplot(Cars93, aes(x=Weight,y=MPG.highway,col=EngineSize)) + 
  geom_point() + 
  scale_color_gradient(low="blue",high="red")


# 연속형 변수를 범주형 변수로 변환
# cut_width(x, width, boundary) : 동일간격으로 구분, boundary는 시작점 지정
# cut_number(x, number=n) : n개의 구간으로 구분, 각 구간에 속한 자료의 개수는 동일
# cut_interval(x, n, length) : n개의 구간으로 구분하되, 구간의 길이는 동일
p2 <- ggplot(filter(diamonds,carat<3), aes(x=carat,y=price))
p2 + geom_boxplot(aes(group=cut_width(carat,width=0.1,boundary=0)))
p2 + geom_boxplot(aes(group=cut_interval(carat,n=10)))


# 이차원 결합확률밀도 그래프
p3 <- ggplot(faithful, aes(x=eruptions,y=waiting)) + 
  xlim(1,6) + ylim(35,100)
p3 + geom_density_2d(aes(col=stat(level)))
p3 + geom_density_2d(aes(col=stat(level))) + 
  scale_color_gradient(low="blue",high="red")
p3 + geom_density_2d(aes(col=stat(level))) + 
  scale_color_gradient(low="blue",high="red") + 
  geom_point(shape=20)


# 등고선 색채우기
p3 + stat_density_2d(aes(fill=stat(level)),geom="polygon")
p3 + stat_density_2d(aes(fill=stat(density)),geom="raster",contour=FALSE)


# 산점도 행렬
data(Rubber, package="MASS")
pairs(Rubber)
pairs(~mpg+wt+disp, data=mtcars)
pairs(~mpg+wt+disp, data=mtcars, panel=panel.smooth)


# 사용자가 패널 함수 정의
my_panel_1 <- function(x,y) points(x,y,col=mtcars$am+1,pch=16)
pairs(~mpg+wt+disp, data=mtcars, panel=my_panel_1)
legend("topleft",c("Automatic","Manual"),pch=16,col=c(1,2),
       xpd=TRUE,horiz=TRUE,bty="n",y.intersp=-1)


# ggpairs에 의한 산점도 행렬
library(GGally)
mtcars_2 <- mtcars %>% select(mpg,wt,disp,cyl,am) %>% 
  mutate(am=factor(am),cyl=factor(cyl))
ggpairs(mtcars_2)
ggpairs(mtcars_2, aes(color=am),
        lower=list(continuous=wrap("smooth",se=FALSE),combo=wrap("facethist",bins=10)))




