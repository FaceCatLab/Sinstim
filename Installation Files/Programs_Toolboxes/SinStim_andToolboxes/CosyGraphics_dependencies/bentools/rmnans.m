function v = rmnans(v)
% RMNANS  Remove NaNs from a vector.
%    RMNANS(V)  returns a vector with all non-NaN elements of input vector V.

if sum(size(v) > 1) > 1 % don't use isvector: not supported by Matlab 6.5.
    error('Input argument must be a vector.')
end

v = v(~isnan(v));
