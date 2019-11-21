function b = isinside(xy, Shape, varargin)
% ISINSIDE  True if coordinates are inside a shape. Same argument than DRAW*. {fast}
%    This function uses the same arguments than DRAW, DRAWRECT, DRAWSQUARE, DRAWROUND to define 
%    the target area.
%
%    b = ISINSIDE(xy, 'rect', XY, WH)  returns true if 'xy' coordinates are inside the rectangle 
%    centered at 'XY' and of width and heigth 'WH'.  'xy' is a 1-by-2 vector of the form [x,y].
%    'XY' and 'WH' are N-by-2 vectors, where N is the number of "targets". (If N>1, 'b' is a N-by-1
%    vector.)
%
%    b = ISINSIDE(xy, 'rect', XYXY)  id., rectangle is now defined by it's corner positions 'XYXY'. 
%    See DRAWRECT, DRAW.
%
%    b = ISINSIDE(xy, 'square', XY, W)  id., square target area.
%
%    b = ISINSIDE(xy, 'round', XY, W)  id., round target area.
%    
% See also: COLLISIONTEST, DRAW, DRAWRECT, DRAWSQUARE, DRAWROUND, GETMOUSE, GETEYE.
%
% Ben, Jul 2011.

switch nargin
    case 4  % 'XY', 'WH'
        XY = varargin{1};
        WH = varargin{2};
        nTargets = max([size(XY,1); size(WH,1)]);
        if nTargets > 1
            if size(XY,1) == 1, XY = repmat(XY,nTargets,1); end
            if size(WH,1) == 1, WH = repmat(WH,nTargets,1); end
        end

        switch lower(Shape)
            case {'round','circle'}
                dx = xy(1) - XY(:,1);
                dy = xy(2) - XY(:,2);
                dist = sqrt(dx^2 + dy^2);
                b = dist <= WH;  % WH is the radius of the circle, in this case

            case {'rect','square'}
                if size(WH,2) == 1
                    WH = [WH WH];  % W -> WH
                end
                b = xy(1) >= XY(:,1) - WH(:,1)/2  &&  xy(1) <= XY(:,1) + WH(:,1)/2  && ...
                    xy(2) >= XY(:,2) - WH(:,2)/2  &&  xy(2) <= XY(:,2) + WH(:,2)/2  ;

            otherwise
                error(['Invalid shape name: "' Shape '".'])
                
        end

    case 3  % 'XYXY'
        b = xy(1) >= XYXY(1)  &&  xy(1) <= XYXY(3)  && ...
            xy(2) >= XYXY(2)  &&  xy(2) <= XYXY(4)  ;
        
    otherwise
        error('Invalid number of input arguments.')

end