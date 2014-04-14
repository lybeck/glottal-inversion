function relerr = compute_relerr(rec, old)

relerr = 100 * norm(rec - old) / norm(old);

end