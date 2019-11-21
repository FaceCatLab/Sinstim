function i = getcyclecount 
% GETCYCLECOUNT  Index of current physical screen refresh cycle since trial start.
%    GETCYCLECOUNT  returns refresh cycle number, counting from first frame of trial. (I.e.: first
%    frame displayed after the STARTTRIAL call = frame #1). What we count here is the number of 
%    one-frame intervals elapsed since trial onset. The difference with GETFRAMECOUNT is that missed
%    frames are taken in account. Note that the result of this function is an estimate. It'd be
%    perfectly reliable over PsychTB, when everything is ok with your hardware, while errors are
%    possible over Cogent or if you have hardware issues (either with the hi-precision clock or
%    with the beam position).
%
% See also: STARTTRIAL, GETFRAMECOUNT, GETDISPLAYCOUNT.

global COSY_TRIALLOG

if COSY_TRIALLOG.isStarted
    i = COSY_TRIALLOG.iFrame; % index frame
    delta_t = time - COSY_TRIALLOG.PERFRAME.TimeStamps(i);
    i = i + floor((delta_t+1) / oneframe); % frames counted -> cycles actually elapsed
else
    i = 0;
end