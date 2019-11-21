function Seq = randpattern(Values,Pattern,N)
% RANDPATTERN  Random order with a repeated pattern.
%    Seq = RANDPATTERN(Values, Pattern, N)  returns the 1-by-N vector 'Seq', with values given by 
%    'Values', in random order given by the repetition of Pattern (see below).
%
% The 'Pattern' vector:
%    - Lower-case characters stands for variable random elements.  Values will be choosen randomly 
%      at each repetition of the pattern.  The first value af a pattern repetition cannot be the same
%      than the last value of the previous repetition.
%      Valid characters are: abcdefghijklmnopqrstuvwxyzàáâãäåæçèéêëìíîïğñòóôõöøùúûüışÿ
%
%    - Upper-case characters stands for constant random elements.  Values are picked randomly once for
%      all, and remain the same for all repetions of the pattern.
%      Valid characters are: ABCDEFGHIJKLMNOPQRSTUVWXYZÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖØÙÚÛÜİŞ
%
%    - Digits characters define non-random elements.  E.g.: '1' stands for Values(1).
%      Valid characters are: 1234567890¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿ , '0' representing the number 
%      10, and special characters 161 ('¡') to 191 ('¿') representing numbers 11 to 41.  Numbers 
%      above 41 cannot be represented.
%
%    - Parenthesis can be used to indicate repetitions of the preceding character.
%      For example: 'abc(3)d' is the same than 'abcccd', while 'abc(1:3)d' will repeat 'c' between one
%      and three times at each pattern repetition.
%    
% Examples:
%    seq = randpattern(1:20,'abcddd',100)  % will repeat the pattern 3 different random element,
%    % then 3 times the same random element. Values for a, b, c and d are standing for will be
%    % choosen randomly at each repetition of the pattern.
%
%    seq = randpattern(1:20,'abcDDD',100)  % will first determine randomly once for all the value
%    % for D. This value will stay the same in all repetitions of the pattern.
%
%    seq = randpattern(11:20,'abc111',100)  % will repeat 3 times an 11 in each repetition of the pattern.
%
%    seq = randpattern(1:20,'abc(1:3)d',100)  % will repeat 'c' between one and three times at each 
%    % pattern repetition.
%
%    seq = randpattern(1:20,'12¡',100)  % will repeat 1, 2, 11, 1, 2, 11, 1, 2, 11,...
%
% Ben Jacob, Oct 2009. (From an idea of Ernesto Palermo.)
%            May 2011: Review digits chars. 

%% Input Args
isChar = ischar(Values);

%% Character Repetitions: "()"
i0 = find(Pattern == '(');
i1 = find(Pattern == ')');
betweenpar = false(size(Pattern));
for p = 1 : length(i0)
    betweenpar(i0(p):i1(p)) = true;
end
iOut = find(~betweenpar);
isRepet = false(1,sum(~betweenpar));
Repetitions = {};
for c = 1 : sum(~betweenpar)
    i = iOut(c);
    if i < length(Pattern) && Pattern(i+1) == '('
        isRepet(c) = true;
        f = find(i0 == i+1);
        Repetitions{c} = eval(Pattern(i0(f)+1:i1(f)-1));
    else
        Repetitions{c} = 1;
    end
end
Pattern(betweenpar) = [];

%% Init vars
Digits = ['1234567890' char(161:191)];
Uppers = 'ABCDEFGHIJKLMNOPQRSTUVWXYZÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖØÙÚÛÜİŞ';
Lowers = 'abcdefghijklmnopqrstuvwxyzàáâãäåæçèéêëìíîïğñòóôõöøùúûüışÿ';
Uniques = unique(Pattern);
if numel(Uniques) > numel(Values)
    error(sprintf('To many different characters in pattern: %d pattern characters for only %d values.',numel(Uniques),numel(Values)))
end
bad = ~ismember(Uniques,[Uppers Lowers Digits]);
if any(bad)
    error(['invalid character(s) in pattern: ''' Uniques(bad) ''''])
end
Constants = zeros(size(Uniques));
Seq = [];

%% Digits pattern characters: User selected elements
isDigit = ismember(Uniques,Digits);
keep = true(size(Values));
for i = find(isDigit)
    Constants(i) = find(Digits == Uniques(i)); % <07-nov-2011: Fix digits > 9> 
    dig = Uniques(i);
    num = find(Digits == dig);
    Constants(i) = Values(num); % Assign value definitively
    keep(num) = 0;
end
Values = Values(keep); % Remove value from 'Value' vector

%% Uppercase pattern letters: Constant elements
Values = Values(randperm(numel(Values)));
isUpper = ismember(Uniques,Uppers);
for i = find(isUpper)
    Constants(i) = Values(1); % Assign value definitively
    Values(1) = []; % Remove value from 'Value' vector
end

isConstant = isDigit | isUpper;
    
%% Get random sequence
for p = 1 : ceil(N / length(Pattern))  % Loop once per pattern repetition. (Index of pattern)
    if p > 1 && ismember(Pattern(1),Lowers)
        valids = setdiff(Values,Seq(end));
    else
        valids = Values;
    end
    randvalids = valids(randperm(length(valids)));
    new = zeros(1,length(Pattern));
    for c = 1 : length(Uniques)  % Loop once for each unique character in pattern
        if isConstant(c),   new(Pattern == Uniques(c)) = Constants(c);
        else                new(Pattern == Uniques(c)) = randvalids(c);
        end
    end
    for c = length(Pattern) : -1 : 1  % Loop once per char in pattern.
        if isRepet(c)
            r = Repetitions{c}(randperm(length(Repetitions{c})));
            r = r(1);
            new = [new(1:c-1) repmat(new(c),1,r) new(c+1:end)];
        end
    end
    Seq = [Seq new];
end
Seq = Seq(1:N);
if isChar
    Seq = char(Seq); 
end