function drawpolygon(varargin)
% DRAWPOLYGON  Draw regular/irregular polygon(s) in offscreen buffer.
%    DRAWPOLYGON(N,Theta,b,XY,R,RGB)  draws a regular polygon of N vertices and of orientation Theta
%    (clockwise deg) in buffer b at coordinates 
%
%    
%
%    DRAWPOLYGON(b,XYXYXY,RGB)


%                  /|\
%                /  |  \
%              /   H|    \
%            /______|______\
%                    W

%                  /|\
%                /  |  \
%              /    |    \
%            /      |      \
%           |      H|       |
%           |_______|_______|
%           |       |  W    |
%           |       |       |
%            \      |      /
%              \    |    /
%                \  |  /
%                  \|/
%
% Ben, Mar. 2009

error(nargchk(3,5,nargin));
drawshape('rect',varargin{:});