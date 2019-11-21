function copybuffer(b0,b1,varargin)
% COPYBUFFER   Copy a whole offscreen buffer on another offscreen buffer. {fast}
%	 COPYBUFFER(b0,b1)  copies source buffer b0 on target buffer b1.
%
%    COPYBUFFER(b0,b1,XY)  copies with an x, y offset.
%
%   <TODO: Fix multiple source buffers!>
%
% Copy a rectangular area only: <TODO>
%    COPYBUFFER(b0,b1,XY,WH)  <todo> copies only a rectangular area
%    COPYBUFFER(b0,b1,XYXY)   <todo> copies only a rectangular area from buffer b0 to
%    the same rectangular location in buffer b1.
%    COPYBUFFER(b0,b1,XYXY0,XY1)  <todo> copies  rectangular area from buffer b0 to XY
%    location in buffer b1. XY are cartesian coord. of the center of the rect., in
%    pixels.
%   
% Image Processings:
%   <The following effects are properly supported only if PTB is used as the graphics 
%    library. (The 'Alpha' effect is availaible on CogentGraphics v1.28, with
%    "startcogent(...'AlphaMode')", but they are performances and synchronization issues.)>
%
%    COPYBUFFER(...,'-rotation',Theta)  applies a rotation of Theta degrees.
%    Only avalaible on PTB, for the moment. <todo: Implement it on CG 1.28+>
%
%    COPYBUFFER(...,'-alpha',Alpha)  copies with a global opacity value Alpha. Alpha 
%    takes value from 0 (fully transparent) to 1 (fully opaque). If they is an Alpha channel,
%    in the image to be copied, the resulting translucency value will be the multiple of the 
%    alpha channel by the global Alpha factor.
%
%    COPYBUFFER(...,'-colorfilter',RGB|RGBA)  modulates each color channel. E.g.,  <TODO: does not work for channel a ???>
%    ColorFilter = [.5 1 0] would leave the green- and Alpha-channel untouched, but it would 
%    multiply the blue channel with 0 - set it to zero blue intensity, and it would multiply 
%    each pixel in the red channel by 0.5 - reducing its intensity to 50%. The most interes-
%    ting application is drawing of arbitrary complex shapes of selectable color: Simply 
%    store a grayscale image, possibly with Alpha channel, in a buffer then draw it with
%    color filter' set to the wanted color and global alpha value. 
%    If an 'Alpha' value is also specified, 'Alpha' and 'ColorFilter' have a multiplicative 
%    effect.
%
%    COPYBUFFER(...,'-filter',kernel)  <TODO>
%
% Deprecated syntax:
%    COPYBUFFER(b0,b1,x,y)
%
% See also DISPLAYBUFFER, COPYBUFFERRECT.
%   
% Ben, 	Sept 2007

%		Oct. 2008: Alpha blending support

% <TODO: DRAWSTOREDIMAGES
%   - multiples textures (Screen('DrawTextures'))


global COSY_DISPLAY


%% INPUT ARGS
i1 = 1;

% b1
if nargin<2, b1=0; end %<v3-beta37>
if length(b1) > 1
    error('Multiple destination buffers not supported.')
end

% n: Number of buffers to copy
n = length(b0);

% b0
if n > 1
    if length(b0) == 1, b0 = repmat(b0,n,1); end
    b0 = b0(isnan(b0));
elseif isempty(b0)
    return % <===!!!
end

% Animated image:
if any(b0 < 0)
    for ib0 = find(b0 < 0)
        a = b0(ib0);
        ia = find([COSY_DISPLAY.BUFFERS.ANIMATIONS.AnimationHandle] == a);
        if isempty(ia), stopcosy; error('Invalid animation handle.'); end
        ib = COSY_DISPLAY.BUFFERS.ANIMATIONS(ia).iCurrentBuffer;
        b = COSY_DISPLAY.BUFFERS.ANIMATIONS(ia).Buffers(ib);
        b0(ib0) = b;
        ib_new = ib + 1;
        if ib_new > COSY_DISPLAY.BUFFERS.ANIMATIONS(ia).nBuffers
            ib_new = ib_new - COSY_DISPLAY.BUFFERS.ANIMATIONS(ia).nBuffers;
        end
        COSY_DISPLAY.BUFFERS.ANIMATIONS(ia).iCurrentBuffer = ib_new;
    end
end

% XY,WH | XYXY
if nargin > 2 && isnumeric(varargin{1})
    switch size(varargin{1},2)
        case 2	                        %   COPYBUFFER(b0,b1,XY)
            XY = varargin{1};
            i1 = i1 + 1;
        case 1,	                        %   COPYBUFFER(b0,b1,x,y)  <deprecated>
            XY(:,1) = varargin{1};
            XY(:,1) = varargin{2};
            i1 = i1 + 2;
        case 4                          %   COPYBUFFER(b0,b1,XYXY)
            % <todo>
    end
else									%   COPYBUFFER(b0,b1)  
    XY = zeros(n,2); % Defaults: x=0, y=0
end
if size(XY,1) < n, XY = repmat(XY,n,1); end

