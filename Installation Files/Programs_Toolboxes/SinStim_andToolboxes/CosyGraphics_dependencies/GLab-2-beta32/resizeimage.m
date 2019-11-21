function I = resizeimage(I,varargin)
% RESIZEIMAGE  Resize image.
%    I = RESIZEIMAGE(I, SCALE) returns an image that is SCALE times the size of I,
%    which is a grayscale, RGB, or binary image, or a cell array containing such images.
%    
%    I = RESIZEIMAGE(I, [W H]) resizes the image so that it has W columns and H rows. 
%    Either W or H may be NaN, in which case RESIZEIMAGE computes the number of columns
%    or rows automatically in order to preserve the image aspect ratio.
%
%    To control the interpolation method used, add a METHOD argument to any of the
%    syntaxes above, like this:
%  
%         I = RESIZEIMAGE(I, SCALE, METHOD) 
%         I = RESIZEIMAGE(I, [NUMROWS NUMCOLS], METHOD),
%
%    See HELP IMRESIZE about the METHOD argument.
%
% Ben, Jan 2010.


% This function is a wrapper for IMRESIZE (Image Processing TB). It adds two improvements:
% - IMRESIZE may outputs imge with values out of range, which can cause bugs in further
%   processing. RESIZEIMAGE fixes that.
% - IMRESIZE waits a [H W] argument; RESIZEIMAGE respects GLab's convention and waits a [W H]
%   vector.


if iscell(I)
    % Cell array: Recursive call for each image
    for i = 1 : numel(I)
        I{i} = resizeimage(I{i},varargin{:});  %  <-- RECURSIVE CALL !!!
    end
    
else
    % [h w] -> [w h]
    if numel(varargin{1}) == 2, 
        varargin{1} = varargin{1}([2 1]);
    end
    
    % Resize
    I = imresize(I,varargin{:});
    
    % Fix out of range bug in imresize
    switch class(I)
        case 'logical'
            range = [0 1];
        case 'uint8'
            range = [0 255];
        case 'uint16'
            range = [0  65535];
        case 'double'
            if any(I >= 2)
                range = [0 255];
            else
                range = [0 1]; % Default case
            end
    end
    I = fitrange(I,range);
    
end
