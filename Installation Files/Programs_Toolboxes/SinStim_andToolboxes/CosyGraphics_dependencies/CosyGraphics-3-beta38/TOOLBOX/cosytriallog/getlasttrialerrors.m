function [nErr,info] = getlasttrialerrors
% GETLASTTRIALERRORS  Number of presentation deadlines missed during last trial. <TODO: Add args>
%    GETLASTTRIALERRORS  returns total number of refresh cycles missed during last trial.
%
%    [n,info] = GETLASTTRIALERRORS  <TODO>

global COSY_TRIALLOG

if ~isempty(COSY_TRIALLOG)
    nErr = nansum(COSY_TRIALLOG.PERDISPLAY.MissedFramesPerDisplay);
else
    nErr = NaN;
end