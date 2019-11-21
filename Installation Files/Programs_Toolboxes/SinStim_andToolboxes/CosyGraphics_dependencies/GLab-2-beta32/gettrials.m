function tr = gettrials(varargin)
% GETTRIALS  Get all trial data recorded between STARTTRIAL and STOPTRIAL calls.
%    TR = GETTRIALS  returns trials data in vector structure TR (one element per trial).
%
%    TR = GETTRIALS('-raw')  returns raw data, without post-processing. For debug purpose.

tmpfile = fullfile(glabtmp,'trials.mat');
s = load(tmpfile);
tr = s.Trials;

if ~nargin || ~strcmpi(varargin{1},'-raw')
    tr = glabhelper_processtrials(tr);
end