function A = getbufferalpha(b)
% GETBUFFERALPHA  Get the content of the alpha-channel of a video-buffer. {slow}
%    M = GETBUFFERALPHA(b)  returns the alpha-channel of buffer b in matrix M.
%
% Example:
%    imshow(getbufferalpha(b));  % displays the state of the alpha channel of buffer b in a Matlab figure.

% Ben, Sep 2011.


RGBA = Screen('GetImage', gcw, [], 'backbuffer', 1, 4); 
A = RGBA(:,:,4);
% imshow(A); figure(gcf);