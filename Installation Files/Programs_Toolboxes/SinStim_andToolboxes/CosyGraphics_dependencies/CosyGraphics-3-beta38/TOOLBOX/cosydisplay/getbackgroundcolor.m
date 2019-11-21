function rgb = getbackgroundcolor
% GETBACKGROUNDCOLOR  Get default background color {fast}
%    rgb = GETBACKGROUNDCOLOR  returns a vector of 3 values ranging between 0 and 1 and describing  
%    the graphics board's current default background color.  After each display (see DISPLAYBUFFER), 
%    the backbuffer (buffer 0) is cleared to that color.
%
% See also: SETBACKGROUND.
%
% Nicolas Deravet, Jan 2013.

global COSY_DISPLAY

rgb = COSY_DISPLAY.BackgroundColor;