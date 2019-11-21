function [tStop,Trials] = stoptrial
% STOPTRIAL  End of automatic processings during trial.
%    STOPTRIAL  stops current trial and returns trial data in the structure DATA.
%
%    t = STOPTRIAL  returns the timestamp of the onset of the "end" frame (blank frame after trial).
%
%    [t,Trials] = STOPTRIAL  returns also the trials log data. 'Trials' is a vectorial structure, 
%    one element per trial. WARNING: The 'Trials' structure oraganisation may change in further 
%    version of CosyGraphics !!!
%
% See also: STARTRIAL, WAITINTERTRIAL.

global COSY_TRIALLOG COSY_GENERAL COSY_DISPLAY COSY_DAQ

%% Check trial is started
if ~isopen('trial')
    error('Trial is not started. See STARTTRIAL.')
end

%% Wait last event
if isfilledfield(COSY_TRIALLOG,'isParallelOut') && COSY_TRIALLOG.isParallelOut ...
    && ~isempty(COSY_TRIALLOG.ParallelOutQueue.Later.Delay)
    tt = COSY_TRIALLOG.ParallelOutQueue.Later.t0 + COSY_TRIALLOG.ParallelOutQueue.Later.Delay;
    t = max(tt);
    dt = t - time;
    if dt > 0
        df = ceil(dt / getframedur) + 1;
        waitframe(df);
    end
end

%% Clear display
d = COSY_DISPLAY.CurrentDisplayDuration;
if ~isempty(d) && (d > 0) && isfinite(d)
    displaybuffer(0,inf,'end');  % !
end
tStop = COSY_DISPLAY.LastDisplayTimeStamp;
COSY_TRIALLOG.StopTimeStamp = tStop;

%% EyeLink: Send stop msg  %<v2-beta55>
if isopen('eyelink')
    msg = sprintf('STOPTTRIAL #%d:  %s',...
        COSY_TRIALLOG.iTrial, datestr(now,'yyyy-mm-dd HH:MM:SS'));
    sendeyelinkmessage(msg); 
    stopeyelinkrecord;
end

%% Reset // port
if isopen('parallelport')
    sendparallelbyte(0);
end

%% Analog Input %<v3-beta25> 
if isopen('analoginput')
    for i=1:length(COSY_DAQ.AI)
        if isfinite(COSY_DAQ.AI(i).AiObject.SamplesPerTrigger) % If we are not in continuous recording..
            try stop(COSY_DAQ.AI(i).AiObject); catch end
        else
            % Do nothing: in continuous recording mode, we let daq logging from openanaloginput to closeanaloginput/stopcosy.
        end
    end
end

%% Update COSY_TRIALLOG
COSY_TRIALLOG.isStarted = false;
COSY_TRIALLOG.isWaitingFirstFrame = false; % (by security)

%% Disp infos
% Let's display infos recorded by COSYHELPER_DISPEVENT.
if COSY_GENERAL.doDispEvents == 1; % 1 (default): Display events after trial
    if isfilledfield(COSY_TRIALLOG,'EventsString')
        f = find(COSY_TRIALLOG.EventsString > 0);
        if isempty(f), f = 0; end
        COSY_TRIALLOG.EventsString(f(end)+1:end) = [];
        disp(COSY_TRIALLOG.EventsString(1:end-1))
    end
end
dispinfo(mfilename,'info',['...End trial #' int2str(COSY_TRIALLOG.iTrial) '.']);

%% Priority back to normal <after disp infos>
setpriority NORMAL

%% Re-enable JIT acceleration <v2-beta39>
% See startcosy internal doc for more info.
feature accel on

%% #
nDisplays = COSY_TRIALLOG.iDisplay;
nFrames = COSY_TRIALLOG.iFrame;

%% -> pd
pd = COSY_TRIALLOG.PERDISPLAY;
pf = COSY_TRIALLOG.PERFRAME;

%% Rm/Add fields
if isfield(COSY_TRIALLOG,'nFramesMax'), COSY_TRIALLOG = rmfield(COSY_TRIALLOG,'nFramesMax'); end
COSY_TRIALLOG.isAborted = isabort;

%% Clip matrices at trial size
fields = fieldnames(pd);
for f = 1 : length(fields)
    pd.(fields{f})(nDisplays+1:end,:) = []; % case displays = rows <TODO: Fix case #display < #cols !??!>
    pd.(fields{f})(:,nDisplays+1:end) = []; % case displays = cols
end
for t = 1 : length(pd.TARGETS) %<NB: "1:COSY_TRIALLOG.nTargets" bugs sometimes when pg aborted>
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
        if ~islogical(pf.(fields{f}))
            pf.(fields{f})(pf.(fields{f}) == -9999) = NaN;
        end
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
% More computation will be done later by helper_processtrials.
pd.ExpectedDurations_ms(~isfinite(pd.ExpectedDurations_ms)) = NaN; %<v2-beta43>
pd.ExpectedDurations_ms(pd.ExpectedDurations_ms == 0)       = NaN; %<v2-beta43>
pd.ExpectedDurations_frames = round(pd.ExpectedDurations_ms / oneframe);
pd.MeasuredDurations_ms = diff(pd.TimeStamps);
pd.MeasuredDurations_ms(end+1) = NaN;
pd.MeasuredDurations_frames = pd.MeasuredDurations_ms / oneframe;
pd.MissedFramesPerDisplay = round(pd.MeasuredDurations_frames) - pd.ExpectedDurations_frames;
pd.MissedFramesPerDisplay(pd.MissedFramesPerDisplay == -inf) = 0; % undefined durations are expected inf frames
if ~isempty(pd.MissedFramesPerDisplay), pd.MissedFramesPerDisplay(end) = 0; end % <v3-beta7: cannot know for last diplay (NaN -> 0).> <v3-beta19: fix case empty.>
helper_checkerrors(mfilename,'missedframes',pd.MissedFramesPerDisplay,nDisplays,10);

%% <- pd
COSY_TRIALLOG.PERDISPLAY = pd;
COSY_TRIALLOG.PERFRAME = pf;

%% Save trial in tmp folder
file = fullfile(cosydir('tmp'),'trials.mat');
i = COSY_TRIALLOG.iTrial;
if i == 1 % First trial: ignore previous trials stored in tmp.
    Trials = COSY_TRIALLOG;
elseif exist(file,'file')
    load(file,'Trials') % Load previous trials
    Trials(i) = COSY_TRIALLOG; % Append current trial
else % First trials missing ???
    Trials(i) = COSY_TRIALLOG;
end
% Save all trials
save(file,'Trials')

%% Output arg ?
if ~nargout
    clear Trials
end