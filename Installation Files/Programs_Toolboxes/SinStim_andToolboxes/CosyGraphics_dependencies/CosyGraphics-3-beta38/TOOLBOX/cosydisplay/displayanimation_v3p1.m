function [DisplayTimes,FramesMissed,varargout] = displayanimation(B,varargin)
%% DISPLAYANIMATION  Real-time display of a sequence of images to be build from pre-stored buffers.
%    [DisplayTimes,FrameErr] = DISPLAYANIMATION(B,X,Y)  displays sequence of buffers whose handles are 
%    stored in matrix B. Each buffer will be displayed with X and Y offsets during one screen frame. 
%    B, X and Y are either scalars (buffer/x/y constant) or b-by-N matrices, where b is the number of
%    buffers per frames and N is the number of frames to display (buffer/x/y variable). It returns
%    1-by-N vectors DisplayTimes (timestamps of begins of vertical blankings) and FrameErr.
%
%    [DisplayTimes,FrameErr] = DISPLAYANIMATION(B,X,XAlign,Y,YAlign)  specifies the x/y alignement. 
%    XAlign can be 'L', 'C' or 'R' to align on left, center or right respectivelly. YAlign ca be 'T', 
%    'C' or 'B' (top, center, bottom). XAlign and YAlign can also be b-by-N matrices of characters.
%
%    [DisplayTimes,FrameErr] = DISPLAYANIMATION(...,Durations)  specifies durations (in ms) of display
%    for each image buffer. 'Durations' is a 1-by-N vector (N is the number of images). Values of 0
%    are interpreted as 1 frame duration.
%
%% Image Processings (PTB only):
%    The following options are only availables if PTB is used as graphics library.
%
%    DISPLAYANIMATION(...,'Alpha',ALPHA)  copies buffers with an alpha (translucency)
%    factor. ALPHA is a b-by-N matrix (see above).
%
%    DISPLAYANIMATION(...,'Scale',S)  copies buffers with a scaling factor S. (S=1 is 100%.)
%
%    DISPLAYANIMATION(...,'BufferRotation',THETA)  copies buffers with a rotation. THETA is
%    a b-by-N matrix (see above) containing the rotation angles, in degrees, clockwise.
%
%    DISPLAYANIMATION(...,'AxesRotation',THETA)  copies buffers with a rotation of both (x,y)
%    coordinates and buffer orientation. THETA is a b-by-N matrix (see above) containing the
%    rotation angles, in degrees, clockwise. If you want to rotate the x, y coordinates but not
%    the buffer orientation, use:  DISPLAYANIMATION(...,'AxesRotation',THETA,'BufferRotation',0).
%
%% Drawings:
%    DISPLAYANIMATION(...,'Draw',Draw.Draw.Shape,X,Y,W,<H>,RGB,<LineWidth>) draws geometrical
%    object(s). Draw.Draw.Shape can be 'square', 'rect', 'round', 'oval' or 'cross' (if shape is
%    constant) ; it can also be a 1-by-N cell array of strings, one for each image to display (if
%    shape varies). X, Y, W (widths), H (heigths) and LineWidth are s-by-N matrices, where s is the
%    number of shapes to draw and N is the number of frames to display.
%    H and LineWidth are optionnals. RGB is a s-by-N-by-3 matrix or rgb values, in the range 0.0 to
%    1.0. In all matrices missing values are replaced by NaNs.
%    See DRAWSHAPE for more informations.
%
%% Triggers and Events:
%    [DisplayTimes,FrameErr,TrigTimes] = DISPLAYANIMATION(...,'Wait',Device,Bytes)  waits trigger.
%    <todo: not yet implemented>
%
%    [DisplayTimes,FrameErr,EventValues,EventTimes] = DISPLAYANIMATION(...,'Get',Device,Values)  gets
%    events from device during the animation. Device can only be 'Keyboard'. <todo: Implement others.>
%    Values are the IDs of the keys to wait for.
%
%    [DisplayTimes,FrameErr,SendTimes] = DISPLAYANIMATION(...,'Send',Device,Bytes)  sends bytes
%    through device. Device can be 'parallel', 'serial' or 'photodiode'. <todo: 'Daq'> "Bytes" is a
%    1-by-N or 1-by-(N+1) vector, containing values to be sent (integers from 1 to 255)
%    and 0s or NaNs where nothing has to be sent. With parallel port you cannot send the same value
%    two times in a row. With photodiode, values are half-bytes (from 0 to 15) (1: upper-left
%    corner, 2: upper-right, 4: lower-left, 8: lower-right; numbers can be added). Bytes will be
%    sent at the beginning of the display (refresh cycle onset) of the corresponding image. If there
%    is a (N+1)th value, it will be sent at the end of the last display.
%    
%    DISPLAYANIMATION(...,'Get',...,'Send',...,'Forward',InputValues)  if it gets a value (from the   
%    'Get' device) included in InputValues, forward it through the 'Send' device at next frame onset.
%    
%    DISPLAYANIMATION(...,'Get',...,'Send',...,'Forward',InputValues,OutputValues)
%
%    If more than one of these options is used, output argume order is:
%    [DisplayTimes,FrameErr,EventValues,EventTimes,SendTimes] = DISPLAYANIMATION(...)
%
%% Real-time Control:
%    DISPLAYANIMATION(...,'FrameErrorEvent',Device,ErrorCode)  sends ErrorCode through Device each
%    time a frame has been missed. Device can be 'parallel' or 'serial'. ErrorCode is an integer
%    from 1 to 255.
%
%    [DisplayTimes,FrameErr] = DISPLAYANIMATION(...,'Isochronous',flag)  in isochronous mode (flag=1), 
%    the function corrects timing errors due to missed refresh deadlines by skipping the next frame 
%    after each missed refresh. This will be perfectly efficient if PTB can get high precision timestamps.
%    If PTB has to fallback to lower precision timestamps due to driver bugs, false positive are
%    possibles. Non-isochronous mode (flag=0) is the default. No correction are done in this mode, but
%    all images are guanrantied to be displayed.
%
%           Normal display (no errors):                 1, 2, 3, 4, 5, 6, 7,...
%           Missed frame #4, no correction:             1, 2, 3, 3, 4, 5, 6, 7,...
%           Missed frame #4, isochronous correction:    1, 2, 3, 3, 4, 6, 7,...    (skip frame #5 to correct phase shift)
%
%           Corresponding elements in vetors:          [1  2  3  4 NaN 6  7 ...]
%
%    DISPLAYANIMATION(...,'Priority',PriorityLevel)  sets priority level during animation.
%    PriorityLevel can be 'NORMAL', 'HIGH', 'REALTIME' or 'OPTIMAL'. (In the latter case, CosyGraphics will
%    choose for you the optimal solution; this is also the default behavior.)
%
%% Splash Screen:
%    DISPLAYANIMATION(...,'Splash',MessageString,BgColor,FontColor,<TimeOut>,<Delay>,<DelayBuffer>)  
%    displays a splash screen when ready and waits a key press to start the animation. MessageString is a cell 
%    array of strings. 'TimeOut' (optional) is the max time to wait for, in milliseconds. Default value is inf.
%    'Delay' (optional) is the number of milliseconds to wait after the key press before to start. 'DelayBuffer'
%    (optional) is the handle of the buffer to be displayed during the delay ; if not provided, a blank screen 
%    will be shown.
%
%%
% See also PREPARESINANIMATION.
%
% Ben, 2007-2011.

