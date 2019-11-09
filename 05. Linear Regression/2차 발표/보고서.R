# 데이터 확인
library(tidyverse)
set.seed(1234)
movie <- read.csv("C:/Users/user/Desktop/학교/04. 통계자료분석실습/2차 발표/data/movie.csv")
movie <- as.tibble(movie) %>% mutate(Name=as.character(Name),Month=as.factor(Month))
movie <- movie[sample(1:nrow(movie),nrow(movie)),]


# 설명변수 스케일 변환
movie <- mutate(movie, Audience=round(Audience/100000,2))


# 범주 통합
movie <- movie %>% mutate(Month=ifelse(Month%in%c("1","2","3"),"1",ifelse(Month%in%c("4","5","6"),"2",ifelse(Month%in%c("7","8","9"),"3","4"))))
movie <- movie %>% mutate(Genre=ifelse(Genre=="Animation","Animation",ifelse(Genre=="Action","Action",ifelse(Genre=="Drama","Drama","Etc"))))
movie <- movie %>%mutate(Month=factor(Month),Genre=factor(Genre))
movie <- as.data.frame(movie)%>%column_to_rownames(var="Name")


#결측값확인
sum(is.na(movie))


#데이터 분리
x.id <- sample(1:nrow(movie),size=nrow(movie)*0.2)
df_test <- movie[x.id,]
df_train <- movie[-x.id,]


# 배급사
df_train %>% group_by(Distributor) %>% 
  summarise(n=n()) %>% 
  ggplot(aes(x=Distributor,y=n,fill=Distributor)) + 
  geom_col() + 
  geom_text(aes(label=n),size=7)


ggplot(df_train, aes(x=Distributor,y=Audience,fill=Distributor)) + 
  geom_boxplot()


ggplot(df_train, aes(x=Distributor,y=Audience,fill=Distributor)) + 
  geom_boxplot(outlier.shape = NA) + 
  ylim(0,10)


# 개봉시기
df_train %>% group_by(Month) %>% 
  summarise(n=n()) %>% 
  ggplot(aes(x=Month,y=n,fill=Month)) + 
  geom_col() + 
  geom_text(aes(label=n),size=7)


ggplot(df_train, aes(x=Month,y=Audience,fill=Month)) + 
  geom_boxplot()


ggplot(df_train, aes(x=Month,y=Audience,fill=Month)) + 
  geom_boxplot(outlier.shape = NA) + 
  ylim(0,50)


# 제작국가
df_train %>% group_by(Country) %>% 
  summarise(n=n()) %>% 
  ggplot(aes(x=Country,y=n,fill=Country)) + 
  geom_col() + 
  geom_text(aes(label=n),size=7)


ggplot(df_train, aes(x=Country,y=Audience,fill=Country)) + 
  geom_boxplot()


# 장르
df_train %>% group_by(Genre) %>% 
  summarise(n=n()) %>% 
  ggplot(aes(x=Genre,y=n,fill=Genre)) + 
  geom_col() + 
  geom_text(aes(label=n),size=7)


ggplot(df_train, aes(x=Genre,y=Audience,fill=Genre)) + 
  geom_boxplot()


# 등급
df_train %>% group_by(Grade) %>% 
  summarise(n=n()) %>% 
  ggplot(aes(x=Grade,y=n,fill=Grade)) + 
  geom_col() + 
  geom_text(aes(label=n),size=7)


ggplot(df_train, aes(x=Grade,y=Audience,fill=Grade)) + 
  geom_boxplot()


# 스크린 타입
df_train %>% group_by(Screen_Type) %>% 
  summarise(n=n()) %>% 
  ggplot(aes(x=Screen_Type,y=n,fill=Screen_Type)) + 
  geom_col() + 
  geom_text(aes(label=n),size=7)


ggplot(df_train, aes(x=Screen_Type,y=Audience,fill=Screen_Type)) + 
  geom_boxplot()


# 원작
df_train %>% group_by(Story) %>% 
  summarise(n=n()) %>% 
  ggplot(aes(x=Story,y=n,fill=Story)) + 
  geom_col() + 
  geom_text(aes(label=n),size=7)


ggplot(df_train, aes(x=Story,y=Audience,fill=Story)) + 
  geom_boxplot()


