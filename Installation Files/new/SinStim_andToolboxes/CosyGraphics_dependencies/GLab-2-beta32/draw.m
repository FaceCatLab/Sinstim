function draw(Shape,RGB,b,varargin)
% DRAW  Primitive drawing function, used by other DRAW* functions.
%    This function is used by all DRAW* functions, except DRAWTEXT.  See each particular function to
%    get help.  DRAW by itself can be usefull to be useed it directly if the shape itself is 
%    variable.
%
%    DRAW('round',    RGB, b, XY, W              <,LineWidth>)
%    DRAW('square',   RGB, b, XY, W              <,LineWidth>)
%    DRAW('cross',    RGB, b, XY, W              <,LineWidth>)
%    DRAW('rect',     RGB, b, XY, WH             <,LineWidth>)
%    DRAW('oval',     RGB, b, XY, WH             <,LineWidth>)
%    DRAW('rect',     RGB, b,     XYXY           <,LineWidth>)
%    DRAW('oval',     RGB, b,     XYXY           <,LineWidth>)
%
%    DRAW('polygon',  RGB, b,     XYXYXY         <,LineWidth>)
%    DRAW('polygon',  RGB, b, XY, XYXYXY <,Theta><,LineWidth>)
%    DRAW('polygonN', RGB, b, XY, D,       Theta <,LineWidth>)  replace "N" by # of sides (e.g.: 'polygon6' = hexagon)
%    DRAW('polygonN', RGB, b, XY, WH,      Theta <,LineWidth>)  <todo>
%
%    DRAW('triangle', ...)                                     is the same as DRAW('polygon3',...)
%    DRAW('arrow',    RGB, b, XY, WH,      Theta <,LineWidth>)  <todo>
%
%    DRAW('dots',     RGB, b, XY, W                          )  <todo>
%    DRAW('dots',     RGB, b, xy, B, W   <,Theta>            )  <todo> B is a logical matrix, and will be drawn centered at xy.
% 
%    DRAW('line',     RGB, b, XY0, XY1           <,LineWidth>)
%    DRAW('line',     RGB, b,     XYXY           <,LineWidth>)
%    DRAW('line',  RGBRGB, b, XY0, XY1           <,LineWidth>)  PTB only.  <todo>
%    DRAW('line',  RGBRGB, b,     XYXY           <,LineWidth>)  PTB only.  <todo>
%
%    DRAW('matrix', M, <RGB,> b, XY <,Theta>)  <todo>
%
% Examples: Six different ways to draw a 60x60 pixels red square. (Use displaybuffer(0); to display the result.)
%       draw('square', [1 0 0], 0, [0 0], 60);
%       draw('rect', [1 0 0], 0, [0 0], [60 60]);
%       draw('rect', [1 0 0], 0, [-30 30, 30 -30]);
%       draw('polygon', [1 0 0], 0, [-30 30, 30 30, 30 -30, -30 -30]);
%       draw('polygon4', [1 0 0], 0, [0 0], 60*sqrt(2), 0); % 60*sqrt(2) is the diameter of the circumscribing circle
%       draw('polygon4', [1 0 0], 0, [0 0], [60 60], 0);
%
% See also DRAWTEXT.
%
% Ben,  Oct 2007 - Jun 2010.

%% <Deprecated syntax>
%    DRAW('polygon',           RGB, b,     XYXYXY <,LineWidth>)
%    DRAW('polygon',           RGB, b, XY, XYXYXY <,LineWidth>)
%    DRAW('polygon', N, Theta, RGB, b, XY, W      <,LineWidth>)
%    DRAW('polygon', N, Theta, RGB, b, XY, WH     <,LineWidth>)  <todo>
%
%    DRAW('triangle',   Theta, RGB, b, XY, WH     <,LineWidth>)  <todo>
%    DRAW('arrow',      Theta, RGB, b, XY, WHWH   <,LineWidth>)  <todo>

% %    DRAW('line', RGB0, RGB1, b, XY0, XY1, <,LineWidth>)  PTB only.
% %    DRAW('line', RGB0, RGB1, b, XYXY,     <,LineWidth>)  PTB only.

