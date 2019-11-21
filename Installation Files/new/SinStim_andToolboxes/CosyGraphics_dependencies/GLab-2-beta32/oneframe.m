function ms = oneframe
% ONEFRAME  Duration of one screen frame.
%    ONEFRAME  returns the frame duration in milliseconds. The value returned will less accurate 
%    before the first GraphicsLab startup.
%
%    It's the same than GETFRAMEDUR.
%
% See also GETFRAMEDUR, GETSCREENFREQ.
%
% Ben, July 2010.

global GLAB_DISPLAY

% NB: Use directly values in GLab's global var, instead of higher lvl function for optimization.

if isfield(GLAB_DISPLAY,'MeasuredScreenFrequency') && ~isempty(GLAB_DISPLAY.MeasuredScreenFrequency) % GLab already started..
    ms = 1000 / GLAB_DISPLAY.MeasuredScreenFrequency; % ..use measured value.
else                                                                                                 % GLab never started..
    dispinfo(mfilename,'warning','GraphicsLab has never been started. Using nominal frame rate as approximation.')
    ms = 1000 / getscreenfreq('nominal'); % ..use nominal value.
end
