function dirpath = userdir
% USERDIR  User directory's path.
%
% See also ENVVAR, PREFDIR.

if ispc % Windows
    dirpath = envvar('USERPROFILE');
    
else % UNIX
    dirpath = envvar('HOME');
    
end
