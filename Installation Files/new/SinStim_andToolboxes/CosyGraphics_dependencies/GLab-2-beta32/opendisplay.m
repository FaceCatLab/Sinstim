function err = opendisplay(varargin)
% OPENDISPLAY  Open G-Lab display, in full screen or in a window.
%   OPENDISPLAY  starts display with default parameters.
%
%   OPENDISPLAY(Screen)  starts display in given screen. 'Screen' value can be 0   
%   (displayin a window), 1 (full screen display on main screen), 2 (full screen  
%   display on secondary screen), 3 (on screen #3), etc. 
%
%	OPENDISPLAY(Screen,DisplayRes)  starts display at given screen resolution. Default 
%   'DisplayRes' value is [800 600].
%
%   OPENDISPLAY(Screen,ScreenRes,BgColor)  starts display with BgColor as default 
%   background color. BgColor is an RGB triplet in the range 0.0 to 1.0.
%
%   OPENDISPLAY(Screen,ScreenRes,<BgColor>,ScreenReqFreq)  checks that the actual 
%   screen frequency matches the frequency that was requested to the operating system. 
%   ScreenReqFreq must have the same value than in the OS configuration. The BgColor 
%   argument is optionnal.
%
%   OPENDISPLAY(Screen,ScreenRes,<BgColor>,ScreenReqFreq,NumTestFrames)  specifies 
%   the number of frames to be displayed to do the screen frequency measure, which is done
%   at first start. The higher the NumFrames value, the higher the precision of the measure.
%   This is critical for EEG experiments. If NumTestFrames = 0, no test is done ; nominal 
%   value is kept as it. 
%
% CogentGraphics only:
%   OPENDISPLAY(...,'AlphaMode')  configurates display to have offscreen buffers in RAM 
%   instead of VRAM. This greatly increase CogentGraphics' alpha blending performances. 
%   Unfortunately, even with this hack, performances stay to low for us. Usage of RAM
%   buffers can also creates synchro problems !!! This mode has no effect on PTB.
%
% See also STARTGLAB, STARTCOGENT, STARTPSYCH, OPENSOUND, OPENKEYBOARD, OPENSERIALPORT, 
%   OPENPARALLELPORT, STOPGLAB.

% Ben, March 2008


global GLAB_DISPLAY GLAB_BUFFERS
persistent Old

err = 0;


%%%%%%%%%%%%%%%%%%%%%PARAMETERS%%%%%%%%%%%%%%%%%%%%
NumFramesForQuickTest = 50;
MaxNumOfQuickTests = 4;
ScreenFreqTolerance = 1;
FontName = 'Arial';
FontSize = 24;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% INPUT ARG.
%%%%%%%%%%%%%%%%%%%%%PARAMETERS%%%%%%%%%%%%%%%%%%%%
% Defaults:
ScreenNum     = 0;
DisplayRes    = [800 600];
ScreenReqFreq = [];
NumTestFramesFullscreen = 600;
NumTestFramesWindowed   =  60;
if iscog,   BgColor = [0 0 0]; % Default background color: black, to avoid flashes if we reset to black later.
else        BgColor = [1 1 1]; % Default background color: white, to avoid flashes if we reset to white later.
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% ******************************************************************************* %%
%%                             PART I. OPEN DISPLAY                                %%
%% ******************************************************************************* %%


% Disp
disp(' ')
if iscog, str = 'Opening Cogent display... ------------------------------------------------------';
else      str = 'Opening PsychToolBox (PTB) display... ------------------------------------------';
end, 
dispinfo(mfilename,'info',str);

% Alpha Mode (CG only):
isAlphaMode4CGMode = 0;
for a = length(varargin) : -1 : 1
    if ischar(varargin{a})
        if strcmpi(varargin{a},'AlphaMode')
            if iscog
                v = getlibrary('CG','Version');
                if v(2) == 24
                    error('Alpha blending not supported by CogentGraphics 1.24')
                end
                isAlphaMode4CGMode = 1;
            elseif isptb
                isAlphaMode4CGMode = 1;
            end
        else
            varargin{a} = str2num(varargin{a}); % Command syntax.
        end
    end
end

% ScreenNum, DisplayRes, BgColor, ScreenReqFreq, NumTestFrames
if length(varargin) >= 1, ScreenNum  = varargin{1}; end
if length(varargin) >= 2, DisplayRes = varargin{2}; end
if length(varargin) >= 3 && length(varargin{3}) == 3
    BgColor = varargin{3};
    varargin(3) = []; % BgColor is optionnal, for backward compat.
end
if length(varargin) >= 3, ScreenReqFreq = varargin{3}; end
if length(varargin) >= 4
    NumTestFrames = varargin{4}; 
elseif ScreenNum
    NumTestFrames = NumTestFramesFullscreen;
else
    NumTestFrames = NumTestFramesWindowed;
end

% ScreenNum & DisplayRes
if length(DisplayRes) == 1
	DisplayRes(2) = round(DisplayRes * 3/4);
end

if iscog % CG: Supports only a few std resolutions. <todo: v1.28: support arbitary resolution>
    SupportedDisplayRes = [ 640 480; 800 600; 1024 768; 1152 864; 1280 1024; 1600 1200 ];
    if isempty(find(SupportedDisplayRes(:,1)*100 + SupportedDisplayRes(:,2) ...
            == DisplayRes(1)*100 + DisplayRes(2))) % if resolution is not supported..
        str0 = ['Unsupported screen resolution.'; ...
                'Supported resolutions are :   '; ...
                '                              '];
        str1 = repmat(' ',6,4);
        str2 = num2str(SupportedDisplayRes);
        str3 = repmat(' ',6,size(str0,2) - size(str2,2) - 4);
        errordlg([str0; str1 str2 str3]);
        return
    end
    
elseif isptb % PTB: 
    switch length(DisplayRes)
        case 2,     WindowRect4PTB = [100 22 100 22] + [0 0 DisplayRes];  
        case 4,     WindowRect4PTB = DisplayRes;
                    DisplayRes = WindowRect4PTB(3:4) - WindowRect4PTB(1:2);
        otherwise   error('Invalid argument ''DisplayRes''.')
    end
    
end

% GLOBAL VAR.
GLAB_DISPLAY.Screen = ScreenNum;
GLAB_DISPLAY.isDisplay = false;
GLAB_DISPLAY.Resolution = DisplayRes;
GLAB_DISPLAY.ScreenSize_cm = [];
GLAB_DISPLAY.ViewingDistance_cm = [];
GLAB_DISPLAY.BackgroundColor = BgColor;
GLAB_DISPLAY.CurrentDisplayDuration = [];
GLAB_DISPLAY.isAlphaMode4CG = isAlphaMode4CGMode;
GLAB_BUFFERS.OffscreenBuffers = [];
GLAB_BUFFERS.DraftBuffer = [];
GLAB_BUFFERS.BlankBuffer = [];
GLAB_BUFFERS.BackgroundBuffer = [];
GLAB_BUFFERS.CurrentBuffer = 0;
GLAB_BUFFERS.LastDisplayedBuffer = 0;
GLAB_BUFFERS.isTexture = logical([]);

% Init Persitent var.
if isempty(Old)
    Old.ScreenNum = -1;
    Old.ScreenReqFreq = -1;
    Old.NumTestFrames = -1;
end

% OPEN DISPLAY !
if iscog % CG
    % Open Display
    res = find(SupportedDisplayRes(:,1) == DisplayRes(1));
    nbits = 32; % 8bits not supported by Cog2007, 16bits is of no use, 24bits have pb with some graphics card ==> 32bits!
    if isAlphaMode4CGMode
        cgopen(res,32,0,ScreenNum,'Alpha');
    else
        cgopen(res,32,0,ScreenNum);
    end
    GLAB_DISPLAY.isDisplay = true;
    clearbuffer;
    displaybuffer;
    
    % Setup Drawing
    cgscale; % unit = pixel
    cgpencol(0,0,1); % Draw color: BLUE, to avoid black on black (or white on w.) display bug
	cgfont(FontName,FontSize);
    
    % On CG, the backbuffer is referenced by the number 0. Multiple displays are 
    % not supported.
    GLAB_BUFFERS.BackbufferOfOnscreenWindow = 0;
    
else % PTB
    % We may call Psychtoolbox commands available only in OpenGL-based 
    % versions of the Psychtoolbox. The Psychtoolbox command AssertPsychOpenGL will issue
    % an error message if someone tries to execute this script on a computer without
    % an OpenGL Psychtoolbox.
    try, AssertOpenGL; end
    
    % Fix PTB Screen Number: Many bugs on different platform/configurations, let's try to
    % fix it and get a valid number.
    if ScreenNum < 2
        if ispc % MS-Windows
            if any(Screen('Screens') == 1) 
                ScreenNum4PTB = 1; % Cheops: bug if 0
            else
                ScreenNum4PTB = 0; % PSP exp. PC with mirror display: only 0 available.
            end
        else    % Linux  <TODO: MacOS X case>
            ScreenNum4PTB = 0; % Ubuntu Hardy with Cinerama, on Cheops: bug with 1 & 2.
        end
    else
        ScreenNum4PTB = ScreenNum; % Let's suppose that user knows what he's doing.
    end
    GLAB_DISPLAY.ScreenNumber4PTB = ScreenNum4PTB;
    GLAB_DISPLAY.WindowRect4PTB = WindowRect4PTB;
    
    % Set Screen Resolution
    if ScreenNum
        s = Screen('Resolution',ScreenNum4PTB,DisplayRes(1),DisplayRes(2));
        GLAB_DISPLAY.SAVE_OS_SETTINGS.Resolution = [s.width s.height];
        GLAB_DISPLAY.SAVE_OS_SETTINGS.BitsPerPixel = s.pixelSize;
        GLAB_DISPLAY.SAVE_OS_SETTINGS.Frequency = s.hz; % <!DEBUG: 60Hz au lieu de 75Hz: investiguer!>
    end
    
    % Open Display
    BgColor = round(BgColor * 255);
    if ScreenNum % Full Screen
        w = Screen('OpenWindow',ScreenNum4PTB,BgColor,[]);
    else         % Windowed
        w = Screen('OpenWindow',ScreenNum4PTB,BgColor,WindowRect4PTB);
    end
    GLAB_DISPLAY.isDisplay = true;
    
    % Onscreen Window
    % On PTB, a backbuffer is referenced by the handle of it's onscreen windows.
    % Multiple displays are supported by PTB, so we can have several onscreen 
    % windows, each with it's own backbuffer. We do not support multiple displays
    % currently, but we will do, ...one day.
    GLAB_BUFFERS.BackbufferOfOnscreenWindow = w; % This will be used by gcw.
    
    % Mouse: 
    % - Is it an X offset?
    % PTB's mouse support is incomplete on Windows and Linux. Mouse co-ordinates are desktop-relative 
    % co-ordinates, while we wanted window-relative co-ord. That means we have an offset in two cases:
    % when displaying in a window, and when displaying full-screen on the right screen of a dual-screen 
    % setup. We'll store this offset in "GLAB_DISPLAY.MouseOffset4PTB".
    GLAB_DISPLAY.MouseOffset4PTB = [0 0];
    screens = Screen('Screens');
    if ScreenNum == 0 % Windowed display
        GLAB_DISPLAY.MouseOffset4PTB = WindowRect4PTB(1:2); % Offset = offset of the window.
    elseif max(screens) > 1  % Full screen display on a dual-screen PC:
        if max(screens) > 2
            error('No support fore more than 2 screens.') % <Quick hack: Comment this line and set the active screen on the left.>
        end
        [x,y] = PtbGetMouse;
        if x > DisplayRes(1) % We are on the right part of the desktop ==> Active screen is the right one.
            otherscreen = 3 - ScreenNum;
            [w0,h0] = Screen('WindowSize',otherscreen);
            GLAB_DISPLAY.MouseOffset4PTB = [w0 0]; % X offset = width of the left monitor.
        end
    end
    % - Get rid of the cursor
    setmouse out; % put it on the lower-right corner
    
	% Setup Drawing
    Screen('TextStyle',gcw,0); % Default PTB text is Bold on MS-Windows.
	settext('FontName',FontName,'FontSize',FontSize,'FontColor',[0 0 1 1]);
    
    % Enable Alpha Blending
    % See "Screen('BlendFunction','?')", "help PsychAlphaBlending" for infos.
    ok = Screen('BlendFunction',gcw,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
    
    % Initialize OpenGL. We need it for the image processing. <v2-beta23>
    if ~IsLinux % <v2-beta27: It crashes on Linux (Ubuntu Lucid)>
        InitializeMatlabOpenGL([], [], 1);
    end
    
    % Load shaders from file <v2-beta23. Update shader list if other shaders used!!>
    % We use a modified version of PTB's function LoadGLSLProgramFromFiles to pre-load shaders from
    % file now to store them into GLAB_DISPLAY, thus avoiding HD calls during RT.
    if ~IsLinux % <v2-beta27: It crashes on Linux (Ubuntu Lucid)>
        dispinfo(mfilename,'info','Loading and building OpenGL shaders...')
        verbose = 1;
        names = {'Convolve2DRectTextureShader.frag.txt',... % used by Add2DConvolutionToGLOperator>EXPCreateStatic2DConvolutionShader
            'Convolve2DRectTexture1ChannelShader.frag.txt',... % id.
            };
        GLAB_DISPLAY.ShaderFiles = {};
        GLAB_DISPLAY.ShaderHandles = [];
        for i = 1 : length(names)
            h = LoadGLSLProgramFromFiles(names{i}, verbose, [], 1); % modified PTB function
            GLAB_DISPLAY.ShaderFiles{i} = names{i};
            GLAB_DISPLAY.ShaderHandles(i) = h;
        end
    end

end

% Onscreen Window
% On PTB, a backbuffer is referenced by the handle of it's onscreen windows.
% Multiple displays are supported by PTB, so we can have several onscreen 
% windows, each with it's own backbuffer. We do not support multiple displays
% currently, but we will do, ...one day.
if isptb
    w = Screen('windows');
    if isempty(w)
        error('No open onscreen window')
    end
    GLAB_BUFFERS.BackbufferOfOnscreenWindow = w(1); % This will be used by gcw.
else % CG: Always return 0 (handle of the backbuffer).
    GLAB_BUFFERS.BackbufferOfOnscreenWindow = 0;
end

% Create Draft Buffer:
% The draft buffer is used on PTB to draw draft character string get font metrics 
% before actual text draw. On CG, we don't use the draft buffer, for the moment.
GLAB_BUFFERS.DraftBuffer = newbuffer;
% The Blank buffer is an empty buffer with only background. It'll be kept consistent
% with background color by SETBACKGROUND.
GLAB_BUFFERS.BlankBuffer = newbuffer;
selectbuffer(0);

disp(' ')

% First run: Set screen size and viewing distance
% - Set physical screen size
if ~isfilledfield(GLAB_DISPLAY,'ScreenSize_cm')
    getscreensizecm; % will fill GLAB_DISPLAY.ScreenSize_cm if OS can give values.
end
% - Set viewing distance to default value of 360/(2*pi) = 57.2958 cm.
if ~isfilledfield(GLAB_DISPLAY,'ViewingDistance_cm')
    setviewingdistancecm(57);
end

% EyeLink: Tell EyeLink the screen resolution
Width  = DisplayRes(1); % <NB: use same var names than openeyelink to permit copy/paste of
Height = DisplayRes(2); %      the 2 command lines below, in case of modif.               >
if isopen('eyelink')
    EyeLink('command', 'screen_pixel_coords = %ld %ld %ld %ld', 0, 0, Width-1, Height-1);
    EyeLink('message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, Width-1, Height-1);
end


%% ******************************************************************************* %%
%%                           PART II.  FREQ TESTINGS                               %%
%% ******************************************************************************* %%

% Disp
disp(' ')
dispinfo(mfilename,'info','Beginning display testing...')

% RAISE PRIORITY BEFORE TESTS
OldPriority = getpriority;
setpriority OPTIMAL                    %  <--- CHANGE PRIORITY ---!!!

% REQUESTED REFRESH FREQUENCY
if isempty(ScreenReqFreq) % ScreenReqFreq not given as argument..
	doVerify = 0;
	if ~isfilledfield(GLAB_DISPLAY,'MeasuredScreenFrequency') % If it's first start..
		% Take a measure as a provisory estimation
		% (needed by measurescreenfreq to display computation time)
		ScreenReqFreq = measurescreenfreq(NumFramesForQuickTest);
	else
		ScreenReqFreq = GLAB_DISPLAY.RequestedScreenFrequency;
	end
	
else % ScreenReqFreq given
	doVerify = 1;
	GLAB_DISPLAY.RequestedScreenFrequency = ScreenReqFreq;
    
end

% MEASURE ACTUAL REFRESH FREQUENCY
if NumTestFrames
    if Old.ScreenNum < 0 ...                                  % If it's first startup..
            || ((ScreenNum ~= Old.ScreenNum) & ScreenNum) ... % or screen has changed (and not for a window)..
            || ScreenReqFreq ~= Old.ScreenReqFreq ...         % or user has requested another frequency..
            || NumTestFrames > Old.NumTestFrames              % or user wants more test frames..

        % Measure
        [Freq1,Freq2,Freq3] = measurescreenfreq(NumTestFrames,NumFramesForQuickTest,ScreenReqFreq);
        
        % Store var.
        GLAB_DISPLAY.MeasuredScreenFrequency = Freq1;
%         dispinfo(mfilename,'info',['Measured screen frequency: ' num2str(Freq1) ' Hz.']);
        if ~doVerify % 'ScreenReqFreq' arg. was not given..
            % Round freq. to closest standard freq., which --we guess-- was the requested one:
            if 71 < Freq1 && Freq1 < 73.5, ScreenReqFreq = 72;
            else ScreenReqFreq = 5 * round(Freq1 / 5);
            end
            GLAB_DISPLAY.RequestedScreenFrequency = ScreenReqFreq;
        end
        Old.ScreenNum = ScreenNum;
        Old.ScreenReqFreq = ScreenReqFreq;
        Old.NumTestFrames = NumTestFrames;
        
        % Check Errors
        if doVerify && abs(Freq1 - ScreenReqFreq) >= ScreenFreqTolerance
            dispinfo(mfilename,'warning','Screen frequency is not what we where waiting for!')
            str = { ['Measured screen frequency is ' num2str(Freq1) ' Hz'];...
                    ['and it was supposed to be ' int2str(ScreenReqFreq) ' Hz.'];...
                    '';...
                    'Maybe you simply forgot to change the screen frequency setting.';...
                    'If it''s not the case, you have either a hardware problem';...
                    'or an operating system problem:';...
                    '';...
                    'Please check Windows screen settings :';...
                    '    Desktop (right click)  �> Properties  �> Settings ';...
                    '    �> (click on screen image if you have more than one)';...
                    '    �> Advanced  �> Monitor';...
                    '';...
                    'Check also that the screen driver is installed and enabled.';...
                    'To enable the screen driver :';...
                    '    My Computer (right click)  �> Properties  �> Hardware';...
                    '    �> Device manager  �> Monitor (right click)';...
                    '    �> Scan for hardware changes'};
            err = displaywarning(str); % default choice: err = 1
            
        elseif doVerify && abs(Freq2 - Freq1) >= ScreenFreqTolerance
            str = {'Screen synchronisation problem.'};
            dispinfo(mfilename,'error',str)
            err = displayerror(str);
                    
%         elseif doVerify && abs(Freq3 - Freq1) >= ScreenFreqTolerance * 2
%             str = {'Performance issue.';...
%                         '';...
%                         'It seems that your graphics hardware is not fast enough';...
%                         'for all operations.'};
%             err = displaywarning(str);
        end
        
    else % Measure done in previous startup: Just quickly check that no config. change occured
        
        for z = 1 : MaxNumOfQuickTests
            Freq1 = measurescreenfreq(NumFramesForQuickTest);
            if abs(Freq1 - GLAB_DISPLAY.MeasuredScreenFrequency) < ScreenFreqTolerance
                break % !
            end
        end
        
        if abs(Freq1 - GLAB_DISPLAY.MeasuredScreenFrequency) > ScreenFreqTolerance % Still different after last test..
            l1 = 'It seems that screen frequency has changed :';
            l2 = ['it was ' int2str(round(getscreenfreq)) ' Hz at G-Lab startup and it is now ' int2str(round(Freq1)) ' Hz.'];
            l4 = 'If you''ve modified the monitor settings in Windows,';
            l5 = 'please modify accordingly the ''ScreenRequestedFreq'' parameter in your program.';
            l7 = 'If you want to continue, just press Enter, but frequency will be WRONG !!!.';
            if nargin >= 3, str = {l1;l2;'';l4;l5;'';l7}; 
            else            str = {l1;l2;'';l7};
            end
            err = displaywarning(str); % default choice: err = 0
            if ~err
                ScreenReqFreq = Freq1; % (provisory)
                doVerify  = 0; % We already know it'll be wrong.
                doMeasure = 1; % Redo measure !
            end
        end
        
    end
    
    % If error: Abort everything !
    if err
        errordlg(str)
        clearglab % === !!!!!
        return % --- !!!
    end
    
else % NumTestFrames=0: Don't test.
    GLAB_DISPLAY.MeasuredScreenFrequency = ScreenReqFreq;
    
end

% BACK OT OLD PRIORITY
setpriority(OldPriority)              %  <--- CHANGE PRIORITY ---!!!

% RESET LAST DISPLAY TIME
GLAB_DISPLAY.LastDisplayTime = [];
    
% PRECOMPILE FUNCTIONS
getscreenres;
getframedur;
waitsynch(0);
waitframe(0);
gcw;

% OUTPUT
if ~nargout, clear err, end

% DONE
disp(' ')
if iscog, msg = 'Cogent display is open. --------------------------------------------------------';
else      msg = 'PsychToolBox display is open. --------------------------------------------------';
end
dispinfo(mfilename,'info',msg)
disp(' ')


%% *************************** SUB-FUNCTIONS ************************** %%

%% MEASURESCREENFREQ  Measure actual screen refresh frequency.
function [Freq1,Freq2,Freq3,Times1,Times2,Times3] = measurescreenfreq(NumFrames1,NumFrames2,ReqFreq)
% MEASURESCREENFREQ  Measure actual screen refresh frequency.
%    This function is lauched by STARTGLAB at first cogent startup, it computes the 
%    real screen frequency; STARTGLAB will and check it's consistency with the 
%    theoretical frequency. In case of mismatch, a error dialog box will be displayed.
%    Measured frequency will then be available trough GETSCREENFREQ.
%    This function doesn't modify any global variable.
%
%    1) Initial Full Measure:
%    Freq1 = MEASURESCREENFREQ(NumFrames1,NumFrames2,ReqFreq)  where 'NumFrames1' is  
%    the number of frames to be displayed to do the frequency measure (using cgflip('V')
%    or Screen('WaitBlanking')), 'NumFrames2' is the number of frames for both the test 
%    of the synchro (using cgflip() or Screen('Flip')) and the performance test (using 
%    displaybuffer(b)) and 'ReqFreq' is the theoretical frequency (the FREQuency that  
%    was REQuested to the OS).
%
%    2) Quick Check:
%    Freq1 = MEASURESCREENFREQ(NumFrames1)
%
% See also STARTGLAB, GETSCREENFREQ, GETFRAMEDUR.
%
% Ben,  Nov. 2007: computescreenfreq
%		Mar. 2008: measurescreenfreq

global GLAB_DISPLAY

%%%%%%%%%%%%%%%%%%%%%PARAMETERS%%%%%%%%%%%%%%%%%%%%
ToleratedError = 2.5; % (ms)  Minumorum = 2 ms, with current algorhythm.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin > 1, NumFrames3 = NumFrames2; end

% Display Message on Screen
bg = .2 + rand(1,3) / 2;
clearbuffer(0,bg)
splash1 = 'Graphics Lab';
if iscog,   
    splash2 = ['(Running over Cogent Graphics toolbox)'];
    fontsize = 30; % CG:  1 = 1 pt
else
    fontsize = 20; % PTB: 1 = 1 pix
    splash2 = ['(Running over PsychToolbox)'];
end
if nargin > 1, 
    drawtext(splash1,0,[0  150],'Arial',1.5*fontsize,[.3 .3 .3]);
    drawtext(splash2,0,[0  110],'Arial',fontsize,[.3 .3 .3]);
	str = 'Measuring screen frequency...';
	drawtext(str,0,[0  0],'Arial',fontsize,[0 0 0]);
	n = round(100*NumFrames1/ReqFreq) / 100;
	str = ['This will take ' int2str(n) ' seconds.'];
	drawtext(str,0,[0 -80],'Arial',fontsize,[0 0 0]);
else
    drawtext(splash1,0,[0  100],'Arial',1.5*fontsize,[.3 .3 .3]);
%     drawtext(splash2,0,[0  60],'Arial',fontsize,[.3 .3 .3]);
	str = 'Checking screen frequency...';
	drawtext(str,0,[0 -70],'Arial',fontsize,[0 0 0]);
end
displaybuffer(0)

% 1) First Startup Test / Quick Check
if nargin > 1 || isfilledfield(GLAB_DISPLAY,'MeasuredScreenFrequency') % If it's not preliminary approximation..
    if nargin == 1,              msg = ['Checking that screen frequency is still ' num2str(getscreenfreq) ' Hz...'];
    elseif GLAB_DISPLAY.Screen,  msg = 'Test 1: Measuring screen frequency with high accuracy...';
    else                         msg = 'Test 1: Measuring screen frequency (in windowed mode we are less accurate)...';
    end
    dispinfo(mfilename,'info',msg) % ..display message.
