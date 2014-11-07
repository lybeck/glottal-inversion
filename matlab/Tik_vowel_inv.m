function x = Tik_vowel_inv(filt, m, alpha, x0, periods, Q, Q_delta)

max_iter = 5000;
tol = sqrt(eps);

n = length(x0);

AT = create_filter_matrix(filt, n)';

Amult = @(x) filter(1, filt, x);
ATmult = @(x) AT * x;

% length of the period (number of samples)
p_len = n / periods;

% constant used in penalty matrix for a suppressing effect for the part
% where air pressure = 0;
suppressing_constant = 3;

% help vector for smoothening
smooth_start = round((Q - Q_delta) * p_len);
smooth_end = round((Q + Q_delta) * p_len);
smooth_hlp = zeros(p_len, 1);
smooth_hlp(smooth_end+1:end) = ones(size(smooth_hlp(smooth_end+1:end)));
smooth_hlp(smooth_start:smooth_end) = linspace(0, 1, length(smooth_hlp(smooth_start:smooth_end)));

% create main diagonal
val1 = 1;
val2 = suppressing_constant;
diag_main = val1 * (1 - smooth_hlp) + val2 * smooth_hlp;

% create the secondary diagonal
val1 = -1;
val2 = 0;
diag_sec = val1 * (1 - smooth_hlp) + val2 * smooth_hlp;

% create the L-matrix
diag_main = repmat(diag_main, periods, 1);
diag_sec = repmat(diag_sec, periods, 1);
diag_sec = diag_sec(1:end-1);
L = diag(diag_main) + diag(diag_sec,1);

Lmult = @(x) L * x;
LTmult = @(x) L' * x;

x = Tik_conj_grad(Amult, ATmult, Lmult, LTmult, m, alpha, x0, max_iter, tol);

end