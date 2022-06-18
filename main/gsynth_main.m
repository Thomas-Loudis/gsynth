%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GSynth
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GSynth is a software for gravity field functionals and Earth Tides modelling.
% GSynth has been composed through merging the two former modules of the
% source code i.e. GRAVsytnh and GRAVtide.
%
% GRAVsynth: Spherical harmonic synthesis of gravity field models for
%            gravity anomalies and geoid modelling
% GRAVtide:  Solid Earth and Ocean Tides effects modelling 
%
% The gravity field functionals are computed based on spherical harmonic
% synthesis. The gravity functionals being modelled and computed are:
% - Geoid (geoid Heights, undulations)
% - Gravity anomalies
% - Solid Earth tides
% - Ocean Tides
% - Tidal effects to gravity data and the geoid
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dr. Thomas Papanikolaou                                         July 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Last modified:
% 12/05/2022  Dr. Thomas Loudis Papanikolaou 
%             General upgrade of the source code interface
% 27/05/2022  Dr. Thomas Loudis Papanikolaou 
%             Development of new configuration apporach for supporting
%             time-wise series analysis of tidal computations 
% 07/06/2022  Thomas Loudis Papanikolaou
%             Integration of GRAVsytnh and GRAVtide into the GSynth package
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% References:
%
% Papanikolaou T. (2013). GRAVsynth and GRAVtide software' User guide,
% Dept. of Gravimetry, HMGS, Greece.
%
% Papanikolaou T., Papadopoulos N. (2015). High-frequency analysis of Earth
% gravity field models based on terrestrial gravity and GPS/levelling data:
% A case study in Greece, Journal of Geodetic Science, 5(1): 67-79, doi:
% 10.1515/jogs-2015-0008.   
%
% Papanikolaou T. (2012). Dynamic modelling of satellite orbits in the 
% frame of contemporary space geodesy missions, Ph.D. Dissertation, 
% Aristotle University of Thessaloniki (AUTH), Greece.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gsynth_main.m script
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:
%  main_gsynth is the main script file that calls the source code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
clc
format long e
fclose('all');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Configuration file for setting all of the required parameters and data
config_filename = 'config_gsynth.in';
% End of Input
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Folders path for source code, configuration files, input data (models)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
main_path = pwd;
%addpath(genpath(main_path));

data_path = fullfile(main_path,'/../data/');
addpath(genpath(data_path));

config_path = fullfile(main_path,'/../config/');
addpath(genpath(config_path));

src_path = fullfile(main_path,'/../src/');
addpath(genpath(src_path));

output_path = fullfile(main_path,'/../results/');
addpath(genpath(output_path));

gsynth_path = fullfile(main_path,'/../');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Call the GSynth source code package
gsynth_mainfunction(config_filename);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% cd(gsynth_path);
