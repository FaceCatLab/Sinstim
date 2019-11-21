function b = storeimage(I,b,x,y)
% STOREIMAGE   Store image matrix in offscreen buffer. (Slow!)
%   b = STOREIMAGE(I)  creates an offscreen buffer, stores image I in it and
%   returns the buffer handle, b. I is an M-by-N-by-3 matrix in the range 0 to 1
%   (as returned by LOADIMAGE), or a cell array (1D or 2D) of such matrices.
%   On PTB, the created buffer will be optimized for fast drawing of the stored
%   image and performances will be significativelly better than with a buffer
%   created first with NEWBUFFER or NEWBUFFER(IMAGESIZE(I)). On the other hand, 
%   to draw into the buffer will be slower. (Technically, STOREIMAGE(I) creates
%   a texture, while NEWBUFFER creates an offscreen window.)
%
% <TODO: What to do whith the following syntaxes ?>
%	STOREIMAGE(I,b)  copies image I in an existing buffer b.
%   On PTB, in this case the already existing buffer will not be optimized. In 
%   most case, avoid this syntax: It can be usefull if you have a lot of things
%   to draw fastly *into* buffer b, but it'll be slower to copy data *from* b
%   to another buffer.
%
%	STOREIMAGE(I,b,[x y])  copies image I in buffer b with an x, y offset.
%   PTB: same remark as above.
%
% Deprecated syntax:
%   STOREIMAGE(I,b,x,y)
%
% See also LOADIMAGE, NEWBUFFER, COPYBUFFER.

% Ben,	Sept 2007.  This is a modified version of preparepict (Cogent2000).
%       Oct 2008    PTB


