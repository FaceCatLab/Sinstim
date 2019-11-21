function [button,t] = waitmouseclick
% WAITMOUSECLICK  Wait mouse button click.
%    WAITMOUSECLICK  .
%    b = WAITMOUSECLICK  waits until user presses any mouse button  
%    and returns button number b (1=left, 2=middle, 4=right).
%
%    [b,t] = WAITMOUSECLICK  returns also time t (msec).
%
% See also GETMOUSE (GLab function), GetClicks (PTB function).
%
% Ben, 2007.

if iscog    % CG
    cgmouse; % clear mouse
    button = 0;
    while ~button
        [x,y,b0,button] = cgmouse;
    end

else        % PTB
    buttons = 0;
    while ~any(buttons)
        [x,y,buttons] = getmouse;
    end
    
    v = [1 2 4];
    button = sum(v(buttons));
    
end
t = time;