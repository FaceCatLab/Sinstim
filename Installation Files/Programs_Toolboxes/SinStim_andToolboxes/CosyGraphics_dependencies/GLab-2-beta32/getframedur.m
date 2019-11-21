function ms = getframedur(option)
% GETFRAMEDUR  Get the duration of one screen frame.
%    D = GETFRAMEDUR  returns the frame duration in milliseconds, as it had been measured at
%    first GLab startup. GLab must have been started at least once for this to work.
%
%    D = GETFRAMEDUR('nominal')  returns the frame duration deduced from the nominal frequency
%    reported by the computer's video driver. This will work even if GLab has never been started.
%
%    D = GETFRAMEDUR('requested')  returns the theoretical frame duration, computed from the
%    screen frequency which was wich was given as input argument to startglab/startcogent/startpsych.  
%
% See also ONEFRAME, COMPUTESCREENFREQ, GETSCREENFREQ.
%
% Ben, Sept-Nov 2007

global GLAB_DISPLAY

ErrStr = 'GLab must have been started at least once before to call GETSCREENFREQ without ''nominal'' option.';

if ~nargin                       % measured
    if isempty(GLAB_DISPLAY) || isempty(GLAB_DISPLAY.MeasuredScreenFrequency), error(ErrStr), end
    ms = 1000 / GLAB_DISPLAY.MeasuredScreenFrequency;
    
elseif lower(option(1)) == 'n';  % 'nominal'
    ms = 1000 / getscreenfreq('nominal');
    
elseif lower(option(1)) == 'r';  % 'requested'
    if isempty(GLAB_DISPLAY) || isempty(GLAB_DISPLAY.MeasuredScreenFrequency), error(ErrStr), end
	ms = 1000 / GLAB_DISPLAY.RequestedScreenFrequency;
	
end