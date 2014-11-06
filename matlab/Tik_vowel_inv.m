function x = Tik_vowel_inv(filt, m, alpha, x0, periods, Q)

max_iter = 5000;
tol = sqrt(eps);

n = length(x0);

AT = create_filter_matrix(filt, n)';

% Estimate of the error used in creation of data (related to the
% unperiodicity of the data). To be provided as an argument in teh
% future...
estimate_of_data_err = 0.2;

Amult = @(x) filter(1, filt, x);
ATmult = @(x) AT * x;
% Lmult = @(x) [diff(x); x(end) - x(1)];
% LTmult = @(x) [x(end) - x(1) ; -diff(x)];

% constant used in penalty matrix for a suppressing effect for the part
% where air pressure = 0;
suppressing_constant = 80;

p_len = n / periods;
q = round(Q * p_len);
v = ones(p_len, 1);
v(q:end) = suppressing_constant;
v1 = -ones(p_len, 1);
v1(q:end) = 0;

% % smoothien
% c_len = round(length(v)/20);
% c = ones(c_len, 1) / c_len;
% v = conv(v, c);
% v = v(c_len:end);
beginning_of_smooth = round((p_len * Q) - (.5 * estimate_of_data_err * p_len));
end_of_smooth = round((p_len * Q) + (.5 * estimate_of_data_err * p_len));
smooth = linspace(beginning_of_smooth, end_of_smooth);

% v = repmat(v, periods, 1);
% Lmult = @(x) x .* v;
% LTmult = @(x) x .* v;

v = repmat(v, periods, 1)
v1 = repmat(v1, periods, 1);
v1 = v1(1:end-1);
L = diag(v) + diag(v1,1);

Lmult = @(x) L * x;
LTmult = @(x) L' * x;

x = Tik_conj_grad(Amult, ATmult, Lmult, LTmult, m, alpha, x0, max_iter, tol);

end