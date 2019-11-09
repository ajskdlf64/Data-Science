# Data Loading
german_credit <- read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/statlog/german/german.data")

# Variable Naming
colnames(german_credit) <- c("chk_acct", "duration", "credit_his", "purpose", 
                             "amount", "saving_acct", "present_emp", "installment_rate", "sex", "other_debtor", 
                             "present_resid", "property", "age", "other_install", "housing", "n_credits", 
                             "job", "n_people", "telephone", "foreign", "response")

# Response variable setting
german_credit$response <- german_credit$response - 1
german_credit$response <- as.factor(german_credit$response)

# Data Summary
str(german_credit)

# Rattle
library(rattle)
rattle()


