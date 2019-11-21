function drawrect(varargin)
% DRAWRECT  Draw rectangle(s) in offscreen buffer. {fast}
%    Note: This function is intended to be as general as possible. To draw easily
%    small target(s), see DRAWSQUARE.
%
%    DRAWRECT(RGB,b,XY,WH)  draws in buffer b N rectangle(s), centered 
%    at x, y coordinates given by N-by-2 matrix 'XY', of width(s) and heigth(s) 
%    given by matrix 'WH', and of color(s) given by matrix 'RGB'. 'W' and 'RGB' 
%    can either have 1 row if rectangles share the same width/color or N rows   
%    if width/color has to be specified for each one.
%
%    DRAWRECT(RGB,b,XYXY)  fills N rectangular area(s) defined by N-by-4 matrix 
%    of coordinates XYXY.  XYXY column order is [x0 y0 x1 y1] (lower-
%    left corner, upper-right corner) or [x0 y1 x1 y0] (upper-left corner, 
%    lower-right corner). 
%
%    DRAWRECT(RGB,b,XYXY,'XY')  <todo> is the same than above. 
%    DRAWRECT(RGB,b,IJIJ,'IJ')  <todo>
%
%    DRAWRECT(RGB,b,XY,WH,LineWidth)  or,
%    DRAWRECT(RGB,b,XYXY,LineWidth)  draws hollow rectangular frame(s). LineWidth  
%    specify the thickness of the line in pixels. Similarly to W and RGB, it can   
%    be a scalar or a N-by-1 matrix.  If LineWidth is 0, draws a filled rect, as 
%    by default.
%
% See also DRAW, DRAWSQUARE, DRAWROUND, DRAWLINE, DRAWTEXT.
%
% Ben, Sept. 2008

global COSY_DISPLAY

error(nargchk(3,5,nargin));

%% Backward compat with versions prior to 2-beta43:
if nargin>=4 && size(varargin{1},2) == 1 && (size(varargin{4},2) == 3 || size(varargin{4},2) == 4)
    varargin(1:4) = varargin([4 1 2 3]);
    msg = 'Obsolete syntax: RGB argument must be the first argument.';
    dispinfo(mfilename,'warning',msg);
    if COSY_DISPLAY.Screen == 0, warning(msg); end  % don't risk to break timing during an experiment (always in full screen)
end
    
%% Draw!
draw('rect',varargin{:});