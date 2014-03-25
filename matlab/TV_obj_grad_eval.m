% Evaluates the gradient of the objective function
%
% Author: RS

function grad = TV_obj_grad_eval(A, f, alpha, m)

grad = A'*Af - A'*m + alpha*TV_penalty_grad_eval(f);

end