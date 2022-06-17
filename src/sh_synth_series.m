function [Dg,zeta_e,C1,C2] = sh_synth_series(r_e,n_max,m_max,GM,ae,Cnm,Snm,elps,Hortho)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gravity field functionals based on spherical harmonics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:
%  Computation of functionals (e.g. geoid undulation, height anomaly, 
%  gravity anomaly, ...) based on the spherical harmonics series expansion
%  and the harmonics coefficients of an Earth Gravity Model (EGM).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input arguments:
% - r:          position vector in Terrestrial Reference System (ITRS)
%               r = [x y z]'
% - GM:                 Earth gravity constant  (m^3/sec^2)
% - ae:                 radius  (meters)
% - Cnm, Snm :          normalized spherical harmonics coefficients
% - sCnm,sSnm:          errors, coefficients covariances
% - n_max:              Cnm and Snm matrices maximum degree
% - m_max:              Cnm and Snm matrices maximum order
% - gama :              Normal gravity in mgal
% - Hortho:             Orthometric height (in meters)
%
% Output arguments:
% - N     :  Geoid undulation          (in meters)
% - zeta  :  Height anomaly            (in meters)
% - Dg    :  Gravity anomaly free-air  (in mgal)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dr. Thomas D. Papanikolaou, HMGS                               March 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Geodetic coordinates
[a,e,e_2,e_second2] = ellipsoid(elps);
[phi_elps,lamda_elps,h] = XYZ_geod(r_e(1,1),r_e(2,1),r_e(3,1),a,e,e_2,e_second2,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spherical coordinates (in radians)
[lon_sph_e,phi_sph_e,radius_e] = lamda_phi(r_e);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% computation of normalized associated Legendre functions
[Pnm_norm] = Legendre_functions(phi_sph_e,n_max);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spherical harmonics of reference ellipsoid (normal potential)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[gama_e,DRV_gama_h_not,Jcf,GMo,Uo] = ellips_grav(phi_elps,elps);
J2 = Jcf(1,1);
J4 = Jcf(2,1);
J6 = Jcf(3,1);
J8 = Jcf(4,1);
% Normal Gravity at point (in m/sec^2)
gama_e = gama_e * 10^(-5);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Normalized zonal harmonics
C20_elps = -J2 / sqrt(5);
C40_elps = -J4 / 3;
C60_elps = -J6 / sqrt(13);
C80_elps = -J8 / sqrt(17);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% delta_Cnm = Cnm - Cn 
Cnm(3,1) = Cnm(3,1) - C20_elps;
Cnm(5,1) = Cnm(5,1) - C40_elps;
Cnm(7,1) = Cnm(7,1) - C60_elps;
Cnm(9,1) = Cnm(9,1) - C80_elps;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Harmonics series expansion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ZETA_expan_n = 0;
Dg_expan_n = 0;
C1_n_series = 0;
for n = 2 : n_max
    if n > m_max
        m_limit = m_max;
    else
        m_limit = n;
    end
    % set series expanion of m to zero for each sequential degree series
    expan_m = 0;
    for m = 0 : m_limit
        expan_m = expan_m + Pnm_norm(n+1,m+1) * (Cnm(n+1,m+1) * cos(m*lon_sph_e) + Snm(n+1,m+1) * sin(m*lon_sph_e));        
    end
    C1_n_series   = C1_n_series + (n+1) * (ae / radius_e)^n * expan_m;
    ZETA_expan_n  = ZETA_expan_n + (ae / radius_e)^n * expan_m;
    Dg_expan_n    = Dg_expan_n + (n-1) * (ae / radius_e)^n * expan_m;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gravity anomaly free-air (in mgal)
Dg = (GM / radius_e^2) * Dg_expan_n * 10^5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
drv_gama_h = - 0.3086;   % [ mgal / m ]
%[gama_not,drv_gama_h,Jcf] = ellips_grav(phi_elps);  % [ mgal / m ]
drv_gama_h = drv_gama_h * 10^-5;  % [ m/s^-2 / m ]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Height anomaly at point e (Ellipsoid surface) : zeta*
zeta_e  = (GM / radius_e) * ( 1 / gama_e) * ZETA_expan_n;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% In case of Ellipsoid surface C1,C2 are computed based on H
if abs(h) < 0.0001
    h = Hortho;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% C1 term
C1 = - ( (h * GM) / (radius_e^2 * gama_e) ) * C1_n_series;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% C2 term
C2 = - (h / gama_e) * zeta_e * drv_gama_h;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

