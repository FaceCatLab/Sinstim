function openeyelink(varargin)
% OPENEYELINK  Initialise SR-Research EyeLink tracker.
%    OPENEYELINK  initialises connection with the EyeLink tracker and configures it.  STARTEYELINKCALIB must 
%    have been run before to calibrate the tracker.
%
%    OPENEYELINK -NOEVENTS  initialises the EyeLink tracker in "no events" mode.  Events will not be
%    transmited through the Ethernet link nor will be recorded.
%   
%    Example: 
%       % Before your experiment:
%       starteyelinkcalib('HV5', 1, [800 600], [.5 .5 .5]); % use same values than startcosy()
%
%       % In your experimental script:
%       startpsych(1, [800 600], [.5 .5 .5]);
%       openeyelink;
%       ...
%       stopcosy;
%
% CosyEyeLink Functions Overview
%    - Calib:
%       starteyelinkcalib > calibeyelink 
%
%    - Experiment script:
%       startcosy
%       openeyelink
%    
%       for i = 1 : nTrials
%           starttrial > starteyelinkrecord
%           ...
%           [x,y] = geteye;    % get gaze position
%           ...
%           stoptrial > stopeyelinkrecord
%       end
%
%       stopcosy > closeeyelink > geteyelink (-> "<cosygraphicstmp>\active.edf")
%       savetrials* (<- "<cosygraphicstmp>\active.edf")
%
%    See also: SETEYELINKEVENTS, CHECKEYELINK, STARTEYELINKCALIB, CALIBEEYELINK, STARTEYELINKRECORD, CLOSEEYELINK.

% Deprecated syntaxes:
%    OPENEYELINK(CalibGrid)  initialises connection, sets the EyeLink tracker and, if EyeLink
%    is not already calibrated, starts calibration procedure.  CosyGraphics's display must be open.
%    CalibGrid can be 'H3', 'HV3', 'HV5', 'HV9' or 'HV13'.
%
%    Examples: 
%       openeyelink HV13  % performs the best possible calibration; perfect for sane human subjects.
%       openeyelink HV5   % starts a simpler calibration; suggested for monkeys.
%
%    OPENEYELINK(ScreenResolution,BgColor)  opens EyeLink independently of CosyGraphics.

global COSY_EYELINK COSY_DISPLAY

%% %%%%%%%%%%%% PARAMS %%%%%%%%%%%%%% %%  <TODO: Params -> args>
edfFile = 'active.edf'; % Make sure the entered EDF file name is 1 to 8
%          characters in length and only numbers or letters are allowed.
%          Name used in Philippe's lab is 'active.edf'.
%
% <!v2-beta55: suppr. sacc params>
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%

%% Check EL not already open  <!v2-beta55>
if ~isempty('COSY_EYELINK') && isfilledfield(COSY_EYELINK,'isOpen') && COSY_EYELINK.isOpen
   dispinfo(mfilename,'warning','EyeLink has already be open and has not been properly closed. Running CLOSEEYELINK first...');
   closeeyelink;
end

%% Check Matlab version
v = version;
if v(1) <= '6'
    warning off MATLAB:m_warning_end_without_block
    warning off MATLAB:mir_warning_variable_used_as_function
end

%% Input Vars
if nargin && strcmpi(varargin{end},'-noevents')
    isEvents = 0;
    varargin(end) = [];
else
    isEvents = 1;  % default
end
switch length(varargin)
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

%% Init COSY_EYELINK var
COSY_EYELINK.isOpen = 0;
COSY_EYELINK.isDummy = 0;
if ~isfilledfield(COSY_EYELINK,'isCalibrated'), COSY_EYELINK.isCalibrated = 0; end
COSY_EYELINK.isRecording = 0;
COSY_EYELINK.isFileRecorded = 0;
COSY_EYELINK.isFileTransfered = 0;

%% Disp info
dispinfo(mfilename,'info','Opening connection to EyeLink PC...')

%% Init EyeLink
% Is CosyGraphics started ?
if exist('ScreenResolution','var')
    Width  = ScreenResolution(1);
    Height = ScreenResolution(2);
