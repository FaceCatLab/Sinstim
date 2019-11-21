function starttrial(varargin)
% STARTTRIAL  Initialization of automatic processings during trial.
%    STARTTRIAL  initializes trial. Call this before the first DISPLAYBUFFER call of the trial.
%    This function is slow, and can take tens of msecs to execute. Actions wich have to be synchro-
%    nized with the onset of the first frame will be executed by the next DISPLAYBUFFER call.
%
%    STARTTRIAL(TargetNames)  initializes a trial with multiple targets. TargetNames is 1-by-N cell 
%    array of strings.
%
%    STARTTRIAL(nFrames)  initializes a trial of defined number of frames.
%
%    STARTTRIAL(TargetNames,nFrames)  cfr supra.
%
% Examples:
%    - General Example (pseudo-code):
%        for i = 1 : nTrials
%           ...
%           starttrial % Initializes new trial
%           ...
%           displaybuffer(b1,duration) % First display: actual onset of the trial!
%           ...
%           displaybuffer(b2,duration)
%           ...
%           ... 
%           stoptrial
%           ...
%        end
%
%    - Executable Example: To have a basic demo, execute this:
%        startpsych;
%        openparallelport;
%        starttrial;
%        drawround([1 0 0],0,[0 0],100);
%        displaybuffer(0,750,'red_circle');
%        sendparallelbyte(1);
%        drawround([.4 0 1],0,[0 0],100);
%        displaybuffer(0,750,'purple_circle');
%        sendparallelbyte(2);
%        stoptrial;
%        stopcosy;
%
%    - Executable Example 2: Same than above, but you'll get better synchro of your // triggers with the display onset:
%        startpsych;
%        openparallelport;
%        starttrial;
%        drawround([1 0 0],0,[0 0],100);
%        displaybuffer(0,750,'red_circle','-send','parallel',1);
%        drawround([.4 0 1],0,[0 0],100);
%        displaybuffer(0,750,'purple_circle','-send','parallel',2);
%        stoptrial;
%        stopcosy;
%
% See also: DRAWTARGET, DISPLAYBUFFER, STOPTRIAL, WAITINTERTRIAL, SAVETRIALS.

%% Programmer's notes:
% This function works in interaction with DRAWTARGET, DISPLAYBUFFER, WAITSYNCH, STOPTRIAL,
% SAVETRIALS. Global var in COSYGLOBAL and STOPCOSY. Other CosyGraphics functions are not modified.
%
% Note about timings:
% - STARTTRIAL does all the initializations procedures (may be slow).
% - DISLAYBUFFER actually starts the trial: The actual trial's onset is the onset of the first 
%   frame.  STARTTRIAL puts a flag (COSY_TRIALLOG.isWaitingFirstFrame) at 1, and at it's first
%   call, DISLAYBUFFER sends all real-time synch operations, and then reputs the flags to 0.
% - STOPTRIAL... stops the trial.
% - As STARTTRIAL/STOTRIAL are not real-time functions, it can be problematic if you want aprecise 
%   inter-trial interval. The WAITINTERTRIAL functions solves this: it schedules the time to wait 
%   for (stores it in a global var.), and STARTTRIAL will wait the time need after all it's 
%   initializations.
% 
% General Overview of the COSY_TRIALLOG system:
% - STARTTRIAL declares COSY_TRIALLOG fields.
% - DISPLAYBUFFER fills COSY_TRIALLOG.PERDISPLAY.TimeStamps and COSY_TRIALLOG.PERDISPLAY.WhichedDurationsMSecs.
%   NB: It always uses COSY_DISPLAY.CurrentDisplayDuration.
% - WAITSYNCH must not be used directly! Use DISPLAYBUFFER(b,DUR);
% - DRAWTARGET: <TODO!>
% ? WAITKEYDOWN, WAIT*: Must be modified <???> <TODO!>
% - STOPTRIAL computes other variables (Durations and Errors), and returns trial data

%% Global vars
global COSY_GENERAL COSY_TRIALLOG COSY_DISPLAY COSY_EYELINK COSY_DAQ

helper_check isdisplay

%% Param
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('nFrames','var'), 
    nFrames = 20000; % Max # of frames
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Input Args
if nargin
    if iscell(varargin{1})
        COSY_TRIALLOG.TargetNames = varargin{1};
    end
    if isnumeric(varargin{end})
        nFrames = varargin{end} + 1; % add 1.
    end
end

