function dispbox(str,d,h,v)
% DISPBOX  Display string like a title, with a frame around.
%    DISPBOX(str,d,h,v)
%
% Ben, June 2010.

if nargin < 2
    d = 20;
    h = 6;
    v = 1;
end

%% Input arg -> 'STR' matrix
if ischar(str)
    STR = str;
elseif iscell(str)
    str = str(:);
    % Find longest string:
    n = 0;
    for i = 1 : numel(str)
        n = max([n,length(str{i})]);
    end
    % Add blanks to each string to reach a length of n:
    for i = 1 : numel(str)
        head = blanks(floor(n - length(str{i}) / 2));
        tail = blanks( ceil(n - length(str{i}) / 2));
        str{i} = [head str{i} tail];
    end
    % cell -> matrix:
    STR = cell2mat(str);
else
    error('Invalid argument.')
end

%% Add...
head = repmat(' ',size(STR,1),h);
tail = head;
STR = [head STR tail];

top = repmat(' ',v,size(STR,2));
bot = top;
STR = [top; STR; bot];

STR(1,:) = '¯';
STR(end,:) = '_';
STR(:,[1 end]) = '|';

head = repmat(' ',size(STR,1),d);
STR = [head STR];

%% Dispay final matrix
disp(STR)