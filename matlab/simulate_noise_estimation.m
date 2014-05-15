
function simulate_noise_estimation(min_size, max_size, iters)

errs = [];
vals = [];
for k = linspace(min_size, max_size, iters);
    factor = 50;
    noise_size = k;
    noise_vec = randn(noise_size, 1) * factor;
    
    estim_chi = delta_fun(noise_size, factor);
    estim_txtbook = sqrt(noise_size) * factor;
    target = norm(noise_vec);
    
    err_chi = abs(estim_chi - target) / target;
    err_txtbook = abs(estim_txtbook - target) / target;
    errs = [errs; [k, err_chi, err_txtbook]];
    
    vals = [vals; [k, estim_chi, estim_txtbook]];
    
    fprintf('\n')
    print_results(estim_chi, estim_txtbook, target);
end

plot(vals(:,1), abs(vals(:,2) - vals(:,3)), 'k-', 'linewidth', 1.3);
xlim([min_size max_size])
xlabel('Vector length', 'fontsize', 12);
ylabel('Error', 'fontsize', 12)

yticks = get(gca, 'ytick');
set(gca, 'xtick', linspace(min_size, max_size, 6));
set(gca, 'ytick', linspace(min(yticks), max(yticks), 5));
set(gca, 'fontsize', 10)
grid on

pause();

plot(errs(:,1), errs(:,2), 'k-', 'linewidth', 1.3);
xlim([min_size max_size])
xlabel('Vector length', 'fontsize', 12);
ylabel('Error', 'fontsize', 12)

yticks = get(gca, 'ytick');
set(gca, 'xtick', linspace(min_size, max_size, 6));
set(gca, 'ytick', linspace(min(yticks), max(yticks), 5));
set(gca, 'fontsize', 10)
grid on

end

function print_results(estim_chi, estim_txtbook, target)

fprintf(['Estimation using mean of chi-dist.: %-10.3f\n',...
         'Estimation using textbook model:    %-10.3f\n',...
         'Actual noise magnitude:             %-10.3f\n'],...
         estim_chi, estim_txtbook, target);

end