function prm_ocean_tides(cfg_fname)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: prm_ocean_tides
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:
%  Data reading and preprocessing: Ocean Tides model file and form
%  spherical harmonic coefficients matrices 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input arguments:
% - cfg_fname:          Input confiugration file name *.in 
% 
% Output arguments:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Thomas Loudis Papanikolaou                                    27 May 2022
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Last modified
% 07/06/2022  Thomas Loudis Papanikolaou
%             Code minor modifications
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


global tides_effects_glb
global ocean_Nmax_glb ocean_Mmax_glb 
global otides_DelaunayNf_glb 
global otides_dCnm_plus_glb otides_dSnm_plus_glb otides_dCnm_minus_glb otides_dSnm_minus_glb


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read .in configuration file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fid = fopen(cfg_fname);
while (~feof(fid))
    line_ith = fgetl(fid);
    str1 = sscanf(line_ith,'%s %*');
    
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
end
fclose(fid);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Models data read and preprocessing

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ocean Tides model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ocean Tides model in form of spherical harmonics from FES series (FES2004, FES2014b, ...)
%[otides_DelaunayNf,otides_dCnm_plus,otides_dSnm_plus,otides_dCnm_minus,otides_dSnm_minus] = tides_fes2004(ocean_tides_model_fname);
%[otides_DelaunayNf,otides_dCnm_plus,otides_dSnm_plus,otides_dCnm_minus,otides_dSnm_minus] = tides_ocean_coef(ocean_tides_model_fname);
[shc_struct, delaunay_doodson_multipliers,otides_dCnm_plus,otides_dSnm_plus,otides_dCnm_minus,otides_dSnm_minus] = read_oceantides(ocean_tides_model_fname);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
otides_DelaunayNf = delaunay_doodson_multipliers;

ocean_Nmax_glb = n_max_otides;
ocean_Mmax_glb = m_max_otides;
otides_DelaunayNf_glb = otides_DelaunayNf;
otides_dCnm_plus_glb  = otides_dCnm_plus;
otides_dSnm_plus_glb  = otides_dSnm_plus;
otides_dCnm_minus_glb = otides_dCnm_minus;
otides_dSnm_minus_glb = otides_dSnm_minus;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
