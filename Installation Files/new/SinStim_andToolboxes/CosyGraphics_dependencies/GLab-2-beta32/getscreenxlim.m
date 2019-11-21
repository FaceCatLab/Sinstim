function [xmin,xmax] = getscreenxlim
% GETSCREENXLIM  Screen min and max X co-ordinates.
%    xx = GETSCREENXLIM
%
%    [xmin,xmax] = GETSCREENXLIM
%
% See also GETSCREENYLIM, GETSCREENRES.

w = getscreenres(1);
xmin = -w/2;
xmax = w/2 - 1;
if nargout < 2
    xmin = [xmin,xmax];
end