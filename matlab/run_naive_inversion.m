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