% NEWTON(F, DF, INIT_GUESS, MAX_ITER, TOL)
% An implementation of the root finding algorithm called Newton's method (for more 
% information see <a href="http://http://en.wikipedia.org/wiki/Newton%27s_method">here</a>).
% Parameters:
% - F = a functionhandle of the function to be minimized
% - DF = a functionhandle of the of the derivative of the function
% - INIT_GUESS = initial guess of the root
% - MAX_ITER = maximum amount of iterations
% - TOL = maximum tolerance of the error of the root
%
% Returns:
% - X = the root computed by the algorithm
% - CONV = flag indicating if convergence was achieved

function [x, conv] = newton(f, df, init_guess, max_iter, tol)

    x = init_guess;
    old_x = x;
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
%         fprintf('alpha = %-2.4e\n', abs(f(new_x)));
        
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