# 시리즈
df_train %>% group_by(Series) %>% 
  summarise(n=n()) %>% 
  ggplot(aes(x=Series,y=n,fill=Series)) + 
  geom_col() + 
  geom_text(aes(label=n),size=7)


ggplot(df_train, aes(x=Series,y=Audience,fill=Series)) + 
  geom_boxplot()


# 상영시간
summary(df_train$Runtime)


ggplot(df_train, aes(x=Runtime)) + 
  geom_histogram(binwidth=10,aes(fill=Distributor)) + 
  facet_wrap(~Distributor,ncol=1)


ggplot(df_train, aes(x=Runtime,y=Audience)) + 
  geom_point(size=2) + 
  geom_smooth(aes(col="Use All Data"),size=2,se=FALSE) + 
  geom_smooth(data=filter(df_train,Runtime<150),aes(col="Except Outlier"),size=2,se=FALSE) + 
  labs(col="")


ggplot(df_train, aes(x=Runtime,y=Audience)) + 
  geom_point(size=2) + 
  labs(col="") + ylim(0,10)


ggplot(df_train, aes(x=Runtime,y=Audience)) + 
  geom_point(size=2) + 
  labs(col="") + ylim(10,150)


# 상영시간
ggplot(df_train) + geom_density(aes(x=Critic_Reviews,fill="Critic"),alpha=0.5) + 
  geom_density(aes(x=Audience_Reviews,fill="Audience"),alpha=0.5) + 
  xlim(0,11) + labs(fill="")


# 시사회 평점
df_train %>% summarise(Critic_m=mean(Critic_Reviews),Critic_sd=sd(Critic_Reviews),
                       Audience_m=mean(Audience_Reviews),Audience_sd=sd(Audience_Reviews))


# 시사회 관객수
ggplot(df_train, aes(x=Preview,y=Audience)) + 
  geom_point(size=2)


ggplot(df_train, aes(x=Preview,y=Audience)) + 
  geom_point(size=2) + 
  xlim(0,40000)


ggplot(df_train, aes(x=Country,y=Preview,fill=Country)) + 
  geom_boxplot() + 
  ylim(0,40000)


# 예고편 조회수
ggplot(df_train, aes(x=Trailer_views,y=Audience)) + 
  geom_point(size=2)


# 스크린 수
ggplot(df_train, aes(x=Screen,y=Audience)) + 
  geom_point(size=2)


#적합
fit <- lm(Audience ~., df_train)
summary(fit) 
AIC(fit);BIC(fit)
library(forecast)
accuracy(fit)


#1)전진선택법
library(MASS)
fit.full <- lm(Audience ~ .,   df_train)
fit.0 <- lm(Audience ~ 1, df_train)
addterm(fit.0, scope=fit.full, test="F")
fit.0 <- update(fit.0, .~. + Screen)
addterm(fit.0, scope=fit.full, test="F")
fit.0 <- update(fit.0, .~.  + Screen_Type)  
addterm(fit.0, scope=fit.full, test="F")
fit.0 <- update(fit.0, .~. + Grade)  
addterm(fit.0, scope=fit.full, test="F")  # Screen, Screen_Type, Grade선택


#2)후진소거법
dropterm(fit,test="F")
fit <- update(fit, . ~ . - Runtime)
dropterm(fit,test="F")  
fit <- update(fit, . ~ . - Genre)
dropterm(fit,test="F")  
fit <- update(fit, . ~ . - Audience_Reviews)
dropterm(fit,test="F")  
fit <- update(fit, . ~ . - Country)
dropterm(fit,test="F")  
fit <- update(fit, . ~ . - Story)
dropterm(fit,test="F")  
fit <- update(fit, . ~ . - Trailer_views)
dropterm(fit,test="F")  
fit <- update(fit, . ~ . - Critic_Reviews)
dropterm(fit,test="F")  
fit <- update(fit, . ~ . - Distributor)
dropterm(fit,test="F")  
fit <- update(fit, . ~ . - Series)
dropterm(fit,test="F")  
fit <- update(fit, . ~ . - Month)
dropterm(fit,test="F")  
fit <- update(fit, . ~ . - Preview)
dropterm(fit,test="F")  
fit <- update(fit, . ~ . - Grade)
dropterm(fit,test="F")    #Screen_Type,Screen

