function [i,j] = mask2ij(L,dim)
% MASK2IJ <DOES NOT WORK !!!>
%    [i,j] = MASK2IJ(MASK <,dim>)

L = logical(L);

m = size(L,1);
n = size(L,2);

% L -> i
I = repmat((1:m)',1,n);
i = I(L);

% L -> j
J = repmat(1:n,m,1);
j = J(L);

% Output
if nargin >= 2 && dim == 2
    i = j;
end