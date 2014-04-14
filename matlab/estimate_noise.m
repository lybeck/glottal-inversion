function noise_est = estimate_noise(m, f, Q, periods, noise_lvl)

filt = load('data/filter_male_a');
[~, ~, yyd] = klatt(f, Q);

len = length(yyd);

pres = repmat(yyd, 2*periods, 1);

vow = filter(1, filt.alpha, pres);

% period to start data from
start = 4;

vow = vow(start * len : periods * len + start * len - 1);

noise_factor =  max(vow);
norm_noise = randn(size(vow));

err = norm(vow - m);
diff_fun = @(c) norm(c * noise_factor * noise_lvl * norm_noise);

noise_est = fminsearch(@(c) abs(diff_fun(c) - err), 1);

end