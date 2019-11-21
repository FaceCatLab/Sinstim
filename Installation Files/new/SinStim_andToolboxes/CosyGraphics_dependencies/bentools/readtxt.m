function [string,lines] = readtxt(filename,string)
% READTXT  Read plain text file.
%    STR = READTXT(FILENAME)  read plain text file FILENAME and outputs the whole content in
%    the character string STR.  If FILENAME is a relative name, it will search for it first in
%    the current directory, then on the Matlab path.
%
%    [STR,LINES] = READTXT(FILENAME)  outputs also each line in the cell array of string LINES, 
%    one element in the cell per line.
%
% See also WRITETXT, STDTEXTREAD.
%
% Ben Jacob, Sep 2010.

%% Param 
isVerbose = 1;

%% Relative name -> Full name
fullname = which(filename);
if isempty(fullname)
    error([filename ' not found.'])
end

%% Read file
fid = fopen(filename,'r');
if fid < 0
    error(['Cannot open file "' filename '".']);
end
string = fscanf(fid,'%c');
fclose(fid);

%% Check if standard ASCII (codes <127)
% <same code on READTXT and WRITETXT !>
if isVerbose
    non_ascii = string > 127;
    if any(non_ascii)
        wrn = ['Some characters are not ASCII standard. (Codes >127)' 10 ...
            'They could be interpreted differently on different programs and platforms.' 10 ...
            'Character codes #: ' int2str(unique(string(non_ascii))) ',' 10 ...
            'which are interpreted by MATLAB on this platform as: ' unique(string(non_ascii))];
%         warning('bentools:NonASCIIChar',wrn)  % <commented 08/2012> <TODO: Review this!>
    end
end

%% Ensure standard end of lines
% Suppress carriage returns (13)
string(string == 13) = []; % end of line = LF on UNIX / CR+LF on Windows
% Linefeed (10) at end of last line
if string(end) ~= 10
    string = [string 10];
end

%% String -> cell
if nargout >= 2
    lf = find(string == 10); % linefeeds
    lines = cell(numel(lf), 1);
    if ~isempty(lf)
        lines{1} = string(1:lf(1)-1);
        for i = 2 : numel(lf)
            lines{i} = string(lf(i-1)+1:lf(i)-1);
        end
    end
end