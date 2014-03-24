function x = myconjgrad(m, a, x0)

m = m(:);
x0 = x0(:);

max_iter = 1000;

%Qmult = @(x) ATmult(Amult(x)) + a * LTmult(Lmult(x));
%load data/A A
filt = load('data/filter_male_a.mat');
Am = @(x) filter(1, filt.alpha, x);
load data/AT AT
Qmult = @(x) AT * Am(x) + a * LTmult(Lmult(x));

tol = sqrt(eps);
b = ATmult(m);

x = x0;
g = Qmult(x0) - b;
d = -g;

for k=1:max_iter
    
    fprintf('Iteration %d / %d\n', k, max_iter)
    
    alpha = -g' * d / (d' * Qmult(d));
    x = x + alpha * d;
    
    diff = Qmult(x) - b;
    diffnorm = norm(diff);
    
    fprintf('Diff norm = %e\n\n', diffnorm)
    
    if diffnorm < tol
        return;
    end
    
    g = Qmult(x) - b;
    beta = (g' * Qmult(d)) / (d' * Qmult(d));
    d = -g + beta * d;
    
end

warning('Iteration did not converge!')

end
