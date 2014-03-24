function A = create_filter_matrix(a, n)

A = eye(n);

Na = length(a);
f = zeros(1, n);
f(1) = 1;
for ii = 2:n
    N = min(ii - 1, Na - 1);
    for k = 1:N
        f(ii) = f(ii) - a(k+1) * f(ii-k);
    end
    A = A + diag(repmat(f(ii), 1, n-ii+1), 1-ii);
end

end

