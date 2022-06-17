function [deg,min,sec] = dec_DegMinSec(dec)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Conversion from Decimal form to Degrees, Minutes and Seconds
%
% Application to Geodetic Coordinates
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input arguments:
% - dec: coordinate's value in decimal form
% Output arguments:
% - deg: Degrees part of coordinate's value
% - min: Minutes part of coordinate's value
% - sec: Seconds part of coordinate's value
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Thomas D. Papanikoalou                                        August 2009
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Last modified
% 07 March 2013     Modified for processing negative values of dec
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Degrees
if dec >= 0
    dec = dec;
    factor = 1;
else
    dec = - dec;
    factor = -1;
end

deg = factor * fix(dec);

% Minutes
min = fix( (dec - fix(dec)) * 60 );

% Seconds
sec = ( (dec - fix(dec)) * 60  - min) * 60;
