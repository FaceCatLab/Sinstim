function b = isazero(a)
% ISAZERO  True for a 0.
%    ISAZERO(A)   returns true if A is a numeric or logical scalar of value 0 and false otherwise.
%
% Ben, June 2010.

b = (isnumeric(a) || islogical(a)) && numel(a) == 1 && a == 0;
