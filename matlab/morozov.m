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
    
    % TODO: is this needed?
%     if norm(mm(r+1:end))>delta || delta>norm(mm)
%         error('Morozov condition is not satisfied; cannot continue computation')
%     end
    
    while ~conv
        f = @(a) sum((a ./ (d(1:r).^2 + a)).^2 .* mm(1:r).^2) + sum(mm(r+1:length(m)).^2) - delta.^2;
        df = @(a) 2.* sum((a ./ (d(1:r).^2 + a)) .* (d(1:r).^2 ./ (d(1:r).^2 + a).^2) .* mm(1:r).^2);
        
        [alpha, conv]= newton(f, df, init_guess, max_iter, tol);
        if ~conv
            delta = delta / 2;
            alpha = 0;
        end
        if delta < 1e-8
           warning('No alpha value could be obtained with Morozovs principle!');
           alpha = 1;
           return; 
        end
    end
    
    % TODO: possible alternative for newton?
%     f = @(a) sum((a ./ (d(1:r).^2 + a)).^2 .* mm(1:r).^2) + sum(mm(r+1:length(m)).^2) - delta.^2;
%     alpha = fminsearch(@(a) abs(f(a)), 1);

end 
