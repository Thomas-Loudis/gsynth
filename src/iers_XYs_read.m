function [XYs] = iers_XYs_read(eop_mjd,XYsfilename)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: iers_XYs_read.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose
%  Read IAU Precession-Nutation model data 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input arguments:
% - eop_mjd     : Epoch's MJD 
% - XYsfilename : File name that includes the X,Y,s parameters of the IAU Precession-Nutation model 
%
% Output arguments:
% - XYs         : IAU Precession-Nutation model' parameters
%                 XYs matrix format:   MJD  X  Y  s
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Thomas Papanikolaou                                             June 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% XYs matrix format :   MJD  X  Y  s

[sz1 sz2] = size(eop_mjd);
fid = fopen(XYsfilename);
xys_indx = 1;
while (~feof(fid))
    line = fgetl(fid);
    XYs_line = str2num(line);
    for i = 1 : sz1
        mjd = fix(eop_mjd(i,1));
        if abs(mjd - XYs_line(1,1)) < 10^-8
            XYs(xys_indx,:) = [mjd XYs_line(1,2) XYs_line(1,3) XYs_line(1,4)];
            xys_indx = xys_indx + 1;
            break
        end
    end
end
fclose(fid);
clear fid
