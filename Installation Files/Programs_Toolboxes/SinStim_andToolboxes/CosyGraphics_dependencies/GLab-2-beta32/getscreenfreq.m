function Hz = getscreenfreq(option)
% GETSCREENFREQ  Get the screen refresh frequency.
%    Hz = GETSCREENFREQ  returns screen refresh frequency, as it had been measured at
%    first GLab startup. GLab must have been started at least once for this to work.
%
%    Hz = GETSCREENFREQ('nominal')  returns the nominal frequency as reported by
%    the computer's video driver. This will work even if GLab has never been started.
%
%    Hz = GETSCREENFREQ('requested')  returns the theoretical frequency, wich was 
%    given as input argument to startglab/startcogent/startpsych.
%   
%
% See also COMPUTESCREENFREQ, GETFRAMEDUR.
%
% Ben, Sept-Nov 2007

global GLAB_DISPLAY

ErrStr = 'GLab must have been started at least once before to call GETSCREENFREQ without ''nominal'' option.';

if ~nargin                       % measured
    if isempty(GLAB_DISPLAY) || isempty(GLAB_DISPLAY.MeasuredScreenFrequency), error(ErrStr), end
    Hz = GLAB_DISPLAY.MeasuredScreenFrequency;

elseif lower(option(1)) == 'n';  % 'nominal'
    if exist('Screen','file') == 3  % If PTB installed (Screen.mex present on the search path)..
        screen = max(Screen('Screens'));
        if screen > 2, error('To many screens. Don''t know which one to choose.'), end
        Hz = Screen('NominalFrameRate',screen);
    else
        ErrStr = ['PsychToolbox not installed.' 10 ... 
            'Sorry, the ''nominal'' option is not yet implemented with Cogent.'];
        error(ErrStr)
    end

elseif lower(option(1)) == 'r';  % 'requested'
    if isempty(GLAB_DISPLAY) || isempty(GLAB_DISPLAY.MeasuredScreenFrequency), error(ErrStr), end
    Hz = GLAB_DISPLAY.RequestedScreenFrequency;

else
    error('Improper argument.')
    
end