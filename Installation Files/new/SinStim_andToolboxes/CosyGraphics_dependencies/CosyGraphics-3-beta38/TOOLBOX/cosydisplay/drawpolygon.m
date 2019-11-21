function drawpolygon(varargin)
% DRAWPOLYGON  Draw regular/irregular polygon(s) in offscreen buffer. {fast}
%
%% 1) Regular Polygons:
%    DRAWPOLYGON(n,RGB,b,XY,D)  draws regular polygon of n vertices in buffer b, circumscribed in 
%    a circle of diameter D centered at XY.  The polygon rests on it's basis.  If RGB, XY or D contain
%    severals rows, one polygon will be draw per row.  n and b must be scalars.
%
%                    ___________
%                   /          /\
%                  /          /  \
%                 /       D /     \
%                /         /       \
%                \        °(x,y)   /
%                 \     /         /
%                  \   /         /
%                   \/__________/
%
%
%    DRAWPOLYGON(n,RGB,b,XY,WH)  draws a not-really-regular polygon of width and heigth defined by WH.
%
%                    ___________
%                   /     |     \
%                  /      |      \
%                 /      H|       \                  /|\
%                /________|________\               /  |  \
%                \    W   |(x,y)   /             /   H|    \
%                 \       |       /            /______|______\
%                  \      |      /                    W
%                   \_____|_____/
%
% 
%    DRAWPOLYGON(N,RGB,b,XY,D|WH,Theta)  rotates the polygon of Theta degrees, clockwise.
%
%    DRAWPOLYGON(...,Theta,LineWith)  draws a hollow polygonal frame. <TODO, not fully implemented!>
%
%% 2) Arbitrary Polygons:
%    DRAWPOLYGON(RGB,b,XYXYXY)  draws an arbitrary polygon with vertices at coord. given by the
%    XYXYXY vector. XYXYXY has the form [x1,y1,x2,y2,...xN,yN].
%
%    DRAWPOLYGON(RGB,b,XY,XYXYXY <,theta>)  draws an arbitrary polygon centered at XY.  XYXYXY are 
%    now relative coordinates: they have XY as origin. <TODO!>
%
%    DRAWPOLYGON(...,LineWith)  draws a hollow polygonal frame. <not fully implemented!>
%
% Ben, Mar. 2009

%%
error(nargchk(3,7,nargin));

if size(varargin{1},2) == 1 % Regular Polygon:
    draw(sprintf('polygon%d',varargin{1}), varargin{2:end});
else                        % Arbitrary Polygon:
    draw('polygon',varargin{:});
end


%                  /|\
%                /  |  \
%              /    |    \
%            /      |      \
%           |      H|       |
%           |_______|_______|         % obolete because when theta = 0, polygon rests on it's basis
%           |       |  W    |
%           |       |       |
%            \      |      /
%              \    |    /
%                \  |  /
%                  \|/
%