close all;
clear all;

% Generates all the ledalab results file that we later aggregate with script_gen_csv_eda.m

current_dir = pwd;
input_dir = fullfile(current_dir, 'data_batch_for_ledalab/');
output_dir = fullfile(current_dir, 'data_batch_ledalab_output/');

% We use the defaults here, see http://www.ledalab.de/documentation.htm
% With some minor Gaussian smoothing (this is the same setting you see when you open Ledalab
Ledalab(input_dir, 'open', 'mat', 'smooth',{'gauss',0.2}, 'analyze', 'CDA', 'optimize', 2, 'export_era', [1 4 .01 1])


% Ensure the output directory exists, if not, create it
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

% Get a list of all files in the current directory ending with '_era.mat'
files = dir('*_era.mat');

% Move each file to the output directory
for i = 1:length(files)
    src = fullfile(files(i).folder, files(i).name);
    dest = fullfile(output_dir, files(i).name);
    movefile(src, dest);
end
