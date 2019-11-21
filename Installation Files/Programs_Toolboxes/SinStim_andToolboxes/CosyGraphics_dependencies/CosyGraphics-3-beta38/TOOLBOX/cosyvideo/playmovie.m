function playmovie(h,xy,wh)
% PLAYMOVIE  Start movie playback.
%    PLAYMOVIE(h)  starts playback of movie of handle h and returns when finished. 'h' is the handle 
%    returned by LOADMOVIE.  Movie is displayed on th whole display surface.
%
%    PLAYMOVIE(h,xy,wh)  centers movie at point xy (a [x y] vector, in pixels) and gives it a width 
%    and a heigtht wy (a [width heigth] vector, in pixels).  Negative values for width or heigth
%    invert the image.
%
%    PLAYMOVIE(h,xyxy)  scales movies between corners given by xyxy. 'xyxy' is a [x0 y0 x1 x1], 
%    where x0, y0 are the coordinates of a corner and x1, y1 are the coordinates of the opposite
%    corner.
%
% Example:
%    h = loadmovie('movie.avi');
%    playmovie(h);
%
% See also: LOADMOVIE, CLOSEMOVIE.

if nargin == 0
    error('Missing argument. You must provide a movie handle.')
end

if iscog
    switch nargin
        case 1
            cgplaymovie(h);
        
        case 2
            xyxy = xy;
            xyxy([1 3])
            xy = [(xyxy(1)+xyxy(3))/2, (xyxy(2)+xyxy(4))/2];
            wh = [abs(xyxy(3)-xyxy(1)), abs(xyxy(4)-xyxy(2))];
            cgplaymovie(h,xy(1),xy(2),wh(1),wh(2));
            
        case 3
            cgplaymovie(h,xy(1),xy(2),wh(1),wh(2));

    end
    
else
    % <TODO>
    
end