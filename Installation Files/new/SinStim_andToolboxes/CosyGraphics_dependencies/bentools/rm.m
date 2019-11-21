function [status,result] = rm(varargin)
% RM  Remove one or more files, on Windows or Unix.
%    RM FILE  removes FILE.
%
% Ben, Jul 2010.

if ispc, cmd = 'del /F'; % /F: don't ask for read-only files.
else     cmd = 'rm';
end

for i = 1 : nargin
    cmd = [cmd ' ' varargin{i}];
end

[status,result] = system(cmd);