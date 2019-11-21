function getsubdir(Dir,Pattern,ExcludePattern)
% GETSUBDIR Get the list of subdirectories of a given directory. <DEPRECATED: USE GETSUBDIRLIST>
%    Cell = GETSUBDIR(Dir) returns the list of all directories full names in a cell array.
%    Cell = GETSUBDIR(Dir,Pattern) <NOT FINISHED>
%    Cell = GETSUBDIR(Dir,Pattern,ExcludePattern) <NOT FINISHED>
%
% Ben, 	Jan. 2008

%		Apr. 2008	Add root dir in the list.


Cell = {Dir};

Dir0 = cd;
cd(Dir);
d = dir;
for i = find([d.isdir])
	od = cd;
	cd(d(i).name)
	Cell = [Cell; {cd}];
	c = getsubdir(cd); % <-- Recursive call -- !!!
	Cell =[Cell; c];
	cd(od)
end

cd(Dir0)