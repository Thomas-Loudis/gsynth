function [gama] = grav_norm(phi)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gravity field functionals based on spherical harmonics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:
%   Computation of functionals (e.g. geoid height, gravity anomaly, ...)
%   based on the spherical harmonics expansion and the harmonics
%   coefficients of an Earth Gravity Model (EGM).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input arguments:
% - phi : Geodetic Latitude in degrees
%
% Output arguments:
% - gama  : Normal gravity in mgal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dr. Thomas D. Papanikolaou                                     March 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Last modified:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% degrees to radians conversion
cf_deg2rad = (pi / 180);
phi_rad = cf_deg2rad * phi;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Normal Gravity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gravity formula GRS'80
% in m/sec^2
gama_e = 9.7803267715;

% series expansion
gama = gama_e * (1 + 0.0052790414 * sin(phi_rad)^2 + 0.0000232718 * sin(phi_rad)^4 + 0.0000001262 * sin(phi_rad)^6 + 0.0000000007 * sin(phi_rad)^8);

% in mgal
gama = gama * 10^(5);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gama_e = 9.7803253359;  % m/sec^2
gama = gama_e * 10^5 * (1 + 0.00193185265241 * sin(phi_rad)^2 ) * (1 / sqrt(1 - 0.00669437999014 * sin(phi_rad)^2) ); % mgal
