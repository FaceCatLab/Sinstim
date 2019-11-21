function Seq = randpattern(Values,Pattern,N)
% RANDPATTERN  Random order with a repeated pattern.
%    Seq = RANDPATTERN(Values,Pattern,N)  returns the 1-by-N vector 'Seq', with values given by 
%    'Values', in random order given by the repetition of Pattern (see example below).
%    
% Example:
%    seq = randpattern(1:20,'ABCDDD',100)  % will repeat the pattern 3 different random element,
%                                          % then 3 times the same random element.
%
% Ben, Oct 2009.

% v1.0

Letters = unique(Pattern);
Seq = [];

for p = 1 : ceil(N / length(Pattern))  % Loop once per pattern repetition. (Index of pattern)
    if p == 1,  valids = Values;
    else        valids = setdiff(Values,Seq(end));
    end
    randvalids = valids(randperm(length(valids)));
    add = zeros(1,length(Pattern));
    for l = 1 : length(Letters)  % Loop once for each different letter in pattern
        add(Pattern == Letters(l)) = randvalids(l);
    end
    Seq = [Seq add];
end