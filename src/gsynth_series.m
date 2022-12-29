function [shs_series, shs_series_3d] = gsynth_series(datapoints_matrix) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: gsynth_series 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input arguments:
% - datapoints_matrix : Matrix according to the following data format
% 
% [ID Lat(Deg min sec) Lon(Deg min sec) h Year Month Day Hours Min Sec g]
%
% g : gravity measurements in mGal
% 
% Remark : Time is referred to UT (Universal Time).
%          Do not put date data in local time.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output arguments:
% - shs_series  : Matrix with the input data plus the computed tides
%                   corrections (solid Earth and ocean tides).
%   Array format
%   Collumns 1 - 15 are the same as input data
%   Collumn 16 shows the computed tide corrections (in mgal)
%   Collumn 17 gives the corrected gravity measurements due to tides (mgal)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Thomas D. Papanikolaou                                         July 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Last modified
% 27/05/2022   Dr. Thomas Loudis Papanikolaou  
%              Major upgrade of the function in order to support the new
%              configuration approach
% 28/05/2022   Dr. Thomas Loudis Papanikolaou  
%              Code revision and rename to "tides_series" 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


global GM_glb ae_glb Cnm_glb Snm_glb
global tides_effects_glb
global ellipsoid_glb
global GLB_time_span GLB_time_interval
global EOP_filename_glb EOP_interp_points_glb iau_precnut_glb
global datapoints_id_array_glb


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gravitational constant
GM = GM_glb;
ae = ae_glb;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
% Tidal effects computation loop
[sz1 sz2] = size(datapoints_matrix);
Npoints_input = sz1;
Nelements = sz2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Matrices Preallocation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time_period = GLB_time_span;
time_interval = GLB_time_interval;
if time_period > 0
timewise_Npoints = time_period / time_interval + 1;
elseif time_period == 0
    timewise_Npoints = 1;
end

% Preallocation of shs_series
Nepochs_out      = timewise_Npoints * Npoints_input;
Nvar_out         = Nelements + 4;
shs_series       = zeros(Nepochs_out , Nvar_out);
shs_series_point = zeros(timewise_Npoints , Nvar_out);
shs_series_3d    = zeros(timewise_Npoints , Nvar_out, Npoints_input);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Point-wise computations
out_i = 0;
for i = 1 : sz1
    
    % Modified Julian Day number
    MJD = datapoints_matrix(i,2);

    % Cartesian coordinates
    X   = datapoints_matrix(i,4);
    Y   = datapoints_matrix(i,5);
    Z   = datapoints_matrix(i,6);
    
    % Position Vector
    r = [X Y Z]';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Earth Orientation Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MJDo = MJD;
time_period = GLB_time_span;
eopfilename = EOP_filename_glb;
EOP_interp_dp = EOP_interp_points_glb;

% Read and store EOP data to array
%[EOP_data_array] = prm_eop(eopfilename, eop_interp_points, time_period, MJDo); 
[eopdat] = prm_eop(eopfilename, EOP_interp_dp, time_period, MJDo); 

% Data points (days) used for interpolation of EOP data
dpint = EOP_interp_dp;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Time-wise computations
for j = 0 : timewise_Npoints - 1    

    % Epoch MJD
    MJD = MJDo + (time_interval / (86400)) * j;
    % Epoch Seconds since start of the day
    Sec00_ti = (time_interval * j) + (MJDo - fix(MJDo) ) * 86400;
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tides coefficients
    prmtides = tides_effects_glb;
    [dCnm_tide,dSnm_tide] = tides_shc(MJD,prmtides,GM,ae, eopdat, dpint);
    [n1 n2] = size(dCnm_tide);
    n_max = n1 - 1;
    m_max = n_max;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tides acceleration computation
    [fx,fy,fz,dVtide_r] = accel_tides_dvr(r,n_max,m_max,GM,ae,dCnm_tide,dSnm_tide);   
%     length_Fxyz = sqrt(fx^2 + fy^2 + fz^2)

% Tides correction and conversion to mGal
    tides_dg_corr = dVtide_r * 10^5;
% Minus sign is applied as conventional with the gravimetry data corrections
    %tides_dg_corr = - dVtide_r * 10^5  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spherical Harmonics Synthesis :: Geoid height and Gravity anomalies
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Orthometric height approximation
Hortho = 0;
Cnm = Cnm_glb; 
Snm = Snm_glb;

% Computation of geoid height and gravity anomaly - Tide free
[Dg_fa_p,Negm,zeta,zeta_e,zeta_z,C1,C2,C3] = sh_synth(r,n_max,m_max,GM,ae,Cnm,Snm,elps,Hortho);

% Free-air Gravity anomaly reduction from computation point to geoid 
Dg_fa_e = Dg_fa_p + (-0.3086) * (Negm-zeta);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Computation of geoid height and gravity anomaly - Tidal effects
[Cnm_tides,Snm_tides] = tides_add2(Cnm,Snm,dCnm_tide,dSnm_tide,-1);
[Dg_fa_p,Negm_tides,zeta,zeta_e,zeta_z,C1,C2,C3] = sh_synth(r,n_max,m_max,GM,ae,Cnm_tides,Snm_tides,elps,Hortho);

% Tides effect to geoid unudulation
tides_dN = Negm_tides - Negm

[dDg_fa_p,dNegm_tides,dzeta,dzeta_e,dzeta_z,dC1,dC2,dC3] = sh_synth(r,n_max,m_max,GM,ae,Cnm_tides,Snm_tides,elps,Hortho);
dNegm_tides 
dzeta
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Store tides corrections computations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Overall matrix that includes coputations for all stations and epochs
    out_i = out_i + 1;
    point_no = out_i;
    shs_series(point_no, 1:Nelements) = datapoints_matrix(i,1:Nelements);
    shs_series(point_no, 2) = MJD;
    shs_series(point_no, 3) = Sec00_ti;
    shs_series(point_no, Nelements+1) = Negm;
    shs_series(point_no, Nelements+2) = Dg_fa_e;
    shs_series(point_no, Nelements+3) = tides_dg_corr;
    shs_series(point_no, Nelements+4) = tides_dN;

fprintf('%5d %s %d %s \n',point_no,'of',Nepochs_out,'points :: computed');
    
    % Matrix for the epochs of the individual station
    epoch_i = j+1;
    shs_series_point(epoch_i, 1:Nelements) = datapoints_matrix(i,1:Nelements);
    shs_series_point(epoch_i, 2) = MJD;
    shs_series_point(epoch_i, 3) = Sec00_ti;
    shs_series_point(epoch_i, Nelements+1) = Negm;
    shs_series_point(epoch_i, Nelements+2) = Dg_fa_e;    
    shs_series_point(epoch_i, Nelements+3) = tides_dg_corr;
    shs_series_point(epoch_i, Nelements+4) = tides_dN;    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end
%point_no = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 3-dimensional matrix that includes coputations for all stations and epochs
    point_i = i;
    shs_series_3d(:,:, point_i) = shs_series_point;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % Save to output file the tides series epochs of the individual station
%     line_ith = datapoints_id_array_glb(i,:);
%     station_ID = sscanf(line_ith,'%s %*');
%     filename_out = sprintf('%s%s%s', 'tides_series_station_', station_ID ,'.out');
%     save(filename_out,'shs_series_point','-ascii');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Repeat matrix initialisation to zero 
    shs_series_point = zeros(timewise_Npoints , Nvar_out);

end

end


