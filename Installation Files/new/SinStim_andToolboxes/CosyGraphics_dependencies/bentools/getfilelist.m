function List = getfilelist(Ext,Dir)
% GETFILELIST
%    List = GETFILELIST(Ext)
%    List = GETFILELIST(Ext,Dir)

if nargin < 2
	Dir = uigetdir;
end

od = cd;
cd(Dir)
Files = dir;
cd(od)
Files = Files(3:end); % remove special Files '.' and '..'

List = {};
for i = 1 : length(Files)
	filename = Files(i).name;
    if length(filename) >= length(Ext) && strcmpi(filename(end-length(Ext)+1:end),Ext)
        List{end+1} = filename;
    end
end

List = List';