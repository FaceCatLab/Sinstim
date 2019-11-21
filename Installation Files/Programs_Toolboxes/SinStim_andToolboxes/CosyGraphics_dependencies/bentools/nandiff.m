% NANDIFF  Difference ignoring NaNs.
%    NANDIFF(X), for a vector X, is the same than DIFF(X(~ISNAN(X))).
%
% Ben, March 2010.

function y = nandiff(x)

y = diff(x(~isnan(x)));