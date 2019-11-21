function drawcross(varargin)
% DRAWCROSS   Draw cross(es) in offscreen buffer. {fast}
%    DRAWCROSS(RGB,b,XY,W)
%
%    DRAWCROSS(RGB,b,XY,W,LineWidth)
%
% Ben, Sept. 2008

%% Backward compat with versions prior to 2-beta43:
if size(varargin{4},2) == 3 || size(varargin{4},2) == 4
    varargin(1:4) = varargin([4 1 2 3]);
end
    
%% Draw!
draw('cross',varargin{:});