function starteyelinkcalib(CalibGrid, ScreenNum, ScreenRes, ScreenBgColor, OffsetY)
% STARTEYELINKCALIB  
%    STARTEYELINKCALIB(CalibGrid, ScreenNum, ScreenRes, ScreenBgColor <,OffsetY>) 
%    CalibGrid can be 'H3', 'HV3', 'HV5', 'HV9' or 'HV13'. See EyeLink User Manual, fig. 2.3.2.2, p. 16.
%    ScreenNum, ScreenRes, ScreenBgColor are the same arguments that will be given to STARTCOSY during 
%    the experiment. Note that ScreenBgColor is optionnal but recommended, because background color has  
%    to be the same during calibration and experiment for optimal EyeLink accuracy.
%    OffsetY (optional) is the same arg. than given to setoffsety (for EyeLab with Barco projector).
%
% Example:
%    starteyelinkcalib('HV5', 1, [800 600], [.5 .5 .5]);
%    % later, in your experimental script, you'll have to use:  startpsych(1, [800 600], [.5 .5 .5]);
%
% See also: STARTPSYCH, CALIBEYELINK.

startpsych(ScreenNum, ScreenRes, ScreenBgColor);
if exist('OffsetY','var')
    setoffsety(OffsetY);
end
dispinfo(mfilename,'info','Starting EyeLink calibration...')
calibeyelink('C',CalibGrid);
dispinfo(mfilename,'info','Done.')
stopcosy;