end

if nargin > 1
    drawtext(splash1,0,[0  150],'Arial',1.5*fontsize,[.3 .3 .3]);
    drawtext(splash2,0,[0  110],'Arial',fontsize,[.3 .3 .3]);
    str = 'Measuring screen frequency...';
    drawtext(str,0,[0  0],'Arial',fontsize,[0 0 0]);
    str = ['This will take ' int2str(n) ' seconds.'];
    drawtext(str,0,[0 -80],'Arial',fontsize,[0 0 0]);
else
    drawtext(splash1,0,[0  100],'Arial',1.5*fontsize,[.3 .3 .3]);
    str = 'Checking screen frequency...';
    drawtext(str,0,[0 -70],'Arial',fontsize,[0 0 0]);
end

% Get Times1
Times1 = zeros(1,NumFrames1);
for f = 1 : NumFrames1
    % Use low-level commands to ensure robustness
    if iscog % CG
        Times1(f) = cgflip('V') * 1000;
    else     % PTB
        %         if GLAB_DISPLAY.Screen == 0, wait(1); end % <v2-beta23: Fix windowed mode. Must be same code than in WAITFRAME !!!>
        %         Screen('WaitBlanking',gcw);
        %         Times1(f) = time;
        Times1(f) = Screen('Flip',gcw,0,1) * 1000;
    end
