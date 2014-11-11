function x = Tik_vowel_inv(filt, m, alpha, x0, periods, Q)

max_iter = 5000;
tol = sqrt(eps);

n = length(x0);

AT = create_filter_matrix(filt, n)';

Amult = @(x) filter(1, filt, x);
ATmult = @(x) AT * x;

% length of the period (number of samples)
p_len = n / periods;

% Index from which onward air pressure = 0
Q_end = round(p_len * Q);

% constant used in penalty matrix for a suppressing effect for the part
% where air pressure = 0;
suppressing_constant = 3;

% create main diagonal
diag_main = zeros(p_len, 1);
diag_main(1 : Q_end) = 1;
diag_main(Q_end : end) = suppressing_constant;

% create the secondary diagonal
diag_sec = zeros(p_len, 1);
diag_sec(1 : Q_end) = -1;

% create the L-matrix
diag_main = repmat(diag_main, periods, 1);
diag_sec = repmat(diag_sec, periods, 1);
diag_sec = diag_sec(1:end-1);
L = diag(diag_main) + diag(diag_sec,1);

Lmult = @(x) L * x;
LTmult = @(x) L' * x;

x = Tik_conj_grad(Amult, ATmult, Lmult, LTmult, m, alpha, x0, max_iter, tol);

end