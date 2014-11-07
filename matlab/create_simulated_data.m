% asdasd


clear

const = load('data/constants');

% should the created data be played?
play_sound = 0;

% plot data?
show_plot = 0;

% which filter should be used?
% 0: female
% 1: male
data_male_filter = 0;

% which glottal model?
% 0: triangle wave
% 1: klatt model
klatt_model = 1;

% the amount of iterations to try and find the right klatt variable
iterations = 8;

% should data validation be used?
validate_data = 0;

% parameters for the data
f = 100;
Q_data = .2;
Q_guess = 1;
Q_delta = .0;
noise_lvl = .05;
periods = 10;

% check that the arguments are ok, if data validation is used
if validate_data
    assert(Q_data <= Q_guess + Q_delta && Q_data >= Q_guess - Q_delta, ...
        'Invalid arguments in data creation! The Q for creating the glottal data must be inside the range [Q_guess-Q_delta, Q_guess+Q_delta]!')
end

if klatt_model
    [xx, yyd] = klatt(f, Q_data);
else
    [xx, yyd] = glottal_triangle(f, Q_data);
end

if data_male_filter
    filt = load('data/filter_male_a');
else
    filt = load('data/filter_female_a');
end

len = length(xx);
maxx = xx(len);

% sound duration in seconds
d = 1;

% repetitions
rep = round(d / maxx);

pres = repmat(yyd, rep, 1);

vow = filter(1, filt.alpha, pres);

noise_factor =  max(abs(vow));
noise = noise_lvl * noise_factor;
noisevow = vow + noise * randn(size(vow));



% create and save data for inversion
start = 4;

m = noisevow(start * len : periods * len + start * len - 1);
x = linspace(0, periods * maxx, periods * len);
yd = repmat(yyd, periods, 1);
plotvow = vow(start * len : periods * len + start * len - 1);

save data/data m x yd periods Q_data Q_guess Q_delta noise_lvl noise_factor f data_male_filter iterations



if show_plot
    
    figure(2)
    clf
    plot(x, yd)
    xlim([0, periods * maxx])
    
    figure(3)
    clf
    plot(x, plotvow)
    xlim([0, periods * maxx])
    
end

if play_sound
    
    pres = pres / max(pres);
    maxvow = max(vow);
    vow = vow / maxvow;
    noisevow = noisevow / maxvow;
    
    sound(pres, const.fs)
    pause(1.5)
    sound(vow, const.fs)
    pause(1.5)
    sound(noisevow, const.fs)
    
end
