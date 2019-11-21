function Cell = getsubdirlist(Dir,Option)
% GETSUBDIRLIST  Get list of sub-directories of a directory.
%    c = GETSUBDIRLIST(Dir)  returns a cell array containing the list of all directories contained
%    in 'Dir', including 'Dir' itself.
%
%    c = GETSUBDIRLIST(Dir,'-onlysub')  does not include "Dir" itself in the list.
%
% Ben, 	Jan. 2008

%		Apr. 2008	Add root dir in the list.

if nargin > 1 && strcmpi(Option,'-onlysub')
    Cell = {};
else
    Cell = {Dir};
end

Dir0 = cd;
cd(Dir)
d = dir;

for i = find([d.isdir])
	if ~strcmp(d(i).name,'.') && ~strcmp(d(i).name,'..')
		od = cd;
		cd(d(i).name)
		Cell = [Cell; {cd}];
		c = getsubdirlist(cd,'-onlysub'); % <-- Recursive call -- !!!
		Cell =[Cell; c];
		cd(od)
	end
end

cd(Dir0)