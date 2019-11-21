function drawround(varargin)
% DRAWROUND  Draw round(s) in offscreen buffer.
%    DRAWROUND(b,XY,D,RGB)  draws round(s) in buffer b. XY is a N-by-2 matrix 
%    of coordinates (in pixels), where N is the number of rounds to draw. D is  
%    the diameter of the round(s). If there are more than one round, D can either  
%    be a scalar (all rounds share the same width) or a N-by-1 matrix (different  
%    widths for each rounds). RGB specify color (red-green-blue, in the range 0.0 
%    to 1.0). Similarly to D, if there are more than one round, RGB can either 
%    be a scalar or a N-by-3 matrix.
%
%    DRAWROUND(b,XY,D,RGB,LineWidth)  draws hollow circle(s). LineWidth specify 
%    the thickness of the line in pixels. Similarly to D and RGB, it can be a  
%    scalar or a N-by-1 matrix. If LineWidth is 0, draws a filled shape, as by 
%    default.
%
% Examples:
%    drawround(0,[-100 200],10,[1 0 0])  % draws (in the backbuffer, or buffer 0)  
%    %   a 10 pixels width red round at coord. x=-100, y=200 (pixels).
%
%    drawround(0,[-100 0; 100 0] ],10,[1 0 0; 0 0 1])  % draws two rounds: a red
%    %   round at x=-100, and a blue round at x=100. Both rounds have a width of 
%    %   10 pixels.
%
% See also DRAWSQUARE, DRAWOVAL.

drawshape('round',varargin{:});