%% PTB Doc: (http://psychtoolbox.org/wikka.php?wakka=FaqTextureWindow)
% Now the longish but detailed explanation for textures vs. offscreen windows
% 
% PTB-Textures and Offscreen windows are nearly the same. Both are OpenGL textures internally and treated the same by all texture related functions, that's why you can pass a texture handle into 'CopyWindow' or an offscreen window handle into 'DrawTexture'. The only difference is in their creation and initialization. One can create OpenGL textures in many different formats, optimized for different purposes. PTB initially creates a texture in a format that is optimized for the typical purpose of the texture, given the function you used to create it, trying to maximize speed and minimize memory consumption for a given purpose. If PTB discovers that the current format of a OpenGL texture is not suitable for an operation, it (should) convert it into a suitable format on-the-fly.
% 
% Conversion is (sometimes) an expensive operation, so its best to create a texture in a way that best matches its later usage to avoid the conversion step.
% 
% Examples:
% 
% Screen('MakeTexture'): PTB assumes the texture is usually only used for drawing it quickly, not drawing into it: The texture is created as either a luminance, or RGBA texture, depending if the Matlab input matrix is a grayscale (1 layer, 2D) matrix or something bigger (> 1 layers, 3D). Image data is stored in Matlabs column major order, reducing the execution time of 'MakeTexture' by up to a factor of 10. Storage is 8 bits per color or luminance component. There are optional flags to 'MakeTexture' to create textures of different formats, e.g., high dynamic range textures with 16 bit or 32bit floating point precision per color component.
% 
% -> Fast creation, minimal memory usage, fast drawing and copying.
% -> When you try to draw into it the first time or apply an image processing operation, PTB will reformat the texture to OpenGL row-major image format and convert pure luminance textures into RGBA textures to make them suitable as rendertargets. Expensive, depending on the size and format of the texture and your gfx-hardware.
% 
% Textures from Quicktime movie playback Screen('GetMovieImage') or video capture engine Screen('GetCapturedImage'): They are created as luminace, RGB or YUV textures (the latter one is optimized for typical video data, used by some movie file formats for better compression). The images are sometimes (some movie formats) upside down. Resolution always 8 bits per component.
% 
% -> Optimized for fast creation, fast drawing copying.
% -> When drawing into them, PTB applies conversion (flipping upside if needed, converting luminance and YUV to RGB if needed).
% 
% Screen('OpenOffscreenWindow'): This "textures" are always meant for drawing into them, therefore they are always created in a suitable format with RGBA channels of either 8bpc precision or - at request- 16 bpc or 32bpc floating point precision. They are always formatted in OpenGL's image layout (row major) and filled with their background color by a routine that is optimized for that.
% 
% -> Optimized for fast filling with background color, fast drawing, fast copy, fast image processing, drawing into them. Never a need to apply any conversions.
% -> Filling them with Matlab image matrices via the slow 'PutImage' would be drastically slower than using 'MakeTexture'.
% 
% Textures created/injected via Screen('SetOpenGLTexture') or Screen('SetOpenGLTextureFromMempointer'): No conversion or optimization, PTB assumes the user of these functions to be an expert, wrong usage will lead to error or crash.
%  
% So when only drawing into a texture, start off with an offscreen window, when only drawing it, start with maketexture, when you need to do both, try both alternatives, depends on the gfx-hardware and cpu which method is faster for your case.
% 
% Btw. "expensive" on modern graphics hardware means something like 1 - 5 msecs, not 20-100 msecs, so expensive is a pretty relative term. 


global GLAB_BUFFERS GLAB_DISPLAY

%% Check display is open
if isempty(GLAB_DISPLAY) || ~GLAB_DISPLAY.isDisplay
    error('No display initialized. Use STARTCOGENT or STARTPSYCH before STORIMAGE.')
end

%% Recursive call if I is a cell array of image matrices
if iscell(I)
    if nargin == 1
        m = size(I,1);
        n = size(I,2);
        b = zeros(m,n);
        for j = 1 : n
            for i = 1 : m
                b(i,j) = storeimage(I{i,j}); % <--- RECURSIVE CALL !
            end
        end
        return % -------- !!!
    else
        error('Cell array not supported if more than one argument.')
    end
end
           
%% Input Args
if nargin < 3       %	STOREIMAGE(I,b,[x y])
	y = 0;
	x = 0;
elseif nargin == 3  %	STOREIMAGE(I,b,x,y) <deprecated>
	y = x(2);
	x = x(1);
end

%% Check format
I = double(I);                             % uint8 --> double
if max(I(:)) > 1, I = I ./ 255; end        % 0-255 --> 0-1

%% Check that buffer is large enough
if nargin >= 2
    [iw ih] = imagesize(I);
    [bw bh] = buffersize(b);
    if bw < iw | bh < ih
        error(['Buffer is to small.' char(10) ...
                'you stried to store an ' int2str(iw) 'x' int2str(ih) ...
                ' in a ' int2str(bw) 'x' int2str(bh) ' buffer.']);
    end
end

%% Store Image
if iscog % CG
    if ndims(I) == 2, I = cat(3,I,I,I); end % MxNx1 --> MxNx3
    
    % Create buffer if needed
    if nargin < 2
        b = newbuffer(imagesize(I));
    end
    
    % Matlab image matrix (MxNx3) -> "PixVal" matrix ([M*N]x3) needed by cgloadarray
    m = size(I,2);
    n = size(I,1);
    pixval = zeros( m*n , 3 );
    pixval(:,1) = reshape( I(:,:,1)', m*n, 1 );
    pixval(:,2) = reshape( I(:,:,2)', m*n, 1 );
    pixval(:,3) = reshape( I(:,:,3)', m*n, 1 );
    
    % Load matrix in video-ram buffer
    tmp_buff = 9999;
    cgloadarray(tmp_buff,m,n,pixval);
    cgsetsprite(b);
    cgdrawsprite(tmp_buff,x,y);
    cgfreesprite(tmp_buff);
    
else % PTB
    if nargin == 1
        I = I * 255; % <faster when not using round()>
        b = Screen('MakeTexture',gcw,I); % <todo: textureOrientation ??>
%         Screen('PreloadTextures',gcw,b); % <TODO: really needed ?>
        GLAB_BUFFERS.OffscreenBuffers(end+1) = b;
        GLAB_BUFFERS.isTexture(end+1) = 1;
    else
        error('Case not yet implemented') 
        % ... <TODO>
    end
    
end