function plot_result(x, rec, yd, Q_guess, Q_delta, periods)

samples_per_period = length(x) / periods;

periods_in_simple_plot = 4;
samples = samples_per_period * periods_in_simple_plot;

x_per = x(1:samples_per_period);
x_per_end = x_per(end);
x_q_range = [x_per_end * (Q_guess - Q_delta); x_per_end * (Q_guess + Q_delta)];
x_q_guess = x_per_end * Q_guess;

create_plot(1, x, rec, yd, periods, x_per_end, x_q_range, x_q_guess)

create_plot(2, x(1:samples), rec(1:samples), yd(1:samples), periods_in_simple_plot, x_per_end, x_q_range, x_q_guess)

create_plot(3, x, rec, nan(length(yd), 1), periods, x_per_end, x_q_range, x_q_guess)

create_plot(4, x(1:samples), rec(1:samples), nan(samples, 1), periods_in_simple_plot, x_per_end, x_q_range, x_q_guess)

create_plot(5, linspace(0, 1, samples_per_period), rec(1:samples_per_period), nan(samples_per_period, 1), samples_per_period, 1, [Q_guess - Q_delta; Q_guess + Q_delta], Q_guess)

end

function create_plot(fig_num, x, rec, yd, periods, x_per_end, x_q_range, x_q_guess)

figure(fig_num)
hold on
plot(x, rec, x, yd);

for ii=1:periods
    offset = ii-1;
    plot(x_q_range + offset*x_per_end, [0;0], 'r.-', 'linewidth',2, 'markersize', 20)
    plot(x_q_guess + offset*x_per_end, 0, 'k.', 'markersize', 20)
end

xlim([0, x(end)])
hold off

end