%% VERSION HISTORY
% v0.1	 Sep. 07    REALTIMEDISPLAY. First simple function, with support for daq trigger.
% v0.2   Oct.   	Precompilation of children function.
% v0.9   Nov.		Add parallel port. Suppr. daq trigger. Fix. timing err.: - 1 frame dur.
% v1.0   Nov.		RTDISPLAYBUFFERS. No more substract 1 frame dur., now it's done by waitsync.
%                   No more set priority itself. Use SETPRIORITY !!!
%        Dec.       rtdisplaysprites
% v2.0   Nov. 08                    DISPLAYANIMATION. Add Special Effects. Send Events: change arguments.
% v2.0.1 Feb. 09                    Fix "Durations" spelling bug.
% v2.1   June                       Suppr. X, Y input arg no more optional. B can be a scalar.
%                                   XAlign, YAlign optional args.
%                                   'Scale' option.
%                                   'Priority' option.
%                                   Fix case no ALPHA or no THETA.
% v2.2   Oct.                       'Isochronous' option.
%                                   <!> FrameErr becomes now a 1xN vector (instead of a scalar).
% v2.3   Oct.                       Fix 2.2.
%                                   'FrameErrorEvent' option.
% v2.4   Nov.       2-beta9/10nov   Store all time vars in COSY_FUNCTIONS.s
%                                   Workaround "neg timestamps" bug
% v2.5   Dec.       2-beta10.       Rewrite totally 2.4.
% v2.6   Jan. 2010  2-beta12a       Fix isochronous mode. <unfinished>
% v2.7              2-beta12b       Fix isochronous mode.
%                                   Splash: Add time out.
%                                   STATS:
%                                   - Rewrite 2.5 exported structure, add lot of stats.
%                                   - Move error messages from Sinstim 1.6.2.
%                                   - Make the function verbose.
%                                   - Export "stats" variable to base ws and caller ws.
%                                   <TODO: Fix N vs N+1 problem>
% v2.7.1            2-beta14        Save log
%                                   ReadyToDisplayTimes = ReadyToDisplayTimesCOG;
% v2.7.2            2-beta15        Moved errors checks & messages to helper_checkerrors (+fix missed frames indexes)
%                                   Fix CpuTime max: ignore 2 first times + add CpuTime_FirstLoop_ms
% v2.7.3            2-beta17        Linux fix: use cogstd only on Windows.  
%                                   Log: Small fixes. stats = s;
% v2.8   Jul.       2-beta23        Fix FunVersion (was 2.7.1).
%                                   Log: Use glablog => Log in x:\cosygraphics\var\log. Log only if full screen.
% v2.8.1 Nov.       2-beta31        Fix case no buffers (only NaNs).
% v2.8.2 June 2011  2-beta39        Fix: last byte of BytesToSend was not sent. <backported in 2-beta32/09jun / SinStim 1.8.2>
% v2.8.3 June 2011  2-beta53        glablog -> glabdir('log') (-> cosydir('log') v3-alpha0)
%
% v3.0   Aug  2011  3-alpha0        GLab 2 -> CosyGraphics 3 :
%                                   glabdir -> cosydir, glab_version -> cosyversion, glabhelper_* -> helper_*
%                                   GLAB_FUNCTIONS -> COSY_FUNCTIONS
% v3.0.1 Sep  2011  3-alpha1        Write this changelog above (v3.0). Update FunVersion.
% v3.0.2 Sep        3-alpha1        <backported in SinStim 1.8.3 sub-fun.>
%                                   'Splash' option: Add DelayBuffer arg (lines 293-7, 372).
% v3.0.3 Feb  2012  3-beta12        Apply JBB's fixes (bug reports 25-01 & 10-02-2012.) Apply JBB's fixes (bug reports 25-01 & 10-02-2012.) <Applied in SinStim 1.8.11's sub-fun, in GLab/CGx 2-beta32 & 3-beta12.>
% v3.1   Mar  2012  3-beta27        Fix CGr 3 port: Fix draw() args.
%                                   Port modifs from SinStim 1.8.12: <Change log error: was marked as done but was not>
%                                   -Add 'ForwardEvents' option.
%                                   -Clip byte to send to 255. Record sent bytes in stats.PERDISPLAY.ValuesActuallySent_byte.
%                                   Fix bg after splash.
% tic

