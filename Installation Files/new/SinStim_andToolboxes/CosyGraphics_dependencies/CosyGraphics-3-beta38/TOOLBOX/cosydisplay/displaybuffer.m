function t = displaybuffer(b,varargin)
% DISPLAYBUFFER  Display content of offscreen buffer at next refresh cycle. {fast}
%    t = DISPLAYBUFFER  or  DISPLAYBUFFER(0)  flips the frontbuffer and the 
%    backbuffer of the onscreen window: at next refresh cycle the current 
%    backbuffer will become the new frontbuffer and be displayed. Returns time
%    of the beginning of the screen refresh cycle, in milliseconds.
%
%	 t = DISPLAYBUFFER(b)  displays buffer b. Buffer will first be copied
%    into the backbuffer (or buffer 0), then the backbuffer will be flipped
%    as explained above and displayed.
%
%    t = DISPLAYBUFFER(b,DUR)  displays buffer b for duration DUR (msec). DUR is actually
%    stored for the next DISPLAYBUFFER call, which will wait to display at time t + DUR. 
%    This is the same than  t = DISPLAYBUFFER(b); WAITSYNCH(DUR); DISPLAYBUFFER(b1);
%    which is deprecated.
%
%        Use  DISPLAYBUFFER(b,oneframe)  to display during one refresh cycle only.  See ONEFRAME.
%        Use  DISPLAYBUFFER(b,inf)  to display indefinitely. (For example until a WAITKEYDOWN returns.)
%        Use  DISPLAYBUFFER(b,0)  if you don't want to give an expected duration. (No automatic verification.)
%
%    The DUR argument is mandatory during a trial (i.e.: between STARTTRIAL and STOPTRIAL).
%
%    t = DISPLAYBUFFER(b,DUR,TAG)  if used between STARTTRIAL and STOPTRIAL, records
%    the string TAG in the automatically recorded trial data.
%
% Example:
%       % 1. Draw consign in an offscreen buffer:
%        b1 = newbuffer; % use newbuffer to create a drawable offscreen buffer
%       drawtext('Look at the following image.',b1);
%
%       % 2. Load image from file and store it an offscreen buffer:
%       cd(cosydir('images'))  % change dir to CosyGraphics's image directory.
%       cd faces
%       filename = 'm1';
%       I = loadimage(filename); % load image from disk as a Matlab matrix.
%       b2 = storeimage(I); % store image matrix in an offscreen buffer in the graphics card's memory..
%
%       % 3. Display:
%       displaybuffer(b1,700); % displays consign.
%       displaybuffer(b2,2000); % waits 700 msec and display image.
%       displaybuffer(0); % waits 2000 msec and clear screen (i.e.: display buffer 0, which had 
%                      % been automatically cleared after the last display.)
%
% Options:
%    DISPLAYBUFFER(...,'-dontclear')
%
%    DISPLAYBUFFER(...,'-photodiode',value) <TODO>
%
%    DISPLAYBUFFER(...,'-send','parallel',value,<delay>,<width>) <TODO>
%
%       Example:
%           startcogent;
%           openparallelport;
%           starttrial;
%           drawround(0,[0 0],100,[1 0 0]);
%           displaybuffer(0,150,'-send','parallel',[4 8 16],[0 100 200])
%           drawround(0,[0 0],100,[.4 0 1]);
%           displaybuffer(0,500)
%           stoptrial;
%
%    t = DISPLAYBUFFER(...,'-psbsync')  resets PSB timer at display onset. ("PSB" is Benoît Gerard's 
%    Psychophysics Synchronisation Box.)
%
% See also NEWBUFFER, STOREIMAGE, GCB, ONEFRAME.
%
% Ben,	Sept-Oct 2007

%  		May 2008: Suppr. 'dontclear' option (Did not work).
%       Feb+Apr 2010: Big modif for trial record system

% Performances:
%    0.64 ms before display + 0.36 ms after, Total: 1 ms, on DARTAGNAN/M6.5/PTB/CosyGraphics-2beta23.

