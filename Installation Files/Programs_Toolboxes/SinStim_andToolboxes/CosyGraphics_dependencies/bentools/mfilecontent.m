function mfile = mfilecontent(option)
% MFILECONTENT  Content of currently executing M-file.
%    STR = MFILECONTENT reads the currently executing M-file (i.e.: the M-file which called it) and 
%    returns the content as a string. 
%
%    STRUCT = MFILECONTENT('ALL') reads the caller -as above-, the caller of the caller if any, the
%    caller of the caller of the caller, etc. and returns a M-by-1 strucure with the fields:
%        name    -- filename
%        content -- content as a string
%
% See also MFILENAME, DBSTACK, MFILEPATH, MFILECALLER. 
%
% Ben, June 2010.

mfile = [];
s = dbstack;
s = s(2:end); % remove mfilecontent itself
for f = 1 : length(s)
    name = s(f).name;
    mfile(f).name = name;
    p = which(mfile(f).name);
    seps = find(p == filesep);
    p(seps(end)+1:end) = [];
    mfile(f).path = p;
    fid = fopen([p name '.m']);
    if fid < 0, error(['Cannot read file ' name]), end
    mfile(f).content = fscanf(fid,'%c');
    fclose(fid);
end

if ~nargin                     %    STR = MFILECONTENT
    mfile = mfile(1).content;
elseif strcmpi(option,'all')   %    STRUCT = MFILECONTENT('ALL')
    % nothing to do
else
    error('Invalid argument.')
end