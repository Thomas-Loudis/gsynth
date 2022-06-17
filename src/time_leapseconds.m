function [UTC_TAI] = time_leapseconds(M,Y)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time Scales Function: time_leapseconds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:
%  Leap seconds as provided by IERS bulletin C
%  Provide the time difference between UTC and TAI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input arguments:
% -  Y:  Year
% Output arguments
% - UTC_TAI:      Difference between UTC and TAI in seconds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Comment:
%  Leap seconds written as an individual function while initially it was
%  included within the functions time_scales and time_scales_GPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Dr. Thomas Papanikolaou                                
% Written: 11 May 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UTC (Coordinated Universal Time)
%  Leap seconds are announced by the IERS - Bulletin C
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Table from IERS Earth Orientation Centre
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Limits of validity (at 0h UTC) TAI-UTC (MJD = Modified Julian Day)
% 1961  Jan.  1 - 1961  Aug.  1     1.422 818 0s + (MJD - 37 300) x 0.001 296s
%       Aug.  1 - 1962  Jan.  1     1.372 818 0s +        ""
% 1962  Jan.  1 - 1963  Nov.  1     1.845 858 0s + (MJD - 37 665) x 0.001 123 2s
% 1963  Nov.  1 - 1964  Jan.  1     1.945 858 0s +        ""
% 1964  Jan.  1 -       April 1     3.240 130 0s + (MJD - 38 761) x 0.001 296s
%       April 1 -       Sept. 1     3.340 130 0s +        ""
%       Sept. 1 - 1965  Jan.  1     3.440 130 0s +        ""
% 1965  Jan.  1 -       March 1     3.540 130 0s +        ""
%       March 1 -       Jul.  1     3.640 130 0s +        ""
%       Jul.  1 -       Sept. 1     3.740 130 0s +        ""
%       Sept. 1 - 1966  Jan.  1     3.840 130 0s +        ""
% 1966  Jan.  1 - 1968  Feb.  1     4.313 170 0s + (MJD - 39 126) x 0.002 592s
% 1968  Feb.  1 - 1972  Jan.  1     4.213 170 0s +        ""
% 1972  Jan.  1 -       Jul.  1    10s            
%       Jul.  1 - 1973  Jan.  1    11s    
% 1973  Jan.  1 - 1974  Jan.  1    12s    
% 1974  Jan.  1 - 1975  Jan.  1    13s    
% 1975  Jan.  1 - 1976  Jan.  1    14s   
% 1976  Jan.  1 - 1977  Jan.  1    15s   
% 1977  Jan.  1 - 1978  Jan.  1    16s   
% 1978  Jan.  1 - 1979  Jan.  1    17s
% 1979  Jan.  1 - 1980  Jan.  1    18s
% 1980  Jan.  1 - 1981  Jul.  1    19s   
% 1981  Jul.  1 - 1982  Jul.  1    20s   
% 1982  Jul.  1 - 1983  Jul.  1    21s    
% 1983  Jul.  1 - 1985  Jul.  1    22s    
% 1985  Jul.  1 - 1988  Jan.  1    23s
% 1988  Jan.  1 - 1990  Jan.  1    24s 
% 1990  Jan.  1 - 1991  Jan.  1    25s
% 1991  Jan.  1 - 1992  Jul.  1    26s
% 1992  Jul.  1 - 1993  Jul   1    27s
% 1993  Jul.  1 - 1994  Jul.  1    28s
% 1994  Jul.  1 - 1996  Jan.  1    29s
% 1996  Jan.  1 - 1997  Jul.  1    30s
% 1997  Jul.  1 - 1999  Jan.  1    31s
% 1999  Jan.  1 - 2006  Jan.  1    32s
% 2006  Jan.  1 - 2009  Jan.  1    33s
% 2009  Jan.  1 - 2012  Jul.  1    34s
% 2012  Jul.  1 - 2015  Jul.  1    35s
% 2015  Jul.  1 - 2017  Jan.  1    36s
% 2017  Jan.  1 -                  37s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Date test for the leap seconds
if Y >= 1996 && Y<= 1996
    if M < 7 
        UTC_TAI = -30;
    elseif M >= 7
        UTC_TAI = -31;
    end

elseif Y == 1983 
    if M < 7 
        UTC_TAI = -21;
    elseif M >= 7
        UTC_TAI = -22;
    end
    
elseif Y == 1984
    UTC_TAI = -22;
    
elseif Y == 1985 
    if M < 7 
        UTC_TAI = -22;
    elseif M >= 7
        UTC_TAI = -23;
    end
    
elseif Y >= 1986 && Y<= 1987
    UTC_TAI = -23;
    
elseif Y >= 1988 && Y<= 1989
    UTC_TAI = -24;
    
elseif Y == 1990
    UTC_TAI = -25;   
    
elseif Y == 1991
    UTC_TAI = -26;   
    
elseif Y == 1992 
    if M < 7 
        UTC_TAI = -26;
    elseif M >= 7
        UTC_TAI = -27;
    end
    
elseif Y == 1993 
    if M < 7 
        UTC_TAI = -27;
    elseif M >= 7
        UTC_TAI = -28;
    end
    
elseif Y == 1994 
    if M < 7 
        UTC_TAI = -28;
    elseif M >= 7
        UTC_TAI = -29;
    end
elseif Y == 1995
    UTC_TAI = -29;   
    
    
elseif Y == 1996
    UTC_TAI = -30;   
    
elseif Y == 1997 
    if M < 7 
        UTC_TAI = -30;
    elseif M >= 7
        UTC_TAI = -31;
    end
elseif Y == 1998
    UTC_TAI = -31;   
    
elseif Y >= 1999 && Y<= 2005
    UTC_TAI = -32;

elseif Y >= 2006 && Y<= 2008
    UTC_TAI = -33;

elseif Y >= 2009 && Y< 2012
    UTC_TAI = -34;

elseif Y == 2012
    if M < 7 
        UTC_TAI = -34;
    elseif M >= 7
        UTC_TAI = -35;
    end
    
elseif Y > 2012 && Y< 2015
    UTC_TAI = -35;

elseif Y == 2015
    if M < 7 
        UTC_TAI = -35;
    elseif M >= 7
        UTC_TAI = -36;
    end
    
elseif Y > 2015 && Y< 2017
    UTC_TAI = -36;
    
elseif Y >= 2017
    UTC_TAI = -37;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

