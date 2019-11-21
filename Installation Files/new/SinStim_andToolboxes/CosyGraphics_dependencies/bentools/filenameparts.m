function [pathname,shortname,ext] = filenameparts(name)
% FILENAMEPARTS  Decompose file name into path name, short file name (without extention) and extension.
%    [pathname,shortname,ext] = FILENAMEPARTS(name)
%
% Ben,  Nov 2010.

f = find(ismember(name,'/\'));
if isempty(f)
    pathname = '';
    filename = name;
else
    pathname = name(1:f(end));
    filename = name(f(end)+1:end);
end

f = find(filename == '.');
if isempty(f)
    shortname = filename;
    ext = '';
else
    shortname = filename(1:f(end)-1);
    ext = filename(f(end)+1:end);
end
