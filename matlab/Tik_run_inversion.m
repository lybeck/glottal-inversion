% A routine that computes the reconstruction of the glottal excitation
% signal according to the vowel data generated by create_simulated_data.
% By default the routine will plot the reconstruction of the glottal
% excitation signal, and optional outputs include playing the glottal
% excitation signal and saving both the sound data and plot data of the
% reconstruction. Files required by the routine are (all located in a data folder)
% -data.mat (generated by create_simulated_data)
% -filter_male_a.mat
% -constants.mat
%
% See also CREATE_SIMULATED_DATA, TIK_A_INV, MOROZOV



clear

% play sound from reconstruction?
play_sound = 0;

% save sound file from reconstruction?
save_sound = 0;

% save plot to results?
save_plot = 0;

load data/data m x yd periods Q_data Q_guess Q_delta noise_lvl noise_factor f data_male_filter
filt = load('data/filter_male_a');
const = load('data/constants');

% filter used for inversion
% 0: female filter
% 1: male filter
male_filter = 1;

% noise multiplier due to error in filter
% if the data is created with inverse crime, noise_level and
% noise_factor need to be sent to the funtion
if xor(data_male_filter, male_filter)
    noise_est = estimate_noise(m, f, Q_guess, periods);
else
    noise_est = estimate_noise(m, f, Q_guess, periods, noise_lvl, noise_factor);
end

% alpha-estimation
x0 = zeros(length(m), 1);
delta = delta_fun(length(m), noise_est);
alpha = morozov(create_filter_matrix(filt.alpha, length(m)), m, delta, 1);

% creating the reconstruction with Tikhonov regularization strategy
rec = Tik_a_inv(m, alpha, x0, periods, Q_guess, Q_delta, male_filter);

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
    filename = 'Comparison-201';
    plot_and_save(filename, x, rec, yd, relerr, relerrv, alpha, Q_data, Q_guess, Q_delta, periods, noise_lvl, noise_factor, f, data_male_filter);
else
    plot_result(x, rec, yd, Q_guess, Q_delta, periods)
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
