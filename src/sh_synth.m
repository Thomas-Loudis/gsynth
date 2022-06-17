function [Dg,N,zeta,zeta_e,zeta_z,C1,C2,C3] = sh_synth(r_p,n_max,m_max,GM,ae,Cnm,Snm,elps,Hortho)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spherical Harmonics Synthesis for gravity field functionals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:
%  Computation of functionals (e.g. geoid undulation, height anomaly, 
%  gravity anomaly, ...) based on spherical harmonics series expansion and
%  the harmonics coefficients of an Earth Gravity Model (EGM).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input arguments:
% - r:          position vector in Terrestrial Reference System (ITRS)
%               r = [x y z]'
% - GM:                 Earth gravity constant  (m^3/sec^2)
% - ae:                 radius  (meters)
% - Cnm, Snm :          normalized spherical harmonics coefficients
% - sCnm,sSnm:          shc errors, coefficients covariances
% - n_max:              Cnm and Snm matrices maximum degree
% - m_max:              Cnm and Snm matrices maximum order
%
% Output arguments:
% - N     :  Geoid undulation          (in meters)
% - zeta  :  Height anomaly            (in meters)
% - Dg    :  Gravity anomaly free-air  (in mgal)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dr. Thomas D. Papanikolaou                                     March 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Point P : computation of spherical coordinates (in radians)
[lon_sph_p,phi_sph_p,radius_p] = lamda_phi(r_p);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Point e : reduction of point p at ellipsoid surface
[a,e,e_2,e_second2] = ellipsoid(elps);
[phi_elps,lamda_elps,h] = XYZ_geod(r_p(1,1),r_p(2,1),r_p(3,1),a,e,e_2,e_second2,1);
% set : h = 0
[X,Y,Z] = geod_XYZ(phi_elps,lamda_elps,0,a,e,e_2);
r_e = [X Y Z]';
% Spherical coordinates at ellipsoid surface (in radians)
[lon_sph_e,phi_sph_e,radius_e] = lamda_phi(r_e);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Normal Gravity at point e (Ellipsoid surface)  mgal
[gama_e] = grav_norm(phi_elps);
%  (mgal to m/sec^2)
gama_e = gama_e * 10^(-5);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IERS Conventions 2003
Wo = 62636856.00;  % [m^2/sec^-2]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GMo, Uo : GRS'80 or WGS'84
[gama_e,DRV_gama_h_not,Jcf,GMo,Uo] = ellips_grav(phi_elps,elps);
% % Normal Gravity at point (in m/sec^2) (mgal to m/sec^2)
gama_e = gama_e * 10^(-5);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2nd approach
% drv_gama_h = - 0.3086 * 10^-5;  % [ m/s^-2 / m ]
% gama_p = gama_e + drv_gama_h * h;
gama_p = gama_e + (- 0.3086 * 10^-5) * h;
zeta_z = (GM - GMo) / (radius_p * gama_p) - (Wo - Uo) / gama_p;
% No_1 = (GM - GMo) / (radius_p * gama_p);
% No_2 = (Wo - Uo) / gama_p;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Point e (Ellipsoid surface) series expansions computations 
%[Dg_e,zeta_e,C1,C2] = sh_synth_series(r_e,n_max,m_max,GM,ae,Cnm,Snm,elps,Hortho);
[Dg_e_NOT,zeta_e,C1_NOT,C2_NOT] = sh_synth_series(r_e,n_max,m_max,GM,ae,Cnm,Snm,elps,Hortho);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gravity anomaly free-air at computation point P
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [gama_p] = grav_norm(phi_elps);
% [Dg_p,zeta_p_notout] = Dg_shc(r_p,n_max,m_max,GM,ae,Cnm,Snm,gama_p);

% Dg at Point P based on series expansion
[Dg_p,zeta_p_NOT,C1,C2] = sh_synth_series(r_p,n_max,m_max,GM,ae,Cnm,Snm,elps,Hortho);
Dg = Dg_p;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%drv_gama_h = - 0.3086;  % [ mgal / m ]
drv_gama_h = - 0.3086 * 10^-5;  % [ m/s^-2 / m ]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% C3 term
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
H = Hortho;    % 
gama_mean = gama_e + 0.5 * drv_gama_h * H;
%Dg_B = (Dg * 10^-5 - 0.1119 * 10^-5 * H)
%C3 = ( (Dg * 10^-5 - 0.1119 * 10^-5 * H) / gama_mean ) * H;
C3 = ( (Dg_p * 10^-5 - 0.1119 * 10^-5 * H) / gama_mean ) * H;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Height anomaly at computation point p (Earth surface) : zeta
zeta = zeta_z + zeta_e + C1 + C2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Geoid undulation
N = zeta + C3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

