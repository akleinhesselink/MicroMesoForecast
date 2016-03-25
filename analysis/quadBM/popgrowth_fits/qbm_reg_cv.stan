data{
  int<lower=0> N; // observations
  int<lower=0> Yrs; // years
  int<lower=0> yid[N]; // year id
  int<lower=0> Covs; // climate covariates
  int<lower=0> G; // groups
  int<lower=0> gid[N]; // group id
  real<lower=0,upper=1> Y[N]; // observation vector
  real<lower=0> sd_clim; // prior sd on climate effects
  matrix[N,Covs] C; // climate matrix
  vector[N] X; // size vector
}
parameters{
  real a_mu;
  vector[Yrs] a;
  real b1_mu;
  vector[Yrs] b1;
  vector[Covs] b2;
  vector[G] gint;
  real<lower=0> sig_a;
  real<lower=0> sig_b1;
  real<lower=0> sig_G;
  real<lower=0> tau;
}
transformed parameters{
  real mu[N];
  vector[N] climEff;
  climEff <- C*b2;
  for(n in 1:N)
    mu[n] <- a[yid[n]] + gint[gid[n]] + b1[yid[n]]*X[n] + climEff[n];
}
model{
  // Priors
  a_mu ~ normal(0,1000);
  b1_mu ~ normal(0,1000);
  sig_a ~ cauchy(0,5);
  sig_b1 ~ cauchy(0,5);
  sig_G ~ cauchy(0,5);
  gint ~ normal(0, sig_G);
  b2 ~ normal(0,sd_clim);
  a ~ normal(a_mu, sig_a);
  b1 ~ normal(b1_mu, sig_b1);
  tau ~ cauchy(0,5);
  
  //Likelihood
  Y ~ lognormal(mu, tau);
}