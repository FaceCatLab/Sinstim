function ms = oneframe
% ONEFRAME  Duration of one screen frame. {fast}
%    ONEFRAME  returns the frame duration in milliseconds. The value returned will less accurate 
%    before the first CosyGraphics startup.
%
%    It's the same than GETFRAMEDUR.
%
% See also GETFRAMEDUR, GETSCREENFREQ.
%
% Ben, July 2010.

global COSY_DISPLAY

% NB: Use directly values in CosyGraphics's global var, instead of higher lvl function for optimization.

if isfield(COSY_DISPLAY,'MeasuredScreenFrequency') && ~isempty(COSY_DISPLAY.MeasuredScreenFrequency) % CosyGraphics already started..
    ms = 1000 / COSY_DISPLAY.MeasuredScreenFrequency; % ..use measured value.
else                                                                                                 % CosyGraphics never started..
    dispinfo(mfilename,'warning','CosyGraphics has never been started. Using nominal frame rate as an approximation.')
    ms = 1000 / getscreenfreq('nominal'); % ..use nominal value.
end
