function restorepath(suffix)
% RESTOREPATH  Dump current path definition file.
%    RESTOREPATH SUFFIX  copies pathdef-dump_<SUFFIX>.m (created by DUMPPATH)
%       into pathdef.m and set the path accordingly.
%
% See also DUMPPATH, SELECTPATH.
%
% Ben, Mar. 2008.

% To do:
%    RESTOREPATH  opens a dialog box to query user for suffix.

pathstr = [matlabroot '\toolbox\local\'];
source = ['"',pathstr,'pathdef-dump_',suffix,'.m"'];
target = ['"',pathstr,'pathdef.m"'];
option = '/vy';
command = ['copy ',source,' ',target,' ',option];
dos(command);

path(pathdef);