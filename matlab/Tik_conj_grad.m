function x = Tik_conj_grad(Amult, ATmult, Lmult, LTmult, m, alpha, x0, max_iter, tol)

if ~isfunction(Amult) || ~isfunction(ATmult) || ~isfunction(Lmult) || ~isfunction(LTmult)
    error('Amult, ATmult, Lmult and LTmult must be function handles!')
end

Qmult = @(x) ATmult(Amult(x)) + alpha * LTmult(Lmult(x));

b = ATmult(m);

x = x0;
g = Qmult(x0) - b;
d = -g;

for k=1:max_iter
    
    a = -g' * d / (d' * Qmult(d));
    x = x + a * d;
    
    diffvec = Qmult(x) - b;
    diffnorm = norm(diffvec);
    
    if ~mod(k, 20)
        fprintf('Iteration %d / %d\n', k, max_iter)
        fprintf('Diff norm = %e\n\n', diffnorm)
    end
    
    if diffnorm < tol
        return;
    end
    
    g = Qmult(x) - b;
    beta = (g' * Qmult(d)) / (d' * Qmult(d));
    d = -g + beta * d;
    
end

warning('Iteration did not converge!')

end

function b = isfunction(f)
b = isa(f, 'function_handle');
end