% Alpha, Theta: Special Options
Theta = [];
Alpha = [];
ColorFilter = [];
FilterKernel = [];
while i1 <= nargin - 2;
    if strcmpi(varargin{i1},'Rotation') || strcmpi(varargin{i1},'-rotation')    %   COPYBUFFER(...,'Rotation',Theta)
        if iscog
            warning('''Rotation'' not currently supported on CogentGraphics.')
            % <TODO: CG 1.28>
        else 
            Theta = varargin{i1+1};
            if isempty(Theta), Theta = []; end %<??>
        end
        if n > 1 && length(Theta) == 1, Theta = Theta * ones(n,1); end
        i1 = i1 + 2;
        
    elseif strcmpi(varargin{i1},'Alpha') || strcmpi(varargin{i1},'-alpha')    %   COPYBUFFER(...,'Alpha',Alpha)
        if iscog == 24 % CG 1.24
            warning('Alpha blending not supported over Cogent.')
        else           % CG 1.28 & PTB
            Alpha = varargin{i1+1};
            if isempty(Alpha), Alpha = []; end %<??>
        end
        if n > 1 && length(Alpha) == 1, Alpha = Alpha * ones(n,1); end
        i1 = i1 + 2;
        
    elseif strcmpi(varargin{i1},'ColorFilter') || strcmpi(varargin{i1},'-colorfilter') %   COPYBUFFER(...,'ColorFilter',RGB)
        if iscog
            warning('Color filter not supported over Cogent.')
        else
            ColorFilter = varargin{i1+1};
        end
        if n > 1 && length(ColorFilter) == 1, ColorFilter = ColorFilter * ones(n,1); end
        if ~isempty(Alpha) 
            % Screen('DrawTexture') ignores 'Alpha' if 'ColorFilter' is specified.
            ColorFilter = ColorFilter .* Alpha(:);
            Alpha = [];
        end
        i1 = i1 + 2;
        
    elseif strcmpi(varargin{i1},'-filter') % <v2-beta23>
        if iscog
            warning('On-the-fly filtering not supported over Cogent.')
        else
            FilterKernel = varargin{i1+1};
            i1 = i1 + 2;
        end
        
    else
        if ischar(varargin{i1})
            error(['Wrong argument: ''' varargin{i1} '''']);
        else 
            error(['Wrong argument (arg' int2str(i1) ').'])
            
        end
    end
    
end

    
%% COPY BUFFER
if iscog
    for i = 1 : n
        cgsetsprite(b1(i));
        if ~isempty(Alpha) && Alpha(i) ~= 1
            [w,h] = buffersize(b0(i));
            cgdrawsprite(b0(i),XY(i,1),XY(i,2),w,h,Alpha(i));
        else
            cgdrawsprite(b0(i),XY(i,1),XY(i,2));
        end
    end
    
else     % PTB
    % Var
    b0(b0==0) = gcw;
    b1(b1==0) = gcw;

    RECT0 = []; % <TODO: copy rect area.>
    
    WH = zeros(n,2);
    for i = 1 : n, WH(i,:) = buffersize(b0(i)); end
    RECT1 = convertcoord('XY,WH -> RECT',XY,WH);

    ColorFilter = convertcoord('RGB-MATLAB -> RGB-PTB', ColorFilter);

    % Textures or Offscreen Windows ?
    t = COSY_DISPLAY.BUFFERS.OffscreenBuffers( COSY_DISPLAY.BUFFERS.isTexture);
    w = COSY_DISPLAY.BUFFERS.OffscreenBuffers(~COSY_DISPLAY.BUFFERS.isTexture);
    isTex = ~isempty(intersect(t,b0));
    isWin = ~isempty(intersect(w,b0));

    % Filter ?
    if ~isempty(FilterKernel)
        b0 = filterbuffer(b0,FilterKernel);
    end

    % Copy (Draw) Buffer
    if isTex && isWin
        error(['Different types of buffers ("Textures" and "Offscreen Windows")' char(10)...
            'given as input. This is not supported. Use STOREIMAGE to store all' char(10)...
            'your pictures in optimized buffers.'])

    elseif isTex % Texture(s)
        if length(b0) > 1, fun = 'DrawTextures'; % <TODO: not yet finished>
        else               fun = 'DrawTexture';
        end
        Screen(fun,b1,b0,RECT0,RECT1,Theta,[],Alpha,ColorFilter); % (b1,b0 order inverted)

    elseif isWin % Offscren Window(s)
        if ~isempty(Alpha) || ~isempty(Alpha)
            error([ 'Cannot apply advanced alpha blending operations on this buffer.' char(10)...
                'Use STOREIMAGE to store your image in a buffer properly' char(10)...
                'optimized for image manipulations (i.e., in PTB words:' char(10)...
                'an "texture", not an "offscreen window".)' ]);
        end
        for i = 1 : length(b0)
            if isempty(RECT0),  rect0 = [];
            else                rect0 = RECT0(:,i);
            end
            if isempty(RECT1),  rect1 = [];
            else                rect1 = RECT1(:,i);
            end
            Screen('CopyWindow',b0(i),b1,rect0,rect1);
        end

    end

    % Delete filtered textures
    if ~isempty(FilterKernel)
        deletebuffer(b0);
    end
    
end