#3)단계별선택법
full.fit <- lm(Audience ~ .,   df_train)
fit0 <- lm(Audience ~ 1, df_train)
addterm(fit0,scope=full.fit,test="F")
fit0 <- update(fit0, .~. +Screen)
dropterm(fit0,test="F")
addterm(fit0,scope=full.fit,test="F")
fit0 <- update(fit0, .~. +Screen_Type)  
dropterm(fit0,test="F")
addterm(fit0,scope=full.fit,test="F") 
fit0 <- update(fit0, .~. +Grade) 
dropterm(fit0,test="F")
addterm(fit0,scope=full.fit,test="F")           #Screen,Screen_Type,Grade

#4)모형 선택 기준에 따른 변수 선택
library(leaps)
fit_all <- regsubsets(Audience ~ ., df_train)
plot(fit_all, main="BIC")                       # country,genre,screen_type,screen선택
plot(fit_all, scale="adjr2", main="adjr2")      # Distributor,Country,Genre,Screen_Type,Preview,Screen 선택
plot(fit_all, scale="Cp", main="Cp")            # Month,Country,Genre,Screen_Type,Preview,Screen선택



#잠정모형선택하기
fit.1.1 <- lm(Audience ~ Screen + Screen_Type + Grade, df_train)                                      # 전진, 단계
fit.1.2 <- lm(Audience ~ Screen_Type + Screen,df_train)                                               # 후진
fit.1.3 <- lm(Audience ~ Country + Genre + Screen_Type + Screen, df_train)                            # bic
fit.1.4 <- lm(Audience ~ Distributor + Country + Genre + Screen_Type + Preview + Screen,df_train)     # adjr2
fit.1.5 <- lm(Audience ~ Month + Country + Genre + Screen_Type + Preview + Screen, df_train)          # cp
BIC(fit.1.1);BIC(fit.1.2);BIC(fit.1.3);BIC(fit.1.4);BIC(fit.1.5)
accuracy(fit.1.1) ; accuracy(fit.1.2) ; accuracy(fit.1.3) ; accuracy(fit.1.4) ; accuracy(fit.1.5)


#여러가지 기준으로 1번 잠정모형 선택
fit.1 <- lm(Audience ~ Screen + Screen_Type + Grade, df_train)


# 등분산성 확인
library(car)
plot(fit.1,which=1)
plot(fit.1,which=3)
spreadLevelPlot(fit.1)
ncvTest(fit.1)


#반응변수변환 여부 확인
summary(powerTransform(fit.1))  
bc <- boxcox(fit.1)
bc$x[which.max(bc$y)]


###반응변수에 상용로그변환을 한후 적합
fit.2 <- lm(log(Audience)~., data=df_train)
summary(fit.2) 
AIC(fit1);BIC(fit.2)
accuracy(fit.2) 


##변수선택


#1)전진선택법
full.fit <- lm(log(Audience) ~ ., df_train)
fit0 <- lm(log(Audience) ~ 1, df_train)
addterm(fit0,scope=full.fit,test="F")
fit0 <- update(fit0, .~. +Screen)
addterm(fit0,scope=full.fit,test="F")
fit0 <- update(fit0, .~. +Critic_Reviews)  
addterm(fit0,scope=full.fit,test="F")  #Screen,Critic_Reviews선택

#2)후진소거법
dropterm(fit1,test="F")
fit1 <- update(fit1, . ~ . - Month)
dropterm(fit1,test="F")  
fit1 <- update(fit1, . ~ . - Distributor)
dropterm(fit1,test="F")  
fit1 <- update(fit1, . ~ . - Country)
dropterm(fit1,test="F")  
fit1 <- update(fit1, . ~ . - Series)
dropterm(fit1,test="F")  
fit1 <- update(fit1, . ~ . - Preview)
dropterm(fit1,test="F")  
fit1 <- update(fit1, . ~ . - Genre)
dropterm(fit1,test="F")  
fit1 <- update(fit1, . ~ . - Audience_Reviews)
dropterm(fit1,test="F")  
fit1 <- update(fit1, . ~ . - Screen_Type)
dropterm(fit1,test="F")  
fit1 <- update(fit1, . ~ . - Story)
dropterm(fit1,test="F")  
fit1 <- update(fit1, . ~ . - Trailer_views)
dropterm(fit1,test="F")      #Runtime,Grade,Critic_Reviews,Screen선택