%% Perfs
% draw('matrix',   1x1)   :  1.8 ms on CHEOPS
% draw('matrix',  10x10)  :  1.8 ms on CHEOPS
% draw('matrix', 100x100) :  2.6 ms on CHEOPS
% draw('matrix',1000x100) : 10.1 ms on CHEOPS


global GLAB_BUFFERS 


%% INPUT ARGS
%%%%%%%%%%%%%%
nVarargin = nargin - 3;

%% Check args
error(nargchk(4,8,nargin));

if b > 0 && ~any(GLAB_BUFFERS.OffscreenBuffers == b)
    warning(['Buffer ' num2str(b) ' does not exist. Use "b = newbuffer();" to open an offscreen buffer.']);
end

%% Shape
% if iscell(Shape) % Case of regular polygons
%     ShapeParams = Shape(2:end);
%     Shape = Shape{1};
% else
%     ShapeParams = {};
% end
    
Shape = lower(Shape);
if     strcmp(Shape,'round')
    Shape = 'oval';
elseif strcmp(Shape,'square')
    Shape = 'rect';
elseif strncmp(Shape,'polygon',7)
    if length(Shape) > 7 % regular polygon
        nSides = str2num(Shape(8:end));
        Shape = 'regpolygon'; % 'polygonN' -> 'regpolygon'
    end
elseif strcmp(Shape,'triangle')
    nSides = 3;
    Shape = 'regpolygon';
elseif strcmp(Shape,'rectangle')
    Shape = 'rect';
else
    % <TODO: Add error check here ???>
end

if strcmp(Shape,'matrix')
    M = RGB;
    RGB = [];
    if size(b,2) >= 3
        RGB = b;
        b = varargin{1};
        varargin(1) = [];
        nVarargin = nVarargin - 1;
        if size(RGB) == 3, RGB(4) = 1; end
        M = cat(3, M*RGB(1), M*RGB(2), M*RGB(3), M*RGB(4));
    end
end

%% Parse varargin -> XY,WH | XYXY | XYXYXY
% Define defaults
XY = []; % x,y center
WH = [];
D = [];
XYXY = []; % x,y two opposite corners
XYXYXY = []; % x,y each corner
Theta = [];
XXX = []; % XYXYXY will be separated later in XXX and YYY.
YYY = []; % XYXYXY will be separated later in XXX and YYY.

