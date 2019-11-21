function draw(Shape,RGB,b,varargin)
% DRAW  Primitive drawing function, used by other DRAW* functions. {fast}
%    This function is used by all DRAW* functions, except DRAWTEXT.  See each particular function to
%    get help.  DRAW by itself can be usefull to be useed it directly if the shape itself is 
%    variable.
%
%         What             Where
%         ----             -----
%    DRAW('round',    RGB, b, XY, W              <,l>)
%    DRAW('square',   RGB, b, XY, W              <,l>)
%    DRAW('cross',    RGB, b, XY, W              <,l>)
%    DRAW('xcross',   RGB, b, XY, W              <,l>)
%    DRAW('arc',      RGB, b, XY, W     <,Th0Th1><,l>)   <todo> XY and W are the center(s) and the width of the circle(s) from which come(s) the arc(s).
%    DRAW('rect',     RGB, b, XY, WH             <,l>)
%    DRAW('oval',     RGB, b, XY, WH             <,l>)
%    DRAW('roundrect',RGB, b, XY, WH              ,l, r) <todo> rounded corners rectangle(s), of corner radius r.
%    DRAW('rect',     RGB, b,     XYXY           <,l>)
%    DRAW('oval',     RGB, b,     XYXY           <,l>)
%    DRAW('arc',      RGB, b,     XYXY           <,l>)   <todo>
%    DRAW('roundrect',RGB, b,     XYXY            ,l, r) <todo> rounded corners rectangle(s), of corner radius r.
%
%    DRAW('triangle', RGB, b, XY, D|WH,  <,theta><,l>)   is the same as DRAW('polygon3',...)
%    DRAW('arrow',    RGB, b, XY, WH,      theta <,l>)   <todo>
%
%    DRAW('polygon',  RGB, b,     XYXYXY         <,l>)
%    DRAW('polygon',  RGB, b, XY, XYXYXY <,theta><,l>)
%    DRAW('polygon#', RGB, b, XY, D,     <,theta><,l>)   replace "#" by nb of sides (e.g.: 'polygon6' = hexagon)
%    DRAW('polygon#', RGB, b, XY, WH,    <,theta><,l>)   <todo>
%    DRAW('star#',    RGB, b, XY, D,     <,theta><,l>)   replace "#" by nb of branches (e.g.: 'star5')
%
%    DRAW('dots',     RGB, b, XY, w                         )  
%    DRAW('dots',     RGB, b, xy, XY, w                     )  <todo> 'XY' are co-ordinates relative to the 'xy' center 
%    DRAW('dots',     RGB, b, xy, B,  w  <,theta>           )  <todo> B is a logical matrix, and will be drawn centered at xy.
%    DRAW('rounddots',...                                   )  same as 'dots'
%    DRAW('squaredots',...                                  )  same as 'rounddots' but draws squares in place of rounds
%
%    DRAW('line',     RGB, b, XY0, XY1           <,l>)
%    DRAW('line',     RGB, b,     XYXY           <,l>)
%    DRAW('line',  RGBRGB, b, XY0, XY1           <,l>)  PTB only.  <todo>
%    DRAW('line',  RGBRGB, b,     XYXY           <,l>)  PTB only.  <todo>
%
%    DRAW('matrix', M, <RGB,> b, XY <,theta>)  <todo??>
%
% Arguments:
%    Let be n, the number of shapes to draw.
%    - RGB:     1-by-3 or n-by-3 matrix of [red, green, blue] values, in the range 0.0 to 1.0, or
%               1-by-4 or n-by-4 matrix of [red, green, blue, alpha] values.
%    - b:       the handle of the buffer to draw into. (As usual, 0 is the backbuffer.)
%    - XY:      1-by-2 or n-by-2 matrix of cartesian coordinates of the center of the shape, in pixels.
%    - xy:      1-by-2 vector of cartesian coordinates of the center of the shape, in pixels.
%    - W:       1-by-1 or n-by-1 array containing width (or diameter) of the shape, in pixels.
%    - WH:      1-by-2 or n-by-2 matrix of [width, heigth] values, in pixels.
%    - D:       1-by-1 or n-by-1 array containing diameter of the circle circumscribing the shape, in pixels.
%    - w:       1-by-1 scalar defining the width (or diameter) of the shape, in pixels.
%    - XYXY:    1-by-4 or n-by-4 matrix of coordinates of pair of opposite corners.
%    - XYXYXY:  1-by-x or n-by-x matrix containig coordinates of all vertices.
%    - XY0,XY1: 1-by-2 or n-by-2 matrices of coordinates 
%    - theta:   1-by-1 or n-by-1 array of rotation angles, measured clockwise from vertical, in degrees.
%    - Th0Th1:  1-by-2 or n-by-2 matrix with start angle(s) (theta0) and end angle(s) (theta1).
%    - l:       1-by-1 or n-by-1 array of line width. If this argument is present, a hollow frame is 
%               drawn in place of a solid shape ; if it's missing if it's 0, a solid shape is drawn.
%
% Examples: Six different ways to draw a 60x60 pixels red square. (Use displaybuffer; to display the result.)
%       draw('square', [1 0 0], 0, [0 0], 60);
%       draw('rect', [1 0 0], 0, [0 0], [60 60]);
%       draw('rect', [1 0 0], 0, [-30 30, 30 -30]);
%       draw('polygon', [1 0 0], 0, [-30 30, 30 30, 30 -30, -30 -30]);
%       draw('polygon4', [1 0 0], 0, [0 0], 60*sqrt(2), 0); % 60*sqrt(2) is the diameter of the circumscribing circle
%       draw('polygon4', [1 0 0], 0, [0 0], [60 60], 0);
%
% See also: DRAWROUND, DRAWSQUARE,... ISINSIDE, DRAWTEXT.
%
% Ben,  Oct 2007 - Jul 2011.

