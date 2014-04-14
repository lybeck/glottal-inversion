function [m, x, y, yd, noise_factor, Q1, xx, yy, yyd, plotvow] = create_vowel_with_noise(data_male_filter, klatt_model, f, Q, Q_rand, noise_lvl, periods)

Q1 = Q + 2*Q_rand*rand()-Q_rand;

if klatt_model
    [xx, yy, yyd] = klatt(f, Q1);
else
    [xx, yy, yyd] = glottal_triangle(f, Q1);
end

if data_male_filter
    filt = load('data/filter_male_a');
else
    filt = load('data/filter_female_a');
end

len = length(xx);
maxx = xx(len);

% sound duration in seconds
d = 1;

% repetitions
rep = round(d / maxx);

pres = repmat(yyd, rep, 1);

vow = filter(1, filt.alpha, pres);

noise_factor =  max(vow);
noise = noise_lvl * noise_factor;
noisevow = vow + noise * randn(size(vow));


% create and save data for inversion
start = 4;

m = noisevow(start * len : periods * len + start * len - 1);
x = linspace(0, periods * maxx, periods * len);
y = repmat(yy, periods, 1);
yd = repmat(yyd, periods, 1);
plotvow = vow(start * len : periods * len + start * len - 1);

end