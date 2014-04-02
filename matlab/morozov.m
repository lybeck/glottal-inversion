function alpha = morozov(A, m, delta, init_guess)

    [U, D, ~] = svd(A);
    d = diag(D);
    mm = U.'*m;
    r = min(size(A));
    
    f = @(a) sum((a ./ (d(1:r).^2 + a)).^2 .* mm(1:r).^2) + sum(mm(r:length(m)).^2 - delta.^2);
    df = @(a) 2.* sum((a ./ (d(1:r).^2 + a)) .* (d(1:r).^2 ./ (d(1:r).^2 + a).^2) .* mm(1:r).^2);
    
    tol = sqrt(eps);
    max_iter = 100;
    
    alpha = newton(f, df, init_guess, max_iter, tol);
%     aplha = fzero(f, init_guess); 

end 
