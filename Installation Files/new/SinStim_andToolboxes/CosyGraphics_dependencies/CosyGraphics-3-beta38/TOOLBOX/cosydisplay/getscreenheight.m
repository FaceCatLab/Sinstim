function h = getscreenheight
% GETSCREENHEIGHT  CosyGraphics' display height, in pixels. 

global COSY_DISPLAY

if ~isfield(COSY_DISPLAY,'Resolution')
    error('You must have open a display at least once before to call this function.')
end

h = COSY_DISPLAY.Resolution(2);