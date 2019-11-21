function [ymin,ymax] = getscreenylim
% GETSCREENYLIM  Screen min and max Y co-ordinates.
%    yy = GETSCREENYLIM
%
%    [ymin,ymax] = GETSCREENYLIM
%
% See also GETSCREENXLIM, GETSCREENRES.

h = getscreenres(2);
ymin = -h/2 + 1;
ymax = h/2;
if nargout < 2
    ymin = [ymin,ymax];
end