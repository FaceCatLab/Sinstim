% VECTSTRUCT2CELL  Convert vectors of structures to cell array.
%    C = VECTSTRUCT2CELL(S)
%
%    [C,CLASSES] = VECTSTRUCT2CELL(S)

function [c,fieldclass] = vectstruct2cell(s)

% leaves
[leaves,sz,fieldclass] = fieldstree(s);

% Get # of rows
m = length(s); % # rows, without titles row
n = length(leaves); % # columns

% s -> c
c = cell(m,n);
for i = 1 : m
    for j = 1 : n
        c{i,j} = eval(['s(i).' leaves{j}]);
    end
end

% Add titles row
c = [leaves'; c];