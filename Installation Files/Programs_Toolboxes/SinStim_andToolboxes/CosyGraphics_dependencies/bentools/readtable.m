function [S,m] = readtable(filename,varargin)
% READTABLE  Read table in text file and returns it as a structure.
%    S = READTABLE(FILENAME)  reads table contained in ASCII file as TAB-separated or  
%    comma-separated values and returns it in structure S, column titles becoming field 
%    names.  m is the number of rows.
%
%    [S,m] = READTABLE(FILENAME)  returns also the number of rows, m.
%
%    READTABLE(FILENAME,VARARGIN)  the function accepts the same arguments than STDTEXTREAD.
%    See " help stdtextread ".
%
% See also: READCONDTABLE, SAVETABLE, DISPTABLE, STDTEXTREAD.

dispinfo(mfilename, 'info', ['Reading text file "' filename '"...']);

[N,T,Titles,Format] = stdtextread(filename,varargin{:});

n = size(N,2); % # cols
ok = ['0':'9' 'A':'Z' 'a':'z' '_'];
S = [];
    
for j = 1 : n
    field = Titles{j};
    % No title:
    if ~any(ismember(field,ok));
        field = ['c' int2str(j)];
    end
    % Remove parts between ():
    f = find(ismember(field,['(' '[' '{']));
    if ~isempty(f)
        field = field(1:f(1));
    end
    % Replace invalid chars by underscores:
    field(~ismember(field,ok)) = '_';
    % Remove trailing blanks:
    field = deblank(field);
    % Remove underscores at beginning/end:
    while field(1) == '_', field(1) = []; end
    while field(end) == '_', field(end) = []; end
    
    % Fill field:
    switch Format(j)
        case 'n',   S.(field) = N(:,j);
        case 's',   S.(field) = T(:,j);
    end
end

dispinfo(mfilename, 'info', ['Table imported in Matlab structure, columns becoming field names:']);
disp(S)

m = size(N,1);