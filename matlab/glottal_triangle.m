
function [xx, yy] = glottal_triangle(f, Q)

const = load('data/constants');

T = 1 / f;
T0 = Q * T;

a = 27 / (4 * T0^2);
b = -27 / (4 * T0^3);

g = @(t) a * t.^2 + b * t.^3;
gd = @(t) 2 * a * t + 3 * b * t.^2;

xx = linspace(0, T, const.fs * T);
yy = tria(xx, T0);

end

function y = tria(x, T0)

y = zeros(size(x));
c = 1 / (T0 / 2);

for ii = 1:length(x)
    if x(ii) <= T0 / 2
        y(ii) = c * x(ii);
    elseif x(ii) < T0
        y(ii) = -c * x(ii) + 2;
    end
end

end
