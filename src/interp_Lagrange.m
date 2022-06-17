function [yint] = interp_Lagrange(X,Y,xint,dpint)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lagrange Polynomials - Lagrangian Interpolation
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:
%  Lagrangian interpolation is based on the computation of Lagrange
%  Polynomials and is suggested for data interpolation such as satellite
%  data, EOP (Earth Orientation Parameters), ...
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input arguments:
% - X:     array of values of the independent variable
% - Y:     array of function values corresponding to X i.e. y=f(x)
% - xint:  X value for which interpolated estimate of y is required
% - dpint: number of data points used for interpolation
%
% Output arguments:
% - yout:  y value of the interpolation that refer to xint value
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Thomas D. Papanikolaou, AUTH                                November 2007
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Testing if interpolation is required or not
% Finding of index position of the first X value before xint (in case
% interpolation is required)
[sz1 sz2] = size(X);
if xint < X(1,1)
    fprintf('%s \n','Interpolation epoch is out of the data span')
    fprintf('%s %f   %s %f \n','Interpolation epoch :',xint,'Data series first epoch :',X(1,1))
elseif xint > X(sz1,1)
    fprintf('%s \n','Interpolation epoch is out of the data span')
    fprintf('%s %f   %s %f \n','Interpolation epoch :',xint,'Data series last epoch :',X(sz1,1))        
end
for i = 1 : sz1
    %xinterpolation = xint;
    %Xseries_i = X(i,1);
    %dXsearch = xint - X(i,1);
    if abs(xint - X(i,1)) < 10^-10
        yint = Y(i,1);
        interpolation = -1;
        break
    elseif xint - X(i,1) < 0
        Xo_indx = i-1;
        interpolation = +1;
        break
    end
end
%clear i sz2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if interpolation == 1
%Xo_indx;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Adjust the "dpint" according to its initial value and the number of
% points of X,Y arrays before and after the interpolation point "xint".
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Number of points before "xint"
Xno_before = Xo_indx;
% Number of points after "xint"
Xno_after = sz1 - Xo_indx;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define "dpint" limits before and after "xint" acording to the initial
% "dpint" ("dpint" is odd or even)
dpint_initial = dpint;
dpint_limit1 = fix(dpint/2);
dpint_limit2 = dpint - fix(dpint/2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set "dpint" new value to fit properly the limits before and after "xint"
dpint_minus = 2;
while (dpint_limit1 > Xno_before) || (dpint_limit2 > Xno_after)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Decrease "dpint" per 1 or 2 units according to dpint_minus variable    
    dpint = dpint - dpint_minus;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    dpint_limit1 = fix(dpint/2);
    dpint_limit2 = dpint - fix(dpint/2);
    %fprintf('%s %s %s %s %s %s %s %s\n','dpint',num2str(dpint),'dpint_limit1',num2str(dpint_limit1),'dpint_limit2',num2str(dpint_limit2),'dpint_minus',num2str(dpint_minus))
end
%fprintf('%s %s %s %s %s %s %s %s %s %s\n','dpint_new',num2str(dpint),'dpint_initial',num2str(dpint_initial),'dpint_limit1',num2str(dpint_limit1),'dpint_limit2',num2str(dpint_limit2),'dpint_minus',num2str(dpint_minus));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% X,Y values of data points defined by the final value of "dpint"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Finding of index position of the first X value for the data area defined
% by dpint (according if dpint is even or odd)
X1_indx = Xo_indx - (fix(dpint/2) - 1);
% dp_half = dpint/2
% deltafix = fix(dp_half) - dp_half
% if abs(fix(dp_half) - dp_half) < 10^-10
%     % Even dpint:
%     X1_indx = Xo_indx - (dp_half - 1);
% elseif abs(fix(dp_half) - dp_half) ~= 0
%     % Odd dpint:
%     Xo_indx
%     dfix = (fix(dp_half)-1)
%     X1_indx = Xo_indx - (fix(dp_half)-1)
% end
% % Xo_indx
% % dfix = fix(dp_half)-1
% X1_indx
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Xdpint = zeros(dpint,1);
Ydpint = zeros(dpint,1);
for i = 1 : dpint
    Xdpint(i,1) = X(X1_indx+i-1,1);
    Ydpint(i,1) = Y(X1_indx+i-1,1);
end
%clear i
% New X,Y matrices with the values for data points defined by dpint
X = Xdpint;
Y = Ydpint;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Langrange interpolation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Number of Data points
[n,m] = size(X);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Computation of coefficients Li (xint)
% Prealocation
L = zeros(n,1);
for i = 1 : n
    L_numerator = 1 ;
    L_denominator = 1;
    for j = 1 : n
        if j == i
            % nothing
        else
            L_numerator = ( xint - X(j,1) ) * L_numerator ;
            L_denominator = ( X(i,1) - X(j,1) ) * L_denominator ;
        end
    end   
    L(i,1) = L_numerator / L_denominator ;
end
%clear i
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimation of value of function Y(X) at point xint
% Estimation is realized by Interpolant Pn(xint) via Lagrange Polynomial
yint = 0;
for i = 1 : n
    yint = Y(i,1) * L(i,1) + yint;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
