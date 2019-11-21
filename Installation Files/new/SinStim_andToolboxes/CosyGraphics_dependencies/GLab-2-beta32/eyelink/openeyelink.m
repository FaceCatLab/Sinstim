function openeyelink(varargin)
% OPENEYELINK  EyeLink initialisation.
%    OPENEYELINK  initialises connection and sets the EyeLink tracker.  STARTEYELINKCALIB must have
%    been run before to calibrate the tracker.
%   
%    Example: 
%       % Before your experiment:
%       starteyelinkcalib('HV5', 1, [800 600], [.5 .5 .5]); % use same values than startglab()
%
%       % In your experimental script:
%       startglab('PTB, 1, [800 600], [.5 .5 .5]);
%       openeyelink;
%       ...
%       stopglab;
%
%    OPENEYELINK(CalibGrid)  initialises connection, sets the EyeLink tracker and, if EyeLink
%    is not already calibrated, starts calibration procedure.  GLab's display must be open.
%    CalibGrid can be 'H3', 'HV3', 'HV5', 'HV9' or 'HV13'.
%
%    Examples: 
%       openeyelink HV13  % performs the best possible calibration; perfect for sane human subjects.
%       openeyelink HV5   % starts a simpler calibration; suggested for monkeys.
%
%    OPENEYELINK(ScreenResolution,BgColor)  opens EyeLink independently of GLab.
%
%
% EyeLink Functions Overview
%
%    startglab
%    openeyelink > calibeyelink (1st time only)
%    
%    for i = 1 : nTrials
%        starttrial > starteyelinkrecord
%        ...
%        [x,y] = geteye;    % get gaze position
%        ...
%        stoptrial > stopeyelinkrecord
%    end
%
%    stopglab > closeeyelink > geteyelink (-> "<glabtmp>\active.edf")
%    savetrials* (<- "<glabtmp>\active.edf")

global GLAB_EYELINK GLAB_DISPLAY

%% %%%%%%%%%%%% PARAMS %%%%%%%%%%%%%% %%  <TODO: Params -> args>
edfFile = 'active.edf'; % Make sure the entered EDF file name is 1 to 8
%          characters in length and only numbers or letters are allowed.
%          Name used in Philippe's lab is 'active.edf'.
saccade_velocity_threshold = 22; % EyeLink default = 30 (std config) or 22 (hi sensitivity config)
saccade_acceleration_threshold = 3800; % EyeLink default = 8000 (std config) or 3800 (hi sensitivity config)
% NB: Std config: ignores small saccade / High sensitivity: detects very small saccades
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%

%% Check Matlab version
v = version;
if v(1) <= '6'
    warning off MATLAB:m_warning_end_without_block
    warning off MATLAB:mir_warning_variable_used_as_function
end

%% Input Vars
switch nargin
    case 1
        CalibGrid = varargin{1};
    case 2
        ScreenResolution = varargin{1};
        BgColor = varargin{2};
%     case 0
%         if isopen('display'), msg = '''CalibGrid'' argument is missing.';
%         else                  msg = 'Missing input arguments.';
%         end
%         error(msg)
end

%% Init GLAB_EYELINK var
GLAB_EYELINK.isOpen = 0;
GLAB_EYELINK.isDummy = 0;
if ~isfilledfield(GLAB_EYELINK,'isCalibrated'), GLAB_EYELINK.isCalibrated = 0; end
GLAB_EYELINK.isRecording = 0;
GLAB_EYELINK.isFileRecorded = 0;
GLAB_EYELINK.isFileTransfered = 0;

%% Disp info
dispinfo(mfilename,'info','Opening connection to EyeLink PC...')

%% Init EyeLink
% Is GLab started ?
if exist('ScreenResolution','var')
    Width  = ScreenResolution(1);
    Height = ScreenResolution(2);
elseif isfield(GLAB_DISPLAY,'isDisplay') && GLAB_DISPLAY.isDisplay
    [Width,Height] = getscreenres;
else
    Width = 0; % will be used as a flag
%     error('No display. You must run startpsych or startcogent before openeyelink.')
end
% Is the network connection configured ?
if checkeyelink('isconfigured')
    isConfigured = 0;
else
    isConfigured = 1; % To run without an EyeLink, for test purpose.
end
% Is an EyeLink connected ?
if checkeyelink('ispresent')
    isDummy = 0;
else
    isDummy = 1; % To run without an EyeLink, for test purpose.
end
% Is EyeLink already closed ?
closeeyelink; % In case it was already open, close it.
% Initialize
if ~isDummy
    err = EyeLink('initialize');
    if err
        msg = 'Error in connecting to the eye tracker';
        dispinfo(mfilename,'error',msg);
        error(msg);
    else
        [v,vs] = EyeLink('GetTrackerVersion');
        dispinfo(mfilename,'info',[vs 'tracker initialized.  TCP/IP link open.']);
        f = find(ismember(vs,'0':'9'));
        GLAB_EYELINK.EyelinkVersion = vs(f(1):f(end));
    end
else
    dispinfo(mfilename,'warning','')
    EyeLink('initializedummy');
    disp('         Eye position will be emulated by mouse position.')
end
% Set global vars
GLAB_EYELINK.isOpen = 1;
GLAB_EYELINK.isDummy = isDummy;

%% Open file to record data to
Eyelink('Openfile', edfFile);

%% Get "el" structure, for EyelinkToolbox functions
% Provide EyelinkToolbox [a part of PTB] with details about the graphics environment
% and perform some initializations [sets only screen resolution]. The information is returned
% in the a structure ["el"] that also contains useful defaults
% and control codes (e.g. tracker state bit and EyeLink key values).
% This "el" structure has to be passed to all PTB/EyelinkToolbox functions.
% NB: The only information send to the tracker is through EyeLink('command','screen_pixel_coords',...)
%     for the rest, EyelinkInitDefaults only defines variables for the PTB/EyelinkToolbox functions.
el = EyelinkInitDefaults;  % el = EyelinkInitDefaults(gcw); % 18 dec 09: don't give window #
% Store PTB/EyelinkToolbox "el" structure in a GLab global variable.
GLAB_EYELINK.EL = el;
% Set EyelinkToolbox colors. The background color must be the same for calibration and experiment,
% in order to have the same dilatation of the pupil. So, let's store GLab's current default
% background color into the "el" structure.
if exist('BgColor','var')
    bg = 255 * mean(BgColor);
elseif isfilledfield(GLAB_DISPLAY,'BackgroundColor')
    bg = 255 * mean(rgb2gray(GLAB_DISPLAY.BackgroundColor));
else
    bg = [.5 .5 .5];
    dispinfo(mfilename,'info','Background color not defined. Using medium gray as default.')
    dispinfo(mfilename,'info','Eyelink accuracy is better when background is the same during calibration and experiment.')
end
GLAB_EYELINK.EL.backgroundcolour = round(bg);
if bg < .4,     GLAB_EYELINK.EL.foregroundcolour = 255;
else            GLAB_EYELINK.EL.foregroundcolour = 0;
end

%% SET UP TRACKER CONFIGURATION
% screen resolution
if Width > 0 % If display is open or if display resolution has been give as input arg..
    EyeLink('command', 'screen_pixel_coords = %ld %ld %ld %ld', 0, 0, Width-1, Height-1);
    EyeLink('message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, Width-1, Height-1);
else
    % Do nothing. Display resolution will be set by opendisplay.
end
% set parser (conservative saccade thresholds)
EyeLink('command', ['saccade_velocity_threshold = ' saccade_velocity_threshold]);
EyeLink('command', ['saccade_acceleration_threshold = ' saccade_acceleration_threshold]);
% set EDF file contents; make sure that we get event data 
EyeLink('command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON');
EyeLink('command', 'link_sample_data  = LEFT,RIGHT,GAZE,HREF,AREA,GAZERES,STATUS');
EyeLink('command', 'link_event_data   = GAZE,GAZERES,HREF,AREA,VELOCITY');
EyeLink('command', 'link_event_filter = LEFT,RIGHT,FIXATION,BLINK,SACCADE,BUTTON');
% allow to use the big button on the eyelink gamepad to accept the
% calibration/drift correction target
EyeLink('command', 'button_function 5 "accept_target_fixation"');

%% Init other GLAB_EYELINK fields
GLAB_EYELINK.PreviousSample = [];

%% Calibrate EyeLink
if ~GLAB_EYELINK.isCalibrated
    if exist('CalibGrid','var')
        if GLAB_EYELINK.isDummy
            dispinfo(mfilename,'warning','Dummy mode: skipping calibration procedure.')
        else
            calibeyelink('C','CalibGrid');
        end
    else
        dispinfo(mfilename,'warning','Display not open. Cannot lauch calibration.')
    end
end

disp(' ')