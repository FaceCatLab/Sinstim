function s = bentoolsroot()
% BENTOOLSROOT  Root directory of BenTools toolbox.
%    S = BENTOOLSROOT  returns a string that is the name of the directory
%    where the BenTools toolbox is installed.
%
% Ben, Jan 2010.

fullname = mfilename('fullpath');
f = find(fullname == filesep);
s = fullname(1:f(end));