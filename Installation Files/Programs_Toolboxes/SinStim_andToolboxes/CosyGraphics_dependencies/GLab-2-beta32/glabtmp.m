function dirpath = glabtmp
% GLABTMP  GraphicsLab's temporary for temporary files. <TODO: Not yet always used!>
%    GLABTMP  returns path of the tmp folder.
%
% See also: GLABROOT, GLABLOG.
%
% Ben,  Jun 2010.

if ispc
    root = glabroot;
    drive = root(1:3);
    
    dirpath = [drive 'glab\tmp\'];
    
else
    error('Not yet implemented on Unix.')
    
end

checkdir(dirpath);
