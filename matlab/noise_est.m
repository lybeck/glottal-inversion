
clear

const = load('data/constants');

% should the created data be played?
play_sound = 0;

% plot data?
show_plot = 0;

% which glottal model?
% 0: triangle wave
% 1: klatt model
klatt_model = 1;

% parameters for the data
f = 120;
Q = .4;
Q_rand = .0;
noise_lvl = .005;
periods = 10;


% number of tests
tests = 100;

mdiff = zeros(tests, 1);
fdiff = zeros(tests, 1);

for ii=1:tests
    
    [m_ref,~,~,~,~,~,~,~,~] = create_vowel_with_noise(1, klatt_model, f, Q, Q_rand, 0, periods);
    [m_male,~,~,~,~,~,~,~,~] = create_vowel_with_noise(1, klatt_model, f, Q, Q_rand, noise_lvl, periods);
    [m_female,~,~,~,~,~,~,~,~] = create_vowel_with_noise(0, klatt_model, f, Q, Q_rand, noise_lvl, periods);
    
    mdiff(ii) = norm(m_ref - m_male);
    fdiff(ii) = norm(m_ref - m_female);
    
end


fact = mean(fdiff) / mean(mdiff)

