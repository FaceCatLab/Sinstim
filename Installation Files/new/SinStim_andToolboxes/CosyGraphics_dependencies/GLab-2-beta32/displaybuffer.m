function t = displaybuffer(b,varargin)
% DISPLAYBUFFER  Display content of offscreen buffer at next refresh cycle.
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
%        Use  DISPLAYBUFFER(b,0)  if you don't want to give an expected duration. (No automatic verifivation.)
%
%    The DUR argument is mandatory during a trial (i.e.: between STARTTRIAL and STOPTRIAL).
%
%    t = DISPLAYBUFFER(b,DUR,TAG)  if used between STARTTRIAL and STOPTRIAL, records
%    the string TAG in the automatically recorded trial data.
%
% Example:
%    % Draw consign in an offscreen buffer:
%    b1 = newbuffer; % use newbuffer to create a drawable offscreen buffer
%    drawtext('Look at the following image.',b1);
%    % Load image from file and store it an offscreen buffer:
%    I = loadimage(filename);
%    b2 = storeimage(I); % use storeimage to store image in an offscreen buffer
%    % Display:
%    displaybuffer(b1,700); % displays consign
%    displaybuffer(b2,2000); % waits 700 msec and display image
%    displaybuffer(0); % waits 2000 msec and clear screen (i.e.: display buffer 0, which had 
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
%    0.64 ms before display + 0.36 ms after, Total: 1 ms, on DARTAGNAN/M6.5/PTB/GLab-2beta23.

% Programmer Note:
%  - Option syntax discussion:
%       DISPLAYBUFFER(...,'-send','parallel',...) ?  pro: 'parallel' could be replaced by 'LPT1', 'LPT2',...
%       or DISPLAYBUFFER(...,'-parallelout',...) ?   
%  - Tag: replace by (...,'-tag',tag,...) ?  con: not necassary option, users will use it only if straightforwd
%  - Tag: Alternative: replace buff# by buff tag ?

global GLAB_IS_RUNNING GLAB_BUFFERS GLAB_DISPLAY GLAB_TRIAL GLAB_PHOTODIODE GLAB_EYELINK GLAB_IS_ABORT GLAB_DEBUG

persistent HaveToWait % will be used to program a wait at next call
if isempty(HaveToWait), HaveToWait = 0; end

%% Check Abort
if checkkeydown('Escape');
    GLAB_IS_ABORT = 1;
    t = -1;
    return %                  <===!!!
end

%% Input Args
% b
if ~nargin
	b = 0;
end
if ischar(b),
    b = str2num(b); % To allow a command syntax in the Command Window.
end
if b > 0 && ~any(GLAB_BUFFERS.OffscreenBuffers == b) % Check that b is an existing buffer
    error(['Invalid buffer ID: Buffer ' int2str(b) ' does not exist.' 10 ...
        'Use NEWBUFFER to create a drawable offscreen buffer or' 10 ...
        'STOREIMAGE to store an image in an offscreen buffer.'])
end

% Dur
if nargin > 1 && isnumeric(varargin{1})
    Dur = varargin{1};
end
if HaveToWait
    Wait = GLAB_DISPLAY.CurrentDisplayDuration; % previous frame (currently on screen) duration
end
if exist('Dur','var')
    if Dur > 0
        GLAB_DISPLAY.CurrentDisplayDuration = Dur; % wait duration for next call to displaybuffer
    else
        GLAB_DISPLAY.CurrentDisplayDuration = [];
    end
elseif ~isempty(GLAB_TRIAL) && GLAB_TRIAL.isStarted
    warning('GLAB:displaybuffer:DurationRequested',...
        ['During a trial, the Duration argument must be given to DISPLAYBUFFER.  See " help displaybuffer ".\n' ...
        'Type: " warning off GLAB:displaybuffer:DurationRequested "  to suppress this warning.'])
else
    GLAB_DISPLAY.CurrentDisplayDuration = [];
end

% Tag
isTag = 0;
Tag = '';
if nargin >= 3 && isnumeric(varargin{1}) && ischar(varargin{2}) && ~isoption(varargin{2})
    isTag = 1;
    Tag = varargin{2};
    if length(Tag) > 8, error('Tag max length is 8 characters. "%s" is too long.',Tag)
    else                Tag = [Tag char(zeros(1,8-length(Tag)))];
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
                    if a0+4 <= aN, ParallelOut.Width = varargin{a0+3};
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
if b > 0 && b ~= gcw
    copybuffer(b,0);
end

%% Photodiodes: Draw squares
if ~isempty(GLAB_PHOTODIODE) && GLAB_PHOTODIODE.isPhotodiode
    if isPSBsync
        setphotodiodevalue(1);
    end
    [x0,x1] = getscreenxlim;
    [y0,y1] = getscreenylim;
    w = GLAB_PHOTODIODE.SquareSize(1);
    h = GLAB_PHOTODIODE.SquareSize(end);
    XY = [x0+w/2 y1-h/2; x0+w/2 y0+h/2; x1-w/2 y1-h/2; x1-w/2 y0+h/2]; % [UL BL; UR BR]
    RGB = repmat(GLAB_PHOTODIODE.Values(:),1,3);
    XY(~GLAB_PHOTODIODE.Locations(:),:) = [];
    RGB(~GLAB_PHOTODIODE.Locations(:),:) = [];
    drawshape('rect',0,XY,[w h],RGB);
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
    GLAB_TRIAL.isParallelOut = 1;
    if ParallelOut.Delay(1) == 0
        GLAB_TRIAL.ParallelOutQueue.Now.Value = ParallelOut.Value(1);
    end
    ii = ParallelOut.Delay > 0;
    if any(ii)
        GLAB_TRIAL.ParallelOutQueue.Later.Value = [GLAB_TRIAL.ParallelOutQueue.Later.Value ParallelOut.Value(ii)];
        GLAB_TRIAL.ParallelOutQueue.Later.t0    = [GLAB_TRIAL.ParallelOutQueue.Later.t0    zeros(1,sum(ii))];
        GLAB_TRIAL.ParallelOutQueue.Later.Delay = [GLAB_TRIAL.ParallelOutQueue.Later.Delay ParallelOut.Delay(ii)];
    end
%     i0 = GLAB_TRIAL.iFrame + 1;
%     ii = i0 + round(ParallelOut.Delay / getframedur);
%     GLAB_TRIAL.PERFRAME.ParallelOut(ii,1) = ParallelOut.Value(:);
end

%% Display! 
% Flip backbuffer (buffer 0) and onscreen buffer and clear backbuffer 
% This operation is synchronized with the refresh cycle.
if iscog % CG
    if dontClear  % <v1.5.3: 'dontclear' doesn't work on CG 1.24> <v2-beta29: Implement '-dontclear' over PTB & CG 1.29.>
        v = getlibrary('CG','version');
        if v(1) >= 1 && v(2) > 25  % v > 1.25 : ok
            t_before = time;
            t = cgflip;
        else                       % CG1.24/Cog1.25 : bug!
            msg = ['Sorry, the ''-dontclear'' option does not run over Cogent 1.25 !!' 10 ...
                '    (This is the only known bug on this version of Cogent ; thay''s why GraphicsLab still' 10 ...
                '    uses it by default on Matlab 6.5.)  Your experiment will run if you start GraphicsLab' 10 ...
                '    over Cogent 1.29.  To do that, use:  startglab(''Cog1.29'',...);  in place of  startcogent(...);'];
            dispinfo(mfilename,'error',msg);
            error(msg)
        end
        
    else
        bg = GLAB_DISPLAY.BackgroundColor;
        t_before = time;
        t = cgflip(bg(1),bg(2),bg(3)); % <== DISPLAY !
        
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
    t = Screen('Flip', w, [], dontClear); % <== DISPLAY !
    t_after = time;
    t = t * 1000; % sec -> ms

end

if isfield(GLAB_TRIAL,'isStarted') && GLAB_TRIAL.isStarted % If we are between STARTTRIAL and STOPTRIAL..
    % 2) JUST AFTER DISPLAY, REAL-TIME:
    % 2.1. Trial onset: First frame onset synchronization events
    if GLAB_TRIAL.isWaitingFirstFrame
        GLAB_TRIAL.StartTimeStamp = t;
        GLAB_TRIAL.isWaitingFirstFrame = 0;
        
        % Eyelink: Send trial sync message
        if isopen('eyelink') % don't use checkeyelink for optimization
            sendeyelinksync;
        end
    end
    
    % 2.2. Frame onset: Send/Get events
    glabhelper_perframeevents(t);

    % 3) AFTER DISPLAY, TAKE IT EASY: Store display data (t, Dur & Tag) in GLAB_TRIAL global var
    % 3.1. Get expected delay:
    if GLAB_TRIAL.iDisplay
        ExpectedInterval = GLAB_TRIAL.PERDISPLAY.ExpectedDurations_ms(GLAB_TRIAL.iDisplay); % <-- iDisplay not yet updated
    else ExpectedInterval = NaN;
    end

    % 3.2. Display onset:
    GLAB_TRIAL.iDisplay = GLAB_TRIAL.iDisplay + 1; % <-- update iDisplay !
    i = GLAB_TRIAL.iDisplay;
    GLAB_TRIAL.PERDISPLAY.TimeStamps(i) = t;
    GLAB_TRIAL.PERDISPLAY.BeforeDisplayTimeStamps(i) = t_before;
    GLAB_TRIAL.PERDISPLAY.AfterDisplayTimeStamps(i)  = t_after;
    if exist('Dur','var') && ~isempty(Dur)
        GLAB_TRIAL.PERDISPLAY.ExpectedDurations_ms(i) = Dur;
    else
        GLAB_TRIAL.PERDISPLAY.ExpectedDurations_ms(i) = NaN;
    end
    if isTag
        GLAB_TRIAL.PERDISPLAY.Tag(i,:) = Tag;
    end
    if GLAB_TRIAL.isParallelOut
        ii = find(GLAB_TRIAL.ParallelOutQueue.Later.t0 == 0);
        if ~isempty(ii)
            GLAB_TRIAL.ParallelOutQueue.Later.t0(ii) = t;
        end
    end
    
else
    ExpectedInterval = NaN;
    
end

%% Disp event
if GLAB_IS_RUNNING
    if ExpectedInterval > getframedur %+ .001
        glabhelper_dispevent(mfilename, sprintf('Displayed buffer %2d.',b), t, ExpectedInterval);
    end
end

%% Update global var.
GLAB_BUFFERS.LastDisplayedBuffer = b;
GLAB_DISPLAY.LastDisplayTime = t;

%% Output time?
if ~nargout
	clear t
end
