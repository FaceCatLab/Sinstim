function drawline(b,varargin)
% DRAWLINE  Draw line(s) in offscreen buffer.
%    DRAWLINE(b,XY0,XY1,RGB <,LineWidth>)  draws line(s) from start point(s) 
%    XY0 to end point(s) XY1. XY0 and XY1 are N-by-2 matrices of cartesian co-
%    ordinates (in pixels), where N is the number of lines to draw. RGB can 
%    either be a  1-by-3 triplet (all lines have the same colors) or a N-by-3 
%    matrix (one row per line to draw). The optional argument LineWidth is the 
%    line width in pixels.
%
%    DRAWLINE(b,XYXY,RGB <,LineWidth>)  does the same. This syntax is similar to 
%    that of DRAWRECT (see).
%
% PTB only:
%    DRAWLINE(b,XY0,XY1,RGB0,RGB1 <,LineWidth>)  or,
%    DRAWLINE(b,XYXY,RGB0,RGB1 <,LineWidth>)  draws line(s) with color(s) RGB0 
%    for the start points and RGB1 for the end points. Color will be interpolated
%    between start and end points. This is available only if PYB is the graphics 
%    library.
%
% Ben, 	May 2008	

%		Sep 2008 <v1.5.7>	Fix line width. Clean: no need to restore color default.

drawshape('Line',b,varargin{:});