
test_iters = 100;

test_errors = nan(test_iters, 3);

for jj = 1:test_iters
    
    fprintf('\nIteration no. %3d\n\n', jj)
    
    create_simulated_data
    
    Tik_run_inversion
    
    test_errors(jj, 1) = compute_relerr(Q_guess, Q_data);
    test_errors(jj, 2) = f;
    test_errors(jj, 3) = Q_data;
    
    disp('')
    
end

save data/klatt_param_approx_errors test_errors
