function out = devcon(varargin)
% DEVCON  Matlab wrapper for Microsoft's DEVCON.EXE program.
%   DEVCON.EXE is the command line replacement of Windows' Device Manager.
%
%   DEVCON HELP  prints help
%
%   DEVCON ...  does the same that DEVCON.EXE.
%
%   STRING = DEVCON(...)  returns the output string in a variable.
%
%   Dependencies: The file DEVCON.EXE is supposed to be present in the same diretory
%   than DEVCON.M ; there is no other dependency (no other m-file needed).
%
% Ben, Jan 2013.

if ~ispc
    error('DEVCON is a Windows-only function.')
end

fullname = which(mfilename);
f = find(fullname == '\');
dirpath = [fullname(1:f(end))];

cmd = ['"' dirpath 'devcon" '];
for i = 1:nargin
    cmd = [cmd varargin{i} ' '];
end

if ~nargout
    dos(cmd);
else
    [s,out] = dos(cmd);
end