%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GSynth models' data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gsynth_data_models.m script
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:
%  gsynth_data_model is a script file for downloading and saving the
%  models' data required by the GSynth software 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Thomas Loudis Papanikolaou                                   18 June 2022
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
clc
format long e
fclose('all');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Folders path for input data (models)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pwd_path = pwd;
data_path_fname = '../data/';
data_path = fullfile(pwd_path,data_path_fname);
cd(data_path);
data_path = pwd;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('%s \n', 'GSynth scripts:');
fprintf('%s \n', 'Script for download input data :: Models data');
fprintf('%s%s \n\n', 'Download and Save data in ', data_path);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gravity Field models by ICGEM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EIGEN-6C4
fprintf('%s', 'Gravity Field model :: EIGEN-6C4 :: ');
url_read   = 'http://icgem.gfz-potsdam.de/getmodel/gfc/7fd8fe44aa1518cd79ca84300aef4b41ddb2364aef9e82b7cdaabdb60a9053f1/EIGEN-6C4.gfc';
save_fname = 'EIGEN-6C4.gfc';
outpath = websave(save_fname , url_read);
fprintf('%s \n', 'downloaded');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ocean Tides model by CNES/GRGS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('%s', 'Ocean Tides model :: FES2014b-v1 :: ');
url_read   = 'http://gravitegrace.get.obs-mip.fr/geofluid/fes2014b.v1.Cnm-Snm_Om1+Om2C20_with_S1_wave.POT_format.txt';
save_fname = 'fes2014b_v1.txt';
outpath = websave(save_fname , url_read);
fprintf('%s \n', 'downloaded');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Planetary and Lunar ephemeris by JPL/NASA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('%s', 'Planetary/Lunar ephemeris :: DE423 :: ');
url_read   = 'https://ssd.jpl.nasa.gov/ftp/eph/planets/ascii/de423/ascp2000.423';
save_fname = 'ascp2000.423';
outpath = websave(save_fname , url_read);

url_read   = 'https://ssd.jpl.nasa.gov/ftp/eph/planets/ascii/de423/header.423';
save_fname = 'header.423';
outpath = websave(save_fname , url_read);

fprintf('%s \n', 'downloaded');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Earth Orientation Parameters by IERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('%s ', 'Earth Orientation Parameters :: EOP-C04 :: ');
url_read = 'https://hpiers.obspm.fr/iers/eop/eopc04/eopc04_IAU2000.62-now';
save_fname = 'eopc04_IAU2000.62-now';
outpath = websave(save_fname , url_read);
fprintf('%s \n', 'downloaded');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('%s%s \n\n', 'Data have been downloaded and saved in :: ', data_path);

% Direct to the central path of the package
gsynth_path = fullfile(pwd_path,'/../');
cd(gsynth_path);