%% <Deprecated syntax>
%    DRAW('polygon',           RGB, b,     XYXYXY <,l>)
%    DRAW('polygon',           RGB, b, XY, XYXYXY <,l>)
%    DRAW('polygon', N, Theta, RGB, b, XY, W      <,l>)
%    DRAW('polygon', N, Theta, RGB, b, XY, WH     <,l>)  <todo>
%
%    DRAW('triangle',   Theta, RGB, b, XY, WH     <,l>)  <todo>
%    DRAW('arrow',      Theta, RGB, b, XY, WHWH   <,l>)  <todo>

% %    DRAW('line', RGB0, RGB1, b, XY0, XY1, <,l>)  PTB only.
% %    DRAW('line', RGB0, RGB1, b, XYXY,     <,l>)  PTB only.

%% Perfs
% draw('matrix',   1x1)   :  1.8 ms on CHEOPS
% draw('matrix',  10x10)  :  1.8 ms on CHEOPS
% draw('matrix', 100x100) :  2.6 ms on CHEOPS
% draw('matrix',1000x100) : 10.1 ms on CHEOPS

%% Optim:  <v2beta37, 2011-05-13, on SESOSTRIS>
% draw('round',rand(1,3),0,[0 0],100);      0.49 ms   ->   0.29 ms


global COSY_DISPLAY


if ~isopen('display')
    error('No display open.')
end


if isptb
    setcoordsystem('cartesian',b);  % <============CHANGE-STATE============!!!
end


%% INPUT ARGS
%%%%%%%%%%%%%%
nVarargin = nargin - 3;

%% Check args
error(nargchk(4,8,nargin));

% Shape
% do nothing: Shape arg will be checked later)

% RGB
if any(RGB(:) > 1)
    stopfullscreen;
    error('Invalid RGB argument. Invalid range: RGB must be an array of doubles in the range 0.0 to 1.0 (not 0 to 255!).')
elseif size(RGB,2) < 3 || size(RGB,2) > 4
    if ~strcmpi(Shape,'line')
        stopfullscreen;
        error('Invalid RGB argument. Invalid dimensions: RGB must be a [r g b] or [r g b alpha] vector or matrix (one row per shape to draw).')
    end
end

% b
if b > 0 
    if ~any(COSY_DISPLAY.BUFFERS.OffscreenBuffers == b)
        warning(['Buffer ' num2str(b) ' does not exist. Use "b = newbuffer();" to open an offscreen buffer.']);
    end
end

%% Shape
Shape = lower(Shape);

