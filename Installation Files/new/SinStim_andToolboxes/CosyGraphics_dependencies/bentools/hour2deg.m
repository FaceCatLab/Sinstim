function deg = hour2deg(hour)
% HOUR2DEG  Conversion from hours (like in a clock) to trigonometric degrees.
%   deg = HOUR2DEG(hour)
%   
%   See also DEG2HOUR.
%   
% Ben, Jan. 2008

deg = (3 - hour) * 30;
deg = fitrange(deg,[0 360],'cyclic');