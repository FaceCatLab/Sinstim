function n = randevent(p)
% RANDEVENT   Random selection of events with differents probabilities.
%    N = RANDEVENT(P)  Picks randomly the Nth event, given probabilities defined by vector P.
%
% Examples:
%    N = randevent([.5 .25 .25])  has 50% chances to return 1, 25% to return 2 and 25% to return 3.
%
%    N = randevent([.5 .25])  is the same.
%
% See also: RAND, RANDELE.
%
% Ben, Feb 2009.

p = p(:);

if sum(p) < 1
    p(end+1) = 1 - sum(p);
elseif sum(p) > 1 + 1e-12 % + 1e-12 to avoid rounding errors
    error('Sum of probabilities > 1.')
end
   
sums = p;
for i = 2 : length(p)
    sums(i) = sums(i-1) + sums(i);
end

f = find(sums >= rand);
n = f(1);