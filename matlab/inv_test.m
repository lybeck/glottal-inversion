
clear

load data/data m x y yd
filt = load('data/filter_male_a');
const = load('data/constants');

x = x(:);
y = y(:);
yd = yd(:);

x0 = zeros(length(m), 1);
alpha = 500;

rec = myconjgrad(m, alpha, x0);

relerr = 100 * norm(rec - yd) / norm(rec);
fprintf('\nRelative error: %g %%\n\n', relerr)


% plots

figure(1)
plot(x, rec, x, yd)
xlim([0, x(end)])



% sound

% sound duration in seconds
d = 1;
% repetitions
rep = round(d / x(end));

recyd = repmat(rec, rep, 1);
syd = repmat(yd, rep, 1);
recvow = filter(1, filt.alpha, recyd);
vow = filter(1, filt.alpha, syd);
recyd = recyd / max(recyd);
recvow = recvow / max(recvow);
syd = syd / max(syd);
vow = vow / max(vow);

sound(syd, const.fs)
pause(2)
sound(recyd, const.fs)
pause(3)

sound(vow, const.fs)
pause(2)
sound(recvow, const.fs)
