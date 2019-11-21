function b = storealphamask(M, bg)
% STOREALPHAMASK<unfinished>   Store matrix in offscreen buffer for later usage as an alpha-mask. {slow}
%   b = STOREALPHAMASK(M)  
%
%   b = STOREALPHAMASK(M, BgColor)
%
% See also: STOREIMAGE, COPYBUFFERTHROUGHMASK.

global COSY_DISPLAY;

if nargin < 2
    bg = COSY_DISPLAY.BackgroundColor;
end

Z = zeros(size(M));
M = cat(3, Z+bg(1), Z+bg(2), Z+bg(3), M);

b = storeimage(M);