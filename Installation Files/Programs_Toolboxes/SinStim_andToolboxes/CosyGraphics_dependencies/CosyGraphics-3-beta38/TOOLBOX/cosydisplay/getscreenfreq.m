function Hz = getscreenfreq(option)
% GETSCREENFREQ  Get the screen refresh frequency. {fast}
%    Hz = GETSCREENFREQ  returns screen refresh frequency, as it had been measured at
%    first CosyGraphics startup. CosyGraphics must have been started at least once for this to work.
%
%    Hz = GETSCREENFREQ('nominal')  returns the nominal frequency as reported by
%    the computer's video driver. This will work even if CosyGraphics has never been started.
%
%    Hz = GETSCREENFREQ('requested')  returns the theoretical frequency, wich was 
%    given as input argument to startcosy/startcogent/startpsych.
%   
%
% See also COMPUTESCREENFREQ, GETFRAMEDUR.
%
% Ben, Sept-Nov 2007

global COSY_DISPLAY

ErrStr = 'CosyGraphics must have been started at least once before to call GETSCREENFREQ without ''nominal'' option.';

if ~nargin                       % measured
    if isempty(COSY_DISPLAY) || isempty(COSY_DISPLAY.MeasuredScreenFrequency), error(ErrStr), end
    Hz = COSY_DISPLAY.MeasuredScreenFrequency;

elseif lower(option(1)) == 'n';  % 'nominal'
    if isptbinstalled
        screen = max(Screen('Screens'));
        if screen > 2, error('To many screens. Don''t know which one to choose.'), end
        Hz = Screen('NominalFrameRate',screen);
    else
        ErrStr = ['PsychToolbox not installed.' 10 ... 
            'Sorry, the ''nominal'' option is not implemented with Cogent.'];
        error(ErrStr)
    end

elseif lower(option(1)) == 'r';  % 'requested'
    if isempty(COSY_DISPLAY) || isempty(COSY_DISPLAY.MeasuredScreenFrequency), error(ErrStr), end
    Hz = COSY_DISPLAY.RequestedScreenFrequency;

else
    error('Improper argument.')
    
end