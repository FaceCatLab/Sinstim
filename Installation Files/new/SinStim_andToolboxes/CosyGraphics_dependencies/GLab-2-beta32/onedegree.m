function ms = oneframe
% ONEDEGREE  One degree distance, in pixels. <TODO: UNFINISHED!>
%    ONEDEGREE  
%
% See also GETFRAMEDUR, GETSCREENFREQ.
%
% Ben, July 2010.

global GLAB_DISPLAY

if isempty(GLAB_DISPLAY) || isempty(GLAB_DISPLAY.MeasuredScreenFrequency) % GLab never started..
    dispinfo(mfilename,'warning','GraphicsLab has never been started. ...')
    % <TODO>
else                                                                      % GLab already started..
    % <TODO>
end