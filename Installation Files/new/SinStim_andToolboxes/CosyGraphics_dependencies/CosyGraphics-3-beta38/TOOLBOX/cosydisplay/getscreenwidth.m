function w = getscreenwidth
% GETSCREENWIDTH  CosyGraphics' display width, in pixels. 

global COSY_DISPLAY

if ~isfield(COSY_DISPLAY,'Resolution')
    error('You must have open a display at least once before to call this function.')
end

w = COSY_DISPLAY.Resolution(1);