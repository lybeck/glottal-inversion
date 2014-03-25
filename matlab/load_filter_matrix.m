function A = load_filter_matrix(n)

% load the filter
load data/filter_male_a alpha;

% length of the filter vector
Na = length(alpha);

% initialize filter matrix
A = zeros(n);
A(1, 1) = alpha(1);

for ii = 2:n
    A(ii, 2:ii) = A(ii-1, 1:ii-1);
    N = min(ii - 1, Na - 1);
    %A(ii, 1) = -sum();
    for k = 1:N
        A(ii, 1) = A(ii, 1) - alpha(k+1) * A(ii, k + 1);
    end
end

end