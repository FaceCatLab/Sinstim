function A = multiplealpha(W)
% MULTIPLEALPHA  Get alpha values for multiple blendings (more than 2 images superposed).
%    A = MULTIPLEALPHA(W)  Computes alpha values A to be used when blending images to get the
%    relative weigths W (proportion of each source image) in the resulting image. In other
%    words,  multiplealpha([w1; w2; ...; wM])  returns the alpha values to get the graphics
%    card making the job equivalent to  ( w1*I1 + w2*I2 + ... + wM*IM ) / M  in Matlab.
%    A and W are M-by-N matrices, where M is the number of images to be superposed and N is 
%    the number of frames.
%
% Example:
%    multiplealpha([.25; .25; .25; .25])  returns:
%
%           1.0000
%           0.5000
%           0.3333
%           0.2500
%
%    which are the alpha values to be used to superpose 4 images with a same contribution (25%)
%    of each.


m = size(W,1);

A = W;

for i = m : -1 : 1
    for i1 = i+1 : m
        A(i,:) = A(i,:) / (1 - A(i1,:));
    end
end