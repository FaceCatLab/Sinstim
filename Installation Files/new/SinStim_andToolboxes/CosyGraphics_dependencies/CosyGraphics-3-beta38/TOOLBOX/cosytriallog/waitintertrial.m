function waitintertrial(Duration)
% WAITINTERTRIAL  Wait between two trials.
%    This function can only be used between STOPTRIAL and STARTTRIAL.
%
%    WAITINTERTRIAL(t)  schedules a wait time of t milliseconds between two trials. Inter-trial time 
%    is counted from the blank screen displayed by STOPTRIAL and the the first frame displayed after
%    STARTTRIAL.  Note that this function only schedules the waiting ; the actual waiting will occur 
%    at the first call of DISPLAYBUFFER after STARTTRIAL.
%
% See also STOPTRIAL, STARTTRIAL, DISPLAYBUFFER.

%
% Ben, Jul 2011.

global COSY_TRIALLOG

if COSY_TRIALLOG.iTrial < 1
    stopcosy;
    error('WAITINTERTRIAL must be called between STOPTRIAL and STARTTRIAL.')
end

COSY_TRIALLOG.InterTrialDuration = Duration;