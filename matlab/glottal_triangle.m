
function [xx, yy, yd] = glottal_triangle(f, Q)

const = load('data/constants');

T = 1 / f;
T0 = Q * T;

xx = linspace(0, T, const.fs * T)';
yy = tria(xx, T0);
yd = [diff(yy); 0];

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
