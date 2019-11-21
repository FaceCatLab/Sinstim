function cdglab(subdir)
% CDGLAB  Change directory to G-Lab's root directory.
%    CDGLAB
%    CDGLAB(SUBDIR)

d = glabroot;
if nargin, d = fullfile(d,subdir); end
cd(d)
disp(cd)