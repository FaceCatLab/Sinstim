function storewhitenoise(duration,b)
% STOREWHITENOISE  Fill sound buffer with white noise of specified duration.
%    STOREWHITENOISE(duration,b)  fills sound buffer b with white noise of specified duration in
%    milliseconds.
%
% Example:
%    storewhitenoise(1000,1);  % prepares 1000 milliseconds of white noise in buffer 1.
%
% See also: SINEWAVE, STORESOUND, STORETUUT.

global cogent;

n = floor( cogent.sound.frequency * duration / 1000 ); 
y = 2 * rand(n,1) - 1; 
% y = y * .01;

storesound(y,b);