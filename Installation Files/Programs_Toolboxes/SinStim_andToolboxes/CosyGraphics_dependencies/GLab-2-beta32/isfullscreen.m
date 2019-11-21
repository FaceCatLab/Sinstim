function b = isfullscreen
% ISFULLSCREEN  True if displaying in full screen.

global GLAB_DISPLAY

if isfilledfield(GLAB_DISPLAY,'Screen')
    if GLAB_DISPLAY.Screen, b = true;
    else                    b = false;
    end
    
else
    b = NaN;
    warning('Screen not defined.');
    
end