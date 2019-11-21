function seq = randele(values,N,delta)
% RANDELE  Random sequence of elements.
%    ele = RANDELE(values)  returns one random elements of the vector 'values'.
%
%    seq = RANDELE(values,N)  returns N random elements in a vector 'seq'.
%
%    seq = RANDELE(values,N,delta)  imposes a minimum of delta elements between
%    two occurences of any given element.


% Input Arg
if nargin < 2, N = 1; end
if nargin < 3, delta = 0; end
% For backward compat.:
if nargin == 3 && strcmpi(delta,'MustChange'), delta = 1; end

% Init Var
seq = zeros(1,N);

% Get Sequence
for e = 1 : N
    e0 = max([1; e-delta]);
    avoid = seq(e0:e-1);
    
	possib = values;
    for a = 1 : length(avoid) % Fix: don't use setdiff, because it suppress repetitive occurences.
        possib(possib == avoid(a)) = [];
    end
	ii = randperm(length(possib));
	i = ii(1);
	seq(e) = possib(i);
end

% Output Arg
if ischar(values), seq = char(seq); end