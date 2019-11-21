function path = whichdir(filename)
% WHICHDIR  containing directory of a file.
%    path = WHICHDIR(filename)  if file exists in Matlab's path, 
%       returns path to it. If file is an m-file, extension can be
%       omitted.
%
% Ben, Mar 2008.

%      Sep 2010.  Add filesep to the end.

fullname = which(filename);
if isempty(fullname)
	path = '';
else
	f = find(fullname == filesep);
	path = [fullname(1:f(end)-1) filesep];
end