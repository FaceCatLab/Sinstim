function [c,fieldclass] = structvect2cell(s, varargin)
% STRUCTVECT2CELL  Convert structure of vectors to cell array.
%    C = STRUCTVECT2CELL(S)  where S is a scalar structure whose fields contain vectors, converts S
%    to a cell array C.  The first row of C contains S's field names (intepreted as column labels),
%    while it's columns -from 2 to end- contain the corresponding field content.
%
%    C = STRUCTVECT2CELL(S)'  to get a row table.
%
%    C = STRUCTVECT2CELL(S,nRows)  
%
%    [C,CLASSES] = STRUCTVECT2CELL(...)  returns also class of each (sub-)field as a cell array
%    of strings.
%
%    STRUCTVECT2CELL(...,'-s')  or  STRUCTVECT2CELL(...,'-silent')  does not print warnings when 
%    invalid fields are encoutered (delete them silently).
%
%¨See also DISPTABLE, STRUCTVECT2CELL, CELL2VECTSTRUCT, STRUCTVECT2VECTSTRUCT.
%
% Ben, Feb 2010.

%% Input Args
isVerbose = 1; % verbose by default
if nargin > 1
    isOpt = isoption(varargin);
    if ~isOpt(1)
        nRows = varargin{1};
    end
    if isOpt(end)
        isVerbose = 0;
    end
end

%% Check s
if ~isstruct(s) || length(s) > 1
    error('Invalid input argument. Input must be a 1-by-1 structure.')
end

%% Special case: Empty struct
if isempty(fieldnames(s))
    c = {};
    fieldclass = {};
    return  %                                             <========== RETURN !!!
end

%% leaves
[leaves,sz,fieldclass] = fieldstree(s);
for i = 1 : length(leaves)
    leaves{i} = ['s.' leaves{i}];
end

%% Get # of rows <TODO: Rewrite using 'sz' var above>
if ~exist('nRows','var')
    sizes = zeros(length(leaves),2);
    chars = false(length(leaves),1);
    for f = 1 : length(leaves),
        try   
            leaf = eval(leaves{f});
            sizes(f,:) = size(leaf);
            chars(f) = ischar(leaf);
        catch
            % do nothing: same try/catch below
        end
    end

    no = (sizes(:,1) .* sizes(:,2) == 0) & ...
         (sizes(:,1) .* sizes(:,2) == 1);
    sizes(no,:) = [];
    chars(no) = [];
    nRows = -1;
    % 1) find a non-char vector (either vert. or horiz.)
    ok = ~chars & xor(sizes(:,1)==1,sizes(:,2)==1);
    if any(ok)
        iok = find(ok);
        nRows = max(sizes(iok(1),:));
    end
    % Case of only one row: No vector found => Search scalars <8-Mar-2011>
    if nRows < 0 && any(~chars & sizes(:,1)==1 & sizes(:,2)==1)
        nRows = 1;
    end
    % 2) only char vectors:
    if nRows < 0
        if any(chars)
            sz = sizes(chars,:);
            sz = sz(:);
            sz(sz==1) = [];
            nRows = median(sz);
        end
    end
    % 3) not found
    if nRows < 0
        error('Invonsistent data in strucure fields. Cannot find nRows.')
    end
end

%% Check validity of each leaf
if exist('nRows','var')
    for f = length(leaves) : -1 : 1
        try 
            leaf = eval(leaves{f});
            ok = 1;
        catch
            ok = 0;
        end
        sz = size(leaf);
        if ~ok
            if isVerbose, dispinfo(mfilename,'warning',sprintf('Invalid leaf causes syntax error. Removing %s',leaves{f})), end
            leaves(f) = []; % ..remove it
            fieldclass(f) = [];
        elseif ~any(sz == nRows) % Invalid dimensions..
            if isVerbose, dispinfo(mfilename,'warning',sprintf('Invalid dimension. Removing %s',leaves{f})), end
            leaves(f) = []; % ..remove it
            fieldclass(f) = [];
        elseif sz(1) > 1 && sz(2) == nRows % "Horizontal" matrix.. (M-by-x matrices are valid; x-by-M are not) <TODO: no more support for matrices>
            if isVerbose, dispinfo(mfilename,'warning',sprintf('Invalid (x-by-M) matrix. Removing %s',leaves{f})), end
            leaves(f) = []; % ..remove it
            fieldclass(f) = [];
        elseif all(sz == [1 nRows]) % Horizontal vector..
            eval([leaves{f} '=' leaves{f} ''';']); % ..make it vertical
        end
    end
end

%% nRows, n
n = length(leaves); % # columns
if ~exist('nRows','var')
    nRows = length(eval(leaves{1})); % # rows in table (NOT counting the label row of the final cell)
end

%% s -> c
c = cell(nRows,n);
for j = 1 : n
    v = eval(leaves{j});
    for i = 1 : nRows
        c{i,j} = v(i,:);
    end
end

%% Add labels row
for i = 1 : length(leaves)
    leaves{i}(1:2) = []; % remove 's.'
end
c = [leaves'; c];