end

% Clear Screen
clearbuffer(0)
displaybuffer(0)

% Compute Freq1. <todo: This code is present 3 times: Move it in a sub-fun.>
Freq1 = subComputeFreq1(Times1,ToleratedError);
if nargin == 1 && isfilledfield(GLAB_DISPLAY,'MeasuredScreenFrequency') % Quick check
    if abs(Freq1 - getscreenfreq) < 1, dispinfo(mfilename,'info','... ok.');
    else dispinfo(mfilename,'warning',['Measured frequency: ' num2str(Freq1) ' Hz. FREQUENCY SEEMS TO HAVE CHANGED !!!']);
    end
elseif nargin == 3 % Initial measure
    dispinfo(mfilename,'info',['... Measured frequency: ' num2str(Freq1) ' Hz.']);
end

% 2) Synchro Test: Check if actual flips return same times than simple wait for refreshs.
if nargin == 3
    dispinfo(mfilename,'info','Test 2: Checking if actual flips return same times than simple wait for refresh...')
    Times2 = zeros(1,NumFrames2);
    for f = 1 : NumFrames2
        if iscog,   Times2(f) = cgflip * 1000;
        else        Times2(f) = Screen('Flip',gcw) * 1000;
        end
    end
    % Compute Freq2
    Freq2 = subComputeFreq1(Times2,ToleratedError);
    if abs(Freq2 - Freq1) < 1.5, dispinfo(mfilename,'info',['... ok. (' num2str(Freq2) ' Hz)']);
    else dispinfo(mfilename,'warning',['... Measured frequency: ' num2str(Freq2) ' Hz. GRAPHICS CARD ERROR !!!']);
    end
    
end

% 3) Performance Test
if nargin == 3
    dispinfo(mfilename,'info','Test 3: Basic performance test...')
	b = newbuffer;
	Times3 = zeros(1,NumFrames3);
	for f = 1 : NumFrames3
		Times3(f) = displaybuffer(b);
	end
	deletebuffer(b);
	% Compute Freq3
	Freq3 = subComputeFreq1(Times3,ToleratedError);
    if abs(Freq3 - Freq1) < 1.5, dispinfo(mfilename,'info','... ok.');
    else dispinfo(mfilename,'warning',['... Measured frequency: ' num2str(Freq3) ' Hz. GRAPHICS CARD CRITICAL PERFORMANCE ISSUE !!!']);
    end
end

%% subComputeFreq1  A sub-function of MEASURESCREENFREQ
function Freq = subComputeFreq1(Times,err)
dt = diff(Times);
m = median(dt);
ok = find(dt >= m - err & dt <= m + err); % Use median to eliminate dropped frames.
framedur = mean(dt(ok)); % Use mean to correct error due to the 1 ms precision of time measures.
Freq = 1000 / framedur;