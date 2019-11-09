RBDdata = read.csv("j:/DataExample/absorbdata.csv", header = T)
summary(RBDdata)

ex1 = aov(absorb ~ subject + treat, data = RBDdata)
summary(ex1)

RBDdata$subject = factor(RBDdata$subject)
ex2 = aov(absorb ~ subject + treat, data = RBDdata)
summary(ex2)


library(foreign)
arffdata <- read.arff("j:/DataExample/absorbdata.arff")
summary(arffdata)

#with(arffdata, subject <- factor(subject))

ex3 = aov(absorb ~ subject + treat, data = arffdata)
summary(ex3)


library(foreign)
german_credit <- read.arff("d:/Lectures/DM/Data/dataset_31_credit-g.arff")
str(german_credit)

german_credit$class <- relevel(german_credit$class, "good") # first level
result_ALL <- glm(class ~ ., data = german_credit, family = binomial)
predict_class = factor(ifelse((fitted(result_ALL) > 0.5), "bad", "good"))
predict_class <- relevel(predict_class, "good")
table(german_credit$class, predict_class)

save(german_credit, file = "j:/DataExample/german_credit.RData")

load(file = "j:/DataExample/german_credit.RData")

library(rattle)
rattle()

