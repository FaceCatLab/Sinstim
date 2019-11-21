function S = findsub(X)
% FINDSUB  Find subscripts of non-zero elements.
%    S = FINDSUB(X)  returns the subscripts corresponding to 
%    the nonzero entries of the array X in matrix S.  S has 
%    one column by dimension of X.
%
% Ben, May 2011.

% <TODO: optim.>


siz = size(X);

switch length(siz)
    case 2
        S = ind2sub(size(X),find(X));
        
    case 3
        % <Note:  ind2sub(size(X),find(X))  does not work for cubic matrices ?!?!?>
        ind = find(X);

        S = zeros(length(ind),length(siz));
        
        S(:,3) = ceil(ind / (siz(2)*siz(1)));
        S(:,2) = ceil(ind / siz(1)) - ((S(:,3)-1)*siz(2));
        S(:,1) = rem(ind,siz(1));
        S(S(:,1)==0, 1) = siz(1);

    otherwise
        error('Matrices of more than 3 dimensions are not supported.')
        
end