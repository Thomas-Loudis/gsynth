function [fx,fy,fz,dV_r] = accel_tides_dvr(r,n_max,m_max,GM,ae,dCnm,dSnm)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tides acceleration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:
%   Tides acceleration components are computed as partial derivatives of
%   spherical harmonics expansion of the tides harmonics coefficients.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remark:
%   The formulas that are implementd here yield the acceleration in an
%   Earth-fixed coordinated system as a function of the Earth-fixed 
%   position vector.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input arguments:
% - r: position vector in Terrestrial Reference System (ITRS)
%   r = [x y z]'
%
% Output arguments:
% - Tides acceleration's components
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Thomas D. Papanikolaou                                     September 2007
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Last modified:
% 08/06/2012  Function accel_egm.m has been renamed and upgraded for taking
%             account the Tides coefficients corrections
% 25/07/2013  The equations have been modified. The terms of the expansion 
%             series that refer to the gravity model have been removed. 
%             The contribution of the tides harmonics coefficients is
%             computed exclusively.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tides corrections Nmax
[n1 n2] = size(dCnm);
Nmax_tide = n1 - 1;
clear n1 n2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% computation of spherical coordinates in radians
[lamda,phi,l] = lamda_phi(r);      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% computation of normalized associated Legendre functions
[Pnm_norm] = Legendre_functions(phi,n_max);
% First-order derivatives of normalized associated Legendre functions
[dPnm_norm] = Legendre1ord(phi,n_max) ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% 2nd approach:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Partial derivatives of potential with respect to spherical coordinates :
% - dV_r     : partial derivative of geopotential to radius
% - dV_phi   : partial derivative of geopotential to latitude
% - dV_lamda : partial derivative of geopotential to longtitude
dV_r = 0;
dV_phi = 0;
dV_lamda = 0;
for n = 2 : n_max
    if n > m_max
        m_limit = m_max;
    else
        m_limit = n;
    end
    for m = 0 : m_limit    
        dV_r = dV_r         + (- (GM/l^2)) * (n+1)*((ae/l)^n) * Pnm_norm(n+1,m+1) *(dCnm(n+1,m+1) * cos(m*lamda) +dSnm(n+1,m+1) * sin(m*lamda)) ;
        dV_phi = dV_phi     + (GM / l) * ((ae/l)^n) * dPnm_norm(n+1,m+1) *(dCnm(n+1,m+1)*cos(m*lamda) +dSnm(n+1,m+1)*sin(m*lamda)) ;
        dV_lamda = dV_lamda + (GM / l) * m * ((ae/l)^n) * Pnm_norm(n+1,m+1) *(dSnm(n+1,m+1)*cos(m*lamda) -dCnm(n+1,m+1)*sin(m*lamda)) ;
    end
end
dV_r = dV_r;
dV_phi = dV_phi;
dV_lamda = dV_lamda;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Partial derivatives of (r,phi,lamda) with respect to (x,y,z)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PDVrx = [
%       cos(phi)*cos(lamda)            cos(phi)*sin(lamda)          sin(phi)
%   (-1/l)*sin(phi)*cos(lamda)     (-1/l)*sin(phi)*sin(lamda)    (1/l)*cos(phi)
% ( -1/(l*cos(phi)) )*sin(lamda)  ( 1/(l*cos(phi)) )*cos(lamda)        0
% ];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Partial derivatives of (r,theta,lamda) with respect to (x,y,z)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PDVrx = [
%       sin(theta)*cos(lamda)            sin(theta)*sin(lamda)           cos(theta)
%   ( 1/l)*cos(theta)*cos(lamda)     ( 1/l)*cos(theta)*sin(lamda)    (-1/l)*sin(theta)
% ( -1/(l*sin(theta)) )*sin(lamda)  ( 1/(l*sin(theta)) )*cos(lamda)         0
% ];
% Replacement of "theta" with "phi"
PDVrx = [
      cos(phi)*cos(lamda)            cos(phi)*sin(lamda)          sin(phi)
  ( 1/l)*sin(phi)*cos(lamda)     ( 1/l)*sin(phi)*sin(lamda)    (-1/l)*cos(phi)
( -1/(l*cos(phi)) )*sin(lamda)  ( 1/(l*cos(phi)) )*cos(lamda)        0
];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Computation of Cartesian counterparts of the acceleration
fxyz = PDVrx' * [dV_r; dV_phi; dV_lamda];
fx = fxyz(1,1);
fy = fxyz(2,1);
fz = fxyz(3,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end