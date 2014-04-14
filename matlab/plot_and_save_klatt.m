

f = 120;
Q = .7;
fs = 1e5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The Klatt-model. This is done with copy-paste so that we can use a
% a higher sampling rate to get a nicer image.

T = 1 / f;
t0 = Q * T;

a = 27 / (4 * t0^2);
b = -27 / (4 * t0^3);

g = @(t) a * t.^2 + b * t.^3;
gd = @(t) 2 * a * t + 3 * b * t.^2;

xx = linspace(0, T, fs * T)';
yy = zeros(size(xx));
yd = zeros(size(xx));

ind = (xx < t0); 
yy(ind) = g(xx(ind));
yd(ind) = gd(xx(ind));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xx = 1000 * xx;

minx = 0;
maxx = xx(end);

linewidth = 1.5;
titlesize = 40;
labelsize = 32;


figure(1)

% airflow plot

subplot(1, 2, 1)

plot(xx, yy, 'k-', 'linewidth', linewidth)
xlim([minx, maxx])
ylim([-.1, 1.1])
grid on
title('Glottal flow', 'fontsize', titlesize)
xlab = xlabel('Time (ms)');
ylab = ylabel('Amplitude');
set(xlab, 'fontsize', labelsize)
set(ylab, 'fontsize', labelsize)



% pressure plot

minyd = min(yd);
maxyd = max(yd);
yddiff = maxyd - minyd;
ydbuff = .1 * yddiff;


subplot(1, 2, 2)

plot(xx, yd, 'k-', 'linewidth', linewidth)
xlim([minx, maxx])
ylim([minyd - ydbuff, maxyd + ydbuff])
grid on
title('Glottal pressure', 'fontsize', titlesize)
xlab = xlabel('Time (ms)');
ylab = ylabel('Pressure');
set(xlab, 'fontsize', labelsize)
set(ylab, 'fontsize', labelsize)

sz=get(0,'Screensize');
sz(4) = sz(4) / 2;
set(gcf, 'Position', sz);
set(gcf, 'PaperPositionMode','auto');

saveas(gcf, 'figures/klatt.eps', 'eps');

