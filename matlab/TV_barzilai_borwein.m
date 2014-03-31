% Function that minimizes the objective function using Barzilai-Borwein
% method.
%
% Author: RS

function f = TV_barzilai_borwein(A, m, alpha, f0, max_iter)
 
delta = 0.0001;
fold = f0;

for k = 1:max_iter
    fprintf('k=%d,\tdelta=%4.3e,\tobj_val=%4.3f\n', k, delta, TV_obj_eval(A, fold, alpha, m));
    
    fnew = fold - delta*TV_obj_grad_eval(A, fold, alpha, m);
    
    y = fnew - fold;
    g = TV_obj_grad_eval(A, fnew, alpha, m) - TV_obj_grad_eval(A, fold, alpha, m);
    delta = (y' * y)/(y' * g);
    fold = fnew;
    
end
f = fnew;

end