% Programmer Note:
%  - Option syntax discussion:
%       DISPLAYBUFFER(...,'-send','parallel',...) ?  pro: 'parallel' could be replaced by 'LPT1', 'LPT2',...
%       or DISPLAYBUFFER(...,'-parallelout',...) ?   
%  - Tag: replace by (...,'-tag',tag,...) ?  con: not mandatory option, users will use it only if straightforwd
%  - Tag: Alternative: replace buff# by buff tag ?

global COSY_GENERAL COSY_DISPLAY COSY_VIDEO COSY_TRIALLOG COSY_PHOTODIODE COSY_DAQ

persistent HaveToWait PreviousTag PreviousDisplayDuration

t_start = time;

%% Check Abortion or Pause
if isptbinstalled
    if checkkeydown('Escape');
        COSY_GENERAL.isAborted = true;
        dispinfo(mfilename,'warning','Abortion key (Esc) has been pressed by the user. Aborting...')
        t = -1;
        return %                             <===!!!
    elseif checkkeydown('P'); % pause
        while checkkeydown('P')
            %  P . . . a . . . u . . . s . . . e . . .
        end
    end
end

%% Persistent Vars
if isempty(HaveToWait), HaveToWait = 0; end  % Will be used to schedule a wait at next call.
if isempty(PreviousTag), PreviousTag = ''; end
if isempty(PreviousDisplayDuration), PreviousDisplayDuration = 0; end  % Used to determine isStartAnim.

%% Input Vars
% b
if ~nargin
	b = 0;
end
if ischar(b),
    b = str2num(b); % To allow a command syntax in the Command Window.
end
if b > 0 && ~any(COSY_DISPLAY.BUFFERS.OffscreenBuffers == b) % Check that b is an existing buffer
    error(['Invalid buffer ID: Buffer ' int2str(b) ' does not exist.' 10 ...
        'Use NEWBUFFER to create a drawable offscreen buffer or' 10 ...
        'STOREIMAGE to store an image in an offscreen buffer.'])
end

% Dur
Dur = 0;
if nargin > 1 && isnumeric(varargin{1})
    Dur = varargin{1};
end
if HaveToWait
    Wait = COSY_DISPLAY.CurrentDisplayDuration; % previous frame (currently on screen) duration
end
if exist('Dur','var')
    if Dur > 0
        COSY_DISPLAY.CurrentDisplayDuration = Dur; % wait duration for next call to displaybuffer
    else
        COSY_DISPLAY.CurrentDisplayDuration = [];
    end
elseif ~isempty(COSY_TRIALLOG) && COSY_TRIALLOG.isStarted
    warning('COSYGRAPHICS:displaybuffer:DurationRequested',...
        ['During a trial, the Duration argument must be given to DISPLAYBUFFER.  See " help displaybuffer ".\n' ...
        'Type: " warning off COSYGRAPHICS:displaybuffer:DurationRequested "  to suppress this warning.'])
else
    COSY_DISPLAY.CurrentDisplayDuration = [];
end

% Tag
isTag = 0;
Tag = '';
if nargin >= 3 && isnumeric(varargin{1}) && ischar(varargin{2}) && ~isoption(varargin{2})
    isTag = 1;
    Tag = varargin{2};
    if length(Tag) > 16 % <16: hard-coded here and in starttrial.>
        error('Tag max length is 16 characters. "%s" is too long.',Tag)
    end
end

