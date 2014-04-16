clear

load('errs_0_600.mat');
[min_relerr, min_alpha] = min(errs(:,2));
tik_alpha = 104.5367;
tik_relerr = errs(int8(tik_alpha), 2);

plot(errs(:,1), errs(:,2), 'k-');
axis([0, 600, 64, 68]);
hold on

plot(min_alpha, min_relerr, 'k.', 'markersize', 35);
plot(tik_alpha, tik_relerr, 'r.', 'markersize', 35);

yticks = get(gca, 'ytick');
set(gca, 'ytick', sort([yticks(1), yticks(4:end), min_relerr, tik_relerr]))
set(gca, 'fontsize', 15)
% title('Error of the reconstruction', 'fontsize', 50)
% ylab = ylabel('Relative error (%)');
% xlab = xlabel('Alpha');
% set(ylab, 'fontsize', 35)
% set(xlab, 'fontsize', 35)
grid on

screensize = get(0, 'screensize');
screensize(4) = screensize(4) * 1.02;
set(gcf, 'position', screensize);

set(gcf, 'paperpositionmode', 'auto')

saveas(gcf, 'alpha_errs_iter.eps', 'epsc')
