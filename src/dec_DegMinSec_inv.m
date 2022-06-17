function [dec] = dec_DegMinSec_inv(deg,min,sec)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Conversion from Degrees, Minutes and Seconds to Decimal form
%
% Application to Geodetic Coordinates
% 
% Input arguments:
% - deg: Degrees part of coordinate's value
% - min: Minutes part of coordinate's value
% - sec: Seconds part of coordinate's value
%
% Output arguments:
% - dec: coordinate's value in decimal form
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Thomas D. Papanikoalou                                        August 2009
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Last modified
% 07 March 2013     Modified for processing negative values of deg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Degrees
if deg >= 0
    dec_deg = deg;
    factor = 1;
else
    dec_deg = - deg;
    factor = -1;
end

% Minutes
dec_min = min / 60;

% Seconds
dec_sec = sec / 3600;

% Decimal form
dec = factor * (dec_deg + dec_min + dec_sec);
