% Routine that evaluates the variation penalty.
%
% Author: RS

function pen = TV_penalty_eval(f)

beta = 1e-5;
diffv = sqrt( (f(2:end) - f(1:end-1)).^2 + beta );
pen = sum(diffv);

end