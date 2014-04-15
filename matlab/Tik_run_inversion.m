
clear

% play sound from reconstruction?
play_sound = 1;

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

% noise multiplier due to error in filter
noise_est = estimate_noise(m, f, Q, periods);

x0 = zeros(length(m), 1);
delta = delta_fun(length(m), noise_est);
alpha = morozov(create_filter_matrix(filt.alpha, length(m)), m, delta, 1);

rec = Tik_a_inv(m, alpha, x0, periods, Q, male_filter);

% relative error
relerr = compute_relerr(rec, yd);
recv = filter(1, filt.alpha, rec);
v = filter(1, filt.alpha, yd);
relerrv = compute_relerr(recv, v);
[shape_err, shape_err_fac] = compute_shape_error(rec, yd);

fprintf('\n')
fprintf('Alpha used in calculations        : %.2f\n', alpha)
fprintf('Relative error on glottal impulse : %g %%\n', relerr)
fprintf('Shape error on glottal impulse    : %g %%\n', shape_err)
fprintf('Relative error on vowel           : %g %%\n\n', relerrv)

% plots
if save_plot
    filename = 'morozov_no-crime_error-005_Qrand-0[Pres-V4]';
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
        
        prefix = '';
        
        if save_plot
            prefix = ['results/', filename];
        end
        
        wavwrite(syd, const.fs, [prefix, 'glottal_impulse_data']);
        wavwrite(recyd, const.fs, [prefix, 'glottal_impulse_rec']);
        wavwrite(vow, const.fs, [prefix, 'vowel_data']);
        wavwrite(recvow, const.fs, [prefix, 'vowel_rec']);
    
    end
end
