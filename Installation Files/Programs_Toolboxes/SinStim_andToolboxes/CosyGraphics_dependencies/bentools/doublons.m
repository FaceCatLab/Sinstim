function filelist = doublons(directory)
% DOUBLONS  Check Matlab path for m-files with identical names.
%
%    DOUBLONS  prints the list of files in Matlab's path which have
%    the same name than a file in the current dir.
%
%    DOUBLONS(DIR)  does the same for give directory.


filelist = [];
if ~nargin
    directory = cd;
end
isinpath = ~isempty(strfind(path,directory));

if isinpath
    rmpath(directory)
end

d = dir;
cd ..        % @@@   !

for i = find(~[d.isdir])
    if strcmpi(d(i).name(end-1:end),'.m')
        if exist(d(i).name,'file')
            filelist = [filelist which(d(i).name) char(10)];
        end
    end
end

cd(directory) % @@@  !

if isinpath
    addpath(directory)
end

% disp(filelist)
