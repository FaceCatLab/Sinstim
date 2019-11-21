function [S,nRows,format] = readcondtable(FileName,doShuffle,doConvertCell2Mat)
% READCONDTABLE  Read condition table from Excell .txt file.
%    [T,nrows] = READCONDTABLE(FileName)  reads a tad-separated value ascii file and returns 
%    the table as the form of a Matlab structure of column-vectors, T.  The two fisrt structure's
%    fields are T.Trial (trial #) and T.Order (see shuffle below).  Then, each column's title in the  
%    file becomes a field's name ; columns containing numbers are stored in the double type, columns  
%    containing strings are stored as cell vectors of strings.  Columns without title are ignored.
%    Optionnally, the last column in the file has "#" as title and contains the number of repetitions
%    for each row. 
%
%    [T,nrows] = READCONDTABLE(FileName,doShuffle)  if doShuffle=1, shuffles the rows. Default
%    is doSuffle=0.  <27-Mar-2012: Changed from previous behavior!!!>  Indexes of trials before 
%    shuffle will be stored in the T.Order field.
%   
%    [T,nrows] = READCONDTABLE(FileName,doShuffle,doConvertCell2Mat)  if doConvertCell2Mat=1, converts 
%    the text column (normally cell array of strings) into characters.  Use that only if you have 
%    columns of single letters.  Default is doConvertCell2Mat=0.  <27-Mar-2012: Changed from previous behavior!!!>
%
%    [S,nRows,format] = readcondtable(...)  returns also a format string: number colomns are 
%    represented by 'n', string columns are rpresented by 's'.
%
% See also: READTABLE, SAVETABLE, DISPTABLE, STDTEXTREAD.
%
% Ben Jacob, 2009-2012.

% v1.0  2009  
% v1.1  2012  Write doc. Change 3d and 3d args defaults <!!!>.
% v1.2  20-Jun-2012     Remove quotes (") to be compatible with OpenOffice.Calc which adds quotes around all strings.
%                       Add error catch for doConvertCell2Mat argument.

%% Input Arg.
if ~nargin
    [f,p] = uigetfile;
    FileName = [p filesep f];
end
if ~exist('doShuffle','var')
    doShuffle = false; % <27-mar-2012: Change defalt !!!>
end
if ~exist('doConvertCell2Mat','var')
    doConvertCell2Mat = false; % <27-mar-2012: Change default !!!>
end

% Init var.
S = struct('Trial',[],'Order',[]);

%% Read file
[N,T,Titles,Format] = stdtextread(FileName,1);

%% Remove quotes  % <v1.2: OpenOffice.Calc adds quotes, let's removes them.>
for j = 1 : length(Titles)
    Titles{j}(Titles{j}=='"') = [];
    if Format(j) == 's'
        for i = 1:size(T,1), T{i,j}(T{i,j}=='"') = []; end
    end
end

%% Parse columns
% 1) Remove columns with no titles, and 2) extract "#" column (Repetitions)
isRepetitions = 0;
N(:,length(Titles)+1:end) = [];
T(:,length(Titles)+1:end) = [];
for j = length(Titles) : -1 : 1
    if isempty(Titles{j})
        Titles(j) = [];
        N(:,j) = [];
        T(:,j) = [];
    elseif strcmp(Titles{j},'#')
        isRepetitions = 1;
        Repetitions = N(:,j);
        Titles(j) = [];
        N(:,j) = [];
        T(:,j) = [];
    end
end

nCols = length(Titles);
    
%% Columns -> Structure fields
for j = 1 : nCols % columns beyond nCols (i.e.: without tile) are ignored
    if ~isempty(Titles{j}) % columns without title are ignored
        if ~ismember(Titles{j}(1),['A':'Z' 'a':'z']) || ... % if first char is not a letter, OR..
                ~all(ismember(Titles{j},['A':'Z' 'a':'z' '0':'9' '_'])) % ..if any other char is not alpha-numeric or an underscore
            error(['"' Titles{j} '" is not a valid field name. Only alpha-numeric characters and underscore are allowed.'])
        end
        switch Format(j)
            case 'n'
                S.(Titles{j}) = N(:,j);
            case 's' 
                S.(Titles{j}) = T(:,j);
        end
    end
end

%% Repetitions
% An optional comlumn, with no title, can be added on the right side to define the # of repetition 
% of each condition.
if isRepetitions
    nCond = size(N,1);        % # rows in table (before Repetitions)
    nRows = sum(Repetitions); % total # elements after Repetitions
    
    for j = 1 : nCols
        field = Titles{j};
        if ~isempty(field) % columns without title are ignored
            i0 = 0;
            switch Format(j)
                case 'n'
                    tmp = zeros(nRows,1);
                    for c = 1 : nCond
                        n = Repetitions(c);
                        tmp(i0+1:i0+n) = S.(field)(c);
                        i0 = i0 + n;
                    end
                case 's'
                    tmp = cell(nRows,1);
                    for c = 1 : nCond
                        n = Repetitions(c);
                        for i = i0+1:i0+n, tmp{i} = S.(field){c}; end
                        i0 = i0 + n;
                    end
                otherwise
                    error('Unknown format.')
            end
            S.(field) = tmp;
        end
    end
    
else
    nRows = size(N,1); %<v1.2: Fix case no repet. column in file>
    
end

%% Shuffle ?
if doShuffle
    dispinfo(mfilename,'info','Re-initialising Matlab''s random number generator.')
    rand('twister',sum(100*clock)) % <===!!!
    order = randperm(nRows);
    for j = 1 : nCols
        field = Titles{j};
        S.(field) = S.(field)(order);
    end
else
    order = 1 : nRows;
end
    
%% Convert cells of strings -> strings ?
if doConvertCell2Mat
    for j = 1 : nCols
        field = Titles{j};
        if iscell(S.(field))
            try S.(field) = cell2mat(S.(field));
            catch error('CAT arguments dimensions are not consistent. doConvertCell2Mat argument must be 0 if you are not using single letters only.')
            end
        end
    end
end

%% Trial and Order fields
S.Trial = (1:nRows)';
S.Order = S.Trial(order);