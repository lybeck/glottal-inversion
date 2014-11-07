function plot_and_save(filename, x, rec, yd, relerr, relerrv, alpha, Q_data, Q_guess, Q_delta, periods, noise_lvl, noise_factor, f, male_filter)

plot_result(x, rec, yd, Q_guess, Q_delta, periods)

scrsize=get(0,'Screensize');
set(gcf,'Position',scrsize);
set(gcf, 'PaperPositionMode','auto');

path_to_file = ['results/', filename];
if exist([path_to_file, '.eps'], 'file') == 2
    want_to_overwrite = input('File exists. Want to overwrite? (0 = no, 1 = yes) ');
    if ~want_to_overwrite
        return;
    end
end

saveas(gcf, [path_to_file, '.eps'], 'epsc');
saveas(gcf, [path_to_file, '.png'], 'png');

fileID = fopen([path_to_file, '.txt'],'w');
fprintf(fileID,...
    ['File = ', filename, '\n\n' ...
     'Relative error of glottal impulse = %-4.2f%% \n',...
     'Relative error of generated vowel = %-4.2f%% \n',...
     'Alpha value                       = %-8.4f \n',...
     'Klatt parameter in data           = %-1.5f \n',...
     'Klatt parameter guess             = %-1.5f \n',...
     'Klatt parameter delta             = %-1.5f \n',...
     'Level of noise in data            = %-5.5f \n',...
     'Factor of the noise of the data   = %-5.5f \n',...
     'Frequency of the vowel sound      = %-7.2f \n',...
     'Inverse crime? (0 = no, 1 = yes)  : %-1d'],...
     relerr, relerrv, alpha, Q_data, Q_guess, Q_delta, noise_lvl, noise_factor, f, male_filter); 
 fclose(fileID);

end