function pathname = glabroot()
% GLABROOT  G-Lab's root directory.
%    pathname = GLABROOT
% 
% See also GLABTMP.
%
% Ben,	Nov. 2007.

p = which('setupglab');
f = find(p == filesep);
f = f(end) - 1;
pathname = p(1:f);
