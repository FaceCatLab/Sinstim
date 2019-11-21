function drawline(varargin)
% DRAWLINE  Draw line(s) in offscreen buffer. {fast}
%    DRAWLINE(RGB,b,XY0,XY1 <,lineWidth>)  draws line(s) from start point(s) 
%    XY0 to end point(s) XY1. XY0 and XY1 are N-by-2 matrices of cartesian co-
%    ordinates (in pixels), where N is the number of lines to draw. RGB can 
%    either be a  1-by-3 triplet (all lines have the same colors) or a N-by-3 
%    matrix (one row per line to draw). The optional argument lineWidth is the 
%    line width in pixels.
%
%    DRAWLINE(RGB,b,XYXY <,LineWidth>)  does the same. This syntax is similar to 
%    that of DRAWRECT (see).
%
% PTB only:
%    DRAWLINE(RGBRGB,b,XY0,XY1 <,lineWidth>  or,
%    DRAWLINE(RGBRGB,b,XYXY,b,XYXY <,lineWidth>)  draws line(s) with a color
%    gradient from color(s) RGB(1:3,:) for the start points to color(s) RGB(4:6,:) 
%    for the end points. Color will be interpolated between start and end points. 
%    This is available only if PYB is the graphics library.
%
% Ben, 	May 2008	

%		Sep 2008 <v1.5.7>	Fix line width. Clean: no need to restore color default.

draw('line',varargin{:});