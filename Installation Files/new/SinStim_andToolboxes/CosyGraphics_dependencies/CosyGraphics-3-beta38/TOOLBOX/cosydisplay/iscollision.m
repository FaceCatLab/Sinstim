function [c,C] = iscollision(shape,XY,wh)
% ISCOLLISION  True if shapes are touching or overlapping. {fast for small matrices (n<100)}
%    [c,C] = ISCOLLISION(shape,w|wh,XY)  returns the collision status vector c (true for
%    colliding shapes) and the collision matrix C.  shape can be 'rect', 'square' or 'round'.
%    w or wh are the same variables than in the DRAW* functions (see).  Different dimention
%    are not supported: all the shapes must identical.
%
% See also: ISINSIDE, DRAW, DRAWRECT, DRAWSQUARE, DRAWROUND.

%% InputArgs
X = XY(:,1);
Y = XY(:,2);

n = length(X);

w = wh(1) + 2; % add 2 pixels include touching shapes into collisions.
h = wh(end) + 2;

%% Compute collision matrix C and collision status vector c
DX = abs(repmat(X,1,n) - repmat(X',n,1));
DY = abs(repmat(Y,1,n) - repmat(Y',n,1));

C = DX <= w & DY <= h;
C = xor(C,eye(n)); % collision matrix
c = (sum(C) > 0)'; % true if collision with another than itself.

switch lower(shape)
    case {'square','rect'}
        % nothing to do.
    case {'circle','round'}
        C(C) = sqrt(DX(C).^2 + DY(C).^2) <= w;
        c = (sum(C) > 0)';
    otherwise
        stopfullscreen;
        error(['Invalid argument. Unknown shape name: ''' shape '''.'])
end
