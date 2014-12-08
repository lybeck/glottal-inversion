function yy = klatt_flow(f, Q)

const = load('data/constants');

T = 1 / f;
t0 = Q * T;

a = 27 / (4 * t0^2);
b = -27 / (4 * t0^3);

gd = @(t) a * t.^2 + b * t.^3;

xx = linspace(0, T, const.fs * T);
yy = zeros(size(xx));

ind = (xx < t0); 
yy(ind) = gd(xx(ind));

end