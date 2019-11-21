function ms = getframedur(option)
% GETFRAMEDUR  Get the duration of one screen frame. {fast}
%    D = GETFRAMEDUR  returns the frame duration in milliseconds, as it had been measured at
%    first CosyGraphics startup. CosyGraphics must have been started at least once for this to work.
%
%    D = GETFRAMEDUR('nominal')  returns the frame duration deduced from the nominal frequency
%    reported by the computer's video driver. This will work even if CosyGraphics has never been started.
%
%    D = GETFRAMEDUR('requested')  returns the theoretical frame duration, computed from the
%    screen frequency which was wich was given as input argument to startcosy/startcogent/startpsych.  
%
% See also ONEFRAME, COMPUTESCREENFREQ, GETSCREENFREQ.
%
% Ben, Sept-Nov 2007

global COSY_DISPLAY

ErrStr = 'CosyGraphics must have been started at least once before to call GETSCREENFRAMEDUR without ''nominal'' option.';

if ~nargin                       % measured
    if isempty(COSY_DISPLAY) || isempty(COSY_DISPLAY.MeasuredScreenFrequency), error(ErrStr), end
    ms = 1000 / COSY_DISPLAY.MeasuredScreenFrequency;
    
elseif lower(option(1)) == 'n';  % 'nominal'
    ms = 1000 / getscreenfreq('nominal');
    
elseif lower(option(1)) == 'r';  % 'requested'
    if isempty(COSY_DISPLAY) || isempty(COSY_DISPLAY.MeasuredScreenFrequency), error(ErrStr), end
	ms = 1000 / COSY_DISPLAY.RequestedScreenFrequency;
	
end