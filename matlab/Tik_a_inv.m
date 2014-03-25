function x = Tik_a_inv(m, alpha, x0, male)

if male
    filt = load('data/filter_male_a');
else
    filt = load('data/filter_female_a');
end

x = Tik_vowel_inv(filt.alpha, m, alpha, x0);

end