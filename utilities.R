#function to get prediction from probability 
getPredictions <- function(prob){
  if(prob>0.5) return(1)
  else return(0)
}

#function to return the confusion matrix 
getConfMatrix <- function(actual, predicted) {
  fp <- sum((actual == 0) & (predicted == 1))
  fn <- sum((actual == 1) & (predicted == 0))
  tp <- sum((actual == 1) & (predicted == 1))
  tn <- sum((actual == 0) & (predicted == 0))
  
  return(c('fp'=fp,'fn'=fn,'tp'=tp,'tn'=tn))
}
