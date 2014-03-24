function y = myfilt(a, x)

n = length(x);
Na = length(a);
y = zeros(size(x));
y(1) = x(1);
for ii = 2:n
    y(ii) = x(ii);
    N = min(Na - 1, ii - 1);
    for k = 1:N
        y(ii) = y(ii) - a(k+1) * y(ii - k);
    end
end

end