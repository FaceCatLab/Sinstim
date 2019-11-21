function date = getfiledate(filename,pathname)
% GETFILEDATE  Date of last modification of a file.
%    V = GETFILEDATE(FILENAME <,PATHNAME>)  returns file's date as a [year,month,day,hour,min,sec] 
%    vector. (This is the same output format that DATEVEC.)
%
%    Examples:
%       - Basic example:
%           d = getfiledate('D:\MATLAB\myfunction.m');
%
%       - To get the date of an m-file:
%           d = getfiledate(which('myfunction.m'));
%
%       - To compare two dates, use datenum:
%           if datenum(getfiledate('file1.m')) > datenum(getfiledate('file2.m'))
%              ...
%           end
%       
%
% See also GETFILELIST, GETFILESIZE, DATESUFFIX, FILENAMEPARTS.
% See also DATEVEC, DATENUM.
%
% Ben Jacob, 2006-2011.

% < Obsolete syntax (no more supported by v3.0):  
%      [day,month,year] = getfiledate(filename,pathname) >

% May  2006		1.0		Ben & Cora		
% Mar. 2008		1.1		Ben & Michael	Quick fix for WinXP French.
% May  2008		2.0		Ben				Use DATEVEC for stability over platforms.
% Jun. 2011		3.0		Ben				Change output arg. <!!!>



if nargout > 1
    error('Wrong number of output arguments.')
end

if nargout >= 2
    fullname = fullfile(pathname,filename);
elseif any(filename == '\' | filename == '/')
    fullname = filename;
elseif ~isempty(which(filename))
    fullname = which(filename);
elseif exist(fullfile(cd,filename),'file')
    fullname = fullfile(cd,filename);
else
    error(['File "' filename '" does not exist.'])
end

d = dir(fullname);

if isempty(d)
    date = [0 0 0 0 0 0];
    warning(['Cannot get date of file "' fullname '".'])
    return                                                     % <===!!!
end

v = version;
if v(1) >= '7' % Matlab 7.x
    [year,month,day,hour,min,sec] = datevec(d.datenum);
else % Matlab 6: 'datenum' field doesn't exist
    [year,month,day,hour,min,sec] = datevec(d.date);
end
date = [year,month,day,hour,min,sec];