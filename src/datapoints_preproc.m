function [datapoints_matrix_in, datapoints_id_array] = datapoints_preproc(filename)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: datapoints_preproc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:
%  Read input data points format and perform data preprocessing (Coordinates conversion)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input arguments:
% - filename:   GSynth data file's name
%
% Output arguments:
% - datapoints_matrix_in: data array
%   datapoints_matrix_in = [id_number MJD_TT Sec_00 X Y Z]
% - ID_array:  ID character array
%
%   MJD_TT:     Modified Julian Day number in Terrestrial Time (TT) including the fraction of the day
%   Sec_00:     Seconds since 0h in TT time scale
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Thomas Loudis Papanikolaou                                    27 May 2022
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Last modified
% 07/06/2022  Thomas Loudis Papanikolaou
%             Code modifications
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


global ellipsoid_glb

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reference Ellipsoid
test = strcmp(ellipsoid_glb,'grs80');
if test == 1
    elps = 2;
end

test = strcmp(ellipsoid_glb,'wgs84');
if test == 1
    elps = 1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute the number of station points of the data
fid = fopen(filename);
i = 0;
j = 1;
Nepochs = 0;
while (~feof(fid))
    line_ith = fgetl(fid);
    if i == 1
        Nepochs = Nepochs + 1;       
    end   

    str1 = sscanf(line_ith,'%s %*');
    endofheader = 'End_of_Header';
    test = strcmp(str1, endofheader);
    if test == 1
        i = 1;
    end

    if Nepochs == 1
       %line = fgetl(fid);
       dataline = str2num( sscanf(line_ith,'%*s ') ); %[str2num(line(1:end))];
       [N1, Nelements] = size(dataline);
    end

end
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Preallocation/Initialisation of arrays
datapoints_matrix_in = zeros(Nepochs, 6);
Nchar_ID = 50;
blank_ith = blanks(1);
datapoints_id_array = repmat(blank_ith, Nepochs, Nchar_ID);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Read and store data
fid = fopen(filename);
i = 0;
j = 1;
while (~feof(fid))
    line_ith = fgetl(fid);
    if i == 1
    %j    
% ID array        
        ID_station = sscanf(line_ith,'%s %*');
        %datapoints_id_array(j,:) = sprintf('%s %*',ID_station);
        ID_station_Nchar = length(ID_station);        
        datapoints_id_array(j, 1:ID_station_Nchar) = sprintf('%s%*',ID_station);
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Coordinates
        % ID Coordinate_1 Coordinate_2 Coordinate_3 Year Month Day Hour Minutes Seconds
        Coordinate_1 = str2num( sscanf(line_ith,'%*s %s %*') ) ;
        Coordinate_2 = str2num( sscanf(line_ith,'%*s %*s %s %*') ) ;
        Coordinate_3 = str2num( sscanf(line_ith,'%*s %*s %*s %s %*') ) ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % Geodetic coordinates 
%     % Latitude
%     deg = gravdata(i,2);
%     min = gravdata(i,3);
%     sec = gravdata(i,4);
%     [phi] = dec_DegMinSec_inv(deg,min,sec);
%     % Longitude
%     deg = gravdata(i,5);
%     min = gravdata(i,6);
%     sec = gravdata(i,7);
%     [lamda] = dec_DegMinSec_inv(deg,min,sec);
%     % Ellipsoid height
%     h = gravdata(i,8);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Geodetic coordinates 
        % Latitude
        phi = Coordinate_1;
        % Longitude
        lamda = Coordinate_2;
        % Ellipsoid height
        h = Coordinate_3;

        % Cartesian coordinates / Position vector
        [a,e,e_2,e_second2] = ellipsoid(elps);
        [X,Y,Z] = geod_XYZ(phi,lamda,h,a,e,e_2);
        r = [X Y Z]';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time argument
        year  = sscanf(line_ith,'%*s %*s %*s %*s %d %*');
        month = sscanf(line_ith,'%*s %*s %*s %*s %*s %d %*');
        day   = sscanf(line_ith,'%*s %*s %*s %*s %*s %*s %d %*');
        hour  = sscanf(line_ith,'%*s %*s %*s %*s %*s %*s %*s %d %*');
        min   = sscanf(line_ith,'%*s %*s %*s %*s %*s %*s %*s %*s %d %*');
        sec   = str2num( sscanf(line_ith,'%*s %*s %*s %*s %*s %*s %*s %*s %*s %s %*') );

        % Julian Date Number
        t_sec = sec + min * 60 + hour * 3600; 
        [JD,MJD] = MJD_date(t_sec,day,month,year);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Matrix values assignment
        datapoints_matrix_in(j,1) = j;
        datapoints_matrix_in(j,2) = MJD;
        datapoints_matrix_in(j,3) = t_sec;
        datapoints_matrix_in(j,4) = X;
        datapoints_matrix_in(j,5) = Y;
        datapoints_matrix_in(j,6) = Z;
        
        j = j + 1;        
    end
        
    str1 = sscanf(line_ith,'%s %*');
    endofheader = 'End_of_Header';
    test = strcmp(str1, endofheader);
    if test == 1
        i = 1;
    end
end
fclose(fid);
