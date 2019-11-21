function [BG,bgcolor] = backgroundmask(I,varargin)
% BACKGROUNDMASK  Make a binary background mask.
%    BG = BACKGROUNDMASK(I)  returns the logical matrix BG, where background  
%    pixels in image I are represented by 1 and non-background pixels by 0. 
%    Background color will be determined automatically.
%
%    BG = BACKGROUNDMASK(C)  where C is a cell array containing image matrices,
%    returns background matrices in the cell array BG of same dimensions than C.
%
%    BG = BACKGROUNDMASK(I|C,bgcolor)  does the same for given backgroundcolor.
%    bgcolor is a [r,g,b] vector in the range 0.0-1.0.
%
%    BG = BACKGROUNDMASK(I|C <,bgcolor>, err)  searches for RGB values +/- err.  
%    'err' value can be either in the range 0.0-1.0 or 0-255. Default is 1/255.
%
%    BG = BACKGROUNDMASK(I|C <,bgcolor>, err, ErodeForm, FillHoles)  <TODO!>
%
%    BG = BACKGROUNDMASK(I|C <,bgcolor>, err, ErodeForm)  erodes the foreground
%    (i.e.: adds background pixels to the background border). ErodeForm is the 
%    number of pixels of dilation. If it's a negative number, background will 
%    be eroded.
%
%    [BG,bgcolor] = BACKGROUNDMASK(I <,err>)  returns also the background color.
%    I must be a matrix, not a cell array.
%
% See also HSVMASK.
%
% Ben,	Oct. 2007.

% <TODO:    
%   - Logical, Grayscale images.
%   - Fill holes.
% >

% INPUT ARGS
% First arg is a Cell Array: Recursive Call
if iscell(I)
    BG = cell(size(I));
    for i = 1 : numel(I)
        BG{i} = backgroundmask(I{i},varargin{:}); % <---RECURSIVE CALL---!!!
    end
    return                                        % <---!!!
end

% I
I = stdrgb(I) * 255; % 0:1 -> 0:255
if ndims(I) == 2, I = cat(3,I,I,I); end
if ndims(I) == 4, I = I(:,:,1:3); end

% bgcolor
if nargin >= 2 && length(varargin{1}) >= 3
    bgcolor = stdrgb(varargin{1}(1:3)) * 255; % 0:1 -> 0:255
    varargin(1) = [];
end

% err
if length(varargin)
    err = varargin{1};
    if err < 1, err = round(err * 255); end % 0:1 -> 0:255
else % Default:
	err = 1;
end

% Dilate (Erode fg = Dilate bg)
try,  Dilate = varargin{3}; 
catch Dilate = 0;
end

% FillHoles
try,  FillHoles = varargin{2}; 
catch FillHoles = 1;
end

% FIND BACKGROUND COLOR (if not given)
% We assume that:
%   - One of the 4 corners has the background color.
%     This can be false for very noisy images. <TODO: Fix this!>
%   - They are more pixels of the background color than of any
%     other color. This is reasonable for natural pictures.
if ~exist('bgcolor','var')
    c1 = I(1,1,:);
    c2 = I(1,end,:);
    c3 = I(end,1,:);
    c4 = I(end,end,:);
    corner_colors = [c1(:)'; c2(:)'; c3(:)'; c4(:)'];
    goodone = 0;
    maxi = 0;
    for corner = 1 : 4
        f1 = find(I(:,:,1) == corner_colors(corner,1));
        f2 = find(I(:,:,2) == corner_colors(corner,2));
        f3 = find(I(:,:,3) == corner_colors(corner,3));
        f = unique([f1' f2' f3']);
        if length(f) > maxi
            goodone = corner;
            maxi = length(f);
        end
    end
    bgcolor = corner_colors(goodone,:);
end

% FIND BACKGROUND PIXELS
BGr = I(:,:,1) <= bgcolor(1) + err & I(:,:,1) >= bgcolor(1) - err;
BGg = I(:,:,2) <= bgcolor(2) + err & I(:,:,2) >= bgcolor(2) - err;
BGb = I(:,:,3) <= bgcolor(3) + err & I(:,:,3) >= bgcolor(3) - err;
BG = BGr & BGg & BGb;

% Case of uniform image: Return matrix of 0s
if sum(BG(:)) == numel(BG)
    BG = logical(zeros(size(BG)));
    
% Dilate foreground
elseif Dilate > 0
    se = strel('disk',Dilate,0);
    BG = imdilate(BG,se);
    
elseif Dilate < 0
    se = strel('disk',-Dilate,0);
    BG = imerode(BG,se);
    
end

% OUTPUT ARGS
bgcolor = bgcolor / 255;