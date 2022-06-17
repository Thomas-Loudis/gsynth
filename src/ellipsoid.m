function [a,e,e_2,e_second2] = ellipsoid(elps)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Refererence ellipsoid parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input arguments:
% - elps: selection of the selected ellipsoid
%         WGS'84: elps=1
%         GRS'80: elps=2
%         Bessel: elps=3
% Output arguments:
% - a:         major semi-axis of ellipsoid in meters
% - e:         ellipsoid's eccentricity
% - e_2:       square of ellipsoid's eccentricity (e^2)
% - e_second2: e'^2 (e': second eccentricity)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Thomas D. Papanikoalou                                          July 2009
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Last modified
% 27/07/2011  Bessel ellipsoid has been added
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if elps == 1
% WGS'84
a = 6378137;
e = 0.0818191908;
e_2 = 0.00669437999;
e_second2 = 0.00673949674;

elseif elps == 2
% GRS'80
a = 6378137;
e = 0.081819191;
e_2 = 0.006694380;
e_second2 = 0.006739497;

elseif elps == 3
    % Bessel
    a = 6377397.155;
    e = 0.08169830;
    e_2 = 0.006674372;
    e_second2 = 0.006719219;
    
elseif elps == 4
    % Hayford (International 1924)
    a = 6378388;
    e = 0.081991889979;
    e_2 = 0.006722670022;
    e_second2 = 0.006768170197;    

end