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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('%s \n\n', 'Donwload and save models data to folder "../data"');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gravity Field models by ICGEM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EIGEN-6C4
url_read   = 'http://icgem.gfz-potsdam.de/getmodel/gfc/7fd8fe44aa1518cd79ca84300aef4b41ddb2364aef9e82b7cdaabdb60a9053f1/EIGEN-6C4.gfc';
save_fname = 'EIGEN-6C4.gfc';
outpath = websave(save_fname , url_read);
%[status,message,messageid] = copyfile(save_fname,data_path);
%delete(save_fname);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ocean Tides model by CNES/GRGS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
url_read   = 'http://gravitegrace.get.obs-mip.fr/geofluid/fes2014b.v1.Cnm-Snm_Om1+Om2C20_with_S1_wave.POT_format.txt';
save_fname = 'fes2014b_v1.txt';
outpath = websave(save_fname , url_read);
%[status,message,messageid] = copyfile(save_fname,data_path);
%delete(save_fname);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Planetary and Lunar ephemeris by JPL/NASA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
url_read   = 'https://ssd.jpl.nasa.gov/ftp/eph/planets/ascii/de423/ascp2000.423';
save_fname = 'ascp2000.423';
outpath = websave(save_fname , url_read);
%[status,message,messageid] = copyfile(save_fname,data_path);
%delete(save_fname);

url_read   = 'https://ssd.jpl.nasa.gov/ftp/eph/planets/ascii/de423/header.423';
save_fname = 'header.423';
outpath = websave(save_fname , url_read);
%[status,message,messageid] = copyfile(save_fname,data_path);
%delete(save_fname);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Earth Orientation Parameters by IERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
url_read = 'https://hpiers.obspm.fr/iers/eop/eopc04/eopc04_IAU2000.62-now';
save_fname = 'eopc04_IAU2000.62-now';
outpath = websave(save_fname , url_read);
% [status,message,messageid] = copyfile(save_fname,data_path);
% delete(save_fname);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%cd(pwd_path);
