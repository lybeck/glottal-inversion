function [relerr, relerrv, shape_err, shape_err_fac] = calculate_statistic(filt, rec, yd)

relerr = compute_relerr(rec, yd);
recv = filter(1, filt.alpha, rec);
v = filter(1, filt.alpha, yd);
relerrv = compute_relerr(recv, v);
[shape_err, shape_err_fac] = compute_shape_error(rec, yd);

end