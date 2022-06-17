function read_cfg_gsynth(cfg_fname)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: read_cfg_gsynth
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:
%  Read configuration file of GSynth; 
%  Assign values to global variables; Data reading and preprocessing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input arguments:
% - cfg_fname:          Input confiugration file name *.in in GSynth format 
% 
% Output arguments:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Thomas Loudis Papanikolaou                                    27 May 2022
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Last modified
% 07/06/2022  Thomas Loudis Papanikolaou
%             read_cfg_gravsynth has been renamed to read_cfg_gsynth
%             Code minor modifications
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global GLB_time_span GLB_time_interval
global datapoints_in_fname_glb

global GM_glb ae_glb Cnm_glb Snm_glb
%global GLB_tide_system
global tides_effects_glb
global ocean_Nmax_glb ocean_Mmax_glb otides_DelaunayNf_glb otides_dCnm_plus_glb otides_dSnm_plus_glb otides_dCnm_minus_glb otides_dSnm_minus_glb

global ellipsoid_glb coordinates_type_glb
global EOP_filename_glb EOP_interp_points_glb iau_precnut_glb
global planets_DE_fname_glb planets_DE_header_glb 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read .in configuration file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fid = fopen(cfg_fname);
while (~feof(fid))
    line_ith = fgetl(fid);
    str1 = sscanf(line_ith,'%s %*');

% Data points file format
    test = strcmp(str1,'input_data_points_filename');
    if test == 1
      in_datapoints_fname = sscanf(line_ith,'%*s %s %*');
      datapoints_in_fname_glb = in_datapoints_fname;
    end
    
    test = strcmp(str1,'reference_frame');
    if test == 1
      reference_frame = sscanf(line_ith,'%*s %s %*');
    end

    test = strcmp(str1,'coordinates_type');
    if test == 1
      coordinates_type = sscanf(line_ith,'%*s %s %*');
      coordinates_type_glb = coordinates_type;
    end

    test = strcmp(str1,'coordinates_ellipsoid');
    if test == 1
      coordinates_ellipsoid = sscanf(line_ith,'%*s %s %*') ;
      ellipsoid_glb = coordinates_ellipsoid;
    end
    
% Time-wise tides analysis (seconds)
    test = strcmp(str1,'time_span');
    if test == 1
      %time_span = str2num( sscanf(line_ith,'%*s %s %*') )
      time_span = sscanf(line_ith,'%*s %d %*');
      GLB_time_span = time_span;
    end

    test = strcmp(str1,'time_interval');
    if test == 1
      time_interval = sscanf(line_ith,'%*s %d %*');
      GLB_time_interval = time_interval;
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% Gravity Field model
    test = strcmp(str1,'gravity_model_fname');
    if test == 1
      gravity_model_fname = sscanf(line_ith,'%*s %s %*') ;
    end
    
    test = strcmp(str1,'gfm_max_degree');
    if test == 1
      n_max_gfm = sscanf(line_ith,'%*s %d %*');
    end

    test = strcmp(str1,'gfm_max_order');
    if test == 1
      m_max_gfm = sscanf(line_ith,'%*s %d %*');
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tides modelling   

% Solid Earth Tides
% Frequency indepedent terms
    test = strcmp(str1,'solid_earth_tides_1');
    if test == 1
      solid_earth_tides_1 = sscanf(line_ith,'%*s %d %*');
      tides_effects_glb(1,1) = solid_earth_tides_1;
    end

% Frequency dependent terms
    test = strcmp(str1,'solid_earth_tides_2_freq');
    if test == 1
      solid_earth_tides_2_freq = sscanf(line_ith,'%*s %d %*');
      tides_effects_glb(1,2) = solid_earth_tides_2_freq;
    end
    
% Ocean Tides
    test = strcmp(str1,'ocean_tides');
    if test == 1
      ocean_tides_yn = sscanf(line_ith,'%*s %d %*');
      tides_effects_glb(1,3) = ocean_tides_yn;
    end

    test = strcmp(str1,'ocean_tides_model_fname');
    if test == 1
      ocean_tides_model_fname = sscanf(line_ith,'%*s %s %*');
    end

    test = strcmp(str1,'otides_max_degree');
    if test == 1
      n_max_otides = sscanf(line_ith,'%*s %d %*');
    end

    test = strcmp(str1,'otides_max_order');
    if test == 1
      m_max_otides = sscanf(line_ith,'%*s %d %*');
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sun, Moon and Planets DE ephemeris    
    test = strcmp(str1,'planetary_ephemeris_DE_filename');
    if test == 1
      planetary_ephemeris_DE_filename = sscanf(line_ith,'%*s %s %*');
      planets_DE_fname_glb = planetary_ephemeris_DE_filename;
    end

    test = strcmp(str1,'planetary_ephemeris_DE_headername');
    if test == 1
      planetary_ephemeris_DE_headername = sscanf(line_ith,'%*s %s %*');
      planets_DE_header_glb = planetary_ephemeris_DE_headername;
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Earth Orientation modelling | Earth Orientation Parameters (EOP)                                                     
    test = strcmp(str1,'EOP_filename');
    if test == 1
      EOP_filename = sscanf(line_ith,'%*s %s %*');
      EOP_filename_glb = EOP_filename;
    end

    test = strcmp(str1,'EOP_interpolation_points');
    if test == 1
      EOP_interpolation_points = sscanf(line_ith,'%*s %d %*');
      EOP_interp_points_glb = EOP_interpolation_points;
    end
        
    test = strcmp(str1,'precession_nutation_model');
    if test == 1
      precession_nutation_model = sscanf(line_ith,'%*s %s %*');
      iau_precnut_glb = precession_nutation_model;
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
end
fclose(fid);




if 1 < 0 
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Models data read and preprocessing

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gravity Field model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Static gravity field models
sigma_shc = 0;
[GM,ae,Cnm,Snm,sCnm,sSnm,nmax] = gfc(gravity_model_fname, n_max_gfm, sigma_shc);
GM_glb = GM;
ae_glb = ae;
Cnm_glb = Cnm;
Snm_glb = Snm;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ocean Tides model read
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ocean Tides model in form of spherical harmonics from FES series (FES2004, FES2014b, ...)
%[otides_DelaunayNf,otides_dCnm_plus,otides_dSnm_plus,otides_dCnm_minus,otides_dSnm_minus] = tides_fes2004(ocean_tides_model_fname);
[otides_DelaunayNf,otides_dCnm_plus,otides_dSnm_plus,otides_dCnm_minus,otides_dSnm_minus] = tides_ocean_coef(ocean_tides_model_fname);

ocean_Nmax_glb = n_max_otides;
ocean_Mmax_glb = m_max_otides;
otides_DelaunayNf_glb = otides_DelaunayNf;
otides_dCnm_plus_glb  = otides_dCnm_plus;
otides_dSnm_plus_glb  = otides_dSnm_plus;
otides_dCnm_minus_glb = otides_dCnm_minus;
otides_dSnm_minus_glb = otides_dSnm_minus;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

end