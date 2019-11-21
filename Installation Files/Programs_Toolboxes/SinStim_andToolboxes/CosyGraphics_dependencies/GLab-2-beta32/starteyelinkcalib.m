function starteyelinkcalib(CalibGrid,varargin)
% STARTEYELINKCALIB
%    STARTEYELINKCALIB(CalibGrid,ScreenNum,ScreenRes <,ScreenBgColor>) 
%    CalibGrid can be 'H3', 'HV3', 'HV5', 'HV9' or 'HV13'. See EyeLink User Manual, fig. 2.3.2.2, p. 16.
%    ScreenNum, ScreenRes, ScreenBgColor are the same arguments that will be given to STARTGLAB during 
%    the experiment. Note that ScreenBgColor is optionnal but recommended, because background color has  
%    to be the same during calibration and experiment for optimal EyeLink accuracy.
%
% Example:
%    starteyelinkcalib('HV5', 0, [800 600], [.5 .5 .5]);

startglab('ptb',varargin{:});
dispinfo(mfilename,'info','Starting EyeLink calibration...')
calibeyelink('C',CalibGrid);
dispinfo(mfilename,'info','Done.')
stopglab;