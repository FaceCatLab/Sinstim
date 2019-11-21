function glabhelper_perframeevents(tDisplay)
% glabhelper_perframeevents  Helper function for DISPLAYBUFFER and WAITFRAME.

global GLAB_TRIAL

if isopen('trial')
    % REAL-TIME: JUST AFTER FRAME ONSET
    % Update #
    GLAB_TRIAL.iFrame = GLAB_TRIAL.iFrame + 1;
    i = GLAB_TRIAL.iFrame;

    % Time
    if nargin,  GLAB_TRIAL.PERFRAME.TimeStamps(i) = tDisplay;
    else        GLAB_TRIAL.PERFRAME.TimeStamps(i) = time;
    end
% t16=time;
    % // port output
    if GLAB_TRIAL.isParallelOut
        v  = GLAB_TRIAL.ParallelOutQueue.Now.Value;
        qq = GLAB_TRIAL.ParallelOutQueue.Later.t0 > 0 & ...
            GLAB_TRIAL.ParallelOutQueue.Later.t0 + GLAB_TRIAL.ParallelOutQueue.Later.Delay < time + 2;
        if any(qq)
            qq = find(qq);
            v = v + sum(GLAB_TRIAL.ParallelOutQueue.Later.Value(qq));
        end
% dt26=time-t16  % <debug: dt26 = 90 µs>
        t = sendparallelbyte(v);
        GLAB_TRIAL.PERFRAME.ParallelOutTimeStamps(i) = t;
        GLAB_TRIAL.PERFRAME.ParallelOutValues(i) = v;
        
        % Update vars:
        GLAB_TRIAL.ParallelOutQueue.Now.Value = 0;
        if any(qq)
            GLAB_TRIAL.ParallelOutQueue.Later.Value(qq) = [];
            GLAB_TRIAL.ParallelOutQueue.Later.t0(qq)    = [];
            GLAB_TRIAL.ParallelOutQueue.Later.Delay(qq) = [];
        end
    end
    
end