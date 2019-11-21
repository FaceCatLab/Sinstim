function [w,h] = getscreensizecm(screenNum)
% GETSCREENSIZECM  Get the size of the screen in centimeters. {fast}
%
%    wh = GETSCREENSIZECM  returns screen size in cm, as given by the OS or as set by SETSCREENSIZECM. 
%    'wh' is an [width heigth] vector.
%
%    [w,h] = GETSCREENSIZECM   returns screen's width and heigth as separate output variables.
%
%    See also SETSCREENSIZECM, GETSCREENRES, GETVIEWINGDISTANCECM.


% <Programmer note: Unit choice for CosyGraphics standard: cm or mm ?
%  - Arg for mm: EDID use mm (>< user never interact directly with EDID)
%                EyeView use mm in evReadChronos (>< it's in the interfance, internally Eyeview uses only deg)
%  - Arg for cm: At 57cm view distance, 1 cm = 1 deg and deg is already a standard unit (even in Eyeview inthis particular case) (!!!)
% Conclusion: cm.
% >


global COSY_DISPLAY


%% Input Args
if ~nargin
    screenNum = max(Screen('Screens'));
end


%% Get screen size
if isfilledfield(COSY_DISPLAY,'ScreenSize_cm')  % We alread have it..
    wh = COSY_DISPLAY.ScreenSize_cm;
else                                            % We don't yet have it: let's ask it to the OS..
    [w,h] = Screen('DisplaySize',screenNum);
    if w && h
        wh  = [w h] / 10;
        msg = ['Physical screen size reported by the operating system is: ' num2str(wh(1)) ' x ' num2str(wh(2)) ' cm.'];
        dispinfo(mfilename,'info',msg);
        COSY_DISPLAY.ScreenSize_cm = wh;
    else % Screen('DisplaySize') returns [0 0] in case of failure
        wh = [NaN NaN];
        msg = 'Cannot get screen physical size from operating system. Use SETSCREENSIZECM to set it manually.';
        dispinfo(mfilename,'error',msg)
    end
end


%% Output Args
if nargout <= 1  % 0 or 1 args
    w = wh;
else             % 2 ars
    w = wh(1);
    h = wh(2);
end