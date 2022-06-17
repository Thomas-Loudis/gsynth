function prm_gfm(cfg_fname)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: prm_gfm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:
%  Data reading and preprocessing: Read gravity model file and form
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

global GM_glb ae_glb Cnm_glb Snm_glb 
%global GLB_tide_system


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read .in configuration file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fid = fopen(cfg_fname);
while (~feof(fid))
    line_ith = fgetl(fid);
    str1 = sscanf(line_ith,'%s %*');

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

% param_keyword = 'gravity_model_fname';
% [param_value] = read_param_cfg(cfg_fname,param_keyword);
% gravity_model_fname = param_value;
% 
% param_keyword = 'gfm_max_degree';
% [param_value] = read_param_cfg(cfg_fname,param_keyword);
% n_max_gfm = str2num(param_value);
% 
% param_keyword = 'gfm_max_order';
% [param_value] = read_param_cfg(cfg_fname,param_keyword);
% m_max_gfm = str2num(param_value);
   
end
fclose(fid);


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
   
