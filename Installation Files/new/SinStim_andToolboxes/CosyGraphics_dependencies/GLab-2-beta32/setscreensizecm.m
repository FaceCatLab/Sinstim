function setscreensizecm(wh)
% SETSCREENSIZECM  Set screen size in centimeters.
%
%    SETSCREENSIZECM(wh)  defines physical size of the screen, overwriting the settings 
%    that GLab's got automatically from the operating system. 'wh' is a [width heigth] vector, in
%    cm. This setting will be used by PIX2DEG and DEG2PIX for pixels -> deg conversions.
%
%    SETSCREENSIZECM(width)  is the same than SETSCREENSIZECM([width 3/4*width]), 3/4 ration being
%    the tandard ration on CRT screens.
%
% See also GETSCREENSIZECM, SETVIEWINGDISTANCECM, SETHARDWARE<todo>, PIX2DEG, DEG2PIX, AICALIBRATION.
%
% Ben, June 2010.

global GLAB_DISPLAY

if length(wh) == 1, wh = [wh 3/4*wh]; end

GLAB_DISPLAY.ScreenSize_cm = wh;

dispinfo(mfilename,'info',['Screen physical size set by user to ' num2str(wh(1)) ' x ' num2str(wh(1)) ' cm.']);