%% Trial #
COSY_TRIALLOG.isWaitingFirstFrame = false; % declare it
COSY_TRIALLOG.StartDate = datestr(now,'yyyy-mm-dd HH:MM:SS');
COSY_TRIALLOG.StartTimeStamp = 0; % declare it
COSY_TRIALLOG.nFramesMax = nFrames;
COSY_TRIALLOG.nTargets = 1; % will be incremented by DRAWTARGET if required
COSY_TRIALLOG.TargetNames = {'target'};
COSY_TRIALLOG.iTrial = COSY_TRIALLOG.iTrial + 1;
disp(' ')
dispinfo(mfilename,'info',['Running trial #' int2str(COSY_TRIALLOG.iTrial) '...']);
COSY_TRIALLOG.iDisplay = 0; % will be incremented by +1 by DISPLAYBUFFER at each call
COSY_TRIALLOG.iFrame = 0; % <currently unused>
if COSY_GENERAL.doDispEvents == 1;
    COSY_TRIALLOG.EventsString = char(zeros(1,1e6)); % 1 MB space allocated !!!
else
    COSY_TRIALLOG.EventsString = [];
end
COSY_TRIALLOG.EventsString_i0 = 0;
COSY_TRIALLOG.iStartAnimation = [];

%% Check error in previous trial
if COSY_TRIALLOG.iTrial >= 2
    nLastTrialMissedFrames = getlasttrialerrors;
else
    nLastTrialMissedFrames = 0;
end

