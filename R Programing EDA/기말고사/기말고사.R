library(tidyverse)
str(iris)

# 문제 1번
ggplot(iris, aes(x="",y=Sepal.Width)) + 
  geom_boxplot() + 
  coord_flip() + 
  xlab("")


# 문제 2번
ggplot(iris, aes(x=Sepal.Width,y=Sepal.Length)) + 
  geom_point() + 
  geom_smooth(data=filter(iris,Species=="setosa"),aes(col="setosa"),se=FALSE) + 
  geom_smooth(data=filter(iris,Species=="versicolor"),aes(col="versicolor"),se=FALSE) + 
  geom_smooth(data=filter(iris,Species=="virginica"),aes(col="virginica"),se=FALSE) + 
  labs(col="Species")


# 문제 4번
species <- c(rep(c("setosa","versicolor","virginica"),each=50),rep(c("setosa","versicolor","virginica"),each=50))
value <- c(iris$Sepal.Length,iris$Sepal.Width)
data <- data.frame(species=species,value=value,group=rep(c("Length","Width"),each=150))
ggplot(data, aes(x=species,y=value)) + 
  geom_boxplot() + 
  facet_wrap(~group,ncol=2) + 
  labs(x="Species",y="",title="Sepal Length & Sepal Width")













