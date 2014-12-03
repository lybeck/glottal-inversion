function [x_axis y_axis] = get_frequency_plot_params(m)

len_m = length(m);
const = load('data/constants');
fs = const.fs;
len_freq = ceil(len_m/2);

fft_m = abs(fft(m));

bin_vals = 0 : len_m - 1;
Hz = (fs/len_m) * bin_vals;

x_axis = Hz(1:len_freq);
y_axis = 10*log10(fft_m(1:len_freq));

end