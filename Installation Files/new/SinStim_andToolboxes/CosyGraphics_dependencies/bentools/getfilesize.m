function [v,str] = getfilesize(filename,pathname)
% GETFILESIZE  Give the size of a file.
%    [v,str] = getfilesize(filename,pathname)
%       'v'  : [Mb kb b] numerical vector.
%       'str': 'x Mb y kb z bytes' string.

if nargin < 2,
    pathname = cd;
end

if pathname(end) == filesep
    pathname = pathname(1 : end-1);
end

D = dir(fullfile(pathname,filename));

if isempty(D)
    warning('File does not exist.')
    v = [0 0 0];
    str = '0 Mb 0 kb 0 bytes';
    return % !!!
end

tot = D.bytes;

Mb = floor(tot / 1024^2);
r  = rem(tot, 1024^2);
kb = floor(r / 1024);
b  = rem(r, 1024);

v = [Mb kb b];

str = [num2str(b) ' bytes'];
if kb | Mb,
    str = [num2str(kb) ' kb ' str];
end
if Mb
    str = [num2str(Mb) ' Mb ' str];
end