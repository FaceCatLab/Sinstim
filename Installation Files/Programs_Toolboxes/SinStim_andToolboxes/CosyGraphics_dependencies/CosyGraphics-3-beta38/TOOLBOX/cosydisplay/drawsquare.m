function drawsquare(varargin)
% DRAWSQUARE  Draw square(s) in offscreen buffer. {fast}
%    DRAWSQUARE(RGB,b,XY,D)  draws square(s) in buffer b. XY is a N-by-2 matrix 
%    of coordinates (in pixels), where N is the number of squares to draw. W specify 
%    the width (diameter) of the square(s). If there are more than one square, W can  
%    either be a scalar (all squares share the same width) or a N-by-1 matrix   
%    (different widths for each squares). RGB specify color (red-green-blue, in the 
%    range  0 to 1). Similarly to W, if there are more than one square, RGB can 
%    either be a scalar or a N-by-3 matrix.
%
%    DRAWSQUARE(RGB,b,XY,D,LineWidth)  draws hollow frames(s). LineWidth specify 
%    the thickness of the line, in pixels. Similarly to W and RGB it can be a scalar
%    or a N-by-1 matrix. If LineWidth is 0, draws a filled square, as by default.
%
% Examples:
%    drawround([1 0 0], 0, [-100 200], 10)  % draws a red square in the backbuffer (buffer 0),
%    %   at coord. x=-100, y=200 (in pixels), with a width of 10 pixels.
%
%    drawround([1 0 0; 0 0 1], 0, [-100 0; 100 0] ], 10)  % draws two squares: a red one
%    %   at x=-100, and a blue one at x=100 ; both having a width of 10 pixels. 
%
% See also DRAW, DRAWROUND, DRAWRECT.

% Ben, 	Oct. 2007
%		Sep. 2008	Split drawsquare & drawrect.

% Performances: 0.54 ms on DARTAGNAN (Core2 Quad 2.66 GHz).

global COSY_DISPLAY

error(nargchk(4,5,nargin));

%% Backward compat with versions prior to 2-beta43:
if nargin>=4 && size(varargin{1},2) == 1 && (size(varargin{4},2) == 3 || size(varargin{4},2) == 4)
    varargin(1:4) = varargin([4 1 2 3]);
    msg = 'Obsolete syntax: RGB argument must be the first argument.';
    dispinfo(mfilename,'warning',msg);
    if COSY_DISPLAY.Screen == 0, warning(msg); end  % don't risk to break timing during an experiment (always in full screen)
end
    
%% Draw with generic function
draw('rect',varargin{:});