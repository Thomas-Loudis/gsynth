function [param_value] = read_param_cfg(infilename,param_keyword)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function:  read_param_cfg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:
%  Read parameter' value of a configuration file *.IN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input arguments:
% - infilename     : prm.in input file name (configuration file)
% - param_keyword  : Parameter keyword 
%
% Output arguments:
% - param_value    : Parameter value from the configuration file
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Thomas D. Papanikolaou                                        June  2012
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Last modified:
% 27/05/2022  Dr. Thomas Loudis Papanikolaou
%             Change of name from "readprmIN" to "read_param_cfg"
%             General code modification
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


fid = fopen(infilename,'r');
while (~feof(fid))
    lineith = fgetl(fid);    
%     if length(lineith) > 0
%         if lineith(1:25) == param_keyword
%             prmline = lineith;
%         end
%     end

% Thomas Loudis Papanikolaou, rev. 27/05/2022
    line_keyword = sscanf(lineith,'%s %*');
    test_keyword = strcmp(line_keyword,param_keyword);
    if test_keyword == 1 
        param_value = sscanf(lineith,'%*s %s %*');
    end        
%

end
fclose(fid);
