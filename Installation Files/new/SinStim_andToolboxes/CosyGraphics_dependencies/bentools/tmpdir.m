function d = tmpdir
% TMPDIR  System's temporary directory.
%    TMPDIR  returns 'C:\Windows\Temp\' on MS-Windows and '/tmp/' on Linux and MacOS X.
%
% Ben Nov 2010.

if ispc,    d = 'C:\Windows\Temp\';
else        d = '/tmp/';
end