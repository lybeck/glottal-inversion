
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

load data/data m x y yd periods Q Q_rand noise_lvl noise_factor f data_male_filter
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
        'noise_factor: %f\n' ...
        'noise_factor * noise_lvl: %f\n' ...
        'periods: %d\n' ...
        ], data_male_filter, f, Q, Q_rand, noise_lvl, noise_factor, noise_lvl*noise_factor, periods);
    fclose(param_file);
end

x0 = zeros(length(m), 1);

start = 301;
stop = 600;
step = 1;

alphavec = start : step : stop;
n = length(alphavec);

errs = zeros(n, 3);
errs(:,1) = alphavec(:);
errs(:,2) = nan * errs(:,2);
errs(:,3) = nan * errs(:,3);

best_err = inf;
best_shape_err = inf;

for ii=1:n
    alpha = alphavec(ii);
    
    rec = Tik_a_inv(m, alpha, x0, periods, Q, male_filter);
    
    relerr = compute_relerr(rec, yd);
    shape_err = compute_shape_error(rec, yd);
    fprintf('Alpha: %-8.2f Relative error: %-8.2f Shape error: %-8.2f\n', alpha, relerr, shape_err)
    errs(ii, :) = [alpha, relerr, shape_err];
    if relerr < best_err
        best_err = relerr;
        best_alpha = alpha;
        best_rec = rec;
    end
    if shape_err < best_shape_err
        best_shape_err = shape_err;
        best_shape_alpha = alpha;
        best_shape_rec = rec;
    end
    
    
    if save_data
        save(filepath, 'errs')
    end
    
    plot(errs(:,1), errs(:,2), 'b-', errs(:,1), errs(:,3), 'g-')
    xlim([start, stop])
    pause(.1)
end

plot(errs(:,1), errs(:,2), 'b-', errs(:,1), errs(:,3), 'g-')
hold on
plot(best_alpha, best_err, 'b.', 'markersize', 20)
plot(best_shape_alpha, best_shape_err, 'g.', 'markersize', 20)
hold off
xlim([start, stop])

disp('')
fprintf('Least relative error: %-8.2f Alpha: %-8.2f\n', best_err, best_alpha)
fprintf('Least shape error:    %-8.2f Alpha: %-8.2f\n', best_shape_err, best_shape_alpha)

rec1 = Tik_a_inv(m, best_alpha, x0, periods, Q, male_filter);
figure(2)
plot(x, rec1, x, yd)
xlim([0, x(end)])
title('Least relative error')

rec2 = Tik_a_inv(m, best_shape_alpha, x0, periods, Q, male_filter);
figure(3)
plot(x, rec2, x, yd)
xlim([0, x(end)])
title('Least shape error')

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
