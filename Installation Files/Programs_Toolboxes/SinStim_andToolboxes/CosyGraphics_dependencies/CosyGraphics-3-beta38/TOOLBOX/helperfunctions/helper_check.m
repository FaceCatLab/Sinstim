function helper_check(test)
% COSYGRAPHICSCHECK  Check CosyGraphics status.
%    COSYGRAPHICSCHECK ISDISPLAY  issues an error if no open display.


global COSY_DISPLAY


switch lower(test)
    case 'isdisplay'
        if isempty(COSY_DISPLAY) || ~COSY_DISPLAY.isDisplay
            str = ['No open display.' 10 ...
                'Use STARTCOGENT to open a CogentGraphics display.' 10 ...
                'Use STARTPSYCH to open a PsychToolBox display.'];
            error(str)
        end
        
    otherwise
        error('Invalid argument.')
        
end
        