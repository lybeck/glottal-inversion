% Function that evaluates the gradient of the penalty function of the
% objective function.
%
% Author: RS

function grad = TV_penalty_grad_eval(f)

n = length(f);
grad  = zeros(n,1);
beta = 1e-5;

grad(1) = (f(1) - f(2)) / eval_single_point(f, 2, beta);
for k = 2:(n-1);
   
    grad(k) = (f(k) - f(k-1)) / eval_single_point(f, k, beta) + (f(k) - f(k+1)) / eval_single_point(f, k + 1, beta);
    
end
grad(end) = (f(n) - f(n-1)) / eval_single_point(f, n, beta);

end

function x = eval_single_point(f, k, beta)

x = sqrt((f(k) - f(k-1)).^2 + beta);

end
