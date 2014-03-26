
clear

% play sound from reconstruction?
play_sound = 0;

load data/data m x y yd periods Q
filt = load('data/filter_male_a');
const = load('data/constants');

% filter used for inversion
% 0: female filter
% 1: male filter
male_filter = 1;

x0 = zeros(length(m), 1);
alpha = 500;

% rec = myconjgrad(m, alpha, x0);
rec = Tik_a_inv(m, alpha, x0, periods, Q, male_filter);

% relative error
relerr = 100 * norm(rec - yd) / norm(rec);
fprintf('\nRelative error: %g %%\n\n', relerr)


% plots
figure(1)
plot(x, rec, x, yd)
xlim([0, x(end)])



% sound
if play_sound
    
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
    
end