% Parse varargin
switch Shape
    case {'rect','oval','cross','polygon'}
        n1 = size(varargin{1},2);
        if nVarargin >= 2, n2 = size(varargin{2},2);
        else               n2 = 0;
        end
        if nVarargin >= 3, n3 = size(varargin{3},2);
        else               n3 = 0;
        end
        
        if     n1 == 2;
            XY = varargin{1};
            if n2 == 1;     WH = [varargin{2} varargin{2}];
            elseif n2 == 2, WH = varargin{2};
            elseif n2 == 4, XYXY = varargin{2};
            elseif n2 >= 6, XYXYXY = varargin{2};
            else            error('Invalid input arguments.')
            end
            i0 = 2;
            
        elseif n1 == 4
            XYXY = varargin{1};
            i0 = 1;
            
        elseif n1 >= 6
            XYXYXY = varargin{1};
            i0 = 1;
            
        else
            error('Missing input arguments.')
            
        end
        
        if ~isempty(XYXY) % <TODO: verfify this!>
            XYXY(:,[2 4]) = sort(XYXY(:,[2 4]),2); % Sort XYXY: get [x0 y0 x1 y1] order (see HELP DRAWRECT).
            XYXY(:,[1 3]) = sort(XYXY(:,[1 3]),2);
        end
        
        if strcmp(Shape,'polygon')
            Theta = varargin{i0+1};
            i0 = i0 + 1;
        end
        
    case 'regpolygon'
        XY = varargin{1};
        switch size(varargin{2},2)
            case 1, D  = varargin{2}; %    DRAW('polygonN', RGB, b, XY, D,    Theta)
            case 2, WH = varargin{2}; %    DRAW('polygonN', RGB, b, XY, WH,   Theta)
            otherwise error('Invalid input arguments.')
        end
        Theta = varargin{3}%;
        i0 = 3;
        
    case 'arrow'
        Shape = 'polygon'; % <!>
        XY = varargin{1};
        WH = varargin{2};
        Theta = varargin{3}; % theta=0: arrow up
        i0 = 3;
        
        % WH -> XYXYXY
        goldenratio = 1.618;
        w = WH(:,1);
        h = WH(:,2);
        whead = w;
        wtail = w / 2;
        htail = h / goldenratio;
        hhead = h - htail;
        XYXYXY = zeros(size(WH,1),14);
        %                   [           tip, r-corner, r-tail-up, r-tail-d, l-tail-d, l-tail-up, l-corner]
        XYXYXY(:,1:2:end) = [zeros(size(w)),      w/2,   wtail/2, wtail/2, -wtail/2,   -wtail/2,     -w/2];
        XYXYXY(:,2:2:end) = [           h/2, h/-hhead,  h/-hhead, -h/2,     -h/2,     h/-hhead,  h/-hhead];
       
    case 'line'
        switch size(varargin{1},2)
            case 4, XYXY = varargin{1};               %    DRAW('line',     RGB, b,     XYXY)
            case 2, XYXY = [varargin{1} varargin{2}]; %    DRAW('line',     RGB, b, XY0, XY1)
            otherwise error('Invalid input arguments.')
        end
        i0 = 2;
        
    case 'matrix'
        XY = varargin{1};
        WH = imagesize(M);
        if nVarargin > 1, Theta = varargin{2}; end
        i0 = nVarargin;
        
    otherwise
        error(['Unknown shape: ''' Shape '''.'])
        
end

% Theta
if ~isempty(Theta)
%     Theta = (90 - Theta) * 2*pi / 360; % clockwise deg -> trig rad
    Theta = -Theta * 2*pi / 360; % clockwise deg -> anti-clockwise rad
else
    Theta = 0;
end

% LineWidth
if nVarargin > i0;
    LineWidth = varargin{i0+1};
else
    if strcmp(Shape,'line'), LineWidth = 1; % Default LineWidth for lines.
    else                     LineWidth = 0; % 0: Filled Shape.
    end
end

% 1 -> M
nShapes = max([size(RGB,1),size(XY,1),size(WH,1),size(D,1),size(XYXY,1),size(XYXYXY,1),size(Theta,1),size(LineWidth,1)]);
if nShapes > 1
    m = nShapes;
    if size(RGB,1) == 1,       RGB       = repmat(RGB,m,1);       end
    if size(WH,1) == 1,        WH        = repmat(WH,m,1);        end
    if size(D,1) == 1,         D         = repmat(D,m,1);         end
    if size(XYXY,1) == 1,      XYXY      = repmat(XYXY,m,1);      end
    if size(XYXYXY,1) == 1,    XYXYXY    = repmat(XYXYXY,m,1);    end
    if size(Theta,1) == 1,     Theta     = repmat(Theta,m,1);     end
    if size(LineWidth,1) == 1, LineWidth = repmat(LineWidth,m,1); end
end

%% Composites: 
% 'cross' -> 2x 'line'
% 'arrow' -> 'polygon'

%% Regular polygons -> Polygons
% XY, D,  Theta  ->  XXX, YYY                 ('regpoly')
% XY, WH, Theta  ->  XXX, YYY, Theta          ('regpoly')

if strcmp(Shape,'regpolygon')
    if rem(nSides,2) % triangle, pentagon, heptagon...
        cornersAngles = (0 : 2*pi/nSides : 1.999*pi) + pi/2;
    else % square, hexagon, octogon...
        cornersAngles = (pi/nSides : 2*pi/nSides : 1.999*pi) + pi/2;
    end
    cornersAngles = repmat(cornersAngles,nShapes,1);

    if ~isempty(D) % XY, D, Theta -> XXX, YYY
        cornersAngles = cornersAngles;
        R = D/2; % radius = diameter/2
        XXX = repmat(R .* cos(cornersAngles), nShapes, 1);
        YYY = repmat(R .* sin(cornersAngles), nShapes, 1);
        Theta = []; % to avoid 2d rotation later

    elseif ~isempty(WH) % XY, WH, Theta -> XXX, YYY, Theta
        XXX = cos(cornersAngles); % We'll resize after
        YYY = sin(cornersAngles);
        % Let's resize:
        w0 = max(XXX')' - min(XXX')';
        h0 = max(YYY')' - min(YYY')';
        for i = 1 : nShapes
            XXX(i,:) = XXX(i,:) .* WH(i,1) / w0(i);
            YYY(i,:) = YYY(i,:) .* WH(i,2) / h0(i);
        end
        % We'll rotate later...
    end
end

%% Computations: Offset, Rotation.
% XY, XYXY -> XYXY
% XY, XYXYXY, Theta -> XXX, YYY

if strcmp(Shape,'polygon') || strcmp(Shape,'regpolygon')
    % XYXYXY -> XXX, YYY
    if ~isempty(XYXYXY)
        nSides = size(XYXYXY,2) / 2;
        % XYXYXY -> XXX, YYY
        % Both cgpolygon and Screen('FillPoly') wait separates X & Y inputs. So, let's separe X and Y.
        XXX = XYXYXY(:,1:2:end);
        YYY = XYXYXY(:,2:2:end);
    end

    % Rotation: XXX, YYY, Theta  -> XXX, YYY
    if ~isempty(Theta)
        [TH0,RRR] = cart2pol(XXX,YYY);
        TH1 = TH0 + repmat(Theta,1,nSides);
        [XXX,YYY] = pol2cart(TH1,RRR);
    end
end

% Add XY offset: XYXYXY = XY + XYXYXY
if ~isempty(XY), 
    % XY, XYXY -> XYXY
    if ~isempty(XYXY),   XYXY = XYXY + [XY XY]; end % 'rect', 'oval', 'cross' <currently undocumented> <todo: document or suppress ?!?>
    % XY, XXX, YYY -> XXX, YYY 
    if ~isempty(XXX)                                % 'polygon', 'regpolygon'
        XXX = XXX + repmat(XY(:,1),1,nSides); 
        YYY = YYY + repmat(XY(:,2),1,nSides); 
    end 
end

% Round
XXX = round(XXX);
YYY = round(YYY);


%% DRAW, CONSERVING DEFAULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if iscog % CG
    % -> CG variables
    switch Shape
        case {'rect','oval'}
            if any(LineWidth == 0) && isempty(WH) % 'XY,WH -> XYXY'
                WH = [XYXY(:,3)-XYXY(:,1), XYXY(:,4)-XYXY(:,2)]; % programmer's note: 1 pixel error ok
                XY = XYXY(1:2) + ceil(WH/2); % <TODO: 1 pixel error? ceil/floor?>
            elseif any(LineWidth > 0) && isempty(XYXY)
                XYXY = convertcoord('XY,WH -> XYXY', XY, WH);
            end
    end
    
    % Get current defaults
    [rgb_old,lw_old] = getdraw('DrawColor','LineWidth');
    
    % Draw  % TODO: 1pix error in Y ? 
    cgsetsprite(b)
    
    for i = 1 : nShapes
        % Set drawing params
        setdraw('DrawColor',RGB(i,:));
        if LineWidth(i), setdraw('LineWidth',LineWidth(i)); end
        
        % Draw!
        switch Shape
            case 'rect'
                if LineWidth(i) % Hollow frame   %<TODO: Fix 1 pix.>
                    R4 = zeros(nShapes*4,4);
                    RGB4  = zeros(nShapes*4,3);
                    for i = 1 : nShapes
                        row = XYXY(i,:);
                        i0 = (i-1) * 4;
                        R4(i0+1,:) = row([1 2 1 4]);
                        R4(i0+2,:) = row([1 4 3 4]);
                        R4(i0+3,:) = row([3 4 3 2]);
                        R4(i0+4,:) = row([3 2 1 2]);
                        RGB4(i0+(1:4),:) = repmat(RGB(i,:),4,1);
                    end
                    cgdraw(R4(:,1)',R4(:,2)',R4(:,3)',R4(:,4)',RGB4);
                else            % Filled Shape
                    cgrect(XY(i,1),XY(i,2),WH(i,1),WH(i,end))
                end
                
            case 'oval'
                if LineWidth(i) % Hollow frame   %<TODO: Fix 1 pix.>
                    cgellipse(XY(i,1),XY(i,2),WH(i,1),WH(i,end))
                else            % Filled Shape
                    cgellipse(XY(i,1),XY(i,2),WH(i,1),WH(i,end),'f')
                end
                
            case {'polygon','regpolygon'}
                cgpolygon(XXX(i,:),YYY(i,:));
                if LineWidth(i)
                    dispinfo(mfilename,'warning','Hollow polygons not yet implemented over Cogent.');
                end
                
            case 'line'
                cgdraw(XYXY(:,1)',XYXY(:,2)',XYXY(:,3)',XYXY(:,4)',RGB);
        end
    end
    
    % Back to defaults
    setdraw('DrawColor',rgb_old,'LineWidth',lw_old);
    cgsetsprite(GLAB_BUFFERS.CurrentBuffer)
    
else     % PTB
    % -> PTB variables
    if b == 0, b = gcw; end % Buffer 0 -> current onscreen window id.
    if ~isempty(XYXY)
        [w,h] = Screen('WindowSize',b);
        RECT = convertcoord('XYXY -> RECT',  XYXY,   [w h]); 
    elseif ~isempty(XY) && ~isempty(WH) && isempty(XXX)
        [w,h] = Screen('WindowSize',b);
        RECT = convertcoord('XY,WH -> RECT', XY, WH, [w h]); 
    elseif ~isempty(XXX)
        [w,h] = getscreenres;
        JJJ =  XXX + w/2;
        III = -YYY + h/2;
    end
    RGB = convertcoord('RGB-MATLAB -> RGB-PTB', RGB);
    isHollow = any(LineWidth); % <todo: case both 0s and Ns>
    if any(LineWidth) && any(~LineWidth), error('Mix of filled shapes and hollow frames not supported.'), end
    
    % Draw!
    switch Shape
        case 'rect'
            if isHollow % Hollow frame
                Screen('FrameRect',b,RGB,RECT,LineWidth);
            else            % Filled Shape
                Screen('FillRect',b,RGB,RECT);
            end
            
        case 'oval'
            if isHollow % Hollow frame
                Screen('FrameOval',b,RGB,RECT,LineWidth);
            else            % Filled Shape
                Screen('FillOval',b,RGB,RECT);
            end
            
        case {'polygon','regpolygon'}
            for i = 1 : nShapes
                if LineWidth(i) % Hollow frame
                    Screen('FramePoly', b, RGB(:,i), [JJJ(i,:)' III(i,:)'], LineWidth(i));
                else             % Filled Shape
                    Screen('FillPoly' , b, RGB(:,i), [JJJ(i,:)' III(i,:)']);
                end
            end
            
        case 'line'
            % XYXYXY: Odd cols: start points coord., Even cols: end points coord.
            XYXYXY = zeros(2,numel(RECT)/2); % | From: [row1: Xi0; row2: Yi0; row3: Xi1; row4: Yi1] ...
            XYXYXY(:) = RECT(:);             % | ... -> To: [row1: Xij; row2: Yij]
            % Fix 1pix position error: Add 1 to end points coord. (Xi1, Yi1), because Apple 
            % coord. are *between* pixels, but do that only for odd LineWidth values:
            % <DEBUG: Still bug if W is odd !!!>
            XYXYXY(find(rem(LineWidth,2)),2:2:end) = XYXYXY(find(rem(LineWidth,2)),2:2:end) + 1;
            % RGB01: Odd cols: start points colors, Even cols: end points colors.
            RGB01 = zeros(size([RGB RGB]));
            RGB01(:,1:2:end) = RGB;
            if exist('RGB1','var')
                RGB1 = RGB1';
                RGB01(:,2:2:end) = RGB1;
            else
                RGB01(:,2:2:end) = RGB; % end points have same colors than start points.
            end
            % LineWidth: Check (max = 10)
            if any(LineWidth) > 10, warning('Max LineWidth = 10'); end
            Screen('DrawLines',b,XYXYXY,LineWidth,RGB01);
            
        case 'dots'
            Screen('DrawDots',b,XY,1,RGB);
            
        case 'matrix'
%             tmp = storeimage(M);
%             copybuffer(tmp,b,'-rotation',Theta);
%             deletebuffer(tmp);
            tmp = Screen('MakeTexture',gcw,round(M*255));
            Screen('DrawTexture',b,tmp,[],[],Theta,[]);
            Screen('Close',tmp);
            
    end
    
end