global COSY_FUNCTIONS

CosyGraphicsVersion = cosyversion;
FunVersion = '3.1';

dispinfo(mfilename,'info','Preparing animation...')

%% INPUT ARGs
%% X, Y, XALIGN, YALIGN
X = varargin{1};
if ischar(varargin{2}) && all(ismember(varargin{2},'LCR'))
    XALIGN = varargin{2};
    varargin(2) = [];
else
    XALIGN = 'C';
end
Y = varargin{2};
if numel(varargin) >=3 && ischar(varargin{3}) && all(ismember(varargin{3},'TCB'))
    YALIGN = varargin{3};
    varargin(3) = [];
else
    YALIGN = 'C';
end
varargin(1:2) = [];

%% Get b and N
b = max([size(B,1) size(X,1) size(Y,1)]); % nb of buffers per set
N = max([size(B,2) size(X,2) size(Y,2)]); % nb of image to display

%% Durations
if numel(varargin) >= 1 && isnumeric(varargin{1})
    Durations = varargin{1};
    varargin(1) = [];
    if isempty(Durations), Durations = ones(1,N) * getframedur;
    elseif length(Durations) == 1, Durations = repmat(Durations,1,N);
    end
else
    Durations = zeros(1,N);
end

%% Options
Get = 0;
Send = 0;
BytesToSend = zeros(1,N);
Draw.Shape = {};
ALPHA  = 1;
XSCALE = 1;
YSCALE = 1;
% THETA  = 0; <Don't define it!>
FrameErrorEvent.Code = 0;
FrameErrorEvent.Device = 'none';
isPhotodiode = 0;
isIsochronous = 0;
Priority = 'OPTIMAL';
Forward.doIt = false; 

