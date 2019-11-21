function M = matdraw(Shape, rgb, M, xy, d)
% MATDRAW  Draw a shape into a Matlab matrix, with the same syntaxw than DRAW().
%    M = MATDRAW('round', RGB, M, xy, D)  draws a round in matrix M.  Syntax is the same than 
%    draw('round',...), with the matrix M replacing the buffer handle.
%
%    M = MATDRAW(Shape, RGB, M, xy, WH)  <unfinished> <TODO>

%% Input Args
% m, n, p
[m,n,p] = size(M);

% M
if all([m,n,p] == [1 2 1]) % M = MATDRAW(Shape, RGB, [m n], ...)   % <TODO: help for this syntax (??)>
    m = M(1);
    n = M(2);
    p = length(rgb);
    M = zeros(m,n,p);
end

% x,y -> i,j
xy(:,1) =  xy(:,1) + n/2;
xy(:,2) = -xy(:,2) + m/2;


%% Get binary mask of the shape 
switch Shape
    case {'round','oval'}
        [X,Y] = meshgrid(1:n,1:m); % we'll use meshgrid for optimisation reason

        % Ellipse with origin (60,50) of size 15 x 40
        MASK = sqrt( (X - xy(1)).^2 + (Y - xy(2)).^2 ) < d/2;
        
    otherwise
        error('Shape not yet supported.')
        % <TODO: other shapes>
        
end

%% Draw shape in matrix
for k = 1:p
    M(MASK) = rgb(k);
end