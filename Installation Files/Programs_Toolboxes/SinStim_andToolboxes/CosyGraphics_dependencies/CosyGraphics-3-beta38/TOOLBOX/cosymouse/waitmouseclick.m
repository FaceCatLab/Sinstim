function [button,xy,t] = waitmouseclick(TimeOut)
% WAITMOUSECLICK  Wait for a mouse button click.
%    WAITMOUSECLICK  waits until user presses any mouse button and returns button  
%    number (1=left, 2=middle, 4=right).  If more than one button is pressed, button
%    numbers are additioned (e.g.: 5=left+right).  If a button is already pressed 
%    when the function is called, this will not be taken in account: the function
%    will wait the next key press.  If Esc key is pressed, the function aborts 
%    immediately.
%
%    [b,xy,t] = WAITMOUSECLICK  returns also cursor position (pixels) and time (msec).
%
%    WAITMOUSECLICK(TimeOut)  if no click happens, returns after TimeOut msec.
%
% Known issue:
%    Focus problem: Never returns when Cogent/Matlab looses focus, in windowed mode.
%
% See also GETMOUSE (CosyGraphics function), GetClicks (PTB function).
%
% Ben, 2007 - 2011.

t0 = time;

if ~isopen('display')
    error('No open display.')
end

if ~nargin
    TimeOut = inf;
end

if iscog    % CG
    cgmouse; % clear mouse
    button = 1;
    while button % Wait first the release of a already pressed button.. <v3-beta37>
        [x,y,b0,button] = cgmouse;
    end
    while ~button
        [x,y,b0,button] = cgmouse;
        if time - t0 >= TimeOut, break, end  %  <--!!
        if checkabortkey % update abort flag
            stopfullscreen;
            break %                            <=== RETURN ===!!!
        end
    end

else        % PTB
    button = 0;
    buttons = 1;
    while any(buttons) % Wait first the release of a already pressed button.. <v3-beta37>
        [x,y,buttons] = getmouse;
    end
    while ~any(buttons)
        [x,y,buttons] = getmouse;
        if time - t0 >= TimeOut, break, end  %  <--!!
        if checkabortkey % update abort flag
            stopfullscreen;
            break %                            <=== RETURN ===!!!
        end
    end
    
    v = [1 2 4];
    button = sum(v(buttons));
    
end
xy = [x,y];
t = time;