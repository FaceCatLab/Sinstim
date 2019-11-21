function showimagediff(A,B,contrast)
% SHOWIMAGEDIFF  Pixel per pixel difference of two images.
%    SHOWIMAGEDIFF(A,B)  shows B - A, channel by channel. Positive values are
%    lighter, negative values are darker. A and B be can be image matrices or 
%    image file names.
%
%    SHOWIMAGEDIFF(A,B,contrast)  multiplies difference by a contrast value.
%    
%       Examples: 
%       showimagediff(A,B,128)  shows differences in 3 colors: white is +,
%       black is -, grey is no diff.
%
%       showimagediff(A,B,1)    is the same than the default.
%
%       showimagediff(A,B,0.5)  scales to the whole range of possible values. 

%% Input Args
if ischar(A), A = loadimage(A); end
if ischar(B), B = loadimage(B); end
A = stdrgb(A);
B = stdrgb(B);
if nargin < 3, contrast = 1; end

%% Compute Difference
D = 0.5 + (B - A) * contrast;
D = fitrange(D,[0 1]);

%% Display it
showrgb(D);