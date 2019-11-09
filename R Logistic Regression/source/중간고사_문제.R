# 라이브러리 호출
library(car)
library(tidyverse)
library(vcd)


# 1-1
Aspirin_mt <- matrix(c(24,20,  10,18,  6,16), ncol=3, dimnames=list(Treatment=c("Placebo","Treated"), Improved=c("None","Some","Marked")))
Aspirin_df <- Aspirin_mt %>% as.table() %>% as.data.frame()
myplot_1 <- ggplot(data=Aspirin_df,aes(x=Treatment, y=Freq ,fill=Improved))
myplot_1 + geom_bar(stat="identity")
myplot_1 + geom_bar(stat="identity",position="fill")


# 1-2
Aspirin <- matrix(c(24,20,  10,18,  6,16), ncol=3, dimnames=list(Treatment=c("Placebo","Treated"), Improved=c("None","Some","Marked")))
chisq.test(Aspirin)


# 1-3
library(vcdExtra)
Aspirin.r <- collapse.table(as.table(Aspirin), Improved=c("No","Yes","Yes"))
chisq.test(Aspirin.r)


# 2-1
myplot_2 <- Arrests %>% as.tibble() %>% ggplot(mapping=aes(x=colour,fill=released))
myplot_2 + geom_bar(position="dodge")
myplot_2 + geom_bar(position="fill")


# 2-2
library(vcd)
with(Arrests, chisq.test(table(colour,released)))


# 2-3
Arrests_t <-  Arrests %>% as.tibble() %>% mutate(released=as.numeric(released)-1)
fit <- glm(released ~ colour + employed + citizen + checks, family="binomial", data=Arrests_t)
confint(fit)


# 2-4
new_data <- tibble(employed="Yes",citizen="Yes")
new_data_1 <- cbind(new_data,checks=seq(0,6,by=1),colour="Black")
prob_1 <- predict(fit,newdata=new_data_1,type="response")
new_data_2 <- cbind(new_data,checks=seq(0,6,by=1),colour="White")
prob_2 <- predict(fit,newdata=new_data_2,type="response")
df <- tibble(checks=seq(0,6,by=1), Black=prob_1, White=prob_2)
ggplot(data=df) + labs(y="Probs of released",col="Race") + 
  geom_line(mapping=aes(x=checks,y=Black,col="Black")) + 
  geom_line(mapping=aes(x=checks,y=White,col="White"))


# 참고
df_1 <- mutate(df,x=White-Black)
ggplot(df_1) + geom_bar(aes(x=checks,y=x),fill="steelblue",stat="identity") + 
  geom_smooth(aes(x=checks,y=x),se=FALSE,col="red",method="lm") + ylim(0,1)

