function n = countloc(FileExt,Dir)
% COUNTLOC  Count lines of codes in a dir. and it's sub-dirs.
%    n = COUNTLOC counts LoC of m-files in current dir and it's sub-dirs.
%
%    n = COUNTLOC(FileExt)
%
%    n = COUNTLOC(FileExt,Dir)
%
% Ben, apr 2008.
%
%      feb 2009. No more per file display.

isVerbose = 1;

if nargin < 1, FileExt = 'm'; end
if nargin < 2, Dir = cd;      end

[Files,Lines] = search('-s',char(10),FileExt,Dir);

n = 0;
for f = 1 : length(Lines)
    nf = length(Lines{f});
    if isVerbose
        disp([Files{f} ': ' num2str(nf)])
    end
    n = n + nf;
end