#3)단계별선택법
full.fit <- lm(log(Audience) ~ .,   df_train)
fit0 <- lm(log(Audience) ~ 1, df_train)
addterm(fit0,scope=full.fit,test="F")
fit0 <- update(fit0, .~. +Screen)
dropterm(fit0,test="F")
addterm(fit0,scope=full.fit,test="F")
fit0 <- update(fit0, .~. +Critic_Reviews)  
dropterm(fit0,test="F")
addterm(fit0,scope=full.fit,test="F") #Critic_Reviews,Screen선택

#4)모형 선택 기준에 따른 변수 선택
fit_all <- regsubsets(log(Audience) ~ .,   df_tr)
plot(fit_all, main="BIC")             #Critic_Reviews,Screen선택
subsets(fit_all, statistic="bic", legend=FALSE)
plot(fit_all, scale="adjr2", main="adjr2")      #Critic_Reviews,Screen,Country,Runtime,Grade,Screen_Type선택 
subsets(fit_all, statistic="adjr2", legend=FALSE) 
plot(fit_all, scale="Cp", main="Cp")            #Runtime,Grade,Critic_Reviews,Screen선택
subsets(fit_all, statistic="cp", legend=FALSE)    
abline(a=1,b=1,lty=3)


#잠정모형선택하기
fit.2.1 <- lm(log(Audience) ~ Screen+Critic_Reviews,df_train)                                   # 전진,단계,bic
fit.2.2 <- lm(log(Audience) ~ Runtime+Grade+Critic_Reviews+Screen,df_train)                     # 후진
fit.2.3 <- lm(log(Audience) ~ Critic_Reviews+Screen+Country+Screen_Type+Runtime+Grade,df_train) # adjr2
fit.2.4 <- lm(log(Audience) ~ Runtime+Grade+Critic_Reviews+Screen,df_train)                     # cp
BIC(fit.2.1) ; BIC(fit.2.2) ; BIC(fit.2.3) ; BIC(fit.2.4)
accuracy(fit.2.1);accuracy(fit.2.2);accuracy(fit.2.3);accuracy(fit.2.4)
summary(fit.2.4)


#여러가지 기준으로 1.3번 잠정모형 선택
fit.2 <- lm(log(Audience) ~ Critic_Reviews + Screen, df_train)


##fit1.3잠정모형의 가정만족여부확인
# 등분산성 확인
plot(fit.2, which=1)
plot(fit.2, which=3)
spreadLevelPlot(fit.2)
ncvTest(fit.2) 


# 정규성 확인
plot(fit.2, which=2)
qqPlot(fit.2)    
shapiro.test(residuals(fit1.3))  #정규성만족


# 독립성 확인
durbinWatsonTest(fit.2) 
checkresiduals(fit.2)      #독립성만족


# 선형성 확인
crPlots(fit.2)
residualPlots(fit.2) 


#이상값확인
influencePlot(fit1.3) 
influenceIndexPlot(fit1.3) 


#다중공선성확인
vif(fit1.3)
boxTidwell(log(Audience) ~ Critic_Reviews+Screen+Runtime, other.x = ~ Country+Screen_Type+Grade, data=df_tr)


#screen에 루트씌운뒤 다시적합
fit2 <- lm(log(Audience) ~ Distributor + Month + Country + Genre + Runtime + Grade + 
             Screen_Type + Story + Series + Audience_Reviews + Critic_Reviews + Trailer_views + Preview + sqrt(Screen),df_train)

##변수선택

