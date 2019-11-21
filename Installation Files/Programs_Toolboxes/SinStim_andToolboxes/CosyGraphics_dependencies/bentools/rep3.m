function M3 = rep3(M,k)
% CAT3   Repeat matrix in the third dimension.
%    M3 = CAT3(M,k)  repeats matrix M, k times, in the third dimension.
%
%    M3 = CAT3(M)  is the same as  M3 = CAT3(M,3)


if nargin < 2, k = 3; end

% s1
s1 = 'cat(3,';

% s2, repeat:  M,
%              12
s2 = repmat(' ',1,2*k-1);
s2(1:2:end) = 'M';
s2(2:2:end) = ',';

% s3
s3 = ');';

% eval!
M3 = eval([s1,s2,s3]);