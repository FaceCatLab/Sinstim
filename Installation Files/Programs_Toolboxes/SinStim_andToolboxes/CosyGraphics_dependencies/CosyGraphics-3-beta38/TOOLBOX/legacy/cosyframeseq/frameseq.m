function S = frameseq(What,varargin)
% FRAMESEQ  Prepare input variables for DISPLAYFRAMESEQ.
%    General syntax:
%       S = FRAMESEQ(What,...,Movement,... <,'-option1',...> <,'-option2',...>
%
%    What:
%       FRAMESEQ('',Duration)  displays nothing for Duration in milliseconds.
%
%       FRAMESEQ(Shape,Color,Size,...)
%       FRAMESEQ(Shape,Color,Size,LineWidth,...) <TODO: orientation>
%
%       FRAMESEQ('buffer',b,...)
%
%       FRAMESEQ('text',string,<FontName>,Size,Color,...)
%
%    Movement: (If you don't find what you which, see the 'custom' movement at the end)
%       FRAMESEQ(...,'fix',[x y],Duration)
%       FRAMESEQ(...,'fix',xyCenter,Rho,Theta,Duration) <todo>
%
%       FRAMESEQ(...,'step',[xstep ystep]) <TODO: coord abs or rel ?> <ans: rel, otherwise it's a fix>
%
%       FRAMESEQ('gap',Duration)  is the same that  FRAMESEQ('',Duration).
%
%       FRAMESEQ(...,'rampe',[x1 y1],Duration,[] ,[]   )  or,
%       FRAMESEQ(...,'rampe',[x1 y1],[]      ,Vel,[]   )  or,
%       FRAMESEQ(...,'rampe',[]     ,Duration,Vel,Alpha)  prepares a rampe from
%       the point x0, y0 to the point x1, y1, of duration 'Duration' (msec), at velocity 'Vel' and of 
%       orientation 'Alpha' (deg). Movement parameters which have to be computed are replaced by [].
%       [x0 y0] is never given as input argument: they are the co-ordinates of the last point of the 
%       previous movement (e.g.: a fixation or a step). See the drawing below to understand why.  
%
%               X ^
%                 |
%             x1 -|                             o  o  o  o  o  o
%                 |                          o
%                 |                       o
%                 |                    o
%                 |                 o
%             x0 -|  o  o  o  o  o
%                 '- |-----------|  |-----------|  |-----------|  ---> time
%                    t0   fix    t1 t0  rampe   t1 t0   fix    t1
%
%       FRAMESEQ(...,'arc',xyCenter,Rho,Theta1,Duration,[]    ,[]     )  or,  <todo>
%       FRAMESEQ(...,'arc',xyCenter,Rho,Theta1,[]      ,AngVel,VelSign)  or,  <todo>
%       FRAMESEQ(...,'arc',xyCenter,Rho,[]    ,Duration,AngVel,VelSign)       <todo>
%
%       FRAMESEQ( ... ,Shape,Size,Color,'continue',...)  x0 and y0 are the last x and y
%       values of the last call to FRAMESEQ. <???>
%
%       FRAMESEQ(...,'custom:xxx',xvect,yvect)
%
% Options:
%  - Tolerance Window:
%    FRAMESEQ(...,'-tolwin',GraceDuration,WinSize)  defines a tolerance window, appearing
%    after GraceDuration ms, of size given by the [width heigth] vector WinSize.
%
%  - Sound:
%    FRAMESEQ(...,'-sound',b,Delay)  associates a sound with the target. The sound  
%    previously stored in audio-buffer #b (by STORESOUND, STORETUUT or a similar STORE* function) 
%    will be  played Delay ms after the onset of the first frame. Delay will be rounded to an   
%    integer number of frames.
%
% Output:
%    The output S is a structure array (one structure per frame) containing the fields:
%           S.mov       Movement ('', 'fix', 'rampe', etc.)
%           S.what      'round', 'square', 'buffer', 'text', etc
%           S.size      Target width, or [width height], or relative coord for a arbitrary polygon
%           S.color     [r g b] or [r g b alpha] vector (values from 0.0 to 1.0)
%           S.x         x position (pixel)
%           S.y         y position (pixel)
%           S.option.tolwin    Tolerance window [width height] ([0 0] if no window)
%           S.option.sound     IDs of audio-buffers to be played (0 if none)
%
% Example: The incredible rashbass of the green point !!!
%    % Init display
%    startcogent % initializes Cogent display with default settings. Use startpsych to init psychToolbx display
%
%    % Get structures for each movement:
%    size = 10;
%    rgb = [1 0 0]; % MUST contain red for PSB !!!
%    fix1  = frameseq('round',rgb,size,'fix',[-200 0],1000,'-tolwin',250,[100 100]);
%    gap   = frameseq('',500);
%    rampe = frameseq('round',rgb,size,'rampe',[200 0],2000,[],[],'-tolwin',250,[200 100],'-sound',1,0);
%    fix2  = frameseq('round',rgb,size,'fix',[200 0],1000,'-tolwin',0,[100 100]);
%
%    % Concatenate structures:
%    target = [fix1 gap rampe fix2];
%
%    % Display trial
%    displayframeseq(target);
%
% See also DISPLAYFRAMESEQ.
%
% Ben,  Jun 2010.

% Ben,  Aug 2009       1-alpha
%       Mar 2010       1-beta: Fixed
%       Apr 2010       2-alpha: Doc only: Change arg. order <!!!>
%       Jun 2010       Change name <!>: *trajectory -> frameseq

% <TODO:
%  - Output: store options in sub-sub-structs: S.options.tolwin, S.options.sound, etc !!!
%  - Input: Add draw order # ?
% >

persistent last_x last_y

S = struct('what',[],'shape',[],'size',[],'color',[],'movement',[],'x',[],'y',[],'tolwin',[]);

%% Input Args: What & Shape
if ischar(What)
    What = lower(What); 
end

if isempty(What) || strcmp(What,'gap')           % Case 1: nothing.
    What = '';
    
elseif isshape(What) % <isshape is a sub-fun.>   % Case 2: shape.   
    Shape = What;
    What = 'shape';
    
elseif strcmp(Shape,'buffer')                    % Case 3: buffer.
    Shape = [];
    
elseif strcmp(Shape,'text')                      % Case 4: text.
    Shape = [];
    
else error('Unknown shape.')
    
end

%% Input Args: Movement ; Parse varargin; i0, i1
Movement = 'gap';
i0mov = 0;
i1mov = 0;
for i = 1 : length(varargin)
    if ismovement(varargin{i})  % <ismovement is a sub-fun.>
        Movement = lower(varargin{i});
        i0mov = i;
    end
end

[i0opt,i1opt] = findoptions(varargin);

if     i0mov,           i1what = i0mov - 1;
elseif ~isempty(i0opt), i1what = i0opt(1) - 1;
else                    i1what = length(varargin);
end

if i0mov
    if ~isempty(i0opt), i1mov = i0opt(1) - 1;
    else                i1mov = length(varargin);
    end
end

%% Input Arg: Parse varargin: What
switch What
    case 'shape'
        [Color,Size] = deal(varargin{1:2});
        if i1what >= 4,  LineWidth = varargin{4};
        else             LineWidth = 0;  % 0 = filled
        end
        
    case 'text'
        error('Case not yet implemented.') % <TODO!>
        
    case 'buffer'
        error('Case not yet implemented.') % <TODO!>
        
    otherwise
        [Shape,Color,Size] = deal(NaN); % <todo:???>
        
end

%% Input Arg: Parse varargin: Movement
% Check input consistency
switch Movement
    case {'step','rampe','arc'}
        if isempty(last_x)
            error(['A frame sequence cannot begin by a ' Movement '.' 10 ...
                'Probably, you should create a one frame fixation before.' 10 ...
                '(See the drawing in the function''s documentation.)'])
        end
end

% Parse varargin
switch Movement
    case {'','gap'} % nothing displayed
        ms = varargin{1};
        varargin(1) = [];
        nFrames = round(ms / oneframe); %<TODO: nominal ???>
        x = NaN * ones(1,nFrames);
        y = NaN * ones(1,nFrames);
        if strcmpi(Movement,'gap') % <???>
            x(end) = last_x;
            y(end) = last_y;
        end
    
    case 'fix'
        [xy,ms] = deal(varargin{i0mov+1:i1mov});
        nFrames = round(ms / oneframe);
        x = xy(1) * ones(1,nFrames);
        y = xy(2) * ones(1,nFrames);

    case 'step'
        xstep = varargin{i0mov+1}(1);
        ystep = varargin{i0mov+1}(2);
        x = last_x + xstep;
        y = last_y + ystep;
        nFrames = 1;

    case 'rampe'
        x1y1 = varargin{i0mov+1};
        ms   = varargin{i0mov+2};
        vel  = varargin{i0mov+3};
        alpha= varargin{i0mov+4};
        
        isarg = [0 0 0 0];
        for i = 1 : 4
            isarg(i) = ~isempty(varargin{i0mov+i});
        end

        if      all(isarg == [1 1 0 0])
            nFrames = round(ms / oneframe);
            x = linspace(last_x,x1y1(1),nFrames+1);
            x(1) = []; % x0 is the position of the last position *before* the rampe (see drawing in help header above)
            y = linspace(last_y,x1y1(2),nFrames+1);
            y(1) = []; % id.
        
        elseif  all(isarg == [1 0 1 0])
            error('Case not yet implemented.') % <TODO!>
            % ... <TODO>
            
        elseif  all(isarg == [0 1 1 1])
            error('Case not yet implemented.') % <TODO!>
            % ... <TODO>

        else
            error('Incorrect arguments: [x1 y1], Duration, Vel, Alpha are inconsistents.')

        end
        
        varargin(1:4) = [];

    case 'arc'
        [xy,Rho] = deal(varargin{i0mov+(1:2)});
        % ...

end

%% Output: x, y
for f = 1 : nFrames
    S(f).x = x(f);
    S(f).y = y(f);
end

%% Output: Movement, Shape, Size, Color
[S.what] = deal(What);
[S.shape] = deal(Shape);
[S.size]  = deal(Size);
[S.color] = deal(Color);
[S.movement] = deal(Movement);

%% Persistent: last_x, last_y
if ~isempty(Movement) && ~strcmp(Movement,'gap')
    last_x = S(end).x;
    last_y = S(end).y;
end

%% Options
[S.tolwin] = deal([0 0]); % Default: no tolerance window
[S.sound]  = deal(0);     % Default: no sound
[ii0,ii1] = findoptions(varargin);
for i = ii0
    switch lower(varargin{i}) % Tolerance window
        case '-tolwin'
            GracePeriod = varargin{i+1};
            WinSize     = varargin{i+2};
            GracePeriod = round(GracePeriod / (1000 / getscreenfreq('nominal'))); % ms -> frames
            for f = 1 : nFrames
                if f <= GracePeriod,    S(f).tolwin = [0 0];
                else                    S(f).tolwin = WinSize;
                end
            end

        case '-sound' % Sound
            Sound.Buffers = varargin{i+1}; % use same var names than in displayframeseq for easy code duplication
            Sound.Times = varargin{i+2};
            if length(Sound.Buffers) > length(unique(Sound.Buffers))
                error(['Cannot play the same sound sound buffer more than once.' 10 ...
                    'If you want to play a sound several times, store it several times in different buffers.'])
            end
            Sound.Frames = round(Sound.Times / getframedur('nominal')) + 1; % ms -> frames
            if max(Sound.Frames) > nFrames
                error('Delay for sound start longer than display duration.')
            end
            for f = 1 : length(Sound.Frames)
                S(Sound.Frames(f)).sound = Sound.Buffers(f);
            end
            
        otherwise
            error(['Unknown option: ' varargin{i}])
    end
end

% % Tolerance Window
% if length(varargin)
%     if strcmpi(varargin{1},'-tolwin') || strcmpi(varargin{1},'tolwin') % <keep 'tolwin' (w/o "-") for bw compat>
%         % Input
%         GracePeriod = varargin{2};
%         WinSize     = varargin{3};
%         varargin(1:3) = [];
%         % ms -> frames
%         GracePeriod = round(GracePeriod / (1000 / getscreenfreq('nominal'))); 
%         % Output
%         for f = 1 : nFrames
%             if f <= GracePeriod
%                 S(f).tolwin = [0 0];
%             else
%                 S(f).tolwin = WinSize;
%             end
%         end
%     else
%         error('Error in input arguments.')
%     end
% else % Default: no tolerance window
%     [S.tolwin] = deal([0 0]);
% end
% 
% % Sound

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% SUB-FUNCTIONS 
%% ISSHAPE  True for a string defining a shape in DRAWSHAPE.
function b = isshape(x)
b = false;
AllShapes = {'square'; 'rectangle'; 'round'; 'oval'; 'cross'; 'polygon'; 'line'};
if ischar(x)
    if strmatch(x,AllShapes)
        b = true;
    end
elseif iscell(x)
    if ~isempty(x) && strcmpi(x{i},'polygon')
        b = true;
    end
end

%% ISMOVEMENT  True for a string defining a movement.
function b = ismovement(x)
b = false;
AllMovements = {'fix'; 'step'; 'rampe'; 'arc'}; % 'gap' not included
if ischar(x)
    if strmatch(x,AllMovements)
        b = true;
    end
end