#1)전진선택법
full.fit <- lm(log(Audience)~Distributor+Month+Country+Genre+Runtime+Grade+Screen_Type+Story+Series+Audience_Reviews+Critic_Reviews+Trailer_views+Preview+sqrt(Screen),df_train)
fit0 <- lm(log(Audience) ~ 1, df_train)
addterm(fit0,scope=full.fit,test="F")
fit0 <- update(fit0, .~. +sqrt(Screen))
addterm(fit0,scope=full.fit,test="F")
fit0 <- update(fit0, .~. +Critic_Reviews)  
addterm(fit0,scope=full.fit,test="F")  
fit0 <- update(fit0, .~. +Grade)  
addterm(fit0,scope=full.fit,test="F")  
fit0 <- update(fit0, .~. +Runtime)  
addterm(fit0,scope=full.fit,test="F")  
fit0 <- update(fit0, .~. +Trailer_views)  
addterm(fit0,scope=full.fit,test="F")  #Screen, Critic_Reviews, Grade, Runtime, Trailer_views 선택


#2)후진소거법
dropterm(fit2,test="F")
fit2 <- update(fit2, . ~ . - Month)
dropterm(fit2,test="F")  
fit2 <- update(fit2, . ~ . - Distributor)
dropterm(fit2,test="F")  
fit2 <- update(fit2, . ~ . - Story)
dropterm(fit2,test="F")  
fit2 <- update(fit2, . ~ . - Series)
dropterm(fit2,test="F")  
fit2 <- update(fit2, . ~ . - Genre)
dropterm(fit2,test="F")  
fit2 <- update(fit2, . ~ . - Audience_Reviews)
dropterm(fit2,test="F")  
fit2 <- update(fit2, . ~ . - Country)
dropterm(fit2,test="F")  
fit2 <- update(fit2, . ~ . - Preview)
dropterm(fit2,test="F")  
fit2 <- update(fit2, . ~ . - Screen_Type)
dropterm(fit2,test="F")    #Runtime,Grade,Critic_Reviews,Trailer_views,sqrt(Screen)선택

#3)단계별선택법
full.fit <- lm(log(Audience)~Distributor+Month+Country+Genre+Runtime+Grade+Screen_Type+Story+Series+Audience_Reviews+Critic_Reviews+Trailer_views+Preview+sqrt(Screen),df_tr)
fit0 <- lm(log(Audience) ~ 1, df_tr)
addterm(fit0,scope=full.fit,test="F")
fit0 <- update(fit0, .~. +sqrt(Screen))
dropterm(fit0,test="F")
addterm(fit0,scope=full.fit,test="F")
fit0 <- update(fit0, .~. +Critic_Reviews)  
dropterm(fit0,test="F")
addterm(fit0,scope=full.fit,test="F") 
fit0 <- update(fit0, .~. +Grade)
dropterm(fit0,test="F")
addterm(fit0,scope=full.fit,test="F")
fit0 <- update(fit0, .~. +Runtime)
dropterm(fit0,test="F")
addterm(fit0,scope=full.fit,test="F")
fit0 <- update(fit0, .~. +Trailer_views)
dropterm(fit0,test="F")
addterm(fit0,scope=full.fit,test="F")  #sqrt(Screen) ,Critic_Reviews,Grade,Runtime,Trailer_views선택

#4)모형 선택 기준에 따른 변수 선택
fit_all <- regsubsets(log(Audience)~Distributor+Month+Country+Genre+Runtime+Grade+Screen_Type+Story+Series+Audience_Reviews+Critic_Reviews+Trailer_views+Preview+sqrt(Screen),df_tr)
plot(fit_all, main="BIC")             #Critic_Reviews,Screen선택
subsets(fit_all, statistic="bic", legend=FALSE)
plot(fit_all, scale="adjr2", main="adjr2")      #Runtime,Grade,Screen_Type,Critic_Reviews,Trailer_views,sqrt(Screen)선택 
subsets(fit_all, statistic="adjr2", legend=FALSE) 
plot(fit_all, scale="Cp", main="Cp")             #Runtime,Grade,Screen_Type,Critic_Reviews,Trailer_views,sqrt(Screen)선택
subsets(fit_all, statistic="cp", legend=FALSE)    
abline(a=1,b=1,lty=3)

#잠정모형선택하기
fit.3.1 <- lm(log(Audience) ~ sqrt(Screen)+Critic_Reviews+Grade+Runtime+Trailer_views, df_train)                      # 전진,단계,후진
fit.3.2 <- lm(log(Audience) ~ Critic_Reviews + sqrt(Screen), df_train)                                                # bic
fit.3.3 <- lm(log(Audience) ~ Runtime + Grade+Screen_Type + Critic_Reviews + Trailer_views + sqrt(Screen), df_train)  # cp,adjr2
BIC(fit.3.1) ; BIC(fit.3.2) ; BIC(fit.3.3)
accuracy(fit.3.1) ; accuracy(fit.3.2) ; accuracy(fit.3.3)
summary(fit.2.4)


