function glabmanual(filename)
% GLABMANUAL  Generate and edit a file with full G-Lab documentation.
%
% See also GLABHELP.
%
% Ben, March 2008.

od = cd;
cd(glabroot) % --!
glabhelp('GLabManual.txt');
edit('GLabManual.txt');
cd(od) %         --!
