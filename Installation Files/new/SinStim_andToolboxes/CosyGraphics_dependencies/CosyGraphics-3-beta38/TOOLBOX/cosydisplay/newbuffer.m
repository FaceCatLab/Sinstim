function b = newbuffer(varargin)
% NEWBUFFER  Create a drawable offscreen buffer. {slow}
%	 b = NEWBUFFER  creates a buffer of the same size than the screen and returns it's handle.
%
%	 b = NEWBUFFER([w h])  creates a buffer of width w and heigth h. Use NEWBUFFER(IMAGESIZE(I))
%    to create a buffer of the size of image I.
%
%	 b = NEWBUFFER(...,[r g b])  creates a buffer with given background color. (Otherwise, 
%    default background color will be used. See SETBACKGROUND.)  [r g b a] vectors are not
%    supported.
%
%    b = NEWBUFFER(I)  <???> creates a buffer of the size of image I, then store I in it with STOREIMAGE.
%
%    NEWBUFFER(b,...)  <CG only> creates a new buffer of handle b. (If a buffer with the same handle 
%    already exists, it will be deleted.)
%
% Example 1: How to prepare a buffer of the same size than the screen (ready to be displayed).
%    I = loadimage(filename);  % Get image matrix from file.
%    b = newbuffer([1 1 1]);   % Create a buffer of the size of the screen, with white background.
%    storeimage(I,b);          % Copy image I in the buffer. Image will be centered.
%
% Example 2: How to store a image in a buffer that fit the image size.
%    b = newbuffer(I);   % Create a buffer, then copy image I in it. Buffer has the size of the image.
%
% See also STOREIMAGE, CLEARBUFFER, DELETEBUFFER, RESIZEBUFFER, COPYBUFFER, READBUFFER, 
%          DISPLAYBUFFER, ISBUFFER, GCB, SETBACKGROUND, IMAGESIZE.
%
% Ben, 	Sept-Oct 2007

% 		10 dec			Fix NEWBUFFER(I) (didn't work)
%       11 dec			Fix NEWBUFFER(I) for grayscale images
%		28 mar 2008 	Suppr. 'cogent' global var.


global COSY_DISPLAY


%% INPUT ARGS
% Case: First arg. is the buffer handle
if ~isempty(varargin) && length(varargin{1}) == 1
	b = varargin{1};
	if ismember(COSY_DISPLAY.BUFFERS.OffscreenBuffers,b)
		deletebuffer(b)
		warning(['NEWBUFFER WARNING: Buffer ' num2str(b) ' already exists. Old b has been deleted.'])
	end
	varargin(1) = [];
end

% Case : Arg. is an image matrix
if ~isempty(varargin) && size(varargin{1},1) > 1 && size(varargin{1},2) > 1 % NB: ndims returns 2 for row vect.
	I = varargin{1};
	if exist('b','var'), newbuffer(b,imagesize(I));
    else                 b = newbuffer(imagesize(I));
	end
	storeimage(I,b);
	return % <---- !!!
end

% Case: Last arg. is a color vector
if ~isempty(varargin) && length(varargin{end}) == 3     
	color = varargin{end};
    if length(color) == 4
        stopcosy;
        error('[r g b a] vectors are not supported.')
    end
	varargin(end) = [];
else
	color = COSY_DISPLAY.BackgroundColor;
end

% Width & Heigth
switch length(varargin)
	case 0
		[w,h] = getscreenres;
	case 1
		w = varargin{1}(1);
		h = varargin{1}(2);
end


%% DEFINE HANDLE (CG only)
if iscog
    % Valid values are 1 to 10000, but we reduce it to 11:10000 for
    % consistency with PTB. Take the first non attributed valid value.
    if ~exist('b','var')
        free = setdiff(11:10000,COSY_DISPLAY.BUFFERS.OffscreenBuffers);
        b = free(1);
    end
end


%% CREATE BUFFER !
if iscog
    cgmakesprite(b,w,h,color(1),color(2),color(3));
    COSY_DISPLAY.BUFFERS.isFloat(end+1) = 0;
else
    %%%%%%%%%%%%%%%%%%%%%%
    isFloatPrecision = 0; % <v2-beta39> <TODO: Review this!!>
    %%%%%%%%%%%%%%%%%%%%%%
    b = Screen('OpenOffscreenWindow',gcw,round(color*255),[0 0 w h]);
    COSY_DISPLAY.BUFFERS.isFloat(end+1) = isFloatPrecision;
end
COSY_DISPLAY.BUFFERS.OffscreenBuffers(end+1) = b;
COSY_DISPLAY.BUFFERS.isTexture(end+1) = 0;

selectbuffer(b) % make it current buffer