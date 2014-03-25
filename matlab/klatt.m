function [xx, yy, yd] = klatt(f, Q)

const = load('data/constants');

T = 1 / f;
t0 = Q * T;

a = 27 / (4 * t0^2);
b = -27 / (4 * t0^3);

g = @(t) a * t.^2 + b * t.^3;
gd = @(t) 2 * a * t + 3 * b * t.^2;

xx = linspace(0, T, const.fs * T)';
yy = zeros(size(xx));
yd = zeros(size(xx));

ind = (xx < t0); 
yy(ind) = g(xx(ind));
yd(ind) = gd(xx(ind));

end