function disptable(s,varargin)
% DISPTABLE(S)  Display structure of vectors as a table.
%    DISPTABLE(S)  displays S, fields names becoming column labels.
%
%    DISPTABLE(S, '-H') or DISPTABLEH(S) displays table horizontally.
%    DISPTABLE(S, '-V') is the same than DISPTABLE(S).
%
%    DISPTABLE(..., '-MEAN')  adds a row (a column if -h) for column (a row if -h) means.
%    DISPTABLE(..., '-MEDIAN')  id.; adds median.
%    DISPTABLE(..., '-STD')  id.; adds median.
%    DISPTABLE(..., '-TOTAL')  id.; adds total.
%
% See also DISPTABLEH.
%
% Ben, Feb 2010.


%%%%%%%%%%%%%%%
nBlanks = 4;
%%%%%%%%%%%%%%%


%% Input Args
orientation = 'v';
isMean = 0;
isMedian = 0;
isStd = 0;
isTotal = 0;
for i = 1 : length(varargin)
    switch lower(varargin{i})
        case {'-h','h'},    orientation = 'h';
        case '-mean',       isMean = 1;
        case '-median',     isMedian = 1;
        case '-std',        isStd = 1;
        case '-total',      isTotal = 1;
    end
end


%% struct -> cell
if length(s) > 1,   [c,classes] = vectstruct2cell(s);
else                [c,classes] = structvect2cell(s,'-silent');
end


%% Modify cell
% Multi-lines strings
for k = 1 : numel(c)
    if ischar(c{k})
        if any(c{k}(:) == 10) || size(c{k},1) > 1; % if multi-lines..
            c{k} = sprintf('[%dx%d char]', size(c{k},1), size(c{k},2));
        end
    end
end

% Add column #
m = size(c,1);
n = size(c,2);
c = [[{[]}; num2cell(1:m-1)'] c];

% Options
nOptionRows = isMean + isMedian + isStd + isTotal;
if nOptionRows
    jd = strmatch('double',classes)' + 1;
    jn = [strmatch('single',classes); strmatch('logical',classes); strmatch('uint',classes); strmatch('int',classes)]' + 1;
    for j = jn
        for i = 2 : m
            c{i,j} = double(c{i,j});
        end
    end
    jj =union(jd,jn);
    M = cell2mat(c(2:end,jj));
    for j = 1 : n
        c{m+1,j} = NaN; % add a row of NaNs to get a blank row on final display
    end
    if isMean
        c(end+1,1) = {'Mean'};
        c(end,jj) = num2cell(nanmean(M));   
    end
    if isMedian
        c(end+1,1) = {'Median'};
        c(end,jj) = num2cell(nanmedian(M));     
    end
    if isStd
        c(end+1,1) = {'SD'};
        c(end,jj) = num2cell(std(M)); % <TODO: bug with nanstd: Fix it>
    end
    if isTotal
        c(end+1,1) = {'TOTAL'};
        c(end,jj) = num2cell(nansum(M)); 
    end
end
if orientation == 'h'
    c = c';
end

% Replace NaNs by strings
for i = setdiff(1:size(c,1), m+1)
    for j = 1 : size(c,2)        
        if ~iscell(c{i,j}) 
            if isnan(c{i,j}) % can be empty => avoid &&
                c{i,j} = 'NaN';
            end
        end
    end
end

% Disp
STR = cell2char(c,nBlanks,'-|');
disp(' ')
disp(STR)
% for i = 1:size(STR,1)  % <Tried to optimize for big tables: to slow!!>
%     fprintf(STR(i,:));
%     fprintf('\n')
%     drawnow;
% end
disp(' ')