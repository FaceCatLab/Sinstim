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
% Example:
%    for i = 1 : nTrials
%       ...
%       starttrial % Initializes new trial
%       ...
%       displaybuffer(0,duration) % Actual onset of the trial
%       ... % <-- during the trial: insert code here
%       stoptrial
%       ...
%    end
%
% See also: DRAWTARGET, DISPLAYBUFFER, WAITSYNCH, STOPTRIAL, SAVETRIALS.

%% Programmer's note:
% This function works in interaction with DRAWTARGET, DISPLAYBUFFER, WAITSYNCH, STOPTRIAL,
% SAVETRIALS. Global var in GLABGLOBAL and STOPGLAB. Other GLab functions are not modified.
% 
% General Overview of the GLAB_TRIAL system:
% - STARTTRIAL declares GLAB_TRIAL fields.
% - DISPLAYBUFFER fills GLAB_TRIAL.PERDISPLAY.TimeStamps and GLAB_TRIAL.PERDISPLAY.WhichedDurationsMSecs.
%   NB: It always uses GLAB_DISPLAY.CurrentDisplayDuration.
% - WAITSYNCH must not be used directly! Use DISPLAYBUFFER(b,DUR);
% - DRAWTARGET: <TODO!>
% ? WAITKEYDOWN, WAIT*: Must be modified <???> <TODO!>
% - STOPTRIAL computes other variables (Durations and Errors), and returns trial data

%% Global vars
global GLAB_TRIAL GLAB_DISPLAY GLAB_EYELINK GLAB_DEBUG

glabhelper_check isdisplay

%% %%%%%%%%%% Params %%%%%%%%%% %%
if ~exist('nFrames','var'), 
    nFrames = 20000; % Max # of frames
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% %%

%% Input Args
if nargin
    if iscell(varargin{1})
        GLAB_TRIAL.TargetNames = varargin{1};
    end
    if isnumeric(varargin{end})
        nFrames = varargin{end} + 1; % add 1.
    end
end

%% Trial #
GLAB_TRIAL.isWaitingFirstFrame = false; % declare it
GLAB_TRIAL.StartDate = datestr(now,'yyyy-mm-dd HH:MM:SS');
GLAB_TRIAL.StartTimeStamp = 0; % declare it
GLAB_TRIAL.nFramesMax = nFrames;
GLAB_TRIAL.nTargets = 1; % will be incremented by DRAWTARGET if required
GLAB_TRIAL.TargetNames = {'target'};
GLAB_TRIAL.iTrial = GLAB_TRIAL.iTrial + 1;
disp(' ')
dispinfo(mfilename,'info',['Running trial #' int2str(GLAB_TRIAL.iTrial) '...']);
GLAB_TRIAL.iDisplay = 0; % will be updated by +1 by DISPLAYBUFFER at each call
GLAB_TRIAL.iFrame = 0; % <currently unused>
if GLAB_DEBUG.doDispEvents == 1;
    GLAB_TRIAL.EventsString = char(zeros(1,1e6)); % 1 MB space allocated !!!
else
    GLAB_TRIAL.EventsString = [];
end
GLAB_TRIAL.EventsString_i0 = 0;

%% INITIALISATION PROCESSES (BEFORE REAL-TIME, CAN BE SLOW)
% Declare vars
% We'll store all current trial data in GLAB_TRIAL. Data of terminated trials will be stored on
% hard-disk to save RAM. (See STOPTRIAL.)

% Times
GLAB_TRIAL.PERFRAME.TimeStamps = zeros(1,nFrames);
GLAB_TRIAL.PERDISPLAY.TimeStamps = zeros(1,nFrames); % Max possible # of displays: nFrames+1
GLAB_TRIAL.PERDISPLAY.BeforeDisplayTimeStamps = zeros(1,nFrames);
GLAB_TRIAL.PERDISPLAY.AfterDisplayTimeStamps = zeros(1,nFrames);
GLAB_TRIAL.PERDISPLAY.ExpectedDurations_ms = zeros(1,nFrames); % will be filled by DISPLAYBUFFER
GLAB_TRIAL.PERDISPLAY.ExpectedDurations_frames  = [];  % will be filled by STOPTRIAL
GLAB_TRIAL.PERDISPLAY.MeasuredDurations_ms  = []; % id.
GLAB_TRIAL.PERDISPLAY.MeasuredDurations_frames = []; % id.
GLAB_TRIAL.PERDISPLAY.MissedFrames = []; % id.

% Targets: We initialize 1 target here. If there are more than one, DRAWTARGET
% will add them at run-time. See DRAWTARGET.
GLAB_TRIAL.PERDISPLAY.TARGETS = []; % It can be a vector (1 ele. per target) => Reinitialise it.
GLAB_TRIAL.PERDISPLAY.TARGETS.Shape = repmat(' ',nFrames,8);
GLAB_TRIAL.PERDISPLAY.TARGETS.XY    = zeros(nFrames,2) - 9999;
GLAB_TRIAL.PERDISPLAY.TARGETS.WH    = zeros(nFrames,2) - 9999;
GLAB_TRIAL.PERDISPLAY.TARGETS.RGB   = zeros(nFrames,3) - 9999; % <a 4th col. (alpha) will be added by drawtarget at runtime if needed> 

% Send:
if isopen('parallelport','out')
    GLAB_TRIAL.isParallelOut = 1;
    GLAB_TRIAL.PERFRAME.ParallelOutTimeStamps  = zeros(1,nFrames) - 9999;
    GLAB_TRIAL.PERFRAME.ParallelOutValues = zeros(1,nFrames) - 9999;
    GLAB_TRIAL.ParallelOutQueue.Now.Value = 0; % scalar: 0 or 1 to 255
    GLAB_TRIAL.ParallelOutQueue.Later.Value = []; % variable length vector
    GLAB_TRIAL.ParallelOutQueue.Later.t0    = []; % id.
    GLAB_TRIAL.ParallelOutQueue.Later.Delay = []; % id.
else
    GLAB_TRIAL.isParallelOut = 0;
end

% Pollings:
% GLAB_TRIAL.PERFRAME.KeyboardPolling = false(nFrames,256);  <usefull?!?>

% Init glabhelper_dispevent function
glabhelper_dispevent -init

% Check EyeLink is recording
if isopen('eyelink') && ~checkeyelink('isrecording')
    starteyelinkrecord;
%     str = 'EyeLink is not recording: eye data will be lost. See ''starteyelinkrecord''.';
%     dispinfo(mfilename,'error',str);
%     error(str)
end

% Set priority (only if user did not set it himself)
if strcmpi(getpriority,'NORMAL') || all(priority == 0)
    setpriority('OPTIMAL')
end

%% SYNCHRONISED PROCESSES (DURING REAL-TIME, MUST BE FAST):
% Real-time processes are not executeed by STARTTRIAL. Instead we
% set flags for DISPLAYBUFFER, which will execute processes synchronized
% with the display.
GLAB_TRIAL.isWaitingFirstFrame = 1; % ..at the onset of the first frame of the trial
GLAB_TRIAL.isStarted = 1;           % ..at the onset of each frame of the trial