% Function of minimisation
%
%  err= gam_err(p,mat)
%  
%  p : is table of parameter to minimize (gamma and k)
%  mat : values for the approximation of gamma and K
%
% by Cecile Bordier
% last modification :  29/01/2003


function err= gam_err(p,mat)
%%%minimization parallel with the Y-coordinates
%err=norm([mat(:,2)-(p(1)*mat(:,1).^p(2))])^2;

%%%minimization parallel with the X-coordinates
err=norm([mat(:,1)-(mat(:,2)/p(1)).^(1/p(2))])^2;


%%%%%%%
%Remarque : two minimizations are equivalent
%%%%%%%