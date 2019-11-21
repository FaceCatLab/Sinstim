function dumppath(suffix)
% DUMPPATH  Dump current path definition file.
%    DUMPPATH SUFFIX  saves pathdef.m to a file named pathdef-dump_<SUFFIX>.m.
%       The dump file will be created in the <MATLAB>\toolbox\local directory.
%
% See also RESTOREPATH, SELECTPATH.
%
% Ben, Mar. 2008.

% To do:
%    DUMPPATH  opens a dialog box to query user for suffix.

pathstr = [matlabroot '\toolbox\local\'];
source = ['"',pathstr,'pathdef.m"'];
target = ['"',pathstr,'pathdef-dump_',suffix,'.m"'];
option = '/vy';
command = ['copy ',source,' ',target,' ',option];
dos(command);