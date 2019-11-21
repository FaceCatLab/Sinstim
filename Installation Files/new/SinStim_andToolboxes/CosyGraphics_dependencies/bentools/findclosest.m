function i = findclosest(v,x)
% i = findclosest(v,x)  Find in vector v the value closest to x.
%                       If there are more than one, only the first is returned.


v = v(:);
delta = abs(v - x);
i = find(delta == min(delta));
i = i(1);
