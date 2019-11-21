function dispinfo(CallerName,InfoType,Message)
% DISPINFO  Display caller function info/warning/error in command window.
%    DISPINFO(MFILENAME,InfoType,Message)  displays caller function name (got from MFILENAME) and 
%    message in command window. MFILENAME is the standard Matlab function. InfoType can be 'INFO', 
%    'WARNING' or 'ERROR'.
%
%    This function is intended to be used by all CosyGraphics functions to display their message in
%    the command window. It does nothing wonderfull curently, but it provides a centralized way to
%    modify the way all function infos are displayed, if needed.
%    <TODO: Replace by "cosyprint" in CosyGr.>
%
% Example:
%    dispinfo(mfilename,'info','Hello world!')

CallerName = upper(CallerName);
if any(strfind(lower(InfoType),'info')),        InfoType = lower(InfoType);
elseif any(strfind(lower(InfoType),'warning')), InfoType = upper(InfoType);
elseif any(strfind(lower(InfoType),'error')),   InfoType = upper(InfoType);
end
message = [CallerName '-' InfoType ': ' Message];
fprintf('%s\n',message); % <CosyG v3-beta6: Use fprintf(), not disp()!!! disp() is queued by Matlab !!!>