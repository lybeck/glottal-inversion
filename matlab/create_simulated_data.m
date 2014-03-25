
clear

const = load('data/constants');

% should the created data be played?
play_sound = 0;

% which filter should be used?
% 0: female
% 1: male
male_filter = 1;

% which glottal model?
% 0: triangle wave
% 1: klatt model
klatt_model = 1;

% parameters for the data
f = 120;
Q = .4;
noise_lvl = .005;
periods = 10;

if klatt_model
    [xx, yy, yyd] = klatt(f, Q);
else
    [xx, yy, yyd] = glottal_triangle(f, Q);
end

if male_filter
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

noise = noise_lvl * max(vow);
noisevow = vow + noise * randn(size(vow));



% create and save data for inversion

start = 4;

m = noisevow(start * len : periods * len + start * len - 1);
x = linspace(0, periods * maxx, periods * len);
y = repmat(yy, periods, 1);
yd = repmat(yyd, periods, 1);
plotvow = vow(start * len : periods * len + start * len - 1);

save data/data m x y yd periods




figure(1)
clf
plot(x, y)
xlim([0, periods * maxx])

figure(2)
clf
plot(x, yd)
xlim([0, periods * maxx])

figure(3)
clf
plot(x, plotvow)
xlim([0, periods * maxx])


pres = pres / max(pres);
maxvow = max(vow);
vow = vow / maxvow;
noisevow = noisevow / maxvow;

if play_sound
    sound(pres, const.fs)
    pause(1.5)
    sound(vow, const.fs)
    pause(1.5)
    sound(noisevow, const.fs)
end
