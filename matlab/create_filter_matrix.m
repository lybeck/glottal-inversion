function A = create_filter_matrix(alpha, n)

% length of the filter vector
Na = length(alpha);

% make sure alpha is a row vector
alpha = alpha(:)';

% initialize filter matrix
A = zeros(n);
A(1, 1) = alpha(1);

for ii = 2:n
    A(ii, 2:ii) = A(ii-1, 1:ii-1);
    N = min(ii - 1, Na - 1);
    A(ii, 1) = -sum(alpha(2:N+1) .* A(ii, 2:N+1));
end

end

