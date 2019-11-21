function dirpath = glablog
% GLABLOG  GraphicsLab's temporary for temporary files. <TODO: Not yet always used!>
%    GLABLOG  returns path of the tmp folder.
%
% See also: GLABROOT, GLABTMP.
%
% Ben,  Jun 2010.

if ispc
    root = glabroot;
    drive = root(1:3);
    
    dirpath = [drive 'glab\var\log'];
    
else
    dirpath = '~/glab/var/log';
    
end

checkdir(dirpath);