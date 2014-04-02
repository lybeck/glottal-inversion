function x = newton(f, df, init_guess, max_iter, tol)

    old_x = init_guess;
    if abs(f(old_x)) < tol
       x = old_x; 
       return;
    end
    
    for k = 1:max_iter
        new_x = old_x - (f(old_x) / df(old_x));
        if abs(f(new_x)) < tol
            x = new_x;
            return;
        end
        old_x = new_x;
        abs(f(new_x))
    end
    error('Iteration did not converge with given maximum iterations!');

end