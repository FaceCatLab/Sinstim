function drawscorebar(points,P,b)
% DRAWSCOREBAR  Draw a score bar.
%    DRAWSCOREBAR(<points,> <P,> <b>)  draws a score bar.  If 'points' is ommited, the current  
%    value (see GETSCORE) will be used.  P is a structure containing score properties as returned 
%    by GETSCOREPROPERTIES (only Bar* fields will be used) ; if ommited, the current properties 
%    of 'CurrentTotal' will be applied.  b is a buffer handle ; if ommited the default is 0.
%
% See also DRAWSCOREDIGIT, DISPLAYSCORE.

%% Input Args
if nargin < 1, points = getscore; end
if nargin < 2, P = getscoreproperties('CurrentTotal'); end
if nargin < 3, b = 0; end

%% Draw Bar
drawrect(P.BarColorFrame, b, [P.BarX P.BarY], [P.BarWidth+2 P.BarHeight+2]);
drawrect(P.BarColorNeutral, b, [P.BarX P.BarY], [P.BarWidth P.BarHeight]);
w = P.BarWidth * points / P.BarMaxValue;
x0 = -P.BarWidth/2;
x1 = x0 + w;
y0 = P.BarY - P.BarHeight/2;
y1 = P.BarY + P.BarHeight/2;
if points >= 0, rgb = P.BarColorSuccess;
else            rgb = P.BarColorFailure;
end
drawrect(rgb, b, [x0 y0 x1 y1]);