for i = 1 : length(varargin)
    if strcmpi(varargin{i},'Get')
        if strcmpi(varargin{i+1},'Keyboard') | strcmpi(varargin{2},'Serial') %#ok<OR2>
            Get = upper(varargin{i+1}(1)); % 'K', 'S'
            ValuesToGet = varargin{i+2};
            if Get == 'K', ValuesToGet = getkeycode(ValuesToGet,'PTB'); end
        end
        
    elseif strcmpi(varargin{i},'Send')
        if strcmpi(varargin{i+1},'parallel') | strcmpi(varargin{i+1},'serial') | strcmpi(varargin{i+1},'daq') %#ok<OR2>
            Send = upper(varargin{i+1}(1)); % 'P', 'S' or 'D'
            BytesToSend = varargin{i+2};
            if Send == 'P', BytesToSend(isnan(BytesToSend)) = 0; end
        elseif strcmpi(varargin{i+1},'photodiode')
            if any(varargin{i+2} > 0)
                isPhotodiode = 1;
                PhotodiodeHalfbytesToSend = varargin{i+2};
            end
        else
            error('Unknown "Send" device.')
        end

    elseif strcmpi(varargin{i},'Forward') %<v2-beta32/v3-beta12/SinStim-1.8.12>
        Forward.InputValues = varargin{i+1};
        if isnumeric(varargin{i+2}),  Forward.OutputValues = varargin{i+2};
        else                          Forward.OutputValues = Forward.InputValues;
        end
        if ~isempty(Forward.InputValues),  Forward.doIt = true;
        end
        Forward.PrevVal = 0;
        Forward.NextVal = 0;

    elseif strcmpi(varargin{i},'Alpha')
        ALPHA = varargin{i+1};
        
    elseif strcmpi(varargin{i},'Scale')
        XSCALE = varargin{i+1};
        YSCALE = varargin{i+1};
        
    elseif strcmpi(varargin{i},'XScale')
        XSCALE = varargin{i+1};
    elseif strcmpi(varargin{i},'YScale')
        YSCALE = varargin{i+1};
        
    elseif strcmpi(varargin{i},'AxesRotation')
        ETA = varargin{i+1};
        
    elseif strcmpi(varargin{i},'BufferRotation') | strcmpi(varargin{i},'Rotation') %#ok<OR2>
        THETA = varargin{i+1};
        
    elseif strcmpi(varargin{i},'Draw')
        % <- varargin
        Draw.Shape = varargin{i+1};
        if ~iscell(Draw.Shape), Draw.Shape = repmat({Draw.Shape},1,N); end
        Draw.X = varargin{i+2};
        Draw.Y = varargin{i+3};
        Draw.W = varargin{i+4};
        if size(varargin{i+5},3) < 3, i1 = i+5;
        else                          i1 = i+4;
        end
        Draw.H = varargin{i1};
        Draw.RGB = varargin{i1+1};
        if length(varargin) >= i1+2 && isnumeric(varargin{i1+2})
            Draw.L = varargin{i1+2};
        else
            Draw.L = 1;
        end
        % 1-by-1 -> b-by-s
        s = max([size(Draw.X,1) size(Draw.Y,1)]);
        fields = fieldnames(Draw);
        for f = 1 : length(fields)
            x = fields{f};
            if size(Draw.(x),1) == 1, Draw.(x) = repmat(Draw.(x),s,1); end
            if size(Draw.(x),2) == 1, Draw.(x) = repmat(Draw.(x),1,N); end
        end
        
    elseif strcmpi(varargin{i},'FrameErrorEvent')
        FrameErrorEvent.Code = varargin{i+1};
        FrameErrorEvent.Device = varargin{i+2};
        
    elseif strcmpi(varargin{i},'Isochronous')
        isIsochronous = varargin{i+1};
        
    elseif strcmpi(varargin{i},'Priority')
        Priority = varargin{i+1};
        
    elseif strcmpi(varargin{i},'Splash')
        Splash.Message   = varargin{i+1};
        Splash.BgColor   = varargin{i+2};
        Splash.FontColor = varargin{i+3};
        if length(varargin) >= i+4 && isnumeric(varargin{i+4})
            Splash.TimeOut = varargin{i+4};
        else
            Splash.TimeOut = inf;
        end
        if length(varargin) >= i+5 && isnumeric(varargin{i+5})
            Splash.Delay = varargin{i+5};
        else
            Splash.Delay = 0;
        end
        if length(varargin) >= i+6 && isnumeric(varargin{i+6})
            Splash.DelayBuffer = varargin{i+6};
        else
            Splash.DelayBuffer = 0;
        end
    end
end

%% *-by-* -> b-by-N matrices
if size(B,1) == 1, B = repmat(B,b,1); end
if size(B,2) == 1, B = repmat(B,1,N); end
if size(X,1) == 1, X = repmat(X,b,1); end
if size(X,2) == 1, X = repmat(X,1,N); end
if size(Y,1) == 1, Y = repmat(Y,b,1); end
if size(Y,2) == 1, Y = repmat(Y,1,N); end
if size(XALIGN,1) == 1, XALIGN = repmat(XALIGN,b,1); end
if size(XALIGN,2) == 1, XALIGN = repmat(XALIGN,1,N); end
if size(YALIGN,1) == 1, YALIGN = repmat(YALIGN,b,1); end
if size(YALIGN,2) == 1, YALIGN = repmat(YALIGN,1,N); end
if size(XSCALE,1) == 1, XSCALE = repmat(XSCALE,b,1); end
if size(XSCALE,2) == 1, XSCALE = repmat(XSCALE,1,N); end
if size(YSCALE,1) == 1, YSCALE = repmat(YSCALE,b,1); end
if size(YSCALE,2) == 1, YSCALE = repmat(YSCALE,1,N); end
if size(ALPHA,1) == 1, ALPHA = repmat(ALPHA,b,1); end
if size(ALPHA,2) == 1, ALPHA = repmat(ALPHA,1,N); end
if exist('ETA','var')
    if size(ETA,1) == 1, ETA = repmat(ETA,b,1); end
    if size(ETA,2) == 1, ETA = repmat(ETA,1,N); end
end
if exist('ETA','var') & ~exist('THETA','var'); %#ok<AND2>
    THETA = ETA;
end
if size(THETA,1) == 1, THETA = repmat(THETA,b,1); end
if size(THETA,2) == 1, THETA = repmat(THETA,1,N); end

%% Correct X, Y
% for Scale
[W,H] = buffersize(B);
W = W .* XSCALE;
H = H .* YSCALE;
X(XALIGN=='L') = X(XALIGN=='L') + W(XALIGN=='L')/2;
X(XALIGN=='R') = X(XALIGN=='R') - W(XALIGN=='R')/2;
Y(YALIGN=='T') = Y(YALIGN=='T') - H(YALIGN=='T')/2;
Y(YALIGN=='B') = Y(YALIGN=='B') + H(YALIGN=='B')/2;

