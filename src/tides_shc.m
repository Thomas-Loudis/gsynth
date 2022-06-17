function [dCnm_tide,dSnm_tide] = tides_shc(mjd,prmtide,GM,ae, eopdat, dpint)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tides_shc 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:
%   Call the required functions for the computation of spherical harmonics
%   coefficients corrections for solid Earth and oceans tides
%
% Input arguments
% - mjd          : MJD in Terrestrial Time (TT) scale including the fracti-
%                  on of the day 
%
% Output arguments:
% - dCnm  :  Gravity field's Cnm corrections matrix due to Tides
% - dSnm  :  Gravity field's Snm corrections matrix due to Tides
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dr. Thomas Papanikolaou                                         June 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Last modified
% 27/05/2022   Dr. Thomas Loudis Papanikolaou  
%              Major upgrade of the function in order to support the new
%              configuration approach
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


global ocean_Nmax_glb ocean_Mmax_glb otides_DelaunayNf_glb otides_dCnm_plus_glb otides_dSnm_plus_glb otides_dCnm_minus_glb otides_dSnm_minus_glb
global planets_DE_fname_glb planets_DE_header_glb 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% JD of computation epoch
jd = mjd + 2400000.5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

eop = eopdat;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Planetary Ephemeris data processing :: DE ephemeris data by JPL/NASA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sun, Moon coordinates computation in GCRF & ITRF (m, m/sec)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reading of DExxx ephemeris data by JPL/NASA
DExxxfilename = planets_DE_fname_glb;
HDxxxfilename = planets_DE_header_glb;
jd = mjd + 2400000.5;
[DEcheby,DErecord,deformat] = dexxxeph_read(DExxxfilename,HDxxxfilename,jd);

% DE ephemeris data processing
% Sun and Moon Geocentric coordinates
[rgMoon,vgMoon] = dexxxeph_stategcrf(10,jd,HDxxxfilename,DEcheby,DErecord);
[rgSun,vgSun] = dexxxeph_stategcrf(11,jd,HDxxxfilename,DEcheby,DErecord);

% Body-Fixed positions of Sun and Moon (Transformation : GCRS to ITRS)
[eopmatrix,deopmatrix] = iers_transf(mjd,eop,dpint);
rgMoon_ITRS = (eopmatrix)' * rgMoon;
rgSun_ITRS = (eopmatrix)' * rgSun;
%clear eopmatrix deopmatrix

% GM of Sun & Moon in m^3/sec^2 (converted from au^3/d^2 to m^3/sec^2)
[GMconstant] = dexxxeph_readhd(HDxxxfilename,GM);
GMmoon = GMconstant(10,1);
GMsun  = GMconstant(11,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tides
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solid Earth Tides
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Frequency-independent : Step 1 (IERS Conventions 2010)
if prmtide(1,1) == 1
    [dCnm_solid1,dSnm_solid1] = tides_solid1(GM,ae,GMmoon,rgMoon_ITRS,GMsun,rgSun_ITRS);
elseif prmtide(1,1) == 0
    dCnm_solid1 = zeros(4+1,4+1);
    dSnm_solid1 = zeros(4+1,4+1); 
end

% Frequency-dependent : Step 2 (IERS Conventions 2010)
if prmtide(1,2) == 1
    [dCnm_solid2,dSnm_solid2] = tides_solid2(mjd,eop,dpint);
elseif prmtide(1,2) == 0
    dCnm_solid2 = zeros(2+1,2+1);
    dSnm_solid2 = zeros(2+1,2+1);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ocean Tides
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ocean_Nmax = ocean_Nmax_glb;
ocean_Mmax = ocean_Mmax_glb;
if prmtide(1,3) == 1
    % FES2004 Ocean Tide model
    %[DelaunayNf_fes04,dCnm_plus,dSnm_plus,dCnm_minus,dSnm_minus] = tides_fes2004(fes2004filename);        
    [dCnm_ocean,dSnm_ocean] = tides_ocean(ocean_Nmax,ocean_Mmax,mjd,eop,dpint, otides_DelaunayNf_glb, otides_dCnm_plus_glb, otides_dSnm_plus_glb, otides_dCnm_minus_glb, otides_dSnm_minus_glb);  
elseif prmtide(1,3) == 0
    dCnm_ocean = zeros(ocean_Nmax+1,ocean_Nmax+1);
    dSnm_ocean = zeros(ocean_Nmax+1,ocean_Nmax+1);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add SHC tide corrections to Cnm,Snm   
    % Solid Earth Tides corrections array
    [dCnm_solid,dSnm_solid] = tides_add2(dCnm_solid1,dSnm_solid1,dCnm_solid2,dSnm_solid2,-1);
    % Tides corrections array
    [dCnm_tide,dSnm_tide] = tides_add2(dCnm_ocean,dSnm_ocean,dCnm_solid,dSnm_solid,-1);
    %[dCnm_tide,dSnm_tide] = tides_add2(dCnm_solid,dSnm_solid,dCnm_ocean,dSnm_ocean,-1);    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

