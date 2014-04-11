function [x, conv] = newton(f, df, init_guess, max_iter, tol)

    old_x = init_guess;
    if abs(f(old_x)) < tol
       x = old_x; 
       conv = 1;
       return;
    end
    
    for k = 1:max_iter
        new_x = old_x - (f(old_x) / df(old_x));
        if abs(f(new_x)) < tol
            x = new_x;
            conv = 1;
            return;
        end
        old_x = new_x;
        fprintf('alpha = %-2.4e\n', abs(f(new_x)));
        
        if(isinf(old_x) || isnan(old_x))
           x = 0;
           conv = 0;
           warning('Iteration diverged!');
           return;
        end
    end
    warning('Iteration did not converge within given maximum iterations!');
    conv = 0;

end