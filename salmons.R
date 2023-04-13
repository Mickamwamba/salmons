setwd("~/DSProjects/RProjects/salmons")
library(readxl)
library(rstan)
library(cvms) 
library(tibble)   # tibble()
source('utilities.R')

salmons <- read_excel('Salmons.xlsx')
salmons$Spending <- scale(salmons$Spending)
head(salmons)

#Split data to train and validtion sets
set.seed(1)
#use 70% of dataset as training set and 30% as validation set
sample <- sample(c(TRUE, FALSE), nrow(salmons), replace=TRUE, prob=c(0.7,0.3))
train  <- salmons[sample ,]
valid   <- salmons[!sample, ]

predictor <- model.matrix(~Spending+Card,data=train)
response <- train$Coupon
test_set <- model.matrix(~Spending+Card,data=valid)
N=length(response)
K=ncol(predictor)
N_test <- nrow(test_set)
stan_data <- list(N=N,K=K,N_test=N_test,predictor=predictor,response=response,test_set=test_set)

fit <- stan('salmons.stan',data = stan_data,cores=4)
print(fit,pars = c('theta'))

theta <- extract(fit)$theta
test_predictions <-  extract(fit)$test_predictions

#calculating point estimates measures: 
prediction_estimates = apply(test_predictions,2,median)
final_predictions = sapply(prediction_estimates,getPredictions)

#Plot the confusion matrix
res <- tibble("target" = valid$Coupon,"prediction" = final_predictions)
res_table <- table(res)
cfm <- as_tibble(res_table)
plot_confusion_matrix(cfm, 
                      target_col = "target", 
                      prediction_col = "prediction",
                      counts_col = "n")

