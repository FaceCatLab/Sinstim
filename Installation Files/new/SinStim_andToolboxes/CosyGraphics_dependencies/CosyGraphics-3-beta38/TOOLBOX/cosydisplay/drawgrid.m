function [x,y] = drawgrid(mn,rgb,b,varargin)
% DRAWGRID  Draw a... grid.
%    DRAWGRID(mn,rgb,b,xy,wh,l)  draws a m-by-n grid of color rgb, in buffer b, 
%    centered at xy, of width and heigth wh, with a line width of l pixels.
%
%    DRAWGRID(mn,rgb,b,xyxy,l)  does the same.  xyxy contains the coordinates of
%    two opposite corners.
%
%    [x,y] = DRAWGRID(...)  the coordinates of the centers of the squares.  x is 
%    a horizontal vector, y is a veritcal vector. 
%
% Example: Draw a sudoku grid:
%       Size = 450;
%       white = [1 1 1];
%       black = [0 0 0];
%       drawsquare(white, 0, [0 0], Size);
%       drawsquare(black, 0, [0 0], Size, 4);
%       drawgrid([3 3], black, 0, [0 0], [Size Size], 2);
%       drawgrid([9 9], black, 0, [0 0], [Size Size], 1);
%       displaybuffer;

%% Input Args
switch length(varargin{1})
    case 2
        xy = varargin{1};
        wh = varargin{2};
        l  = varargin{3};
        x0 = round(xy(1) - wh(1)/2);
        x1 = round(xy(1) + wh(1)/2);
        y0 = round(xy(2) - wh(2)/2);
        y1 = round(xy(2) + wh(2)/2);
        
    case 4
        xyxy = varargin{1};
        l  = varargin{2};
        x0 = min(xyxy([1 3]));
        x1 = max(xyxy([1 3]));
        y0 = min(xyxy([2 4]));
        y1 = max(xyxy([2 4]));
        
    otherwise
        error('Invalid arguments.')
end

%% Draw lines
% Horizontal lines:
hLines_y = round(linspace(y0, y1, mn(2)+1));
hLines_XY0 = [repmat(x0,mn(1)+1,1) hLines_y'];
hLines_XY1 = [repmat(x1,mn(1)+1,1) hLines_y'];

% Vertical lines:
vLines_x = round(linspace(x0, x1, mn(1)+1));
vLines_XY0 = [vLines_x' repmat(y0,mn(2)+1,1)];
vLines_XY1 = [vLines_x' repmat(y1,mn(2)+1,1)];

% Draw all lines:
XY0 = [hLines_XY0; vLines_XY0];
XY1 = [hLines_XY1; vLines_XY1];
drawline(rgb, b, XY0, XY1, l);

%% Output Args
if nargout
   x = mean([vLines_x(1:end-1); vLines_x(2:end)]); % coord of the centers
   
   hLines_y = hLines_y(end:-1:1);
   y = mean([hLines_y(1:end-1); hLines_y(2:end)]);
   y = y';
   
%    X = repmat(x, 9, 1); %<suppr. 3-beta37>
%    Y = repmat(y, 1, 9);
end

