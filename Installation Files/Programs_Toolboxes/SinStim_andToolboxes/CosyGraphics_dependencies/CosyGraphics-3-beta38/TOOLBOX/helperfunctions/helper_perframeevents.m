function helper_perframeevents(tDisplay)
% helper_perframeevents  Helper function for DISPLAYBUFFER and WAITFRAME.

global COSY_TRIALLOG

if isopen('trial')
    % REAL-TIME: JUST AFTER FRAME ONSET
    % Update #
    COSY_TRIALLOG.iFrame = COSY_TRIALLOG.iFrame + 1;
    i = COSY_TRIALLOG.iFrame;

    % Time
    if nargin,  COSY_TRIALLOG.PERFRAME.TimeStamps(i) = tDisplay;
    else        COSY_TRIALLOG.PERFRAME.TimeStamps(i) = time;
    end
% t16=time;
    % // port output
    if COSY_TRIALLOG.isParallelOut
        v  = COSY_TRIALLOG.ParallelOutQueue.Now.Value;
        qq = COSY_TRIALLOG.ParallelOutQueue.Later.t0 > 0 & ...
            COSY_TRIALLOG.ParallelOutQueue.Later.t0 + COSY_TRIALLOG.ParallelOutQueue.Later.Delay < time + 2;
        if any(qq)
            qq = find(qq);
            v = v + sum(COSY_TRIALLOG.ParallelOutQueue.Later.Value(qq));
        end
% dt26=time-t16  % <debug: dt26 = 90 µs>
        t = sendparallelbyte(v); % <v2-beta49: Comment it.>
        COSY_TRIALLOG.PERFRAME.ParallelOutTimeStamps(i) = t;
        COSY_TRIALLOG.PERFRAME.ParallelOutValues(i) = v;
        
        % Update vars:
        COSY_TRIALLOG.ParallelOutQueue.Now.Value = 0;
        if any(qq)
            COSY_TRIALLOG.ParallelOutQueue.Later.Value(qq) = [];
            COSY_TRIALLOG.ParallelOutQueue.Later.t0(qq)    = [];
            COSY_TRIALLOG.ParallelOutQueue.Later.Delay(qq) = [];
        end
    end
    
end