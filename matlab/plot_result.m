function plot_result(x, rec, yd, Q_guess, Q_delta, periods)

figure(1)
hold on
plot(x, rec, x, yd);

x_per = x(1:end/periods);
x_per_end = x_per(end);
x_q_range = [x_per_end * (Q_guess - Q_delta); x_per_end * (Q_guess + Q_delta)];
x_q_guess = x_per_end * Q_guess;

for ii=1:periods
    offset = ii-1;
    plot(x_q_range + offset*x_per_end, [0;0], 'r.-', 'linewidth',2, 'markersize', 20)
    plot(x_q_guess + offset*x_per_end, 0, 'k.', 'markersize', 20)
end

xlim([0, x(end)])
hold off

end