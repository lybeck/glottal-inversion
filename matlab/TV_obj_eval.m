% Routine that evaluates the objective function.
%
% Author: RS

function obj = TV_obj_eval(A, f, alpha, m)

obj = ((A*f - m)'*(A*f - m))/2 + alpha*TV_penalty_eval(f);

end