#잠정모형선택
fit.3 <- lm(log(Audience) ~ Runtime + Grade + Screen_Type + Critic_Reviews + Trailer_views + sqrt(Screen), df_train) # cp,adjr2
summary(fit.3)
accuracy(fit.3)
AIC(fit.3) ; BIC(fit.3)


##fit.3잠정모형의 가정만족여부확인
# 등분산성 확인
plot(fit.3,which=1)


# 정규성 확인
qqPlot(fit.3)    


# 독립성 확인
durbinWatsonTest(fit.3) 
checkresiduals(fit.3)  #독립성만족


# 선형성 확인
crPlots(fit.3)
residualPlots(fit.3) 


#이상값 탐ㅅ
influencePlot(fit.3) 
influenceIndexPlot(fit.3)  


# 이상값 확인
df_train[c("옥자","리얼"),]
summary(df_train)


#다중공선성확인
vif(fit.3)


#최종모형
fit.3 <- lm(log(Audience) ~ Runtime + Grade + Screen_Type + Critic_Reviews + Trailer_views + sqrt(Screen),df_train) #cp,adjr2
summary(fit.3)


# Test Data
summary(df_test)


#예측
pred <- round(exp(predict(fit.3,type="response",newdata=df_test[1:10,])),2)
pred <- cbind(real=df_test[1:10,]$Audience,pred)
pred <- data.frame(pred) %>% rownames_to_column(var="Title")
result <- data.frame(Title=c(pred$Title,pred$Title), Audience=c(pred$real,pred$pred),group=rep(c("real","pred"),each=10))
ggplot(result, aes(x=Title,y=Audience,fill=group)) + geom_bar(stat="identity",position = "dodge") + coord_flip() + labs(fill="")


pred <- round(exp(predict(fit.3,type="response",newdata=df_test[11:20,])),2)
pred <- cbind(real=df_test[11:20,]$Audience,pred)
pred <- data.frame(pred) %>% rownames_to_column(var="Title")
result <- data.frame(Title=c(pred$Title,pred$Title), Audience=c(pred$real,pred$pred),group=rep(c("real","pred"),each=10))
ggplot(result, aes(x=Title,y=Audience,fill=group)) + geom_bar(stat="identity",position = "dodge") + coord_flip() + labs(fill="")


pred <- round(exp(predict(fit.3,type="response",newdata=df_test[21:30,])),2)
pred <- cbind(real=df_test[21:30,]$Audience,pred)
pred <- data.frame(pred) %>% rownames_to_column(var="Title")
result <- data.frame(Title=c(pred$Title,pred$Title), Audience=c(pred$real,pred$pred),group=rep(c("real","pred"),each=10))
ggplot(result, aes(x=Title,y=Audience,fill=group)) + geom_bar(stat="identity",position = "dodge") + coord_flip() + labs(fill="")


pred <- round(exp(predict(fit.3,type="response",newdata=df_test)),2)
pred <- cbind(real=df_test$Audience,pred)
pred <- data.frame(pred)
accuracy(pred$pred, pred$real)


summary(fit.3)
anova(fit.3)
data.frame(x=c("Runtime", "Grade", "Screen_Type", "Critic_Reviews", "Trailer_views", "srqt(Screen)", "Residuals"),
           y=c(45/196,3/196,8/196,4/196,32/196,76/196,28/196)) %>%
  ggplot(aes(x=x,y=y,fill=x)) + 
  geom_col(show.legend = F) + 
  labs(x="설명변수", y="sum of Sq 백분율",fill="") + 
  geom_text(aes(label=paste0(round(y,2)*100,"%")),size=5) + 
  coord_flip()


x=1:2000
y=1.512e-01*sqrt(x)
data.frame(x=x,y=y) %>% ggplot(aes(x=x,y=y)) + geom_line() + labs(x="Screen", y="Audience", title="Screen & Audience")
