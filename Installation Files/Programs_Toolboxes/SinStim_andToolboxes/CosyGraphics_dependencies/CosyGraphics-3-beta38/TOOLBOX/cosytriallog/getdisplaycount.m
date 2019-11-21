function i = getdisplaycount
% GETDISPLAYCOUNT  Number of display flips from trial start.
%    GETDISPLAYCOUNT  returns number of flips (i.e.: number of calls to DISPLAYBUFFER) 
%    since start of trial.
%
% See also: STARTTRIAL, DISPLAYBUFFER, GETFRAMECOUNT, GETCYCLECOUNT.

global COSY_TRIALLOG

if COSY_TRIALLOG.isStarted
    i = COSY_TRIALLOG.iDisplay;
else
    i = 0;
end