function t = isfilledfield(S,fieldname)
% ISFILLEDFIELD  True if field exists and is not empty.
%    t = isfilledfield(S,fieldname)  returns 1 if field exists and is not empty, 0 otherwise.

t = isfield(S,fieldname) && ~isempty(getfield(S,fieldname));
