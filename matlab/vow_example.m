
clear

const = load('data/constants');

f = 100;
Q = .4;
noise_lvl = 50;

%[xx, yy] = glottal_triangle(f, Q);
%yd = [diff(yy), 0];

[xx, yy, yd, g, gd] = klatt(f, Q);

len = length(xx);
maxx = xx(len);

% sound duration in seconds
d = 1;

% repetitions
rep = round(d / maxx);

pres = repmat(yd, 1, rep);

filt = load('data/filter_male_a');
filt2 = load('data/filter_female_a');

vow = myfilt(filt.alpha, pres);
%vow = filter(1, filt2.alpha, pres);

noisevow = vow + noise_lvl * randn(size(vow));



start = 4;
p = 10;

plotx = linspace(0, p * maxx, p * len);
ploty = repmat(yy, 1, p);
plotyd = repmat(yd, 1, p);
plotvow = vow(start * len : p * len + start *len - 1);


m = noisevow(start * len : p * len + start * len - 1);
x = plotx;
y = ploty;
yd = plotyd;
A = create_filter_matrix(filt.alpha, length(plotyd));
AT = A';
save data/data m x y yd
save data/A A
save data/AT AT




figure(1)
clf
plot(plotx, ploty)
xlim([0, p * maxx])

figure(2)
clf
plot(plotx, plotyd)
xlim([0, p * maxx])

figure(3)
clf
plot(plotx, plotvow)
xlim([0, p * maxx])


pres = pres / max(pres);
maxvow = max(vow);
vow = vow / maxvow;
noisevow = noisevow / maxvow;

sound(pres, const.fs)
pause(1.5)
sound(vow, const.fs)
pause(1.5)
sound(noisevow, const.fs)