% for Axes Rotation
if exist('ETA','var')
    [TH,R] = cart2pol(X,Y);
    TH = TH - ETA * pi/180;
    [X,Y] = pol2cart(TH,R);
    if ~isempty(Draw.Shape)
        [TH,R] = cart2pol(Draw.X,Draw.Y);
        E = repmat(ETA(1,:),size(Draw.X,1),1); % we suppose that angle is the same for every buffer.
        TH = TH - E * pi/180;
        [Draw.X,Draw.Y] = pol2cart(TH,R);
    end
end

%% PsychToolBox: Get "RECT" argument
% To get best performances in the real-time loop, we'll use PTB's Screen function
% directly. (Much faster than copybuffer, mainly due to current lack of optimization
% in convertcoord.)
XY = [X(:) Y(:)];  % b*N-by-2
% WH = zeros(b*N,2); % b*N-by-2
% for i = 1 : b*N, WH(i,:) = buffersize(B(i)); end
WH = [W(:) H(:)];
RECT = convertcoord('XY,WH -> RECT',XY,WH); % 4-by-b*N
RECT3 = zeros(4,b,N); % 4-by-b-by-N
RECT3(:) = RECT(:);

%% Export reprocessing duration to workspace
assignin('base','dt_displayanimation',toc)

%% Splash Screen
if exist('Splash','var')
    rgb = getbackgroundcolor; %<v3-beta37>
    displaymessage(Splash.Message,Splash.BgColor,Splash.FontColor,...                   % W...a...i...t...
        'continue',getkeynumber('Enter'),'quit',getkeynumber('Escape'),Splash.TimeOut);
    if Splash.Delay
        %         clearbuffer(0); % <todo: usefull? displaybuffer has already cleared buff0!>
        tEndSplash = displaybuffer(Splash.DelayBuffer);
        waitsynch(Splash.Delay);
    end
    setbackground(rgb); %<v3-beta37>
end

%% Init. Var.
DisplayTimes = NaN + zeros(1,N+1);
ReadyToDisplayTimesPTB = NaN + zeros(N,1); %<v2-beta32/27fev2012: JBB fix, bug report 25-01-2012: was not preallocated.>
ReadyToDisplayTimesCOG = NaN + zeros(N,1); %<v2-beta32/27fev2012: JBB fix, bug report 25-01-2012: was not preallocated.>
ReturnFromDisplayTimesPTB = NaN + zeros(N,1); %<v2-beta32/27fev2012: JBB fix, bug report 10-02-2012: make it vertical to fix stat bug below.>
ReturnFromDisplayTimesCOG = NaN + zeros(N,1); %<v2-beta32/27fev2012: JBB fix, bug report 10-02-2012: make it vertical to fix stat bug below.>
GetValues = NaN + zeros(1,N);
GetTimes  = NaN + zeros(1,N);
SendTimes = NaN + zeros(1,N+1);
BytesSent = NaN + zeros(1,N+1); %<v3-beta37>
FramesMissed = zeros(1,N);  % # of frame misses detected
FramesSkipped = false(1,N); % 1 if skipped, 0 if not.
all_j = NaN + zeros(1,N);
OneFrame = getframedur;

%% PRECOMPILE FUNCTIONS
j = 1;
if isPhotodiode
    setphotodiodevalue(0);
end
if ~isempty(Draw.Shape)
    xy = [Draw.X(:,j) Draw.Y(:,j)];
    wh = [Draw.W(:,j) Draw.H(:,j)];
    rgb = reshape(Draw.RGB(:,j,:),size(Draw.RGB,1),3);
    l = Draw.L(:,j);
    draw(Draw.Shape{j},rgb,0,xy,wh,l);
end

%% MAIN LOOP
setpriority(Priority) %=================================================
dispinfo(mfilename,'info','Starting real-time animation...')
j = 1;
old_j = 1; % <This fixes "miss frame #3 bug! old_j must be defined to avoid a delay on second iteration!>
str = '';  % <id.>

tMainLoopStart = time;
% t0=time;
while j <= N
    % Create image to display in backbuffer
    % For optimization, we use directly lower-level C functions.
% if j==1, t383=time-t0, end
    ii = ~isnan(B(:,j));
    if any(ii)
        if isptb
            Screen('DrawTextures',gcw,B(ii,j),[],RECT3(:,ii,j),THETA(ii,j),[],ALPHA(ii,j));
        else
            error('Not yet implemented for CogentGraphics.')
        end
    end
% if j==1, t390=time-t0, end
    if ~isempty(Draw.Shape)
        xy = [Draw.X(:,j) Draw.Y(:,j)];
        wh = [Draw.W(:,j) Draw.H(:,j)];
        rgb = reshape(Draw.RGB(:,j,:),size(Draw.RGB,1),3);
        l = Draw.L(:,j);
        draw(Draw.Shape{j},rgb,0,xy,wh,l);
    end
