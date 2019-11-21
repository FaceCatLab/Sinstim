function drawsquare(varargin)
% DRAWSQUARE  Draw square(s) in offscreen buffer.
%    DRAWSQUARE(b,XY,W,RGB)  draws square(s) in buffer b. XY is a N-by-2 matrix 
%    of coordinates (in pixels), where N is the number of squares to draw. W specify 
%    the width (diameter) of the square(s). If there are more than one square, W can  
%    either be a scalar (all squares share the same width) or a N-by-1 matrix   
%    (different widths for each squares). RGB specify color (red-green-blue, in the 
%    range  0 to 1). Similarly to W, if there are more than one square, RGB can 
%    either be a scalar or a N-by-3 matrix.
%
%    DRAWSQUARE(b,XY,W,RGB,LineWidth)  draws hollow frames(s). LineWidth specify 
%    the thickness of the line, in pixels. Similarly to W and RGB it can be a scalar
%    or a N-by-1 matrix. If LineWidth is 0, draws a filled square, as by default.
%
% Examples:
%    drawsquare(0,[-100 200],10,[1 0 0])  % draws (in the backbuffer, or buffer 0)  
%    %   a 10 pixels width red square at coord. x=-100, y=200 (pixels).
%
%    drawsquare(0,[-100 0; 100 0] ],10,[1 0 0; 0 0 1])  % draws two squares: a red
%    %   square at x=-100, and a blue square at x=100. Both squares have a width of 
%    %   10 pixels.
%
% See also DRAWROUND, DRAWRECT.

% Ben, 	Oct. 2007
%		Sep. 2008	Split drawsquare & drawrect.

% Performances: 0.54 ms on DARTAGNAN (Core2 Quad 2.66 GHz).

drawshape('rect',varargin{:});