function [UT,D,M,Y] = MJD_inv(MJD)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Conversion between the Modified Julian Day Number (MJD) and the Calendar
% Date
%
% Conversion from Modified Julian day number to Civil date.
% Civil Date is expressed in Gregorian calendar.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input arguments:
% - MJD: Modified julian day number
%
% Output arguments:
% - UT: time in hours, fraction of the day
% - D: number of day
% - M: number of month
% - Y: Year
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Thomas D. Papanikolaou                                   November 2007
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Computation of civil date by intermediate auxiliary quantities
% a,b,c,d,e,f
q = MJD - floor(MJD);

a = floor(MJD) + 2400001;

if a<2299161
    b=0;
else
    b=floor( (a-1867216.25)/36524.25 );
end

if a<2299161
    c=a+1524;
else
    c=a+b-floor(b/4)+1525;
end

d = floor((c-121.1)/365.25);
e = floor(365.25*d);
f = floor((c-e)/30.6001);

% compute fraction of the day - UT in seconds
UT = q * 24 * 3600;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
UT = sprintf('%.6f',UT);
UT = str2num(UT);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%&
% compute Day (D)
D = c - e - floor(30.6001*f) ;
% compute Month (M)
M = f - 1 - 12 * floor(f/14);
% compute Year(Y)
Y = d - 4715 - floor((7+M)/10);