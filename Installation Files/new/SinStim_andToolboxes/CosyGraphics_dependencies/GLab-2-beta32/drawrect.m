function drawrect(varargin)
% DRAWRECT  Draw rectangle(s) in offscreen buffer.
%    Note: This function is intended to be as general as possible. To draw easily
%    small target(s), see DRAWSQUARE.
%
%    DRAWRECT(b,XY,WH,RGB)  draws in buffer b N rectangle(s), centered 
%    at x, y coordinates given by N-by-2 matrix 'XY', of width(s) and heigth(s) 
%    given by matrix 'WH', and of color(s) given by matrix 'RGB'. 'W' and 'RGB' 
%    can either have 1 row if rectangles share the same width/color or N rows   
%    if width/color has to be specified for each one.
%
%    DRAWRECT(b,XYXY,RGB)  fills N rectangular area(s) defined by N-by-4 matrix 
%    of coordinates XYXY. XYXY column order is normally [x0 y0 x1 y1] (lower-
%    left corner, upper-right corner).
%
%    Alternatively, XYXY column order can be [x0 y1 x1 y0] (upper-left corner, 
%    lower-right corner). The former order was more intuitive if you think in 
%    Cartesian x,y coordinates; the latter can be convenient if you are used to 
%    the conventional graphics i,j coordinates (origin at the upper-left, downward 
%    vertical axis --like for matrix coordinates). (PTB functions use such i,j 
%    coordinates for the "rect" argument.) Note that independently of the column  
%    order, we always use Cartesian coordinates (origin at the center, upward Y 
%    axis). <todo: suppress this ?>
%
%    DRAWRECT(b,XYXY,'XY',RGB)  is the same than above. <todo>
%    DRAWRECT(b,IJIJ,'IJ',RGB)  <todo>
%
%    DRAWRECT(b,XY,WH,RGB,LineWidth)  or,
%    DRAWRECT(b,XYXY,RGB,LineWidth)  draws hollow rectangular frame(s). LineWidth  
%    specify the thickness of the line in pixels. Similarly to W and RGB, it can   
%    be a scalar or a N-by-1 matrix.  If LineWidth is 0, draws a filled rect, as 
%    by default.
%
% See also DRAWSQUARE, DRAWROUND, DRAWOVAL, DRAWLINE, DRAWTEXT.
%
% Ben, Sept. 2008

error(nargchk(3,5,nargin));
drawshape('rect',varargin{:});