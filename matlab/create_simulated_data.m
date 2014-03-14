
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

