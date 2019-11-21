function writetxt(filename,string)
% WRITETXT  Write string to plain text file.
%    WRITETXT(FILENAME,STR)  writes character string STR to file FILENAME. If FILENAME contains no
%    file extention, the ".txt" extension will be appended.
%
%    WRITETXT(FILENAME,C)  where C is a cell vector of string, writes strings contained in C into
%    file FILENAME, adding a linefeed after each element.
%
% See also READTXT.
%
% Ben Jacob, Sep 2010.

%% Param 
isVerbose = 1;

%% Input args
% Add '.txt' extention
if ~any(ismember(filename,'.'))
    filename = [filename '.txt'];
end

% Cell -> string
if iscell(string)
    s = '';
    for i = 1 : numel(string)
        s = [s string{i}];
        linefeed = char(10);
        if ~strcmp(s(end),linefeed)
            s(end+1) = linefeed;
        end
    end
    string = s;
end

%% Check if standard ASCII
% <same code on READTXT and WRITETXT !>
if isVerbose
    non_ascii = string > 127;
    if any(non_ascii)
        wrn = ['Some characters are not ASCII standard. (Codes >127)' 10 ...
            'They could be interpreted differently on different programs and platforms.' 10 ...
            'Character codes #: ' int2str(unique(string(non_ascii))) ',' 10 ...
            'which are interpreted by MATLAB on this platform as: ' unique(string(non_ascii))];
        warning('bentools:NonASCIIChar',wrn)
    end
end

%% Write string to file
fid = fopen(filename,'w');
if fid < 0
    error(['Cannot open file "' filename '".']);
end
fprintf(fid,'%s',string);
fclose(fid);