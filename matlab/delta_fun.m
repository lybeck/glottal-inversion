function delta = delta_fun(k, noise_est)

log_gamma = gammaln((k+1)/2) - gammaln(k/2);
delta = noise_est * sqrt(2) * exp(log_gamma);

end