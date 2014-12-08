function a = int_discrete(x, y)

if length(x) ~= length(y)
    error('Input vectors should be of the same size! Lengths were: x = %d, y = %d', length(x), length(y));
end

dx = diff(x);

a = zeros(size(x));
for ii = 1:length(dx)
    a(ii+1) = a(ii) + ((y(ii) + y(ii+1)) / 2) * dx(ii);
end

end