switch Shape
    case {'rect','oval','line','arc'} 
        % Primitive shapes: do nothing.
    
    case {'round','circle'}
        Shape = 'oval'; % 'round' behave the same than 'oval'
    
    case {'square','rectangle'}
        Shape = 'rect'; % 'square' behave the same than 'rect'
    
    case 'squaredots'
        Shape = 'dots';
        DotShape = 'square'; % for PTB
        DotType = 0; % for PTB's Screen('DrawDot') function
        
    case {'rounddots','dot'}
        Shape = 'dots';
        DotShape = 'round';
        DotType = 2; % <1 or 2 ??? (2=high quality anti-aliasing)>

    case 'triangle'
        nSides = 3;
        Shape = 'regpolygon';

    case 'matrix'
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
    
    otherwise
        if strncmp(Shape,'polygon',7)
            if length(Shape) > 7 % regular polygon
                nSides = str2double(Shape(8:end));
                Shape = 'regpolygon'; % 'polygon#' -> 'regpolygon'
            end
            
        elseif strncmp(Shape,'star',4)
            nSides = str2double(Shape(5:end)); % nSides will be doubled later: 
            % e.g. for a start5, we first computes coords of the peaks (same as a polygon5), 
            % and then we'll intercalate the coords of the concave angles.
            Shape = 'starpolygon';

        else % ERROR!
            stopfullscreen;
            if ischar('Shape'), str = ['Unknown shape: ''' Shape '''.'];
            else                str = ['Shape argument must be a character string.'];
            end
            error(['Invalid argument. ' str]);
            
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
    case {'rect','oval','polygon','cross','xcross','arc'}
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
        
        if ~isempty(XYXY) % <TODO: verify this!>
            XYXY(:,[2 4]) = sort(XYXY(:,[2 4]),2); % Sort XYXY: get [x0 y0 x1 y1] order (see HELP DRAWRECT).
            XYXY(:,[1 3]) = sort(XYXY(:,[1 3]),2);
        end
        
        % Angles (Theta/Th0Th1):
        switch Shape
            case 'polygon'
                if length(varargin) > i0
                    Theta = varargin{i0+1};
                    i0 = i0 + 1;
                end
            
            case 'arc'
                Th0Th1 = varargin{i0+1};
                i0 = i0 + 1;
                
        end
        
    case {'regpolygon','starpolygon'}
        XY = varargin{1};
        switch size(varargin{2},2)
            case 1, D  = varargin{2}; %    DRAW('polygonN', RGB, b, XY, D,    Theta)
            case 2, WH = varargin{2}; %    DRAW('polygonN', RGB, b, XY, WH,   Theta)
            otherwise error('Invalid input arguments.')
        end
        if length(varargin) < 3,    Theta = 0;
        else                        Theta = varargin{3};
        end
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
        
    case 'dots'
        if nargin ~= 5, error('Invalid number of arguments.'); end
        
        XY = varargin{1};
        if size(XY,2) ~= 2, error('XY input argument must be an N-by-2 matrix.'); end
        w = varargin{2};
%         if ~isscalar(w), error('w input argument must be a scalar.'); end
        i0 = 2;
        
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

% lineWidth
if nVarargin > i0;
    lineWidth = varargin{i0+1};
else
    if strcmp(Shape,'line') || strcmp(Shape,'cross') || strcmp(Shape,'xcross') 
        lineWidth = 1; % Default lineWidth for lines.
    else
        lineWidth = 0; % 0: Filled Shape.
    end
end

% 1 -> M
nShapes = max([size(RGB,1),size(XY,1),size(WH,1),size(D,1),size(XYXY,1),size(XYXYXY,1),size(Theta,1),size(lineWidth,1)]);
if strcmp(Shape,'arc'), nShapes = max([nShapes,size(Th0Th1,1)]); end %<v3-beta37>

if nShapes > 1
    m = nShapes;
    if size(RGB,1) == 1,       RGB       = repmat(RGB,m,1);       end
    if size(XY,1) == 1,        XY        = repmat(XY,m,1);        end
    if size(WH,1) == 1,        WH        = repmat(WH,m,1);        end
    if size(D,1) == 1,         D         = repmat(D,m,1);         end
    if size(XYXY,1) == 1,      XYXY      = repmat(XYXY,m,1);      end
    if size(XYXYXY,1) == 1,    XYXYXY    = repmat(XYXYXY,m,1);    end
    if size(Theta,1) == 1,     Theta     = repmat(Theta,m,1);     end
    if size(lineWidth,1) == 1, lineWidth = repmat(lineWidth,m,1); end
    if strcmp(Shape,'arc') %<v3-beta37>
        if size(Th0Th1,1) == 1, Th0Th1   = repmat(Th0Th1,m,1);    end 
    end
end

%% Composites: 
% 'cross' -> 2x 'line'
% 'arrow' -> 'polygon'

%% Regular polygons -> Polygons
% XY, D,  Theta  ->  XXX, YYY                 ('regpoly')
% XY, WH, Theta  ->  XXX, YYY, Theta          ('regpoly')
switch Shape
    case {'regpolygon','starpolygon'}
        if rem(nSides,2) % odd # of faces..
            cornersAngles = (0 : 2*pi/nSides : 1.999*pi) + pi/2;
        else % even # of faces..
            cornersAngles = (pi/nSides : 2*pi/nSides : 1.999*pi) + pi/2;
        end
        cornersAngles = repmat(cornersAngles,nShapes,1);

        if ~isempty(D) % XY, D, Theta -> XXX, YYY
            cornersAngles = cornersAngles + repmat(Theta,1,nSides); % We rotate now!
            R = repmat(D/2, 1, nSides); % radius = diameter/2
            XXX = R .* cos(cornersAngles);
            YYY = R .* sin(cornersAngles);
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
        
        % Star polygons: Intercalate inner angles
        switch Shape
            case 'starpolygon'
                nSides = nSides * 2; % <!> see note above, at var definition
                [TH,R] = cart2pol(XXX,YYY);
                [xxx_in,yyy_in] = pol2cart(TH+(2*pi/nSides), R/2.5);
                tmp = zeros(size(XXX,1),2*size(XXX,2));
                tmp(:,1:2:end) = XXX;
                tmp(:,2:2:end) = xxx_in;
                XXX = tmp;
                tmp(:,1:2:end) = YYY;
                tmp(:,2:2:end) = yyy_in;
                YYY = tmp;
        end
end

%% Polygons: Computations: Offset, Rotation.
% XY, XYXY -> XYXY
% XY, XYXYXY, Theta -> XXX, YYY
switch Shape
    case {'polygon','regpolygon','starpolygon'}
        % XYXYXY -> XXX, YYY
        if ~isempty(XYXYXY)
            nSides = size(XYXYXY,2) / 2;
            % XYXYXY -> XXX, YYY
            % Both cgpolygon() and Screen('FillPoly') wait separates X & Y inputs. So, let's separe X and Y.
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

%% Cross -> 2 lines  <v3-beta21>
if strcmp(Shape,'cross') || strcmp(Shape,'xcross')
    m = size(XY,1);
    XYXY = zeros(m*2,4);
    rgb = RGB;
    RGB = zeros(m*2,size(rgb,2));
    for i = 1:m
        if strcmp(Shape,'cross')
            XYXY(2*i-1,[1 3]) = XY(i,1);
            XYXY(2*i-1,[2 4]) = [XY(i,2)-WH(i,2)/2 XY(i,2)+WH(i,2)/2];
            XYXY(2*i,[1 3]) = [XY(i,1)-WH(i,1)/2 XY(i,1)+WH(i,1)/2];
            XYXY(2*i,[2 4]) = XY(i,2);
        else
            Shape = 'cross'; % <!>
            XYXY(2*i-1,[1 3]) = [XY(i,1)-WH(i,1)/2 XY(i,1)+WH(i,1)/2];
            XYXY(2*i-1,[2 4]) = [XY(i,2)-WH(i,2)/2 XY(i,2)+WH(i,2)/2];
            XYXY(2*i,[1 3]) = [XY(i,1)-WH(i,1)/2 XY(i,1)+WH(i,1)/2];
            XYXY(2*i,[2 4]) = [XY(i,2)+WH(i,2)/2 XY(i,2)-WH(i,2)/2];
        end
        RGB(2*i-1:2*i,:) = repmat(rgb(i,:),2,1);
    end
end


%% DRAW, CONSERVING DEFAULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if iscog % CG
    % -> CG variables
    switch Shape
        case {'rect','oval'}
            if any(lineWidth == 0) && isempty(WH) % 'XY,WH -> XYXY'
                WH = [XYXY(:,3)-XYXY(:,1), XYXY(:,4)-XYXY(:,2)]; % programmer's note: 1 pixel error ok
                XY = XYXY(1:2) + ceil(WH/2); % <TODO: 1 pixel error? ceil/floor?>
            elseif any(lineWidth > 0) && isempty(XYXY) % Hollow frame: not directly supported, we'll draw 4 lines
                XYXY = [XY - WH/2, XY + WH/2];
%                 XYXY = convertcoord(',WH -> XYXY', XY, WH);
            end
    end
    
    % Get current defaults
    [rgb_old,lw_old] = sub_getdraw('DrawColor','LineWidth');
    
    % Draw  % TODO: 1pix error in Y ? 
    cgsetsprite(b)
    
    for i = 1 : nShapes
        % Set drawing params
        sub_setdraw('DrawColor',RGB(i,:));
        if lineWidth(i), sub_setdraw('LineWidth',lineWidth(i)); end
        
        % Draw!
        switch Shape
            case 'rect'
                if lineWidth(i) % Hollow frame   %<TODO: Fix 1 pix.>
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
                if lineWidth(i) % Hollow frame   %<TODO: Fix 1 pix.>
                    cgellipse(XY(i,1),XY(i,2),WH(i,1),WH(i,end))
                else            % Filled Shape
                    cgellipse(XY(i,1),XY(i,2),WH(i,1),WH(i,end),'f')
                end
                
            case 'arc' %<v3-beta37>
                Th0Th1 = 90 - Th0Th1; % Cogent uses trigonometric angles.
                Th0Th1 = rem(Th0Th1,360);
                startAngles = Th0Th1(:,2)'; % start angle and end angles are inverted because we inverted the sign.
                endAngles   = Th0Th1(:,1)';
                if lineWidth(1), ArcType = 'A'; % Hollow frames
                else             ArcType = 'S'; % FIlled sectors
                end
                cgarc(XY(i,1),XY(i,2),WH(i,1),WH(i,end),startAngles,endAngles,RGB,ArcType);
                
            case {'polygon','regpolygon','starpolygon'}
                cgpolygon(XXX(i,:),YYY(i,:));
                if lineWidth(i)
                    dispinfo(mfilename,'warning','Hollow polygons not yet implemented over Cogent.'); %<TODO>
                end
                
            case 'dots'
                sub_setdraw('LineWidth',w); 
                cgdraw(XY(:,1)',XY(:,2)',XY(:,1)',XY(:,2)',RGB);
                
            case {'line','cross'}
                cgdraw(XYXY(:,1)',XYXY(:,2)',XYXY(:,3)',XYXY(:,4)',RGB);
        end
    end
    
    % Back to defaults
    sub_setdraw('DrawColor',rgb_old,'LineWidth',lw_old);
    cgsetsprite(COSY_DISPLAY.BUFFERS.CurrentBuffer4CG)
    
else     % PTB
    % -> PTB variables
    if b == 0, b = gcw; end % Buffer 0 -> current onscreen window id.
    if  ~isempty(XY) && ~isempty(WH) && isempty(XXX) && ~strcmp(Shape,'cross')
        XYXY = [XY XY] + [-WH WH]/2;
        XYXY(:,[2 4]) = sort(XYXY(:,[2 4]), 2); 
        XYXY = XYXY';
    end
    RGB = 255 * RGB'; % RGB-MATLAB -> RGB-PTB (transposed!!!)
    isHollow = any(lineWidth); % <todo: case both 0s and Ns>
    if any(lineWidth) && any(~lineWidth), error('Mix of filled shapes and hollow frames not supported.'), end
    
    % Draw!
    switch Shape
        case 'rect'
            if isHollow % Hollow frame
                Screen('FrameRect', b, RGB, XYXY, lineWidth);
            else        % Filled Shape
                Screen('FillRect' , b, RGB, XYXY);
            end
            
        case 'oval'
            if isHollow % Hollow frame
                Screen('FrameOval', b, RGB, XYXY, lineWidth);
            else        % Filled Shape
                Screen('FillOval' , b, RGB, XYXY);
            end
            
        case 'arc' %<v3-beta37>
            arcAngles = -diff(Th0Th1,1,2); % PTB counts in trigonometric sense, contrarily to what sais Screen('*Arc','?') documentation.
            startAngles = Th0Th1(:,1)-180; % PTB starts at 6 o'clock.
            startAngles = mod(startAngles,360);
            for i = 1:nShapes % Screen('*Arc') does not seem to support multiple draws at once.
                if isHollow % Hollow frame
                    Screen('FrameArc', b, RGB(:,i), XYXY(:,i), startAngles(i), arcAngles(i), lineWidth(i));
                else        % Filled Shape
                    Screen('FillArc' , b, RGB(:,i), XYXY(:,i), startAngles(i), arcAngles(i));
                end
            end
            
        case {'polygon','regpolygon','starpolygon'}
            for i = 1 : nShapes
                if lineWidth(i) % Hollow frame
                    Screen('FramePoly', b, RGB(:,i), [XXX(i,:)' YYY(i,:)'], lineWidth(i));
                else            % Filled Shape
                    Screen('FillPoly' , b, RGB(:,i), [XXX(i,:)' YYY(i,:)']);
                end
            end
            
        case {'line','cross'}
            % XYXYXY: Odd cols: start points coord., Even cols: end points coord.
            XYXYXY = zeros(2,numel(XYXY)/2); % | From: [row1: Xi0; row2: Yi0; row3: Xi1; row4: Yi1] ...
            tmp = XYXY';
            XYXYXY(:) = tmp(:);             % | ... -> To: [row1: Xij; row2: Yij]
            % Fix 1pix position error: Add 1 to end points coord. (Xi1, Yi1), because Apple 
            % coord. are *between* pixels, but do that only for odd lineWidth values:
            % <DEBUG: Still bug if W is odd !!!>
%             XYXYXY(find(rem(lineWidth,2)),2:2:end) = XYXYXY(find(rem(lineWidth,2)),2:2:end) + 1; %<Suppr. 3-beta35: bugged>
            % RGB01: Odd cols: start points colors, Even cols: end points colors.
            RGB01 = zeros(size([RGB RGB]));
            RGB01(:,1:2:end) = RGB;
            if exist('RGB1','var')
                RGB1 = RGB1';
                RGB01(:,2:2:end) = RGB1;
            else
                RGB01(:,2:2:end) = RGB; % end points have same colors than start points.
            end
            % lineWidth: Check (max = 10)
            if any(lineWidth) > 10, warning('Max lineWidth = 10'); end

            Screen('DrawLines',b,XYXYXY,lineWidth,RGB01);
            
        case 'dots'
            Screen('DrawDots', b, XY', w, RGB, [], DotType);
            
        case 'matrix'
%             tmp = storeimage(M);
%             copybuffer(tmp,b,'-rotation',Theta);
%             deletebuffer(tmp);
            tmp = Screen('MakeTexture',gcw,round(M*255));
            Screen('DrawTexture',b,tmp,[],[],Theta,[]);
            Screen('Close',tmp);
            
    end
    
end

if isptb
    setcoordsystem('screen',b);  % <============CHANGE-STATE============!!!
end


%% SUB-FUNCTIONS:
function sub_setdraw(varargin)
% SETDRAW  Set Cogent's drawing settings. (Cogent-only) <not finished> 
%    SETDRAW(SettingName,SettingValue)  sets the value of specified setting.
%
%    SETDRAW(SettingName1,SettingValue1,SettingName2,SettingValue2,...)
%
% Valid setting names are:
%
%   'Scale':
%       SETDRAW('Scale','Pixel')  sets pixel coordinate. (CosyGraphics's default.)
%
%       SETDRAW('Scale',ScreenWidthDeg)  set degree (of visual angle) as the co-
%       ordinate system to use, and sets given value as the screen width in degrees.
%    
%       SETDRAW('Scale',[ScreenWidthMM ObserverDistanceMM)  set degree of visual
%       angle) as the coordinate system, and compute the screen with in deg from 
%       screen width and observer distance in millimeters.
%
%   'XAlign','YAlign':
%       SETDRAW('XAlign',Alignement)  sets horizontal alignement for all drawing 
%       operations. Alignement value can be: 'L' (or 'Left'), 'C' (or 'Center'),
%       'R' (or 'Right').
%   
%       SETDRAW('YAlign',Alignement)  sets vertical alignement for all drawing 
%       operations. Alignement value can be: 'T' (or 'Top'), 'C' (or 'Center'),
%       'B' (or 'Bottom').
%
%   'LineWidth'
%       SETDRAW('LineWidth',w)  sets line width to w pixels.
%
%   'DrawColor'
%       SETDRAW('DrawColor',rgb)  sets pen color. rgb is a red-green-blue triplet 
%       in the range 0.0 to 1.1.
%
%       SETDRAW('BackgroundColor',rgb)  sets default background color. rgb is a 
%       red-green-blue triplet in the range 0.0 to 1.1.
%       
%	, 'BackgroundColor', ('TransparencyColor'), 'FontName', 'FontSize'.
%       <TODO>

global COSY_DISPLAY

for i = 1 : 2 : nargin-1
	Value = varargin{i+1};
	switch lower(varargin{i})
		case 'scale'
			if ischar(Value) && strfind(lower(Value),'pixel')
				cgscale
			elseif isnumeric(Value) && length(Value == 1)
				cgscale(Value)
			elseif isnumeric(Value) && length(Value == 2)
				cgscale(Value(1),Value(2))
			else
				error('Invalid value for ''ScreenWidth'' Setting.')
			end
            
		case 'xalign'
			if strncmpi('Value','L',1) | strcnmpi('Value','C',1) | strncmpi('Value','R',1)
				yvalue = sub_getdraw('YAlign');
				cgalign(Value,yvalue);
			end
            
		case 'yalign'
			if strncmpi('Value','T',1) | strncmpi('Value','C',1) | strncmpi('Value','B',1)
				xvalue = sub_getdraw('XAlign');
				cgalign(xvalue,Value);
			end
            
		case 'drawcolor'
			cgpencol(Value(1),Value(2),Value(3));
            
		case 'backgroundcolor'
			COSY_DISPLAY.BackgroundColor = varargin{1}(:)';
            clearbuffer(0);
            
		case 'linewidth'
			cgpenwid(Value);
            
		case 'fontname'
			h = sub_getdraw('FontHeight');
			cgfont(Value,h);
            
		case 'fontheigth'
			n = sub_getdraw('FontName');
			cgfont(n,Value);
            
		otherwise
			error(['Invalid property name: ' varargin{i} '.'])
	end
end

function varargout = sub_getdraw(varargin)
% GETDRAW  Get Cogent's drawing settings. (Cogent-only)
%    Settings = GETDRAW  returns all setting values in a structure.
%
%    Value = GETDRAW(SettingName)  returns value of given setting.
%    Valid setting names are: 'PixelScale', 'DrawColor', 'BackgroundColor', 
%    ('TransparencyColor'), 'LineWidth', 'FontName', 'FontSize'.
%
%    [Value1,Value2,...] = GETDRAW(SettingName1,SettingName2,...)
%
% Ben, apr. 2008.

%    Settings = GETDRAW('all')  returns the raw structure returned by cgGetData.

global COSY_BACKGROUND

l = strcmpi(varargin,'FontColor');
if any(l), varargin(l) = {'DrawColor'}; end

GPrim = cgGetData('GPD');
GScnd = cgGetData('GSD');

drawcolor = [GPrim.DrawCOL.CR.Red GPrim.DrawCOL.CR.Grn GPrim.DrawCOL.CR.Blu] / 255;
trancolor = [GPrim.TranCOL.CR.Red GPrim.TranCOL.CR.Grn GPrim.TranCOL.CR.Blu] / 255;
switch GPrim.AlignX
	case 0, xalign = 'L';
	case 1, xalign = 'C';
	case 2, xalign = 'R';
end
switch GPrim.AlignY
	case 0, yalign = 'T';
	case 1, yalign = 'C';
	case 2, yalign = 'B';
end

if ~nargin
	Out.PixelScale			= GScnd.PixScale; % Pixels per unit
	Out.XAlign				= xalign;
	Out.YAlign				= yalign;
	Out.DrawColor			= drawcolor;
	Out.BackgroundColor		= COSY_BACKGROUND;
	Out.TransparencyColor	= trancolor;
	Out.LineWidth			= GPrim.LineWidth;
	Out.FontName			= GPrim.Fontname; %(sic)
	Out.FontSize			= GPrim.PointSize;
    varargout{1} = Out;
else
    for arg = 1 : nargin
        switch lower(varargin{arg})
            case 'pixelscale',			Out = GScnd.PixScale;
            case 'xalign',				Out = xalign;
            case 'yalign',				Out = yalign;
            case 'drawcolor',			Out = drawcolor;
            case 'backgroundcolor',		Out = COSY_BACKGROUND;
            case 'transparencycolor',	Out = trancolor;
            case 'linewidth',			Out = GPrim.LineWidth;
            case 'fontname',			Out = GPrim.Fontname; %(sic)
            case 'fontsize',			Out = GPrim.PointSize;
            case 'all',					Out = GPrim;
            otherwise,          error('Invalid setting name.');
        end
        varargout{arg} = Out;
    end
end
