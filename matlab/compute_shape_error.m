function [err, scaling_factor] = compute_shape_error(rec, old)

scaled_error = @(c) compute_relerr(c*rec, old);
init_guess = 1;
[scaling_factor, err] = fminsearch(scaled_error, init_guess);

end