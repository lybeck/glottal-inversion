function plot_and_save(filename, x, rec, yd, relerr, relerrv, Q, Q_rand, noise_lvl, f, male_filter)

plot(x, rec, x, yd);
xlim([0, x(end)])
scrsize=get(0,'Screensize');
set(gcf,'Position',scrsize);
set(gcf, 'PaperPositionMode','auto');

path_to_file = ['results/', filename];
if exist([path_to_file, '.png'], 'file') == 2
    want_to_overwrite = input('File exists. Want to overwrite? (0 = no, 1 = yes) ');
    if ~want_to_overwrite
        return;
    end
end

saveas(gcf, [path_to_file, '.png'], 'png');

fileID = fopen([path_to_file, '.txt'],'w');
fprintf(fileID,...
    ['File = ', filename, '\n\n' ...
     'Relative error of glottal impulse = %-10.2f%% \n',...
     'Relative error of generated vowel = %-10.2f%% \n',...
     'Klatt parameter                   = %-1.5f \n',...
     'Random factor of Klatt parameter  = %-1.5f \n',...
     'Level of noise in data            = %-5.5f \n',...
     'Frequency of the vowel sound      = %-7.2f \n',...
     'Inverse crime? (0 = no, 1 = yes)  : %-1d'],...
     relerr, relerrv, Q, Q_rand, noise_lvl, f, male_filter);
 fclose(fileID);

end