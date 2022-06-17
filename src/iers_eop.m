function [eop] = iers_eop(filename,mjd)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function:  iers_eop(filename,mjd).m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:
%  Reading of EOP (Earth Orientation Parameters) data series format
%  provided by IERS (International Earth Rotation Service and Reference
%  Systems) combined series C04.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input arguments:
% - filename:  EOP data series file name  e.g. 'eopc04_IAU2000.62-now'
% - mjd:       Array of the MJD (Modified Julian Day) numbers of the
%              required dates (MJD in UTC time scale)
%
% Output arguments:
% - eop:      Array of the selected EOP data for the days defined by the
%             "mjd" imput argument
%   eop matrix is defined as eop = [mjd x y UT1_UTC dX dY]  nx6 matrix
%   mjd:      MJD refered to 0h in UTC time scale 
%   x,y:      Polar motion coordinates (in seconds) 
%   UT1_UTC:  Difference between UT1 and UTC (in arcsec)
%   dX,dY:    VLBI corrections to the Precession-Nutation model IAU2000
%             (in arcsec)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remarks:
% - Input argument filename must be a string in single quotation marks e.g.
%   'eopc04_IAU2000.62-now'
% - File of the solution from 1962 until the current week for the version
%   which Celestial Pole offsets (dX,dY) referred to the
%   precession-nutation model IAU 2000 is usually named as
%   "eopc04_IAU2000.62-now".
% - dn: Number of days for EOP interpolation is recommended by IERS to 4.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remark: 
%  EOP series that are available by IERS are refered to UTC time scale.
%  Thus, time input argument which refer to TT time scale is converted to
%  UTC with the function time_scales.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Thomas D. Papanikolaou, AUTH                                November 2007
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Last modified:
%   06/04/2011  Upgrade for reading IERS 08 C04 EOP series format.
%               Official IERS 08 C04 solution since 1 February 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read EOP series file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[nmjd n2] = size(mjd);
clear n2
fid = fopen(filename);
i = 1;
while (~feof(fid))
  line = fgetl(fid);
  %if line(1) == 1 || line(1) == 2      
  if length(line) == 155
      mjdi = str2num(line(15:19));
      if mjdi == mjd(i,1) %1 + i
          mjd_dpi = str2num(line(15:19));
          x = str2num(line(22:30));
          y = str2num(line(33:41));
          UT1_UTC = str2num(line(44:53));
          dX = str2num(line(68:76));
          dY = str2num(line(79:87));
          eop(i,:) = [mjd_dpi x y UT1_UTC dX dY];
          i = i + 1;
          clear mjd_dpi x y UT1_UTC dX dY               
      end
  end
  if i > nmjd
      break
  end
end
fclose(fid);
clear i
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%