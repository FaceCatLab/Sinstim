function rmcd(r)
% RMCD   Remove current directory from the Matlab path.
% RMCD R   Remove also sub-directories.
%
% See also ADDCD, RMPATH, GENPATH.

% ben, 17 sep 2007

rmpath(cd);

if nargin
	files = dir;
	for f = 3 : length(files)
		if files(f).isdir && ~isempty(strfind(lower(path),lower(files(f).name)))
			od = cd;
			cd(files(f).name)
			rmcd r
			cd(od)
		end
	end
end