%% INITIALISATION PROCESSES (BEFORE REAL-TIME, NO PROBLEM IF IT'S SLOW)
% Declare vars
% We'll store all current trial data in COSY_TRIALLOG. Data of terminated trials will be stored on
% hard-disk to save RAM. (See STOPTRIAL.)

% Analog Input %<v3-beta25>
% Need about 10ms between start(AI) and trigger(AI) (to fill temporary buffer). So, let's begin by 
% that. (trigger(AI) will be called by displaybuffer at 1st frame onset.)
if isopen('analoginput')
    for i=1:length(COSY_DAQ.AI)
        if isfinite(COSY_DAQ.AI(i).AiObject.SamplesPerTrigger) % If we are not in continuous recording..
            dispinfo(mfilename,'info','Starting analog input engine... Acquisition will be triggered at first display´s onset...')
            start(COSY_DAQ.AI(i).AiObject);
        else
            % Do nothing: in continuous recording mode, we let daq logging from openanaloginput to closeanaloginput/stopcosy.
        end
    end
end

% Times
COSY_TRIALLOG.PERFRAME.TimeStamps = zeros(1,nFrames);
COSY_TRIALLOG.PERFRAME.isDisplay  = false(1,nFrames);
COSY_TRIALLOG.PERDISPLAY.TimeStamps = zeros(1,nFrames); % Max possible # of displays: nFrames+1
COSY_TRIALLOG.PERDISPLAY.DisplaybufferCalledTimeStamps = zeros(1,nFrames);
COSY_TRIALLOG.PERDISPLAY.ScreenFlipCalledTimeStamps = zeros(1,nFrames);
COSY_TRIALLOG.PERDISPLAY.ScreenFlipReturnedTimeStamps = zeros(1,nFrames);
COSY_TRIALLOG.PERDISPLAY.DisplaybufferReturnedTimeStamps = zeros(1,nFrames);
COSY_TRIALLOG.PERDISPLAY.ExpectedDurations_ms = zeros(1,nFrames); % will be filled by DISPLAYBUFFER
COSY_TRIALLOG.PERDISPLAY.ExpectedDurations_frames = zeros(1,nFrames);  % will be filled by STOPTRIAL
COSY_TRIALLOG.PERDISPLAY.MeasuredDurations_ms = zeros(1,nFrames); % id.
COSY_TRIALLOG.PERDISPLAY.MeasuredDurations_frames = zeros(1,nFrames); % id.
COSY_TRIALLOG.PERDISPLAY.MissedFramesPerDisplay = zeros(1,nFrames); % id.
% COSY_TRIALLOG.PERDISPLAY.Tag = char(zeros(nFrames,16)); % <16: hard-coded here and in displaybuffer.> <Commentd 2-beta49 for perf issue (even after fix).>

% Targets: We initialize 1 target here. If there are more than one, DRAWTARGET
% will add them at run-time. See DRAWTARGET.
COSY_TRIALLOG.PERDISPLAY.TARGETS = []; % It can be a vector (1 ele. per target) => Reinitialise it.
COSY_TRIALLOG.PERDISPLAY.TARGETS.Shape = repmat(' ',nFrames,8);
COSY_TRIALLOG.PERDISPLAY.TARGETS.XY    = zeros(nFrames,2) - 9999;
COSY_TRIALLOG.PERDISPLAY.TARGETS.WH    = zeros(nFrames,2) - 9999;
COSY_TRIALLOG.PERDISPLAY.TARGETS.RGB   = zeros(nFrames,3) - 9999; % <a 4th col. (alpha) will be added by drawtarget at runtime if needed> 

% Send:
if isopen('parallelport','out')
    COSY_TRIALLOG.isParallelOut = 1;
    COSY_TRIALLOG.PERFRAME.ParallelOutTimeStamps  = zeros(1,nFrames) - 9999;
    COSY_TRIALLOG.PERFRAME.ParallelOutValues = zeros(1,nFrames) - 9999;
    COSY_TRIALLOG.ParallelOutQueue.Now.Value = 0; % scalar: 0 or 1 to 255
    COSY_TRIALLOG.ParallelOutQueue.Later.Value = []; % variable length vector
    COSY_TRIALLOG.ParallelOutQueue.Later.t0    = []; % id.
    COSY_TRIALLOG.ParallelOutQueue.Later.Delay = []; % id.
else
    COSY_TRIALLOG.isParallelOut = 0;
end

% Pollings:
% COSY_TRIALLOG.PERFRAME.KeyboardPolling = false(nFrames,256);  <usefull?!?>

%% Init helper_dispevent function
helper_dispevent -init

%% EYELINK: SLOW INIT PROCESSES
if isopen('eyelink')
    % Check EyeLink is recording
    if ~checkeyelink('isrecording')
        dispinfo(mfilename,'warning','EyeLink currently not recording. Starting recording...');
        starteyelinkrecord; % (slow: there is a wait(50) inside)
    end
    
    % Send message to EyeLink (Accurate sync msg will be send by DISPLAYBUFFER)  %<v2-beta55>
    msg = sprintf('STARTTRIAL #%d:  %s  (see "TRIALSYNCTME" msg below for actual onset)',... % spelling error deliberate to avoid parsing errors.
        COSY_TRIALLOG.iTrial, datestr(now,'yyyy-mm-dd HH:MM:SS'));
    sendeyelinkmessage(msg); 
end

%% Set priority (only if user did not set it himself)
if isptbinstalled
    if strcmpi(getpriority,'NORMAL') || all(priority == 0)
        setpriority('OPTIMAL')
    end
else
    setpriority('OPTIMAL');
end

%% Reload "buffers" (OpenGL textures) in Video-RAM <PTB-only>
if isptb
    Screen('PreloadTextures',gcw);
end
if nLastTrialMissedFrames
    % ... <?>
end

%% Disable JIT acceleration <v2-beta39>
% See startcosy internal doc for more info.
feature accel off

%% Empty Matlab's UI queue <v3-beta6>
drawnow;

%% WAIT REST OF INTER-TRIAL TIME
if COSY_TRIALLOG.iTrial > 1 && COSY_TRIALLOG.InterTrialDuration
    remaining = COSY_TRIALLOG.InterTrialDuration - time + COSY_TRIALLOG.StopTimeStamp;
    if remaining<0
        msg = sprintf('Inter-trial interval already exceeded by %.1f msec.  [ERROR]', -remaining);
        dispinfo(mfilename,'ERROR',msg);
    end
    COSY_DISPLAY.LastDisplayTimeStamp = COSY_TRIALLOG.StopTimeStamp; % <SIDE EFFECT!> reset LastDisplayTimeStamp to calls to displaybuffer() between trials.
    waitsynch(COSY_TRIALLOG.InterTrialDuration);
end

%% EYELINK: SOFT REAL-TIME PROCESSES (DON'T LOOSE TO MUCH TIME)
if isopen('eyelink')
    % Clear event queue
    cleareyelinkevents;
    
    % Time offset: Update at each trial because of clock drift. <v3-beta27>
    COSY_EYELINK.TimeOffset = helper_measureeyelinktimeoffset;
    
end

%% SYNCHRONISED PROCESSES (DURING REAL-TIME, MUST BE FAST):
% Real-time processes are not executeed by STARTTRIAL. Instead we
% set flags for DISPLAYBUFFER, which will execute processes synchronized
% with the display.
COSY_TRIALLOG.isWaitingFirstFrame = true; % ..at the onset of the first frame of the trial
COSY_TRIALLOG.isStarted = true;           % ..at the onset of each frame of the trial