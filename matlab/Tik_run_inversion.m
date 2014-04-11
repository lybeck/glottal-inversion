
clear

% play sound from reconstruction?
play_sound = 0;

% save sound file from reconstruction?
save_sound = 0;

% save plot to results?
save_plot = 1;

load data/data m x y yd periods Q Q_rand noise_lvl noise_factor f data_male_filter
filt = load('data/filter_male_a');
const = load('data/constants');

% filter used for inversion
% 0: female filter
% 1: male filter
male_filter = 1;

x0 = zeros(length(m), 1);

delta = length(m) * noise_lvl * noise_factor;
alpha = morozov(create_filter_matrix(filt.alpha, length(m))', m, delta, 1);
% alpha = 20;

% rec = myconjgrad(m, alpha, x0);
rec = Tik_a_inv(m, alpha, x0, periods, Q, male_filter);

% relative error
relerr = 100 * norm(rec - yd) / norm(rec);
recv = filter(1, filt.alpha, rec);
v = filter(1, filt.alpha, yd);
relerrv = 100 * norm(recv - v) / norm(v);
fprintf('\nRelative error on glottal impulse : %g %%\n', relerr)
fprintf('\nRelative error on vowel           : %g %%\n\n', relerrv)


% plots
if save_plot
    filename = 'morozov_no-crime_error-005_Qrand-0[V2]';
    plot_and_save(filename, x, rec, yd, relerr, relerrv, alpha, Q, Q_rand, noise_lvl, noise_factor, f, data_male_filter);
else
    figure(1)
    plot(x, rec, x, yd)
    xlim([0, x(end)])
end

% sound
if play_sound || save_sound
    
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
    
    if play_sound
        
        sound(syd, const.fs)
        pause(2)
        sound(recyd, const.fs)
        pause(3)
        
        sound(vow, const.fs)
        pause(2)
        sound(recvow, const.fs)
    
    end
    
    if save_sound
       
       wavwrite(syd, const.fs, 'glottal_impulse_data');
       wavwrite(recyd, const.fs, 'glottal_impulse_rec');
       wavwrite(vow, const.fs, 'vowel_data');
       wavwrite(recvow, const.fs, 'vowel_rec');
    
    end
end
