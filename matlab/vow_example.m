
const = load('data/constants');

f = 130;
Q = .7;
[xx, yy] = glottal_triangle(f, Q);
yd = [diff(yy), 0];
len = length(xx);
maxx = xx(len);

% sound duration in seconds
d = 1;

% repetitions
rep = d / maxx;

pres = repmat(yd, 1, rep);

filt = load('data/filter_male_a');
vow = filter(1, filt.alpha, pres);

p = 4;
plotx = linspace(0, p * maxx, p * len);
ploty = repmat(yy, 1, p);
plotyd = repmat(yd, 1, p);
plotvow = vow(1: p * len);

figure(1)
clf
plot(plotx, ploty)
xlim([0, 4 * maxx])

figure(2)
clf
plot(plotx, plotyd)
xlim([0, 4 * maxx])

figure(3)
clf
plot(plotx, plotvow)
xlim([0, 4 * maxx])

sound(pres, const.fs)
sound(vow, const.fs)
