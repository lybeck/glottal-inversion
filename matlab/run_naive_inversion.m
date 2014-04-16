load data/data m x y yd periods Q Q_rand noise_lvl noise_factor f data_male_filter
filt = load('data/filter_male_a');

A = create_filter_matrix(filt.alpha, length(m));
rec = A \ m;

figure(1)
plot(x, rec)
hold on
plot(x, yd, 'g-', 'linewidth', 2);
xlim([0, x(end)])
scrsize=get(0,'Screensize');
set(gcf,'Position',scrsize);


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

prefix = 'naive_test[V2]_'

wavwrite(syd, const.fs, [prefix, 'glottal_impulse_data']);
wavwrite(recyd, const.fs, [prefix, 'glottal_impulse_rec']);
wavwrite(vow, const.fs, [prefix, 'vowel_data']);
wavwrite(recvow, const.fs, [prefix, 'vowel_rec']);