% if j==1, t398=time-t0, end
    % Photodiode: Draw square for photodiode?
    if isPhotodiode
        setphotodiodevalue(PhotodiodeHalfbytesToSend(j));
    end
% if j==1, t403=time-t0, end
    % Wait trigger
    % <TODO>

    % Display!
    ReadyToDisplayTimesPTB(j) = time;
    if ispc, ReadyToDisplayTimesCOG(j) = cogstd('sGetTime',-1); end
    DisplayTimes(j) = displaybuffer(0); %  <----- D I S P L A Y  !
    ReturnFromDisplayTimesPTB(j) = GetSecs;
    if ispc, ReturnFromDisplayTimesCOG(j) = cogstd('sGetTime',-1); end
% if j==1, t413=time-t0, end
    % Frame errors <takes 0.060ms to execute on DARTAGNAN>
    nMisses = 0;
    nSkips  = 0;
    if j > 1 % <AVOID THIS !!!>
        dt = DisplayTimes(j) - DisplayTimes(old_j); % <v1.6.1 (fix v1.4): j-1 -> old_j !!!> <v1.6.2: Fix "miss fram #3 bug: old_j must be declared>
        if dt > 1.5 * OneFrame
            nMisses = round(dt / OneFrame) - 1;
            FramesMissed(j) = nMisses;
        end
    end
% if j==1, t424=time-t0, end
    % -Isochronous mode: Correct missed refreshes:
    if isIsochronous && nMisses > 0
        nSkips = nMisses;
        j1 = min([N j+nSkips]);
        FramesSkipped(j+1:j1) = 1;
        FramesMissed(j+1:j1) = NaN;
        if strcmpi(FrameErrorEvent.Device,'serial')
            sendserialbytes(1,FrameErrorEvent.Code);
        end
    end
% if j==1, t435=time-t0, end
    % Just after display: Send Event?
    if     Send == 'P'
        b = BytesToSend(j);
        if nSkips && strcmpi(FrameErrorEvent.Device,'parallel') % Isochronous mode..
            b = b + FrameErrorEvent.Code; % ..send error code
        end
        sendparallelbyte(b);
        if BytesToSend(j)
            SendTimes(j) = time;
        end
    elseif Send == 'S'
        if ~isnan(BytesToSend(j))
            sendserialbytes(1,BytesToSend(j));
            SendTimes(j) = time;
        end
    elseif Send == 'D'
        % <TODO>
    end
% if j==1, t454=time-t0, end
    % Get Events?
    if Get == 'K'
        [n,c,t] = checkkeydown(ValuesToGet);
        GetValues(j) = n(1);
        GetTimes(j)  = t(1);
    elseif Get == 'S',
        % <TODO>
    end
    
    % Abort?
    if isaborted, break, end % !
    
    % Wait...
    if ~isempty(Durations) && Durations(j) > 0
        if Durations(j)
            waitsynch(Durations(j));   %  W . . . a . . . i . . . t . . .
        end
    end
% if j==1, t473=time-t0, end
    % j+
    if nSkips > 0 % Isochronous mode:
        msg = ['Missed  frame(s) # ' int2str(old_j+1 : old_j+nSkips) '. ' ...
                'Skipping frame(s) # ' int2str(old_j+2 : old_j+nSkips+1) ' to correct temporal shift.'];
        dispinfo(mfilename,'warning',msg);
        disp(str)
    end
    old_j = j;
    all_j(j) = j;
    j = j + 1 + nSkips;
% if j==1, t483=time-t0, end
end

%% End
if ~isaborted, nDisplayed = N;
else         nDisplayed = j;
end
clearbuffer(0); % <todo: usefull? displaybuffer has already cleared buff0!>
t1 = displaybuffer(0);
DisplayTimes(nDisplayed+1) = t1; % Add "the end" display time
if Send == 'P'
    if ~isaborted 
        if length(BytesToSend) > N
            t1 = sendparallelbyte(BytesToSend(N+1));
            wait(1);
            sendparallelbyte(0);
        else
            t1 = sendparallelbyte(0);
        end
        SendTimes(nDisplayed+1) = t1;
    else
        sendparallelbyte(0);
    end
end

dispinfo(mfilename,'info','...end real-time animation.')
setpriority('NORMAL') %===================================================


%% TIMES
RawDisplayTimes = DisplayTimes;
ReturnFromDisplayTimesPTB = ReturnFromDisplayTimesPTB * 1000;
ReturnFromDisplayTimesCOG = ReturnFromDisplayTimesCOG * 1000;

if exist('tEndSplash','var'),  Delay = DisplayTimes(1) - tEndSplash;
else                           Delay = 0;
end

Durations(Durations==0) = OneFrame;
nFrames = sum(round(Durations / OneFrame));
t0 = DisplayTimes(1);
DisplayTimes = DisplayTimes - t0;

t = DisplayTimes([~FramesSkipped true]);
dt = diff(t);
DisplayIntervals = NaN + zeros(1,N);
DisplayIntervals(~FramesSkipped) = dt;

