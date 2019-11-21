function glabhelper_check(test)
% GLABCHECK  Check GLab status.
%    GLABCHECK ISDISPLAY  issues an error if no open display.


global GLAB_DISPLAY


switch lower(test)
    case 'isdisplay'
        if isempty(GLAB_DISPLAY) || ~GLAB_DISPLAY.isDisplay
            str = ['No open display.' 10 ...
                'Use STARTCOGENT to open a CogentGraphics display.' 10 ...
                'Use STARTPSYCH to open a PsychToolBox display.'];
            error(str)
        end
        
    otherwise
        error('Invalid argument.')
        
end
        