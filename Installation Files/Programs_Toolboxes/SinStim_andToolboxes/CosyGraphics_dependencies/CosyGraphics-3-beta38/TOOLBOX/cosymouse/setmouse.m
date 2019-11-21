function setmouse(x,y)
% SETMOUSE  Set current mouse position to given co-ordinates.
%    SETMOUSE(x,y)  sets mouse position to x, y co-ordinates.
%
%    SETMOUSE(xy)  does the same.
%
%    SETMOUSE OUT  puts mouse's cursor out of the display.
%
% See also GETMOUSE.
%
% Ben, March 2008.

global COSY_DISPLAY

if nargin == 1
    if isnumeric(x) %    SETMOUSE(xy) 
        y = x(2);
        x = x(1);
    else            %    SETMOUSE OUT
        [w,h] = getscreenres;
        x =  w/2;
        y = -h/2;
    end
end

if iscog	% CG
    cgmouse(x,y);
    
else        % PTB
    [w,h] = getscreenres;
    x = floor( x + w /2);
    y = floor(-y + h/2);
    x = x + COSY_DISPLAY.MouseOffset4PTB(1);
    y = y + COSY_DISPLAY.MouseOffset4PTB(2);
    PtbSetMouse(x,y);
    
end