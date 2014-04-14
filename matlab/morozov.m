% MOROZOV(A, M, DELTA, INIT_GUESS)
% Calculates the alpha parameter using Morozov's discrepancy principle.
% Parameters:
% - A = the filter matrix from the matrix model
% - M = measurement data
% - DELTA = approximation of the level of noise in measurement data
% - INIT_GUESS = initial guess of the alpha parameter
%
% Returns:
% - The computed alpha parameter value.

function alpha = morozov(A, m, delta, init_guess)

    [U, D, ~] = svd(A);
    d = diag(D);
    mm = U.'*m;
    r = min(size(A));
    tol = 1e-6;
    max_iter = 5000;
    conv = 0;
    
    while ~conv
        f = @(a) sum((a ./ (d(1:r).^2 + a)).^2 .* mm(1:r).^2) + sum(mm(r:length(m)).^2 - delta.^2);
        df = @(a) 2.* sum((a ./ (d(1:r).^2 + a)) .* (d(1:r).^2 ./ (d(1:r).^2 + a).^2) .* mm(1:r).^2);
        
        [alpha, conv]= newton(f, df, init_guess, max_iter, tol);
        if ~conv
            delta = delta * 0.1;
            alpha = 0;
        end
        if delta < 1e-8
           warning('No alpha value could be obtained with Morozovs principle!');
           alpha = 1;
           return; 
        end
    end

end 
