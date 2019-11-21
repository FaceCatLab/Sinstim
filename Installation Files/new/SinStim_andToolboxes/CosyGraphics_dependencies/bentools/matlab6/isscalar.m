function b = isscalar(s)
% ISSCALAR True if array is a scalar.
%     This is a Matlab6 replacement of the Matlab7 built-in function.
%
%     ISSCALAR(S) returns logical true (1) if S is a 1 x 1 matrix
%     and logical false (0) otherwise.
%  
%     See also isvector, isnumeric, islogical, ischar, isempty.
% 
%     Overloaded methods:
%        dfilt.isscalar
%        categorical/isscalar
% 
%     Reference page in Help browser
%        doc isscalar

b = numel(s) == 1 && all(size(s) == [1 1]);