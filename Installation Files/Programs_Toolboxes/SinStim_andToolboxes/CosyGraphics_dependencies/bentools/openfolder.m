function openfolder(name)
% OPENFOLDER  Open folder with Windows Explorer (or Nautilus on Ubunutu Linux).
%    OPENFOLDER(FOLDERPATH)  opens folder window.
%
%    OPENFOLDER(FILENAME)  opens the folder containing the gven file. 'MFILENAME' is the name of an
%    m-file in the Matlab path.
%
%    OPENFOLDER  by itself, opens current dir's window.
%
%    OF(...)  does the same (command-lind shortcut).
%
% Ben, June 2010.

if ~nargin, name = pwd; end

if ispc, name(name=='/') = '\'; end

if exist(name,'file') &&  ~exist(name,'dir')
    name = whichdir(name);
elseif ~any(name == '\' | name == '/') % if it's a relative name..
    name = [pwd filesep name];
end
if ~exist(name,'dir')
    error('Sorry, no folder or file correspond to the name you have given.')
end

if ispc 
    cmd = ['explorer ' name '&'];
    dos(cmd);
else
    cmd = ['nautilus ' name '&'];
    unix(cmd);
end