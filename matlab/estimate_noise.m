function noise_est = estimate_noise(m, f, Q, periods)

% number of tests
tests = 100;

filt = load('data/filter_male_a');
[~, ~, yyd] = klatt(f, Q);

len = length(yyd);

pres = repmat(yyd, 2*periods, 1);

vow = filter(1, filt.alpha, pres);

% period to start data from
start = 4;

vow = vow(start * len : periods * len + start * len - 1);

maxv = max(abs(vow));
maxm = max(abs(m));

% the normalized difference between vowels
err = norm(vow/maxv - m/maxm) * maxv;

% sum of estimations to calculate mean error
estsum = 0;

for ii=1:tests
    norm_noise = randn(size(vow));
    diff_fun = @(c) norm(c * norm_noise);
    estsum = estsum + fminsearch(@(c) abs(diff_fun(c) - err), 1);
end

mean_err = estsum / tests;
noise_est = mean_err / 2;

end