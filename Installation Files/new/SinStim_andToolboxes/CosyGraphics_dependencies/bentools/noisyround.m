function X = noisyround(X)
% NOISYROUND  Round following the noisy-bit method.
%    NOISYROUND(X)  rounds the elements of X following the "noisy-bit method":
%    let's be x an arbitrary element of X, x has a probability of (x - fix(x)) to be 
%    rounded toward infinity (of same sign than x) and a probability of 1 - (x - fix(x))
%    to be rounded toward zero.
%
%    See "<GLab folder>\MiscDocumentation\The noisy bit method.pdf" about the noisy-
%    bit method.
%
% Example:
%    noisyround(12.72)  will return 13 in 72% of the cases and 12 in 28%.
%    
% Ben, May 2011.

D = X - fix(X);
isUp = D > rand(size(X));
isUp = isUp(:);

X(isUp)  = ceil(X(isUp));
X(~isUp) = floor(X(~isUp));