function copy(source,dest)
% COPY  Copy file.
%    COPY SOURCEFILE DESTFILE
%    COPY SOURCEFILE DESTDIR  <todo>
%
% See also CP.

% <TODO: jokers in file names: See getfilesize code!!>


if exist([source '.m'],'file')
    source = [source '.m'];
elseif ~exist(source,'file')
    error(['File "' source '" does not exist.'])
end

fid = fopen(source,'r+');
if fid < 0, error(['Cannot open source file "' source '".']), end
content = fread(fid,inf,'*uint8');
fclose(fid);

fid = fopen(dest,'w');
if fid < 0, error(['Cannot open dest file "' dest '".']), end
fwrite(fid,content);
fclose(fid);