if isptb 
    ReadyToDisplayTimes = ReadyToDisplayTimesPTB;
    ReturnFromDisplayTimes = ReturnFromDisplayTimesPTB;
else      
    ReturnFromDisplayTimes = ReturnFromDisplayTimesCOG;
    ReadyToDisplayTimes = ReadyToDisplayTimesCOG;
end

GetTimes = GetTimes - t0;
SendTimes = SendTimes - t0;
% <todo: remove the following in next version>
% if isIsochronous
%     ok = ~isnan(all_j);
%     t = DisplayTimes([ok true])
%     dt = diff(t);
%     e = abs(Durations(ok) - dt);
%     e = round(e / getframedur);
%     FrameErr(ok) = e;
% else
%     e = abs(Durations - diff(DisplayTimes));
%     FrameErr = round(e / getframedur);
% end
    

%% STATS
% Export stats in a global variable <GLab v2-beta10, rewritten in v2-beta12b>
% <SinStim 1.6.1+: No more used directly ==> Modularity is restored>

try % We want to compute stats without lowering the function stability
    s = struct;
    
    % General info
    s.ScreenFreq_Hz = getscreenfreq;
    s.CosyGraphicsVersion = cosyversion('str');
    s.MatlabVersion = version;
    if isIsochronous, s.Mode = 'isochronous';
    else              s.Mode = 'non-isochronous';
    end
    
    % Displays
    s.Displayed = nDisplayed;
    pd.DisplayTimes_ms = DisplayTimes; % final timestamps
    pd.DisplayIntervals_ms = DisplayIntervals;
    pd.DisplayIntervals_frames = round(DisplayIntervals / OneFrame);
    
    % Missed Frames
    nFrameMisses = sum(FramesMissed(FramesMissed > 0));
    s.MissedRefreshDeadlines_ERRORS = nFrameMisses;
    s.FramesSkippedToCorrect = sum(FramesSkipped > 0);
    f = find(FramesMissed > 0); % <NB: find(FramesMissed) would find also NaNs>
    s.MissedRefreshDeadlines_frameindexes = f;
    s.MissedRefreshDeadlines_framespermiss = FramesMissed(f);
    pd.FramesMissed = FramesMissed;
    pd.FramesSkipped = FramesSkipped;
    
    % Send/Get Bytes
    pd.SentTimes_ms = SendTimes;
    ii = find(SendTimes > 0);
    pd.ValuesToBeSent_byte = BytesToSend;
    pd.ValuesActuallySent_byte = BytesSent; %<v3-beta37>
    s.BytesSent = length(ii);
    ii_notsent = find(BytesToSend > 0 & [FramesSkipped false]);
    s.BytesNotSent_ERRORS = length(ii_notsent);
    s.BytesNotSent_frameindexes = ii_notsent;
    s.BytesNotSent_values = BytesToSend(ii_notsent);
    if isPhotodiode
        ii_notdiode = find(PhotodiodeHalfbytesToSend > 0  &  FramesSkipped);
        s.PhotodiodeNotDisplayed_ERRORS = length(ii_notdiode);
        s.PhotodiodeNotDisplayed_frameindexes = ii_notdiode;
        s.PhotodiodeNotDisplayed_halfbytes = PhotodiodeHalfbytesToSend(ii_notdiode);
    end
    pd.GotTimes_ms    = GetTimes;
    pd.GotValues_byte = GetValues;
    
    % Durations
    s.DelayBeforeStart_s = Delay / 1000;
    TotalDuration_ms = DisplayTimes(nDisplayed+1) - DisplayTimes(1);
    s.TotalDuration_s = TotalDuration_ms / 1000;
    s.TotalDuration_frames = round(TotalDuration_ms / OneFrame);
    s.TotalDuration_ERROR = s.TotalDuration_frames - nFrames;
    s.TotalDurationImprecision_ms = TotalDuration_ms - nFrames*OneFrame;
    pd.DEBUG.ReadyToDisplayTimes_ms = ReadyToDisplayTimes;
    pd.DEBUG.RawDisplayTimes_ms = RawDisplayTimes; % raw times, as returned by Screen('flip') (without substracting t0, but divided by 1000)
    pd.DEBUG.ReturnFromDisplayTimesPTB_ms = ReturnFromDisplayTimesPTB; % times without beam position correction
    pd.DEBUG.ReturnFromDisplayTimesCOG_ms = ReturnFromDisplayTimesCOG; % id., from low res. timer trough cogstd
    
    % CPU Execution Duration:
    CpuTimes = [NaN; ReadyToDisplayTimes(2:end) - ReturnFromDisplayTimes(1:end-1)]; % CPU exec times. %<v2-beta32/27fev2012: JBB fix, bug report 10-02-2012: changed to vertical concatenation.>
    CpuTimes(1) = ReadyToDisplayTimes(1) - tMainLoopStart;
    pd.CpuTimes_ms = CpuTimes;
    xd = CpuTimes(~isnan(CpuTimes));
    s.CpuTime_FirstLoop_ms  = xd(1); % loop 1 (prepares frame 2)
    s.CpuTime_SecondLoop_ms = xd(2); % loop 2 (prepares frame 3)
    mmm = [min(xd) median(xd) max(xd(3:end))]; % Don't take in account frame 1 and 2 for max, because of interpreter overload
    s.CpuTime_MinMedianMax_ms = mmm;
    s.CpuLoad_MinMedianMax_pc = mmm * 100 / OneFrame;
