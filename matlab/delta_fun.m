function delta = delta_fun(k, noise_factor, noise_lvl)

log_delta = log(sqrt(2)) + gammaln((k+1)/2) - gammaln(k/2);
delta = noise_factor * noise_lvl * exp(log_delta);

end