% Options
dontClear = 0;
isParallelOut = 0;
isPSBsync = 0;
oo = [find(isoption(varargin)) length(varargin)+1];
for i = 1 : length(oo)-1
    a0 = oo(i);
    aN = oo(i+1) - 1; % one before the option after ;-)
    switch lower(varargin{a0})
        case '-dontclear'
            dontClear = 1;
        case '-send'
            if ~isopen('trial')
                str = '''-send'' option only available between STARTTRIAL and STOPTRIAL calls.';
                dispinfo(mfilename,'error',str)
                error(str)
            end
            switch lower(varargin{a0+1})
                case 'parallel'
                    isParallelOut = 1;
                    ParallelOut.Value = varargin{a0+2};
                    if a0+3 <= aN, ParallelOut.Delay = varargin{a0+3};
                    else           ParallelOut.Delay = zeros(size(ParallelOut.Value));
                    end
                    if a0+4 <= aN, ParallelOut.Width = varargin{a0+3}; % <TODO: Width arg not used !!>
                    else           ParallelOut.Width = []; % default: // port will be reset to 0 at next frame
                    end
                otherwise
                    error(['Unknown device: ''' varargin{a} '''. The only valid device, currently, is ''parallel''']);
            end
        case '-psbsync'
            isPSBsync = 1;
        otherwise
            error(['Unknown option name: ''' varargin{a0} '''']);
    end
end

%% Copy b -> 0
% If buffer to display is not the backbuffer of the onscreen window,
% we have first to copy it first to the backbuffer (buffer 0). This 
% operation is not synchronized with the refresh cycle.
if b ~= 0 && b ~= gcw
    copybuffer(b,0);
end

%% Photodiodes: Draw squares
if ~isempty(COSY_PHOTODIODE) && COSY_PHOTODIODE.isPhotodiode
    if isPSBsync
        setphotodiodevalue(1);
    end
    [wscreen,hscreen] = getscreenres;
    xmax = wscreen/2;
    ymax = hscreen/2;
    x0 = -ceil(xmax);
    x1 = floor(xmax);
    y0 = -floor(ymax);
    y1 = ceil(ymax);
    w = COSY_PHOTODIODE.SquareSize(1);
    h = COSY_PHOTODIODE.SquareSize(end);
    XY = [x0+w/2 y1-h/2; x0+w/2 y0+h/2; x1-w/2 y1-h/2; x1-w/2 y0+h/2]; % [UL BL; UR BR]
    RGB = repmat(COSY_PHOTODIODE.Values(:),1,3);
    XY(~COSY_PHOTODIODE.Locations(:),:) = [];
    RGB(~COSY_PHOTODIODE.Locations(:),:) = [];
    draw('rect',RGB,0,XY,[w h]);
    if isPSBsync
        setphotodiodevalue(0);
    end
end

%% Wait?
% - Wait if a wait has been programmed at previous call:
if HaveToWait
    if ~isempty(Wait) && isfinite(Wait)
        waitsynch(Wait,'ms','-displaybuffer');
    end
end
% - Program a wait for next call:
if exist('Dur','var')
    if ~isempty(Dur) && ~isnan(Dur)
        HaveToWait = 1;
    end
end

%% Trial events:
% 1) JUST BEFORE DISPLAY (AFTER WAIT):
% 1.1. Store Events to send
if isParallelOut
    COSY_TRIALLOG.isParallelOut = 1;
    if ParallelOut.Delay(1) == 0
        COSY_TRIALLOG.ParallelOutQueue.Now.Value = ParallelOut.Value(1);
    end
    ii = ParallelOut.Delay > 0;
    if any(ii)
        COSY_TRIALLOG.ParallelOutQueue.Later.Value = [COSY_TRIALLOG.ParallelOutQueue.Later.Value ParallelOut.Value(ii)];
        COSY_TRIALLOG.ParallelOutQueue.Later.t0    = [COSY_TRIALLOG.ParallelOutQueue.Later.t0    zeros(1,sum(ii))];
        COSY_TRIALLOG.ParallelOutQueue.Later.Delay = [COSY_TRIALLOG.ParallelOutQueue.Later.Delay ParallelOut.Delay(ii)];
    end
%     i0 = COSY_TRIALLOG.iFrame + 1;
%     ii = i0 + round(ParallelOut.Delay / getframedur);
%     COSY_TRIALLOG.PERFRAME.ParallelOut(ii,1) = ParallelOut.Value(:);
end

%% Display! 
% Flip backbuffer (buffer 0) and onscreen buffer and clear backbuffer 
% This operation is synchronized with the refresh cycle.
if iscog % CG
    if dontClear  % <v1.5.3: 'dontclear' doesn't work on CG 1.24> <v2-beta29: Implement '-dontclear' over PTB & CG 1.29.>
        v = getcosylib('CG','version');
        if v(1) >= 1 && v(2) > 25  % v > 1.25 : ok
            t_before = time;
            t = cgflip;
        else                       % CG1.24/Cog1.25 : bug!
            msg = ['Sorry, the ''-dontclear'' option does not run over Cogent 1.25 !!' 10 ...
                '    (This is the only known bug on this version of Cogent ; thay''s why CosyGraphics still' 10 ...
                '    uses it by default on Matlab 6.5.)  Your experiment will run if you start CosyGraphics' 10 ...
                '    over Cogent 1.29.  To do that, use:  startcosy(''Cog1.29'',...);  in place of  startcogent(...);'];
            dispinfo(mfilename,'error',msg);
            error(msg)
        end
        
    else
        bg = COSY_DISPLAY.BackgroundColor;
        t_before = time;
        t = cgflip(bg(1),bg(2),bg(3)); % <== DISPLAY ==!
        
    end
  
    t_after = time;
    if t == -2, error('cgflip error: Probably no Cogent display open.'), end
    t = t * 1000; % sec -> ms      % < v2-alpha2: suppr. "floor" !>

else     % PTB
    w = gcw;
    Screen('DrawingFinished', w, dontClear); % Optimization: Tells Psychtoolbox 
    %   that no further drawing commands will be issued before the
    %   next SCREEN('Flip') command. This is a hint to the PTB that allows to optimize
    %   drawing in some occasions.
    t_before = time;
    if COSY_DISPLAY.UseDirectXWorkaround4PTB >= 2  % If opendisplays has detected synchro pb with Screen('Flip')..
        WaitVerticalBlank('wait'); % ..use Andrea Conte's DirectX workaround.
    end
    t = Screen('Flip', w, [], dontClear); % <== DISPLAY ==!
    t_after = time;
    t = t * 1000; % sec -> ms
    t = t + COSY_DISPLAY.TimeStampsEstimatedConstantError;

end

%% Trial
if isopen('trial') % If we are between STARTTRIAL and STOPTRIAL..
    % 2) JUST AFTER DISPLAY, REAL-TIME:
    % 2.1. Trial onset: First frame onset synchronization events
    if COSY_TRIALLOG.isWaitingFirstFrame % First frame of trial!
        % Eyelink: Send trial sync message
        if isopen('eyelink') % don't use checkeyelink for optimization
            sendeyelinksync;
        end
        
        % Daq: Trigger Analog Input
        if isopen('analoginput')
            for i=1:length(COSY_DAQ.AI)
                trigger(COSY_DAQ.AI(i).AiObject);
            end
        end
        
        COSY_TRIALLOG.StartTimeStamp = t;
        COSY_TRIALLOG.isWaitingFirstFrame = false;
    end

    % 2.2. Frame onset: Send/Get events
    helper_perframeevents(t);

    % 3) AFTER DISPLAY, TAKE IT EASIER: Store display data (t, Dur & Tag) in COSY_TRIALLOG global var
    % 3.1. Get expected delay:
    if COSY_TRIALLOG.iDisplay
        ExpectedPreviousInterval = COSY_TRIALLOG.PERDISPLAY.ExpectedDurations_ms(COSY_TRIALLOG.iDisplay); % <-- iDisplay not yet incremented
    else ExpectedPreviousInterval = NaN;
    end

    % 3.2. Display onset:
    COSY_TRIALLOG.iDisplay = COSY_TRIALLOG.iDisplay + 1; % <-- increment iDisplay !
    i = COSY_TRIALLOG.iDisplay;
    COSY_TRIALLOG.PERDISPLAY.TimeStamps(i) = t;
    COSY_TRIALLOG.PERDISPLAY.DisplaybufferCalledTimeStamps(i) = t_start;
    COSY_TRIALLOG.PERDISPLAY.ScreenFlipCalledTimeStamps(i) = t_before;
    COSY_TRIALLOG.PERDISPLAY.ScreenFlipReturnedTimeStamps(i)  = t_after;
    isStartAnim = 0; % true for first frame of a frame-by-frame animation.
    isStopAnim = 0;  % true for last frame of a frame-by-frame animation.

    if exist('Dur','var') && ~isempty(Dur)
        COSY_TRIALLOG.PERDISPLAY.ExpectedDurations_ms(i) = Dur;
        if Dur == oneframe % "oneframe" arg *MUST* be used for anims.
            if PreviousDisplayDuration ~= Dur || ~strcmp(PreviousTag,Tag)
                isStartAnim = 1;
            end
        end
    else
        COSY_TRIALLOG.PERDISPLAY.ExpectedDurations_ms(i) = NaN;
    end

    if i > 1 && COSY_TRIALLOG.PERDISPLAY.ExpectedDurations_ms(i-1) == oneframe 
        if Dur ~= oneframe || ~strcmp(PreviousTag,Tag)
            isStopAnim = 1;
        end
    end

    if isTag  % <Commented v2-beta45 because of big timing bug!!!!> <uncommented v2-beta49> <retested v2-beta49: still to slow after starttrial fix.>
              % <Uncommented v3-alpha6, because needed by savetrials4eyeview ; retested: takes 0.030 to 0.050 ms on Latitude D610.>
        COSY_TRIALLOG.PERDISPLAY.Tag(i,1:length(Tag)) = Tag;
    end

    if COSY_TRIALLOG.isParallelOut
        ii = find(COSY_TRIALLOG.ParallelOutQueue.Later.t0 == 0);
        if ~isempty(ii)
            COSY_TRIALLOG.ParallelOutQueue.Later.t0(ii) = t;
        end
    end

else
    ExpectedPreviousInterval = NaN;
    isStartAnim = 0;
    isStopAnim = 0;
    
end

%% Video recording
if ~isempty(COSY_VIDEO)
    if COSY_VIDEO.isRecording
        % Vars:
        i = COSY_VIDEO.iDisplay + 1;
        COSY_VIDEO.iDisplay = i; % <-- update iDisplay ! (not the same count than for trial log)
        if  0 < Dur && Dur < inf  % If duration is given.. 
            COSY_VIDEO.DisplayDuration(i) = Dur; % ..store it.
        else                      % If duration is not given..
            COSY_VIDEO.DisplayDuration(i) = 0;   % ..we'll store it at next display.
        end
        if i > 1 && COSY_VIDEO.DisplayDuration(i-1) == 0  % If duration was not given at previous display..
            COSY_VIDEO.DisplayDuration(i-1) = t - COSY_DISPLAY.LastDisplayTimeStamp; % ..store measured delta time.
        end
        
        % Capture image from framebuffer:
        COSY_VIDEO.RecordedImages{i} = Screen('GetImage',gcw);
    end
end

%% Event to print
if isopen('trial')
    doPrint = 0;
    if Dur ~= oneframe  % Fixed image..  <NB: Use Dur (=next interval) and not ExpectedPreviousInterval (=previous interval).>
        if isTag,  
            if b   str = sprintf('Displayed "%s" (buffer %2d).', Tag, b);
            else   str = sprintf('Displayed "%s".', Tag);
            end
        else       str = sprintf('Displayed buffer %2d.', b);
        end
        doPrint = 1;
    elseif isStartAnim  % Frame-by-frame animation: Print only at the first frame..
        if isTag,  str = sprintf('Started "%s" frame-by-frame animation...', Tag);
        else       str =         'Started frame-by-frame animation.';
        end
        doPrint = 1;
    end
    
    if doPrint
        if ~isStopAnim
            expected = ExpectedPreviousInterval;
        else
            i0 = COSY_TRIALLOG.iStartAnimation;
            i1 = COSY_TRIALLOG.iDisplay - 1;
            expected = sum(COSY_TRIALLOG.PERDISPLAY.ExpectedDurations_ms(i0:i1));
        end
        helper_dispevent(mfilename, str, t, expected);
    end

end

%% Update global & persistent var.
COSY_DISPLAY.BUFFERS.LastDisplayedBuffer = b;
COSY_DISPLAY.LastDisplayTimeStamp = t;
if isStartAnim
    COSY_TRIALLOG.iStartAnimation = COSY_TRIALLOG.iDisplay; % <v2-beta45 fix: must be after stop anim event print.>
end
PreviousTag = Tag;
PreviousDisplayDuration = Dur;
if isopen('trial')
    COSY_TRIALLOG.PERFRAME.isDisplay(COSY_TRIALLOG.iFrame) = true;
    COSY_TRIALLOG.PERDISPLAY.DisplaybufferReturnedTimeStamps(i) = time;
end

%% Output time?
if ~nargout, clear t; end