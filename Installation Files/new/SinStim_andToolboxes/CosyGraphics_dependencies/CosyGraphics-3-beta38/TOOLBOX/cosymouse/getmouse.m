function [x,y,is,was] = getmouse(ScreenPosition)
% GETMOUSE  Get current mouse pointer position and button states.
%    This functions works perfecly with Cogent, However with PsychTB, there are issues 
%    due to incomplete support of the mouse by PTB 3.0.8 on MS-Windows and Linux: 
%    - in windowed display: coord are only correct if you DON'T MOVE THE WINDOW.
%    - in fullscreen display: we have to use a hack (see below) to get correct coord. 
%
%    xy = GETMOUSE  returns mouse position, in pixels.
%
%    [x,y] = GETMOUSE  id. 
%
%    [x,y,isDown] = GETMOUSE  returns also the state of the buttons. 'isDown' is 
%    a 3 element vector of logical values containing a 1 if left/middle/right button,
%    repectively, is down and a 0 if it is not. 
%
% PsychTB only, hack for dual-screen: 
%    For fullscreen display on a dual-monitor PC, use this hack (PTB only):
%    GETMOUSE(ScreenPosition)  ScreenPosition is 'L' (left) or 'R' (right).
%
% Cogent only:
%    [x,y,isDown,wasDown] = GETMOUSE  'wasDown' is similar to 'isDown' but contains  
%    1s if buttons has been down since last call to getmouse. This is not supported 
%    on PTB.
%
% Obsolete syntax:
%    [xy,isDown,wasDown] = GETMOUSE  is no more supported.
%    
%
% See also SETMOUSE, WAITMOUSECLICK.
%
% Ben, March 2008.


%
% Programmer's note: About syntax:   <TODO: Suppress [x,y] = GETMOUSE ????>
%    xy = GETMOUSE  is still supported for backward compatibility, but deprecated.
%    Programmer's note: We prefer the [x,y] = GETMOUSE syntax, with is the same than
%    the syntax of PTB's homonymous function 'GetMouse', and is also consistent
%    with the syntax of CG's 'cgmouse'.


global COSY_DISPLAY

if ~isopen('display')
    error('No open display.')
end

%% Get Mouse
if iscog    % CG
    [x,y,is,was] = cgmouse;

    is = dec2bin(is,3);
    was = dec2bin(was,3);
    is  = logical([str2double(is(3)) str2double(is(2)) str2double(is(1))]);
    was = logical([str2double(was(3)) str2double(was(2)) str2double(was(1))]);
    
else        % PTB
    if nargout == 4
        error('''wasDown'' output argument not supported over PTB.')
    end
    
    % Get mouse:
    [x,y,is] = PtbGetMouse;
    
    % Remove offset:
    % PTB's mouse support is incomplete on Windows and Linux. Mouse co-ordinates are desktop-relative 
    % co-ordinates, while we wanted window-relative co-ord. That means we have an offset in two cases:
    % when displaying in a window, and when displaying full-screen on the right screen of a dual-screen 
    % setup. OPENDISPLAY has stored this offset in "COSY_DISPLAY.MouseOffset4PTB".
    x = x - COSY_DISPLAY.MouseOffset4PTB(1);
    y = y - COSY_DISPLAY.MouseOffset4PTB(2);
    
    % JI -> XY (Graphics coord. -> Cartesian coord.):
    [w,h] = getscreenres;
    x =  x - w/2;
    y = -y + h/2;
    
end

%% Output Arg.
if nargout <= 1,
    x = [x,y];  % [x,y] -> xy
end
    
