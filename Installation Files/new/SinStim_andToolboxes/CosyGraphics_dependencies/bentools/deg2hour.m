function hour = deg2hour(deg)
% DEG2HOUR  Conversion from trigonometric degrees to hours (like in a clock).
%   hour = DEG2HOUR(deg)
%   
%   See also HOUR2DEG.
%   
% Ben, Jan. 2008

hour = (90 - deg) / 30;
hour = fitrange(hour,[0 12],'cyclic');