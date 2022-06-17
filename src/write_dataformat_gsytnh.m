function [fid] = write_dataformat_gsytnh(out_filename, cfg_filename, data_matrix, points_id_array)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function:  write_dataformat_gsytnh
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:
%  Write data to output file according to the GSynth output data format 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input arguments:
% - filename  : Output file name
% - cfg_filename : Configuration file name
%
% Output arguments:
% -     : 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dr. Thomas Loudis Papanikolaou                               7 June  2022
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


global Cnm_glb 
global ocean_Nmax_glb ocean_Mmax_glb 
global src_version 


fid = fopen(out_filename,'w');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Write Header
param_keyword = 'GSynth series format file';
fprintf(fid,'%-27s',param_keyword);
fprintf(fid,'%s\n','');

param_keyword = 'Software_version';
prm_value   = 'GSynth v.0.9.1';
fprintf(fid,'%-27s %s %s %s',param_keyword, ': ', 'GSynth', src_version);
fprintf(fid,'%s\n','');

% Gravity Field model d/o : GOCO06s  100x100
param_keyword = 'gravity_model_fname';
[gfm_name] = read_param_cfg(cfg_filename,param_keyword);

%param_keyword = 'gfm_max_degree';
%[N_max] = read_param_cfg(cfg_filename,param_keyword);

%param_keyword = 'gfm_max_order';
%[M_max] = read_param_cfg(cfg_filename,param_keyword);

[sz1,sz2] = size(Cnm_glb);
N_max = sz1 - 1;

param_keyword = 'Gravity Field model d/o';
fprintf(fid,'%-27s %s %s %d%s%d',param_keyword, ': ', gfm_name, N_max,'x',N_max);
fprintf(fid,'%s\n','');

% Planetary_ephemeris     : -
param_keyword = 'planetary_ephemeris_DE_filename';
[param_value] = read_param_cfg(cfg_filename,param_keyword);
Nchar = length(param_value);
DE_no = param_value(Nchar-2 : Nchar);
DE_name = sprintf('%s%s','DE',DE_no);

param_keyword = 'Planetary_Ephemeris';
fprintf(fid,'%-27s %s %s', param_keyword, ': ', DE_name);
fprintf(fid,'%s\n','');


% Solid Earth Tides       : -  Frequency indepedent terms
param_keyword = 'solid_earth_tides_1';
[param_value] = read_param_cfg(cfg_filename,param_keyword);
parm_num = sscanf(param_value,'%d %*');
if parm_num == 1 
    param_write = 'y';
elseif parm_num == 0
    param_write = 'n';
end

param_keyword = 'Solid Earth Tides non-freq';
fprintf(fid,'%-27s %s %s', param_keyword,': ',param_write);
fprintf(fid,'%s\n','');

% Solid Earth Tides       : - Frequency dependent Terms  
param_keyword = 'solid_earth_tides_2_freq';
[param_value] = read_param_cfg(cfg_filename,param_keyword);
parm_num = sscanf(param_value,'%d %*');
if parm_num == 1 
    param_write = 'y';
elseif parm_num == 0
    param_write = 'n';
end

param_keyword = 'Solid Earth Tides freq';
fprintf(fid,'%-27s %s %s', param_keyword,': ',param_write);
fprintf(fid,'%s\n','');


% Ocean Tides model d/o   : geoM2_case2  100x100 
param_keyword = 'ocean_tides';
[param_value] = read_param_cfg(cfg_filename,param_keyword);
parm_num = sscanf(param_value,'%d %*');
if parm_num == 1 
    param_write = 'y';
elseif parm_num == 0
    param_write = 'n';
end

if param_write == 'y'
   
param_keyword = 'ocean_tides_model_fname';
[octides_model_name] = read_param_cfg(cfg_filename,param_keyword);

param_keyword = 'otides_max_degree';
[N_max_otides] = read_param_cfg(cfg_filename,param_keyword);

param_keyword = 'otides_max_order';
[M_max_otides] = read_param_cfg(cfg_filename,param_keyword);

param_keyword = 'Ocean Tides model d/o';
%fprintf(fid,'%-27s %s %s %s%s%s',param_keyword, ': ', octides_model_name, N_max_otides,'x',M_max_otides);
fprintf(fid,'%-27s %s %s %d%s%d',param_keyword, ': ', octides_model_name, ocean_Nmax_glb,'x',ocean_Mmax_glb); 
fprintf(fid,'%s\n','');

else
    
param_keyword = 'Ocean Tides model d/o';
fprintf(fid,'%-27s %s ',param_keyword, ': - ');
fprintf(fid,'%s\n','');
    
end


% Earth Orientation                                                       
% EOP data                : eopc04_IAU2000.62-now
param_keyword = 'EOP_filename';
[eop_name] = read_param_cfg(cfg_filename,param_keyword);

param_keyword = 'Earth Orientation EOP';
fprintf(fid,'%-27s %s %s ',param_keyword, ': ', eop_name);
fprintf(fid,'%s\n','');


% Data_format             
format_line = 'Point_ID | Modified Julian Day number | Seconds since 00h | X(m) Y(m) Z(m) | Geoid Height (m) | Gravity anomaly free-air (mgal)  | Tidal vertical gravitational acceleration (mgal) | Tidal impact to geoid height (m)' ;
fprintf(fid,'%-27s %s %s ', 'Data_format', ': ', format_line);
fprintf(fid,'%s\n','');

% header_end
header_end = 'end_of_header';
fprintf(fid,'%-27s ',header_end );
fprintf(fid,'%s\n','');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Write computations
[N1, N2, N3] = size(data_matrix);
Npoints = N3;
Nepochs = N1;

for i_point = 1 : Npoints
    % Station (point) ID Name
    points_id_line_ith = points_id_array(i_point,:);
    point_ID_name_ith = sscanf(points_id_line_ith,'%s %*');
        
    for j_epochs = 1 : Nepochs
        % Computations per epoch
        data_ith = data_matrix(j_epochs, : , i_point);
        %lineith_data = data_matrix(j_epochs , 2:end, i_point)
        %fprintf(fid,'%s\n',lineith);
    
        % Write Point ID name
        fprintf(fid,'%-9s',point_ID_name_ith);

        % Write computations data
        fprintf(fid,'%19.9f',data_ith(2:3) );
        fprintf(fid,'%19.4f', data_ith(4:6) );
        fprintf(fid,'%25.15f',data_ith(7:end) );
        %format_i = ['%' num2str(wno) '.' num2str(prno(i,1)) 'f'];

        % Chnange line
        fprintf(fid,'%s\n','');

    end
end
fclose(fid);
