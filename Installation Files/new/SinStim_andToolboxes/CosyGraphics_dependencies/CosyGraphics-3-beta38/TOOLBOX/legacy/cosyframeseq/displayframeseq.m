function isFailed = displayframeseq(varargin)
% DISPLAYFRAMESEQ  Display trajectories prepared by FRAMESEQ.
%
%    DISPLAYFRAMESEQ(S)  display target defined by S. S is the output from FRAMESEQ (see).
%
%    DISPLAYFRAMESEQ(S, S2,... ,Sn)  displays main target S, plus secondary targets S2,...
%
% Example: 
%    See HELP FRAMESEQ.
%
% Options:
%    DISPLAYFRAMESEQ(...,'-tolwin',device,isActive,isDrawn)  sets tolerance window options. device
%    can be 'mouse' or 'eyelink'. isActive can be 0 (disable experiment control) or 1 (respect the
%    settings from FRAMESEQ. isDrawn can
%    be 0 (don't draw eye and tolerance window) or 1 (draw them).
% 
%    DISPLAYFRAMESEQ(...,'-sound',b,t)  plays sounds stored in buffers n° b (see STORESOUND, 
%    STORETUUT) at times t (ms). b and t are 1-by-N vectors. Note that you cannot play twice the 
%    same buffer ; if you need to play a sound more than once, store it several times in different
%    buffers.
%
%        Example: Synchronizing sound start with a display event:
%            startcogent;           % starts Cogent display, with default settings
%            opensound;             % initialize sound, with default settings
%            storetuut(3000,200,1); % stores a 3000 Hz, 200 ms, sine wave in buffer #1)
%            grayPoint = frameseq('round',20,[.5 .5 .5],'fix',[0 0],1000);  % gray point, 1 s
%            redPoint  = frameseq('round',20,[1 0 0],'fix',[0 0],700);      % red point, 700 ms
%            traj = [grayPoint redPoint]; 
%            displayframeseq(traj,'-sound',1,1000) % displays points, playing the sound when the point's color changes
%
% See also FRAMESEQ.
%
% Ben,  Jun 2010.


%% Params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nFrameOutToFail = 3; % Number of frame out to be considered failed.
TolWinColor = [0 0 .5]; % monkey lab: must be blue
EyeColor    = [0 0 1];  % monkey lab: must be blue
EyeDiameter = 8;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Input Args
% Targets
% - First arg is always a target:
S = varargin{1};
varargin(1) = [];
% - Multiple targets: Concatenate vertically target structures:
while ~isempty(varargin)
    if ~ischar(varargin{1})
        S = [S; varargin{1}];
        varargin(1) = [];
    else % ischar: First option
        break
    end
end

% Options
TolWin.Device = 'mouse'; % <TODO: Suppress this argument!>
TolWin.isActive = 1;
TolWin.isDrawn = 0;
Sound.Buffers = [];
Sound.Times = [];
while ~isempty(varargin) % See:<!>
    % - Tolerance window
    if strcmpi(varargin{1},'tolwin') % <todo: remove this in further version>
        error('Option ''tolwin'' is deprecated: Please replace ''tolwin'' by ''-tolwin''.')
    elseif strcmpi(varargin{1},'-tolwin')        
        TolWin.Device = varargin{2}; % <TODO: Suppress this argument!>
        TolWin.isActive = char(varargin{3});
        TolWin.isDrawn = varargin{4};
        varargin(1:4) = []; % <!>   % <todo: If suppressing Device argument: 1:4 -> 1:3>
    % - Sound
    elseif strcmpi(varargin{1},'-sound')
        Sound.Buffers = varargin{2};
        Sound.Times = varargin{3};
        varargin(1:3) = []; % <!>
    else
        disp(varargin{1})
        error('Invalid option.')
    end
end


%% Vars
% #
nTargets = size(S,1);
nFrames  = size(S,2);
Times = zeros(1,nFrames);
SendTimes = zeros(1,nFrames);

% Tolerance window
isOutside = 0;
isFailed = 0;
isTolWin = false(1,nFrames);
for i = 1 : nTargets
    wh = [S(i,:).tolwin];
    wTolWin = wh(1:2:end);
    hTolWin = wh(2:2:end);
    if any(hTolWin) % We found the target which has a tolerance window..
        isTolWin = wTolWin > 0;
        xTolWin = [S(i,:).x];
        yTolWin = [S(i,:).y];
        break % <---!!!                               ..and we stop here
    end
end

% Sound
% - 1st alternative: Sound can be defined as an option. In this case we already got the Sound.Buffers
% and Sound.Times variables (see above).
ii = round(Sound.Times / oneframe) + 1; % ms -> frames
Sound.PerFrame = zeros(1,nFrames);
Sound.PerFrame(ii) = Sound.Buffers;
% - 2d alternative: Sound can be defined by frameseq in the S.sound field. We'll now add 
% those data to Sound.PerFrame. NB: The two alternatives can be both used, but starting more than
% one audio-buffer at the same time is not supported: the last buffer ID will erase the previous
% one in Sound.PerFrame. NB2: The Sound.Buffers and Sound.Times variables are not used here.
for i = 1 : nTargets
    jj = find([S(i,:).sound]);
    Sound.PerFrame(jj) = [S(i,jj).sound];
end
% Check sound
% if length(Sound.Buffers) > length(unique(Sound.Buffers))
%     stopcosy;
%     error(['Cannot play the same sound sound buffer more than once.' 10 ...
%         'If you want to play a sound several times, store it several times in different buffers.'])
% end

% Load TDT Constants
TDT = TDT_params;

% Events: Prepare display event at each "movement change".
isEvent.Mov = false(1,nFrames);
LastEvent.Mov = zeros(1,nFrames);
isEvent.Mov(1) = 1;
last_j = 1;
for j = 2 : nFrames
    if ~strcmp(S(1,j-1).movement, S(1,j).movement)
        isEvent.Mov(j) = 1;
        LastEvent.Mov(j) = last_j;
        last_j = j;
    end
end

% Target names
TargetNames = cell(1,nTargets+1); % # targets + 1 eye
TargetNames{1} = 'target';
for t = 2 : nTargets
    TargetNames{t} = sprintf('target%d',t);
end
TargetNames{end} = 'eye';


%% PSB: arm target sync
if isopen('PSB')
    psb_armtargetsync on
end


%% MAIN LOOP
starttrial(TargetNames,nFrames);   %===================================================

for j = 1 : nFrames
% t0=time;
% profile on
% for ddd= 1:1000 % <DEBUG!!!>
    % CHECK TOLERANCE
    if isopen('eyelink'),  [xEye,yEye] = geteye;
    else                   [xEye,yEye] = getmouse;
    end
    if isTolWin(j)
        if      xEye < xTolWin(j) - wTolWin(j)/2 || xEye > xTolWin(j) + wTolWin(j)/2 || ...
                yEye < yTolWin(j) - hTolWin(j)/2 || yEye > yTolWin(j) + hTolWin(j)/2
            isOutside = isOutside + 1;
        end
        if TolWin.isActive && isOutside >= nFrameOutToFail
            clearbuffer(0);
            displaybuffer(0,inf);
            isFailed = -1;
            break % <---!!!
        end
    else
        isOutside = 0;
    end
    
    % DRAW
    clearbuffer; % For background <TODO: optimize this>
    for i = 1 : nTargets
        % Draw target(s) in backbuffer
        movement = S(i,j).movement;
        xy = [S(i,j).x S(i,j).y];
        if ~strcmp(movement,'') && ~strcmp(movement,'gap')
            drawtarget(i, S(i,j).shape, S(i,j).color, 0, xy, S(i,j).size);
        end
    end
    % Draw tolerance box
    if TolWin.isDrawn
        drawtarget(nTargets+1, 'round', EyeColor, 0, [xEye yEye], EyeDiameter);
        if isTolWin(j)
            draw('rect', TolWinColor, 0, xy, S(i,j).tolwin, 1);
        end
    end
% end
% profile viewer
% dt204=time-t0
    % DISPLAY!
    Times(j) = displaybuffer(0, oneframe, S(1,j).movement);     %  <----- D I S P L A Y  !
% t0=time;
    % SEND EVENTS (Just after display!)
    if isopen('TDT')
        b = TDT.ParallelTriggers.FrameStart;
        if j == 1
            b = b + TDT.ParallelTriggers.TrialStart;
            disp('-> TDT: trial start')
        end
        SendTimes(j) = sendparallelbyte(b);
    end
    
    % PLAY SOUND! (Just after display!)
    % Programmer's note: I send first // outputs, then we start sound, because 1) I know execution 
    % time of sendparallelbyte: 200 to 250 µs, and it's short in comparison of the expected delay 
    % of sound on MS-Windows. <TODO: review this after sound testing on oscilloscope!>
    if Sound.PerFrame(j)
        playsound(Sound.PerFrame(j));
    end
    
    % RESET // PORT
    if isopen('TDT')
       wait(TDT.ParallelTriggerWidth) % Wait... 
       sendparallelbyte(0);
    end
    
    % EVENT
    if isEvent.Mov(j)
        if j > 1
            last_j = LastEvent.Mov(j);
            expected = (j - last_j) * oneframe;
            msg = sprintf('End   "%5s".', S(1,last_j).movement);
            helper_dispevent(mfilename, msg, Times(j), expected);
        end
        msg = sprintf('Start "%5s"...', S(1,j).movement);
        helper_dispevent(mfilename, msg, Times(j));
    end
% dt242=time-t0;
    % ABORT?
    if isabort
        break % !
    end
end

%% End
% Display end frame
clearbuffer;
tEnd = displaybuffer(0,inf);     %  <----- D I S P L A Y  !
f = find(isEvent.Mov);
last_j = f(end);
expected = (j - last_j) * oneframe;
msg = sprintf('End   "%5s".', S(1,last_j).movement);
helper_dispevent(mfilename, msg, Times(j), expected);

% TDT: Send end trigger after end frame onset
if isopen('TDT')
    b = TDT.ParallelTriggers.FrameStart + TDT.ParallelTriggers.TrialEnd;
    SendTimes(end+1) = sendparallelbyte(b);
    disp('-> TDT: trial end')
    wait(TDT.ParallelTriggerWidth)
    sendparallelbyte(0);
end

% Stop trial
stoptrial;  %===================================================

%% PSB: target sync off
if isopen('PSB')
    psb_armtargetsync off
end

% %% Export vars to workspace
% assignin('base','DisplayTimes',Times)
% assignin('base','SendTimes',SendTimes)