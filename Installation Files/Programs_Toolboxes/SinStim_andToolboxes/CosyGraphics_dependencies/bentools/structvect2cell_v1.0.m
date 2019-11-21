% STRUCTVECT2CELL  Convert structure of vectors to cell array.
%    C = STRUCTVECT2CELL(S)
%    C = STRUCTVECT2CELL(S)'
%
%    C = STRUCTVECT2CELL(S,M)  
%
%¨See also DISPTABLE, STRUCTVECT2CELL, CELL2VECTSTRUCT, STRUCTVECT2VECTSTRUCT.
%
% Ben, Feb 2010.

function c = structvect2cell(s,m)

% Check s
if ~isstruct(s) || length(s) ~= 1
    error('Invalid input argument. Input structure must be a 1-by-1 structure.')
end

% fields
fields = fieldnames(s);

% Remove fields containing invalid arrays
if exist('m','var')
    for f = length(fields) : -1 : 1
        sz = size(s.(fields{f}));
        if ~any(sz == m) % Invalid dimensions..
            fields(f) = []; % ..remove it
        elseif sz(1) > 1 && sz(2) == m % "Horizontal" matrix.. (M-by-x matrices are valid; x-by-M are not)
            fields(f) = []; % ..remove it
        elseif all(sz == [1 m]) % Horizontal vector..
            s.(fields{f}) = s.(fields{f})'; % ..make it vertical
        end
    end
end

% m, n
n = length(fields); % # columns
if ~exist('m','var')
    m = length(s.(fields{1})); % # rows in table (NOT counting the label row of the final cell)
end

% s -> c
c = cell(m,n);
for j = 1 : n
    for i = 1 : m
        c{i,j} = s.(fields{j})(i,:);
    end
end

% Add labels row
c = [fields'; c];

% % fields
% fields = fieldnames(s);
% 
% % m, n
% n = length(fields); % # columns
% if ~exist('m','var')
%     m = length(s.(fields{1})); % # rows in table (NOT counting the label row of the final cell)
% end
% 
% % s -> c
% c = cell(m,n);
% for j = 1 : n
%     for i = 1 : m
%         c{i,j} = s.(fields{j})(i);
%     end
% end
% 
% % Add labels row
% c = [fields'; c];