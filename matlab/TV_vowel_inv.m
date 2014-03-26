function f = TV_vowel_inv(filt, m, alpha, f0)

max_iter = 100;
n = length(f0);
A = create_filter_matrix(filt, n)';

f = TV_barzilai_borwein(A, m, alpha, f0, max_iter);

end