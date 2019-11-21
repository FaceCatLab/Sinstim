function y = sigmoid(x, s, x0, y0)
% SIGMOID  Sigmoid function.
%    y = SIGMOID(x, s, x0)  computes the the sigmoid function:
%
%                            1
%           f(x) = ------------------------
%                   1 + exp(-(x0 - x) / s)
%
%    where x is the abscisse vector, x0 is the position of the inflexion point (y=0.50)
%    and s is the slope of the sinusoid.
%
%    y = SIGMOID(x, s, x0, y0)  x0 is the position where y=y0, instead of the position of 
%    the inflexion point.
%
% Ben, March 2011.


y = 1 ./ ( 1 + exp(-(x-x0) ./ s) );

if exist('y0','var') && y0 ~= 0.5
    ii = find(y >= y0);
    i2 = ii(1);
    x2 = x(i2);
    delta = x2 - x0;
    
    y = sigmoid(x, s, x0 - delta);
    
end