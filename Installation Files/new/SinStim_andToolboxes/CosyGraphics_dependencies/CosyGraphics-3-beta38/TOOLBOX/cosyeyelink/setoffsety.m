function setoffsety(Yoff)
% SETOFFSETY  Set a Y offset for both graphics and EyeLink tracker. <PTB only.>
%    SETOFFSETY(Yoff)  configures the graphics hardware to translate the origin of the Y cartesian 
%    axis of 'Yoff' pixels ; all functions communicating with the EyeLink PC will transparently
%    handle that offset in order to have consistent coordinate sytem on both systems. 
%    On Philippe Lefevre's lab, when using the Barco projector, 'Yoff' should be half the number of
%    pixel lines on the top of the screen that the subject cannot seen.
%
% Ben Jacob, Nov 2011.

global COSY_DISPLAY

if isopen('display') && iscog
    msg = 'Offset Y is supported only over PsychToolBox. It will be ignored over Cogent.';
    dispinfo(mfilename,'error',msg);
    warning(msg)
end

if Yoff > 0, Yoff = ceil(Yoff);
else         Yoff = floor(Yoff);
end

COSY_DISPLAY.Offset = [0 Yoff];

setcoordsystem('screen');

dispinfo(mfilename,'info',['Vertical offset of cartesian coordinate system set to ' num2str(Yoff) ' pixels.'])
dispinfo(mfilename,'info','A virtual resolution will be given to the EyeLink PC to take in account the Y offset.')
if isopen('eyelink')
    [w,h] = getscreenres;
    h = h - 2*abs(Yoff);
    helper_telleyelinkscreenres([w h], mfilename);
end
