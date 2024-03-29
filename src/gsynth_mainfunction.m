function gsynth_mainfunction(config_filename)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gsynth_mainfunction.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:
%  gsynth_mainfunction is the main function for calling the source code of
%  GSynth
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input arguments:
% - config_filename     : Configuration file name
%
% Output arguments:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dr. Thomas Loudis Papanikolaou                               7 June  2022
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 10/06/2022  Thomas Loudis Papanikolaou
%             Code modification for changing the script to function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


global src_version 
src_version = 'v.0.9.4';

to_tic = tic;
% delete('*.out');
% [status, message, messageid] = rmdir('OUT*','s');

fprintf('%s%s \n\n','GSynth version ',src_version);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Configuration file read: Global variables assignment
read_cfg_gsynth(config_filename);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('%s \n\n','Data reading and preprocessing');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data read and preprocessing: 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gravity Field model read
prm_gfm(config_filename);

% Ocean Tides model
prm_ocean_tides(config_filename);

% Planets ephemeris data read and processing

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GSynth input file read and processing: Stations data points 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global datapoints_in_fname_glb
[datapoints_matrix_in, datapoints_id_array] = datapoints_preproc(datapoints_in_fname_glb);

global datapoints_id_array_glb
datapoints_id_array_glb = datapoints_id_array;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Point-wise & Time-wise copmutations based on spherical harmonic synthesis 
% for Solid Earth and Ocean tides effects, Gravity anomalies, Geoid undulations
[synth_series, synth_series_3d] = gsynth_series(datapoints_matrix_in);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Write data to output file
% out_filename = 'synth_series.out';
% save(out_filename,'synth_series','-ascii')
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GSynth output data format
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[clock_time] = clock;
clock_char = sprintf('%d',clock_time(1));
for i = 2 : 5
if clock_time(i) < 10 
    clock_i = sprintf('%s%d','0',clock_time(i));
else
    clock_i = sprintf('%d',clock_time(i));
end
clock_char = sprintf('%s%s',clock_char,clock_i);
end    

sec = fix(clock_time(6));
if clock_time(i) < 10 
    clock_i = sprintf('%s%d','0',sec);
else
    clock_i = sprintf('%d',sec);
end
clock_char = sprintf('%s%s',clock_char,clock_i);

out_filename_0 = 'gsynth_series';
gsynth_output_suffix = '.shs';
out_filename = sprintf('%s%s%s%s',out_filename_0,'_',clock_char,gsynth_output_suffix);

% Write computations results to output file
[fid] = write_dataformat_gsytnh(out_filename, config_filename, synth_series_3d, datapoints_id_array);
[status,message,messageid] = copyfile(out_filename,'../results');
delete(out_filename);

fprintf('\n');
fprintf('%s %s \n\n', 'Results have been stored in the output file:',out_filename);

current_path = pwd;
output_path = fullfile(current_path,'/../results/');
cd(output_path);
output_path = pwd;
fprintf('%s %s \n\n', 'Results folder path:', output_path);
% Open results output file
edit(out_filename);
% Return to the main path
cd(current_path);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('%s % .3f \n', 'Overall Computation Time (min)             :', toc(to_tic)/60);
