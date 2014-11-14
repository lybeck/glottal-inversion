function [folder, want_to_overwrite] = create_results_folder(filename)

folder = ['results/', filename , '_result_folder'];
if exist(folder) == 7
    want_to_overwrite = input('Results folder exists. Want to overwrite all data? (0 = no, 1 = yes) ');
else
    mkdir(folder);
    want_to_overwrite = 1;
end

end