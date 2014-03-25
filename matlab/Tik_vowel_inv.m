function x = Tik_vowel_inv(filt, m, alpha, x0)

max_iter = 1000;
tol = sqrt(eps);

n = length(x0);

AT = create_filter_matrix(filt, n)';

Amult = @(x) filter(1, filt, x);
ATmult = @(x) AT * x;
Lmult = @(x) [diff(x); x(end) - x(1)];
LTmult = @(x) [x(end) - x(1) ; -diff(x)];

x = Tik_conj_grad(Amult, ATmult, Lmult, LTmult, m, alpha, x0, max_iter, tol);

end