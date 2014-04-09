
clear

% play sound from reconstruction?
play_sound = 0;

% save sound file from reconstruction?
save_sound = 0;

% save plot to results?
save_data = 1;

% save parameters
directory = 'results/tik_alpha_nocrime1';
filename = 'tik_inv_errs.mat';
filepath = [directory, '/', filename];

load data/data m x y yd periods Q Q_rand noise_lvl noise f data_male_filter
filt = load('data/filter_male_a');
const = load('data/constants');

% filter used for inversion
% 0: female filter
% 1: male filter
male_filter = 1;

if save_data
    if ~exist(directory, 'dir')
        mkdir(directory)
    end
    param_path = [directory, '/parameters.txt'];
    param_file = fopen(param_path, 'w');
    fprintf(param_file, [ ...
        'data_male_filter: %d\n' ...
        'f: %d\n' ...
        'Q: %f\n' ...
        'Q_rand: %f\n' ...
        'noise_lvl: %f\n' ...
        'noise: %f\n' ...
        'periods: %d\n' ...
        ], data_male_filter, f, Q, Q_rand, noise_lvl, noise, periods);
    fclose(param_file);
end

x0 = zeros(length(m), 1);

start = 0;
stop = 100;
step = .2;

alphavec = start + step : step : stop;
n = length(alphavec);

errs = zeros(n, 2);
errs(:,1) = alphavec(:);
errs(:,2) = nan * errs(:,2);

best_err = inf;

for ii=1:n
    alpha = alphavec(ii)
    rec = Tik_a_inv(m, alpha, x0, periods, Q, male_filter);
    relerr = 100 * norm(rec - yd) / norm(rec)
    errs(ii, :) = [alpha, relerr];
    if relerr < best_err
        best_err = relerr;
        best_alpha = alpha;
        best_rec = rec;
    end
    
    
    if save_data
        save(filepath, 'errs')
    end
    
    plot(errs(:,1), errs(:,2))
    xlim([start + step, stop])
    pause(.1)
end

alpha = best_alpha;
rec = best_rec;

% relative error
relerr = 100 * norm(rec - yd) / norm(rec);
recv = filter(1, filt.alpha, rec);
v = filter(1, filt.alpha, yd);
relerrv = 100 * norm(recv - v) / norm(v);
fprintf('\nRelative error on glottal impulse : %g %%\n', relerr)
fprintf('\nRelative error on vowel           : %g %%\n\n', relerrv)

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
    
    if save_sound
        
        wavwrite(syd, const.fs, 'glottal_impulse_data');
        wavwrite(recyd, const.fs, 'glottal_impulse_rec');
        wavwrite(vow, const.fs, 'vowel_data');
        wavwrite(recvow, const.fs, 'vowel_rec');
        
    end
end
