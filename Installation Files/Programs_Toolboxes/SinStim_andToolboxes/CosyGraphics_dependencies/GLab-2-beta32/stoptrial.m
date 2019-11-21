function Trials = stoptrial
% STOPTRIAL  End of automatic processings during trial.
%    DATA = STOPTRIAL  stops current trial and returns trial data in the structure DATA.
%
% See also: STARTRIAL.

global GLAB_TRIAL GLAB_DEBUG

%% Wait last event
if GLAB_TRIAL.isParallelOut && ~isempty(GLAB_TRIAL.ParallelOutQueue.Later.Delay)
    tt = GLAB_TRIAL.ParallelOutQueue.Later.t0 + GLAB_TRIAL.ParallelOutQueue.Later.Delay;
    t = max(tt);
    dt = t - time;
    if dt > 0
        df = ceil(dt / getframedur) + 1;
        waitframe(df);
    end
end

%% Update GLAB_TRIAL
GLAB_TRIAL.isStarted = false;
GLAB_TRIAL.isWaitingFirstFrame = false;

%% Clear display
displaybuffer(0,[]);

%% Disp infos
if GLAB_DEBUG.doDispEvents == 1; % 1 (default): Display events after trial
    f = find(GLAB_TRIAL.EventsString > 0);
    if isempty(f), f = 0; end
    GLAB_TRIAL.EventsString(f(end)+1:end) = [];
    disp(GLAB_TRIAL.EventsString(1:end-1))
end
dispinfo(mfilename,'info',['...End trial #' int2str(GLAB_TRIAL.iTrial) '.']);

%% Priority back to normal <after disp infos>
setpriority NORMAL

% #
nDisplays = GLAB_TRIAL.iDisplay;
nFrames = GLAB_TRIAL.iFrame;

%% -> pd
pd = GLAB_TRIAL.PERDISPLAY;
pf = GLAB_TRIAL.PERFRAME;

%% Rm/Add fields
GLAB_TRIAL.isStarted = false;
GLAB_TRIAL.isWaitingFirstFrame = false;
GLAB_TRIAL = rmfield(GLAB_TRIAL,{'nFramesMax'});
GLAB_TRIAL.isAborted = isabort;

%% Trunk matrices at trial size
fields = fieldnames(pd);
for f = 1 : length(fields)
    pd.(fields{f})(nDisplays+1:end,:) = []; % case displays = rows <TODO: Fix case #display < #cols !??!>
    pd.(fields{f})(:,nDisplays+1:end) = []; % case displays = cols
end
for t = 1 : length(pd.TARGETS) %<NB: "1:GLAB_TRIAL.nTargets" bugs sometimes when pg aborted>
    fields = fieldnames(pd.TARGETS(t));
    for f = 1 : length(fields)
        pd.TARGETS(t).(fields{f})(nDisplays+1:end,:) = []; % displays = rows
    end
    
    % Replace -9999 by NaN (DRAWTARGET avoids use of NaN because it's to slow):
    subfields = fieldnames(pd.TARGETS(t));
    for f2 = 1 : length(subfields)
        if isnumeric(pd.TARGETS(t).(subfields{f2}))
            pd.TARGETS(t).(subfields{f2})(pd.TARGETS(t).(subfields{f2}) == -9999) = NaN;
        end
    end
end
fields = fieldnames(pf);
for f = 1 : length(fields)
    if ~isstruct(pf.(fields{f}))
        pf.(fields{f})(nFrames+1:end,:) = []; % case frames = rows
        pf.(fields{f})(:,nFrames+1:end) = []; % case frames = cols
        pf.(fields{f})(pf.(fields{f}) == -9999) = NaN;
    else
        for f2 = 1 : length(subfields)
            pf.(fields{f}).(subfields{f2})(nFrames+1:end,:) = []; % case frames = rows
            pf.(fields{f}).(subfields{f2})(:,nFrames+1:end) = []; % case frames = cols
            pf.(fields{f}).(subfields{f2})(pf.(fields{f}).(subfields{f2}) == -9999) = NaN;
        end
    end
end

%% Times
% Compute times & errors now and display info or warning message.
% More computation will be done later by glabhelper_processtrials.
pd.ExpectedDurations_frames = round(pd.ExpectedDurations_ms / getframedur);
pd.MeasuredDurations_ms = diff(pd.TimeStamps);
pd.MeasuredDurations_ms(end+1) = NaN;
pd.MeasuredDurations_frames = pd.MeasuredDurations_ms / oneframe;
pd.MissedFrames = round(pd.MeasuredDurations_frames) - pd.ExpectedDurations_frames;
pd.MissedFrames(pd.MissedFrames == -inf) = 0; % undefined durations are expected inf frames
glabhelper_checkerrors(mfilename,'missedframes',pd.MissedFrames,nDisplays,5);

%% <- pd
GLAB_TRIAL.PERDISPLAY = pd;
GLAB_TRIAL.PERFRAME = pf;

%% Save trial in tmp folder
file = fullfile(glabtmp,'trials.mat');
i = GLAB_TRIAL.iTrial;
if i == 1
    Trials = GLAB_TRIAL;
elseif exist(file,'file')
    load(file,'Trials') % Load previous trials
    Trials(i) = GLAB_TRIAL; % Append current trial
else % First trials missing ???
    Trials(i) = GLAB_TRIAL;
end
% Save all trials
save(file,'Trials')

%% Output arg ?
if ~nargout
    clear Trials
end
