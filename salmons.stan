data {
  int<lower=0> N;
  int<lower=0> N_test;
  int<lower=0> K;
  int response [N];
  matrix[N,K] predictor;
  matrix[N_test,K] test_set;
}

parameters {
  vector [K] theta;
}
model {
  response ~ bernoulli_logit(predictor*theta);
}
generated quantities{
  real test_predictions [N_test]; 
  for (i in 1:N_test) test_predictions[i] = inv_logit(test_set[i]*theta);
}

