function drawpolygon(varargin)
% DRAWPOLYGON  Draw regular/irregular polygon(s) in offscreen buffer.
%    DRAWPOLYGON(N,Theta,b,XY,D,RGB)  draws a regular polygon of N vertices and of orientation Theta
%    in buffer b, circumscribed in a circle of diameter D centered at XY. Theta is an angle in
%    clockwise degrees. At the origin (Theta=0), the polygon rests on it's basis.
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
%    DRAWPOLYGON(N,Theta,b,XY,WH,RGB)  <todo ???>
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
%    DRAWPOLYGON(b,XYXYXY,RGB)  draws an arbitrary polygon with vertices at coord. given by the
%    XYXYXY vector. XYXYXY has the form [x1,y1,x2,y2,...xN,yN].
%
%    DRAWPOLYGON(b,XY,XYXYXY,RGB)  draws an arbitrary polygon "centered" at XY. XYXYXY are now 
%    relative coordinates: they have XY as origin. <TODO!>
%
% Ben, Mar. 2009

error(nargchk(3,7,nargin));
if nargin <= 4
    drawshape('polygon',varargin{:});
else
    shape = [{'polygon'}, varargin(1:2)];
    drawshape(shape,varargin{3:end});
end