function resizebuffer(buffer,sz)
% RESIZEBUFFER  Change the size of an offscreen buffer. {slow}
%    RESIZEBUFFER(buff,[w h])  Change size to width w and height h.
%    RESIZEBUFFER(buff,IMAGESIZE(I))  Give the same size than image I.
%
% See also NEWBUFFER, BUFFERSIZE, IMAGESIZE.
%
% Ben, Sept 2007

%    RESIZEBUFFER(buffer,size(I))  Give the buffer the same size than I. I is
%       an M-by-N-by-3 image matrix created by I = LOADIMAGE(filename).
%       Deprecated. Don't use it.

global COSY_DISPLAY

if ~ismember(buffer,COSY_DISPLAY.BUFFERS.OffscreenBuffers)
	error(['Buffer ' numstr(buffer) ' does not exist.'])
end
% if length(size == 3) && size(3) == 3
% 	sz = size([2 1]);
% end

deletebuffer(buffer)
newbuffer(buffer,sz);