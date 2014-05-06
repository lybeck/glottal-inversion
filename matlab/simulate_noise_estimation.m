
function simulate_noise_estimation(iters)

errs = [];
vals = [];
for k = 1:iters
    factor = k;
    noise_size = 1e3;
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

plot(errs(:,1), errs(:,2), errs(:,1), errs(:,3));
legend('Chi', 'Textbook', 'Location', 'best');

pause();

plot(vals(:,1), vals(:,2), vals(:,1), vals(:,3));
legend('Chi', 'Textbook', 'Location', 'best');
end

function print_results(estim_chi, estim_txtbook, target)

fprintf(['Estimation using mean of chi-dist.: %-10.3f\n',...
         'Estimation using textbook model:    %-10.3f\n',...
         'Actual noise magnitude:             %-10.3f\n'],...
         estim_chi, estim_txtbook, target);

end