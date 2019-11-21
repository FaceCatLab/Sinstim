function startcosy(Lib,varargin)
% STARTCOSY  Initialize CosyGraphics toolbox.
%    See STARTCOGENT to start CosyGraphics over CogentGraphics (CG).
%    See STARTPSYCH to start CosyGraphics over PsychToolBox (PTB).
%
%    STARTCOSY('Cog',...)  starts CosyGraphics over CogentGraphics (CG).
%    STARTCOSY('PTB',...)  starts CosyGraphics over CogentGraphics (CG).
%
% See also STOPCOSY, CLEARCOSY.
%
% Ben, 2007 - 2008

%    0.1    Sept. 07	First version, used for matlab meeting.
%                       Known bugs: fullscreen bugs, opt. 'keyboard' inverted, opt. 'mouse' doesn't work.
%    0.2	Oct.		Fix fullscreen mode. 24 -> 32bits. Bg white -> black is black (avoid flash).
%    -------------------
%    0.9.0	Nov.		Fix keyboard. Suppress Cogent2000 mouse support (We'll use CGMOUSE only).
%                       Default priority 'HIGH'. Two first input arg. become optionnal.
%                       Add arallel port. Always try to open serial port (no more optional).
%    0.9.1				Fix 0.9.0 (was not working) Suppress 'options' variable. Rewrite freq. computation.
%    -------------------
%    1.0   19/11/2007   First exp. Bruno (Cog2007 v1.2)
%    1.2   11/12        Provisory fix (!): NO MORE SERIAL PORT !!! (Crashes with laptops)
%                       Redo screen freq. computation if NumTestFrames > NumTestFrames_Old
%	 1.2.1 08/01/2008	Fix case when 'ScreenReqFreq' arg. not given. Fix default fg color.
%                       startcogent's version nï¿½ is now the same that the toolbox v. nï¿½. (1.1 became 1.2)
%	 1.2.2 24/01		isFullScreen -> Screen.
%    -------------------
%    1.3   30/01		Serial & Parallel port: Definitive fix: no more in startcogent. Use open*port.
%    	   				Set path at startup.
%    1.3.2 05/03		Help corrections.
%    -------------------
%    1.4   10/03		Make glabgoc.txt file.
%                       Define global variable in base workspace.
%    -------------------
%    1.5   28/03		Review screen freq. measuring & checking.
%	 1.5.2 21/05		Add "Cogent*\Cogent2000\Obsolete-Replaced" to path.
%	 1.5.3 21/05		Add "Cogent*\PsychToolBox" to path.
%    1.5.6 17/09		Input arg.: Default first arg. = 0. Use -1 or 'nodisplay' value to start 
%                       without display.
%						Add "Cogent*\Legacy" to path.
%	 1.5.7 ?/09			Moved path setup to 'setupcosy'.
%						Fix 'startcogent NoDisplay'.
%						Fix pseudo-random nuber genration: Initialize Matlab random generator.
%    -------------------
%    1.6				Fix command syntax.
%    1.6.2              Fix priority.
%    ===================
%    2-alpha5           STARTCOGENT -> STARTCOSY !
%    2-beta4            Fix opendisplay/openkeyboard chick and egg problem (Cog). See comment in code.
%
%    See COSYVERSION for later versions info.


cosyglobal % Use cosyglobal to be sure no var is forgot: global var init bugs are uneasy to identifiate.
% evalin('base','cosyglobal') % <v1.4> <Suppr. v3-alpha6>

% %%%%%%%%%%%%%%%%%%%%%PARAMETERS%%%%%%%%%%%%%%%%%%%%  <suppr. v2-beta49>
% KeyboardTimeRes = [1 4]; % [Exclusive NonExclusive] (ms)
% KeyboardQueueLength = 100;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% INPUT ARG.
% "Lib" argument <v2-beta29>
LibVersion = [];
if ~nargin || ~ischar(Lib) % Lib missing..
    error('Input argument "Lib" has not been given.')
elseif ~strncmpi(Lib,'Cog',3) && ~strncmpi(Lib,'PTB',3) % Lib invalid..
    error(['Invalid "Lib" input argument: unknown ''' Lib ''' library.'])
else % Valid lib :-)
    % Is it a version number ?
    if any(ismember(Lib,'0':'9'));
        f = find(ismember(Lib,'0':'9'));
        LibVersion = Lib(f(1):end);
        Lib = Lib(1:3);
    end
    % Ensure std lib name / remove version from lib name
    if strncmpi(Lib,'Cog',3),       Lib = 'Cog';
    elseif strncmpi(Lib,'PTB',3),	Lib = 'PTB';
    end
end
if strcmp(Lib,'Cog') && ~ispc
    error('Cogent is only supported on MS-WIndows.')
end
if strcmp(Lib,'Cog')
    v = vstr2vnum(version);
    if v(1) == 7 && v(2) == 1
        str1 = 'You are using MATLAB 7.1. There is an issue with this version of MATLAB: it needs a special version of Cogent.';
        str2 = 'You can continue, but without guanranty of proper functionning.  Press enter to continue...';
        dispinfo(mfilename,'warning',str1);
        dispinfo(mfilename,'warning',str2);
    end
end
% "keep display" option ? <v2-beta23>
doKeepDisplay = 0;
for f = 1 : findoptions(varargin)
    if strcmpi(varargin{f},'-keep')
        doKeepDisplay = 1;
        varargin(f) = [];
    end
end
% Command Syntax
for arg = 1 : min(length(varargin),2)
	if ischar(varargin{arg}), varargin{arg} = str2num(varargin{arg}); end
end
% Check arg consistency
if nargin>1 && length(varargin{1}) > 1
    error('Screen number argument is missing.')
end
% Is Display ?
if ~isempty(varargin) && (isequal(varargin{1},-1) | strcmpi(varargin{1},'-nodisplay')), isDisplay = 0;
else                                                                                    isDisplay = 1;
end
% Is Exclusive Keyboard ?
isExclusiveKeyboard = 0;
if ~isempty(varargin) && (strcmpi(varargin{end},'ExclusiveKeyboard') || strcmpi(varargin{end},'-exclusivekeyboard'))
	isExclusiveKeyboard = 1;
	varargin(end) = [];
end
% Backward comp. with v0.1 demos:
if length(varargin) >= 3 && strcmpi(varargin{3},'keyboard')
	varargin(3) = []; % Just drop it.
end

%% STOP G-LAB IF ALREADY RUNNING
if isopen('cosygraphics') % <v2-beta21: Add this test; v2-beta43: rewrite it with isopen>
    disp(' ')
    dispinfo(mfilename,'info','CosyGraphics already open. First closing previous session...')
    stopcosy;
end

%% DISP INFO
%                     |¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|
%                     |                C O S Y   G R A P H I C S               |
%                     |                    version 3-beta##                    |
%                     |________________________________________________________|
disp(' ')
disp(' ')
dispbox({'C O S Y   G R A P H I C S'; ['version ' vnum2vstr(cosyversion)]}, 14, 16, 1);
disp(' ')
disp('              Benvenuto JACOB, Institute of NeuroSiences, Univ. Catholique de Louvain.')
disp(' ')
switch upper(Lib(1))
    case 'C',   libname = ['Cogent, version ' vnum2vstr(getcosylib('Cog','version'))];
    case 'P',   libname = 'PsychToolBox';
    otherwise error('Invalid library.')
end
disp(' ')
dispinfo(mfilename,'info',['Starting CosyGraphics, version ' vnum2vstr(cosyversion) ', over ' libname '...'])
disp(' ')

%% LIBRARIES & PATH <v1.3, rewritten in 1.5, moved to setupcosy in 1.5.7>
% For Cogent: set version to be used: <v2-beta29>
switch Lib
    case 'Cog'
        % < v2-beta29: set Cogent version here.
        %  Default is now always 1.29, because of 'dontclear' bug in 1.25 (see displaybuffer)> <v2-beta51: 1.29 -> 1.30>
        if isempty(LibVersion)
            LibVersion = '1.30';
        end
        setcosylib('Cog',vstr2vnum(LibVersion)); % set version
    case 'PTB'
        % Do nothing: setcosylib will set the correct defaults: <same behaviour as v2-beta28 and prior>
        % - Cog-1.25 on ML-6.5,  because most Cogent2000 v1.25 functions run independantly of a CogentGraphics window.
        % - Cog-1.29 on ML-7.5,  because v1.25 does not run on ML-7.5.
end

% Run setupcosy to ensure that Matlab path is correct:
setupcosy;
cosyglobal % setupcosy calls clearcosy in case lib version has changed: re-run cosyglobal

%Init PTB
if isfield(COSY_GENERAL,'isPTBInstalled')
    COSY_GENERAL = rmfield(COSY_GENERAL,'isPTBInstalled');
end
if isptbinstalled % Is PTB installed ?
    COSY_GENERAL.isPTBInstalled = true;
    
    % Initialize MatlabOpenGL:
    % "Call this function at the beginning of your experiment script before
    % calling *any* Psychtoolbox Screen() command."  <TODO: put it in SETCOSYGRAPHICS !!!>
    try
        InitializeMatlabOpenGL;
    catch
        dispinfo(mfilename,'error','Failed to initialize Matlab OpenGL (MOGL)!  Error masseage was:');
        lasterr
    end

else
    COSY_GENERAL.isPTBInstalled = false;
    if strcmpi(Lib,'PTB'),  error('PsychToolBox is not installed.');
    else                    dispinfo(mfilename,'warning','PsychToolBox is not installed.');
    end
    
end

% Set library: PTB/Cog
setcosylib(Lib);
setcosylib('Sound',Lib); % <v3-beta13: Moved from startpsych to here. (Was not in startcogent !!)>
if ispc
    cgloadlib; % Init CogentGraphics (and Cogent2000 if v1.28+)
end

%% GLOBAL VARIABLES <must come after setupcosy>
% store CosyGraphics's version. <v2-beta21>
COSY_GENERAL.CosyGraphicsVersion = vnum2vstr(cosyversion); % <NB: Used dirctly by setupcosy.>
% COSY_GENERAL.LIBRARIES.VERSIONS.CosyGraphics = vstr2vnum(cosyversion); % <suppr. because it crashes getcosylib at CosyGraphics startup>

% Store values
COSY_DISPLAY.doKeep = doKeepDisplay;

% Init variables
COSY_TRIALLOG.iTrial = 0;
COSY_TRIALLOG.isStarted = false; % trial not started
COSY_TRIALLOG.isWaitingFirstFrame = false;
COSY_TRIALLOG.InterTrialDuration = 0;

% Reset Flags
COSY_GENERAL.isAborted = false;
COSY_GENERAL.doDispEvents = 1; % 0: don't display, 1: display after trial / don't display if not in trial, 2: display during trial.

% User script name
% Get user script name -if there is one- and store it global var
s = dbstack;
% s(1) is 'startcosy',... , s(end) is the script of the user,  if there is one.
name = s(end).name;
if ~strcmpi(name,'startcosy') && ~strcmpi(name,'startcogent') && ~strcmpi(name,'startpsych')
    COSY_GENERAL.UserScript = name;
else
    COSY_GENERAL.UserScript = '';
end

%% INIT. MATLAB
% Init. random generator (See 'help rand'):
dispinfo(mfilename,'info','Initializing MATLAB''s pseudo-random number generator with a unique seed...')
seed = sum(100*clock);
rand('state',seed);
COSY_GENERAL.RandomSeed = seed; % conserve it, just in case, to be able to reproduce an experiment

% Disable JIT acceleration <v2-beta23>
%   Functions, are precompiled and optimized by Matlab's JIT compiler at load time, and during 
% execution, so they are faster. One problem of dynamic optimization at runtime ("hot spot 
% optimization") is that loops in your code may execute slower during the first few iterations 
% than in the remaining iterations, because they are optimized during runtime. 
%   Tests on Sinstim 1.6.5 showed important slow-down on fist iteration on M7.5/WinXP and critical 
% slow-down on M7.6/Ubuntu9.4. (Slow-down is neglectable on M6.5/WinXP.) No improvement were shown 
% on median execution time, nor on maximum execution time !!! and this, on both M6.5 and M7.5.
%   Conclusion: Let's disable the JIT acceleration on MATALB 7.x. <TODO: What about M6.5 ?>
v = version;
if v(1) >= 7
    dispinfo(mfilename,'info','Disabling MATLAB''s just-in-time (JIT) acceleration...')
    feature accel off
%     COSY_GENERAL.isJIT = 0;
else
%     COSY_GENERAL.isJIT = 1;
end

% Disable Matlab 7 warning messages due to case inconsistency in Cogent
dispinfo(mfilename,'info','Disabling MATLAB''s case sensitivity check...')
warning off MATLAB:dispatcher:InexactMatch % <TODO: find better solution.>

%% PRECOMPILE FUNCTIONS <todo: revoir!>
time;
wait(0);
if isptbinstalled
    GetSecs;
    WaitSecs(0); 
end
if iscog
    cogstd('sGetTime',-1);
end
isptb;
iswin;
islinux;
isosx;
isos9;
isoctave;

%% SYNCHRONIZE TIMERS
dispinfo(mfilename,'info','Synchronizing low res. and high res. timers...')
setpriority REALTIME -silent
try
    GetSecs;
    ok = 1;
catch
    ok = 0;
end
if ispc && ok
    tic
    dt = inf;
    while dt >= 1 % while diff > 1 ms
        cogstd('sGetTime',GetSecs);
        dt = round( abs( cogstd('sGetTime',-1) - GetSecs ) * 100000) / 100;
        if toc > 2 % Timeout: 2 sec
            warning(['STARTCOSY: FAILED TO SYNCHRONISE TIMERS.' 10 ...
                'Error is ' num2str(dt) ' msec.'])
            break % !
        end
    end
else
    dt = NaN;
end
tTimersSync = time;
setpriority NORMAL -silent
if dt < 1
    dispinfo(mfilename,'info',['Done. Error is ' num2str(dt) ' ms.'])
end
dispinfo(mfilename,'debuginfo',['dt = ' num2str(dt) ' ms.'])

%% INIT. PTB KEYBOARD
% Chick & egg problem: CogInput 1.28+ cannot be run before cgopen (contrary to v1.25) but OPENDISPLAY 
% needs keyboard for message screens, if any. So, openkeyboard is ran a first time before opendisplay  
% with 'PTB' arg. to init PTB keyboard only with default settings, then a second time to init keyboard 
% with definitive settings. <v2-alpha4>
openkeyboard('PTB','-init');

%% INIT. DISPLAY !
if isDisplay && (~doKeepDisplay || ~isopen('display'))
	err = opendisplay(varargin{:});  % !
    if err 
        return % !!!
    end
elseif doKeepDisplay
    COSY_DISPLAY.isDisplay = 1;
else
    COSY_DISPLAY.isDisplay = 0;
end

%% INIT. KEYBOARD
% Inti kb with definitive settings. (See "Chick & egg problem" above.)
openkeyboard; 

%% INIT. SCORE MODULE <???>
openscore;

%% SET FLAG
COSY_GENERAL.isStarted  = true;
COSY_GENERAL.wasStarted = true; % <v2-beta23, replaces COSY_FIRST_START_DONE, suppressed in v2-beta21.>
 
%% SET PROCESS PRIORITY
% In case the user forget to set it in his script, we prefer to have CosyGraphics running in HIGH priority
% by default.
disp(' ')
setpriority OPTIMAL  % <suppr. 2-beta23 / restored 2-beta39>

%% TEST TIMER DRIFT <suppr. 2-beta39 (did not work)>
% if ispc
%     elapsed = (time - tTimersSync) / 1000; % (sec)
%     dt = round( abs( cogstd('sGetTime',-1) - GetSecs ) * 100000) / 100;
%     drift = dt * 60 / elapsed; % ms / min
%     if drift > 5, type = 'warning';
%     else          type = 'info';
%     end
%     drift = round(drift*10) / 10;
%     dispinfo(mfilename,'debuginfo',['dt after ' num2str(elapsed) ' s: dt = ' num2str(dt) ' ms.'])
%     % dispinfo(mfilename,type,['Timer drift test: Drift = ' num2str(drift) ' ms per min.'])
% end

%% DISPLAY VERSION AND INFOS
disp(' ')
dispinfo(mfilename,'info',['CosyGraphics v' vnum2vstr(cosyversion) ' ready.'])
disp(' ')
dispbox({['CosyGraphics v' vnum2vstr(cosyversion) ' ready.']; ...
    'To get help, type:  cosyhelp'}, 14, 16, 1);
disp(' ')
% dispinfo(mfilename,'info','To get help, type:')  % <suppr. v3-beta27>
% disp(' ')
% disp('       cosyhelp    % to get the list of functions, with a short description.')
% % disp('       cosymanual  % to edit the complete reference manual.') %<v3-alpha5: suppr.>
% disp(' ')

if ~isptbinstalled
    dispinfo(mfilename,'warning','Without PsychToolBox installed, CosyGraphics runs with limited functionalities,');
    dispinfo(mfilename,'warning','if you are on MATLAB 64 bits, it''s the best you can get (unless you install a 32 bits version),');
    dispinfo(mfilename,'warning','if you are on MATLAB 32 bits, please install the PsychToolBox.');
    disp(' ')
end
