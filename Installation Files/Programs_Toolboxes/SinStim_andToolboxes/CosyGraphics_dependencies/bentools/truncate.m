function M = truncate(M,range)
% TRUNCATE  Truncate values below min. and above max.
%    B = TRUNCATE(A,range)  trucates values in matrix A at min. and max. given 
%       by the 'range' vector. 'range' is a vector of the form [min max].
%
% Ben, Oct. 2007

for k = 1 : size(M,3)
	f = find(M < range(1));
	M(f) = range(1);
	f = find(M > range(2));
	M(f) = range(2);
end
	