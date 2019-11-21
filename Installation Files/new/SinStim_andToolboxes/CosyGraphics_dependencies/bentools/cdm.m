function cdm(MFileName)
% CDM  Change current Directory to an M-file's parent directory.
%    CDM MFILENAME
%
% Ben, Feb 2009.

str = which(MFileName);
f = find(str == filesep);
if isempty(f)
    disp(str)
else
    f = f(end);
    dir = str(1:f);
    cd(dir)
    disp(dir)
end