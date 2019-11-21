function addcd(r)
% ADDCD   Add current directory to the Matlab path.
% ADDCD R   Add also sub-directories.
%
% See also RMCD, ADDPATH, GENPATH.

% ben, 17 sep 2007

addpath(cd);

if nargin
	files = dir;
	for f = 3 : length(files)
		if files(f).isdir && ~strcmpi(files(f).name,'private')
			od = cd;
			cd(files(f).name)
			addcd r
			cd(od)
		end
	end
end
