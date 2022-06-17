function [DelaunayNf_otidesmodel,dCnm_plus,dSnm_plus,dCnm_minus,dSnm_minus] = tides_ocean_coef(otides_filename)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tides_ocean_coef : Ocean Tide Models (FES2004, FES2014b)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:
%  Read data of ocean tide model (geoptential spherical harmonic
%  coefficients e.g. FES2004 data format) and find the Delaunay variables 
%  multipliers for each tide wave via the Doodson number
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input arguments
% - otides_filename :  Ocean Tide model data file name with the harmonics
%                     coefficients Cnm,Snm based on the FES2004 data format
%                     as by IERS reference file "fes2004_Cnm-Snm.dat"
%
% Output arguments:
% - DelaunayNf_otidesmodel : Delaunay variables multipliers for model' tidal
%                            waves 
% - dCnm_plus  : FES2004 coefficients to be used in Eq.6... IERS Conv.2010
%   dSnm_plus    Coefficients are stored in these four 3D arrays
%   dCnm_minus
%   dSnm_minus
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Thomas D. Papanikolaou, AUTH                                   June  2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Last modified
%  23/06/2012  Speed up reading of FES2004 model's coefficients and store
%              them in 3D arrays
%  28/06/2012  Revised according to the IERS Conventions 2010 updates at 
%              23/09/2011 & 14/10/2011
%              fes2004_Cnm-Snm.dat : revised file
%              Coefficients Unit is now 10^-11 and Coefficients corrections
% 
% 01/02/2019  Dr. Thomas Papanikolaou
%             Delaunay variables multipliers update: M4 tidal wave added 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Coefficients Unit : 10^-12 (IERS Conventions 2010)
% Coefficients Unit : 10^-11 (IERS Conventions 2010 updated 23/09/11)
fes2004_cfunit = 10^(-11);
%fprintf('%s %.0e \n','FES2004 Coefficients Unit :',fes2004_cfunit);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% N : Five multipliers of the Delaunay variables (l l' F D Omega)
% N : Nj, j = 1:5
% Values are taken from Tables 6.5b, 6.5a, 6.5c
% Matrix format : Columns : Doodson_No. l l' F D Omega   Amp.(ip) Amp.(op)
% Last two columns are not required
Ndelaunay_f  = [
55.565   0  0  0  0  1 
55.575   0  0  0  0  2 
56.554   0 -1  0  0  0 
57.555   0  0 -2  2 -2 
65.455  -1  0  0  0  0 
75.555   0  0 -2  0 -2 
85.455  -1  0 -2  0 -2 
93.555   0  0 -2 -2 -2 
135.655  1  0  2  0  2 
145.555  0  0  2  0  2 
163.555  0  0  2 -2  2 
165.555  0  0  0  0  0 
235.755 -2  0 -2  0 -2 
245.655  1  0  2  0  2 
255.555  0  0  2  0  2 
273.555  0  0  2 -2  2 
275.555  0  0  0  0  0 
455.555  0  0  4  0  4 
];

%DelaunayNf_fes2004 = Ndelaunay_f;

% FES2004_DelaunayNf = [
% 55.565 Om1 
% 55.575 Om2 
% 56.554 Sa  
% 57.555 Ssa 
% 65.455 Mm  
% 75.555 Mf  
% 85.455 Mtm 
% 93.555 Msq 
% 135.655 Q1 
% 145.555 O1
% 163.555 P1 
% 165.555 K1 
% 235.755 2N2
% 245.655 N2 
% 255.555 M2 
% 273.555 S2 
% 275.555 K2 
% 455.555 M4 
% ];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read Ocean Tides model' data file :: Read number of tidal frequencies
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fid = fopen(otides_filename);
% linei = 0;
headeri = 1;
while headeri == 1
    HDlineread = fgetl(fid);
%     linei = linei + 1;
    if HDlineread(1:7) == 'Doodson'
        headeri = 0;
    end
end

otidesmodel_Nfreq = 0;
linei = 0;
while (~feof(fid))
    lineread = fgetl(fid);
    linei = linei + 1;

    %doodson_no = str2num(lineread(1:7));
    doodson_no = str2num( sscanf(lineread,'%s %*') );
    if (linei == 1)
        doodson_wave_i = doodson_no;
        otidesmodel_Nfreq = otidesmodel_Nfreq + 1;
        otidesmodel_doodson_matrix(otidesmodel_Nfreq) = doodson_no;
    end
    
    %if (doodson_no ~= doodson_wave_i )
    if abs(doodson_no - doodson_wave_i) > 10^-8
        otidesmodel_Nfreq = otidesmodel_Nfreq + 1;
        otidesmodel_doodson_matrix(otidesmodel_Nfreq) = doodson_no;
        doodson_wave_i = doodson_no;
    end    
end
fclose(fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Preallocation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
otidesmodel_Nmax = 100;
%otidesmodel_Nfreq;

%Ndelaunay_f = zeros(otidesmodel_Nfreq,6);
DelaunayNf_otidesmodel = zeros(otidesmodel_Nfreq,6);
dCnm_plus = zeros(otidesmodel_Nmax+1,otidesmodel_Nmax+1,otidesmodel_Nfreq);
dSnm_plus = zeros(otidesmodel_Nmax+1,otidesmodel_Nmax+1,otidesmodel_Nfreq);
dCnm_minus = zeros(otidesmodel_Nmax+1,otidesmodel_Nmax+1,otidesmodel_Nfreq);
dSnm_minus = zeros(otidesmodel_Nmax+1,otidesmodel_Nmax+1,otidesmodel_Nfreq);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Model's Matrix with Doodson numbers and Delaunay multipliers 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Nfreq_table Ndel] = size(Ndelaunay_f);
[Nfreq_model] = size(otidesmodel_doodson_matrix);

for n_model = 1 : Nfreq_model 
    doodson_no = otidesmodel_doodson_matrix (n_model);
    for n_table = 1 : Nfreq_table
        doodson_no_table = Ndelaunay_f(n_table,1);
        if ( abs(doodson_no - doodson_no_table) < 10^-8 )
            %DelaunayNf_fes2004
            DelaunayNf_otidesmodel(n_model,1) = doodson_no;
            for i_delaunay = 2 : Ndel
                DelaunayNf_otidesmodel(n_model,i_delaunay) = Ndelaunay_f(n_table,i_delaunay); 
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read Ocean Tides model' data file: Coefficients matrices (3d)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fid = fopen(otides_filename);
% linei = 0;
headeri = 1;
while headeri == 1
    HDlineread = fgetl(fid);
%     linei = linei + 1;
    if HDlineread(1:7) == 'Doodson'
        headeri = 0;
    end
end

%[sz1 sz2] = size(Ndelaunay_f);
% iread = 0;
%if_FES2004 = 0;
%DelaunayNf_otidesmodel = zeros(1,sz2-2);
%i2test = 0;

[sz1 sz2] = size(DelaunayNf_otidesmodel);

while (~feof(fid))
    lineread = fgetl(fid);
%     linei = linei + 1;
    doodson_no = str2num(lineread(1:7));
    for idelaunay = 1 : sz1
%        if abs(doodson_no - Ndelaunay_f(idelaunay,1)) < 10^-8
        if abs(doodson_no - DelaunayNf_otidesmodel(idelaunay,1)) < 10^-8
%             iread = iread + 1;
                        
            % Read and store d/o coefficients
            dCnmSnm = sscanf(lineread,'%*f %*s %d %d %f %f %f %f');
            Nread = dCnmSnm(1,1);
            Mread = dCnmSnm(2,1);
            
            % 3D arrays  ixjxk : n x m x frq
            dCnm_plus(Nread+1, Mread+1, idelaunay) = fes2004_cfunit * dCnmSnm(3,1);
            dSnm_plus(Nread+1, Mread+1, idelaunay) = fes2004_cfunit * dCnmSnm(4,1);
            dCnm_minus(Nread+1, Mread+1, idelaunay) = fes2004_cfunit * dCnmSnm(5,1);
            dSnm_minus(Nread+1, Mread+1, idelaunay) = fes2004_cfunit * dCnmSnm(6,1);
            
            break
        end
    end    
    clear doodson_no N_f
end
fclose(fid);
clear sz1 sz2 i linei fes2004_indx
