function [xx, yd] = klatt(f, Q)

const = load('data/constants');

T = 1 / f;
t0 = Q * T;

a = 27 / (4 * t0^2);
b = -27 / (4 * t0^3);

gd = @(t) 2 * a * t + 3 * b * t.^2;

xx = linspace(0, T, const.fs * T)';
yd = zeros(size(xx));

ind = (xx < t0); 
yd(ind) = gd(xx(ind));

end