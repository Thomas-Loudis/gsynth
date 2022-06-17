function [phi,lamda,h] = XYZ_geod(X,Y,Z,a,e,e_2,e_second2,meth)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Relation between Cartesian and Geodetic coordinates
%
% Computation of geodetic coordinates (ellipsoid Latitude and longitude)
% from the equivalent cartesian coordinates.
%
% "Height Method" (Fotiou 1998) is implemented here.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input arguments:
% - X,Y,Z:     Cartesian coordinates in meters
% - a:         major semi-axis of ellipsoid in meters
% - e:         ellipsoid's eccentricity
% - e_2:       square of ellipsoid's eccentricity (e^2)
% - e_second2: e'^2 (e': second eccentricity)
% - meth: Latitude's computation method
%         1. Sequential Iterations
%         2. "Height Method" algorithm (Fotiou 1998)
%         For choise 1 set parameter meth equal to 1
%         For choise 2 set parameter meth equal to 2
%         (Sequential Iterations method is suggested for mm accuracy)
% 
% Output arguments:
% - phi,lamda,h: Geodetic coordinates
%               latitude,longitude (phi,lamda) in degrees
%               Geometric Height (h) in meters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Thomas D. Papanikolaou                                          July 2009
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Longitude
[angle] = arctan(Y,X);
% Conversion in degrees
lamda_deg = (180 / pi) * angle;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if meth ==1
% Method based on sequential iterations for Latitude's computation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inital value of Latitude seting geometric height equal to zero (h=0).
phi0_rad = atan( (Z * (1 + e_second2)) / sqrt(X^2 + Y^2) );
% Number of Iterations: iter
iter = 4;
phi_rad = phi0_rad;

% N = a / sqrt(1 - e_2 * (sin(phi0_rad))^2 )
% phi_rad = atan( (Z + e_2 * N * sin(phi0_rad)) / sqrt(X^2 + Y^2) )
% h = Z / sin(phi_rad) - (1 - e_2) * N

for i = 1 : iter
% Radius of curvature of Prime normal section
N = a / sqrt(1 - e_2 * (sin(phi0_rad))^2 );
% Latitude
phi_rad = atan( (Z + e_2 * N * sin(phi0_rad)) / sqrt(X^2 + Y^2) );
% Height (geometric)
h = Z / sin(phi_rad) - (1 - e_2) * N;
% Next Iteration
phi0_rad = phi_rad;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif meth == 2
% "Height Method" algorithm (Fotiou 1998)
% see also A. Fotiou, E. Livieratos 2000, pp. 52
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
P = sqrt(X^2 + Y^2);
phio_rad = atan( (Z * (1 + e_second2)) / P);
% Radius of curvature of Prime normal section
No = a / sqrt(1 - e_2 * (sin(phio_rad))^2);

ho = Z / sin(phio_rad) - (1 - e_2) * No;
Po = (No + ho) * cos(phio_rad);

% Height (geometric)
h = ho + (P - Po) * cos(phio_rad);

% Latitude
tan_phi = tan(phio_rad) / (1 + e_second2 * (h / (No+h)) ) ;
phi_rad = atan( tan_phi );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
% Conversion in degrees
phi_deg = (180 / pi) * phi_rad;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
phi = phi_deg;
lamda = lamda_deg;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%