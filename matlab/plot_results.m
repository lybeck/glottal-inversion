function plot_results(filename, iter, x, rec, yd, relerr, relerrv, alpha, Q_data, Q_guess, periods, noise_lvl, noise_factor, f, male_filter, save)

plot_all_results(filename, iter, x, rec, yd, Q_guess, periods, save)

if save
    
    path_to_file = ['results/', filename];
    if exist([path_to_file, '.eps'], 'file') == 2
        want_to_overwrite = input('File exists. Want to overwrite? (0 = no, 1 = yes) ');
        if ~want_to_overwrite
            return;
        end
    end
    
    fileID = fopen([path_to_file, '.txt'],'w');
    fprintf(fileID,...
        ['File = ', filename, '\n\n' ...
        'Relative error of glottal impulse = %-4.2f%% \n',...
        'Relative error of generated vowel = %-4.2f%% \n',...
        'Alpha value                       = %-8.4f \n',...
        'Klatt parameter in data           = %-1.5f \n',...
        'Klatt parameter guess             = %-1.5f \n',...
        'Level of noise in data            = %-5.5f \n',...
        'Factor of the noise of the data   = %-5.5f \n',...
        'Frequency of the vowel sound      = %-7.2f \n',...
        'Inverse crime? (0 = no, 1 = yes)  : %-1d'],...
        relerr, relerrv, alpha, Q_data, Q_guess, noise_lvl, noise_factor, f, male_filter);
    fclose(fileID);
end
end

function plot_all_results(filename, iter, x, rec, yd, Q_guess, periods, save)

samples_per_period = length(x) / periods;

periods_in_simple_plot = 4;
samples = samples_per_period * periods_in_simple_plot;

x_per_length = x(samples_per_period + 1);
x_q_guess = x_per_length * Q_guess;

create_plot([filename, '_default_', num2str(iter)], x, rec, yd, periods, x_per_length, x_q_guess, save)

create_plot([filename, '_default-light_', num2str(iter)], x(1:samples), rec(1:samples), yd(1:samples), periods_in_simple_plot, x_per_length, x_q_guess, save)

create_plot([filename, '_no_objective_', num2str(iter)], x, rec, nan(length(yd), 1), periods, x_per_length, x_q_guess, save)

create_plot([filename, '_no_objective-light_', num2str(iter)], x(1:samples), rec(1:samples), nan(samples, 1), periods_in_simple_plot, x_per_length, x_q_guess, save)

create_plot([filename, '-_no-objective_one-period_', num2str(iter)], linspace(0, 1, samples_per_period), rec(1:samples_per_period), nan(samples_per_period, 1), samples_per_period, 1, Q_guess, save)

end

function create_plot(filename, x, rec, yd, periods, x_per_length, x_q_guess, save)

hold on
plot(x, rec, x, yd);

for ii=1:periods
    offset = ii-1;
    plot(x_q_guess + offset*x_per_length, 0, 'k.', 'markersize', 20)
end

xlim([0, x(end)])
hold off
if save
    
    path_to_file = ['results/', filename];
    if exist([path_to_file, '.eps'], 'file') == 2
        want_to_overwrite = input('File exists. Want to overwrite? (0 = no, 1 = yes) ');
        if ~want_to_overwrite
            return;
        end
    end
    
    scrsize=get(0,'Screensize');
    set(gcf,'Position',scrsize);
    set(gcf, 'PaperPositionMode','auto');
    
    saveas(gcf, [path_to_file, '.eps'], 'epsc');
    saveas(gcf, [path_to_file, '.png'], 'png');
    
end

clf
end