%     if mmm(2) >= OneFrame,   s.CpuLoad_ERROR = true;  % longer than frame interval
%     else                     s.CpuLoad_ERROR = false;
%     end
%     if mmm(2) >= OneFrame/2, s.CpuLoad_WARNING = true; % longer than half the frame interval
%     else                     s.CpuLoad_WARNING = false;
%     end
    s.CpuLoadAboveCapacity_ERRORS = sum(CpuTimes(2:end) >= OneFrame); % longer than frame interval
    s.CpuLoadAboveHalfCapacity_WARNINGS = sum(CpuTimes(2:end) > OneFrame/2); % longer than half the frame interval

    % Timer Imprecision:
    TimerImprecisions = pd.DisplayIntervals_ms - pd.DisplayIntervals_frames * OneFrame;
    pd.TimerImprecisions_ms = TimerImprecisions;
    TimerImprecisions = abs(TimerImprecisions);
    s.TimerImprecision_MinMedianMax_ms = [min(TimerImprecisions) median(TimerImprecisions) max(TimerImprecisions)];
    s.TimerImprecisionAbove2ms_ERRORS = sum(TimerImprecisions > 2); % > 2 ms is considered as an error.
    s.TimerImprecisionAbove2ms_frameindexes = find(abs(TimerImprecisions) > 2);
    
    % % debug
    % pd.DEBUG.all_j = all_j;
    
    % Fix "[1x0 double]" display>
    fields = fieldnames(s);
    for f = 1 : length(fields)
        if isempty(s.(fields{f})), s.(fields{f}) = []; end
    end
    
catch
    disp(' ')
    disp('DISPLAYANIMATION ERROR!:  !!! ----- DISPLAYANIMATION MADE A BUG DURING STATS COMPUTATIONS ----- !!!')
    disp('The function will try to continue but it''s behavior is now unpredictable.')
    disp('Please copy/paste the following MATLAB error message and send it to ben.jacob@uclouvain.be:')
    disp(' ')
    disp(lasterr)
    disp(' ')
    
end


%% EXPORT STATS
% pd -> s.PERDISPLAY
try s.PERDISPLAY = pd; end

% Export s
stats = s; % <v2-beta17>
COSY_FUNCTIONS.displayanimation = s; % -> global var.
assignin('base','stats',s);          % -> workspace
assignin('caller','stats',s);        % -> calling function 
disp('DISPLAYANIMATION-info: Stats about the animation have been exported to your workspace.')
disp('                       You can now find it in the "stats" structure:')
disp(' ')
disp(s)


%% ERROR MESSAGES   
% <v2-beta12b: Moved from SinStim 1.6.2>
% <v2-beta15:  Moved to helper_checkerrors>

thresh = 5; % <TODO: hard coded -> global var?>
helper_checkerrors(mfilename,'missedframes',FramesMissed,nDisplayed,thresh,isIsochronous);

% % Big error: display CosyGraphics warning
% if ~isaborted && nFrameMisses >= 5 + 5*isIsochronous; % Tresh is 5 in std mode and 10 in isochronous mode. <TODO: global var?>
%     str = {'!!! Timing errors !!!';...
%             '';...
%             'Unusual number of timing errors:';...
%             '';...
%             [int2str(nFrameMisses) ' frames where missed.']};
%     displaywarning(str);
% end
% % Display in Command window
% str = [int2str(nFrameMisses) ' missed frames, on ' int2str(nDisplayed) ' displayed.'];
% if ~isaborted && nFrameMisses > 0
%     % Error: Display WARNING
%     disp('DISPLAYANIMATION WARNING: ')
%     str = [str ' Frames which where missed are:  ' int2str(nFrameMisses)];
%     disp(str)
%     if isIsochronous
%         disp('Isochronous mode: Frames have been skipped to correct the phase shift.')
%     else
%         disp('Non-isochronous mode: No correction has been applied.')
%     end
% elseif ~isaborted
%     % No Error: Display INFO
%     str = [str ' :-)'];
%     disp(['DISPLAYANIMATION INFO: ' str])
% else
%     disp(['DISPLAYANIMATION INFO: ABORTED BY USER! ' str])
% end
% disp(' ')


%% Save Log  <v2-beta14>
if isfullscreen
    logfile = fullfile(cosydir('log'), [mfilename datesuffix]);
    v = version;
    if v >= '7', save(logfile,'-v6');
    else         save(logfile);
    end
end


%% Output Arg.
varargout = {};
if Get
    varargout{end+1} = GetValues;
    varargout{end+1} = GetTimes;
end
if Send
    varargout{end+1} = SendTimes;
end


%% Done.
dispinfo(mfilename,'info','Done.')
disp(' ')