elseif isfield(COSY_DISPLAY,'isDisplay') && COSY_DISPLAY.isDisplay
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
    err = Eyelink('initialize');
    if err
        msg = 'Error in connecting to the eye tracker';
        dispinfo(mfilename,'error',msg);
        error(msg);
    else
        [v,vs] = Eyelink('GetTrackerVersion');
        dispinfo(mfilename,'info',[vs 'tracker initialized.  TCP/IP link open.']);
        f = find(ismember(vs,'0':'9'));
        COSY_EYELINK.EyelinkVersion = vs(f(1):f(end));
    end
else
    dispinfo(mfilename,'warning','')
    Eyelink('initializedummy');
    disp('         Eye position will be emulated by mouse position.')
end
% Set global vars
COSY_EYELINK.isOpen = 1;
COSY_EYELINK.isDummy = isDummy;

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
% Store PTB/EyelinkToolbox "el" structure in a CosyGraphics global variable.
COSY_EYELINK.EL = el;
% Set EyelinkToolbox colors. The background color must be the same for calibration and experiment,
% in order to have the same dilatation of the pupil. So, let's store CosyGraphics's current default
% background color into the "el" structure.
if exist('BgColor','var')
    bg = 255 * mean(BgColor);
elseif isfilledfield(COSY_DISPLAY,'BackgroundColor')
    bg = 255 * mean(rgb2gray(COSY_DISPLAY.BackgroundColor));
else
    bg = [.5 .5 .5];
    dispinfo(mfilename,'info','Background color not defined. Using medium gray as default.')
    dispinfo(mfilename,'info','Eyelink accuracy is better when background is the same during calibration and experiment.')
end
COSY_EYELINK.EL.backgroundcolour = round(bg);
if bg < .4,     COSY_EYELINK.EL.foregroundcolour = 255;
else            COSY_EYELINK.EL.foregroundcolour = 0;
end

%% SET UP TRACKER CONFIGURATION
% screen resolution
if Width > 0 % If display is open or if display resolution has been given as input arg..
    if isfilledfield(COSY_DISPLAY,'Offset'), Yoff = COSY_DISPLAY.Offset(2);
    else                                     Yoff = 0;
    end
    [w,h] = getscreenres;
    h = h - 2*abs(Yoff);
    helper_telleyelinkscreenres([w h], mfilename); % (must be after "COSY_EYELINK.isOpen = 1;")
else
    % Do nothing. Display resolution will be set by opendisplay.
end
% set parser (conservative saccade thresholds)
seteyelinksaccades; % set EL saccade to default values %<!v2-beta55>
% set EDF file contents; make sure that we get event data 
if isEvents 
    Eyelink('command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON');
    Eyelink('command', 'link_event_data   = GAZE,GAZERES,HREF,AREA,VELOCITY');
    Eyelink('command', 'link_event_filter = LEFT,RIGHT,BLINK,SACCADE,BUTTON'); % <v3-beta11: suppr. FIXATION. See SETEYELINKEVENTS.>
else
    Eyelink('command', 'file_event_filter = LEFT,RIGHT,MESSAGE');
    dispinfo(mfilename,'warning','EyeLink set in "no events" mode.')
end
Eyelink('command', 'link_sample_data  = LEFT,RIGHT,GAZE,HREF,AREA,GAZERES,STATUS');

% allow to use the big button on the eyelink gamepad to accept the
% calibration/drift correction target
Eyelink('command', 'button_function 5 "accept_target_fixation"');

%% Time offset  <v3-beta27>
COSY_EYELINK.TimeOffset = helper_measureeyelinktimeoffset;

%% Init other COSY_EYELINK fields
COSY_EYELINK.PreviousSample = [];

% %% Calibrate EyeLink  %<!v2-beta55: suppr.>
% if ~COSY_EYELINK.isCalibrated
%     if exist('CalibGrid','var')
%         if COSY_EYELINK.isDummy
%             dispinfo(mfilename,'warning','Dummy mode: skipping calibration procedure.')
%         else
%             calibeyelink('C','CalibGrid');
%         end
%     else
%         dispinfo(mfilename,'warning','Display not open. Cannot lauch calibration.')
%     end
% end

disp(' ')