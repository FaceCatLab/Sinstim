function b = isfullscreen
% ISFULLSCREEN  True if displaying in full screen. {fast}

global COSY_DISPLAY

if isfilledfield(COSY_DISPLAY,'Screen')
    if COSY_DISPLAY.Screen, b = true;
    else                    b = false;
    end
    
else
    b = NaN;
    warning('Screen not defined.');
    
end