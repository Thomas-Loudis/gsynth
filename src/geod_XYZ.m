function [X,Y,Z] = geod_XYZ(phi,lamda,h,a,e,e_2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Relation between Cartesian and Geodetic coordinates
%
% Equations for the computation of geodetic coordinates (ellipsoid Latitude
% and longitude) of a position that the cartesian coordinates are giiven.
%
% "Height Method" (Fotiou 1998) is used here.
%
% Input arguments:
% - phi,lamda,h:  Geodetic coordinates
%                 latitude,longitude (phi,lamda)     in degrees
%                 Geometric Height (h)               in meters
% - a:            major semi-axis of ellipsoid       in meters
% - e:            ellipsoid's eccentricity
% - e_2:          square of ellipsoid's eccentricity (e^2)
% 
% Output arguments:
% - X,Y,Z:     Cartesian coordinates in meters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Thomas D. Papanikolaou                                          July 2009
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Conversion from degrees to radians
phi_rad = (pi / 180) * phi;
lamda_rad = (pi / 180) * lamda;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Radius of curvature of Prime normal section
N = a / sqrt(1 - e_2 * (sin(phi_rad))^2 );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Computation of cartesian coordinates
X = (N + h) * cos(phi_rad) * cos(lamda_rad);
Y = (N + h) * cos(phi_rad) * sin(lamda_rad);
Z = ( (1 - e_2) * N + h ) * sin(phi_rad);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%