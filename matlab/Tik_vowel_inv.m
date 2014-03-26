function x = Tik_vowel_inv(filt, m, alpha, x0, periods, Q)

max_iter = 1000;
tol = sqrt(eps);

n = length(x0);

AT = create_filter_matrix(filt, n)';

Amult = @(x) filter(1, filt, x);
ATmult = @(x) AT * x;
% Lmult = @(x) [diff(x); x(end) - x(1)];
% LTmult = @(x) [x(end) - x(1) ; -diff(x)];

p_len = n / periods;
q = round(Q * p_len);
v = ones(p_len, 1) * .1;
v(q:end) = 10;
v = repmat(v, periods, 1);
Lmult = @(x) x .* v;
LTmult = @(x) x .* v;

x = Tik_conj_grad(Amult, ATmult, Lmult, LTmult, m, alpha, x0, max_iter, tol);

end