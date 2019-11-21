function drawshape(Shape,b,varargin)
% DRAWSHAPE  Primitive drawing function, used by other DRAW* functions.
%    This function is used by all DRAW* functions, except DRAWTEXT.  See each particular function to
%    get help.  DRAWSHAPE by itself can be usefull to be useed it directly if the shape itself is 
%    variable.
%
%    DRAWSHAPE('rect'|'oval'|'cross', b, XY, W|WH, RGB <,LineWidth>)
%    DRAWSHAPE('rect'|'oval',         b, XYXY,     RGB <,LineWidth>)
%
%    DRAWSHAPE('polygon',           b,     XYXYXY, RGB <,LineWidth>)
%    DRAWSHAPE('polygon',           b, XY, XYXYXY, RGB <,LineWidth>)
%    DRAWSHAPE({'polygon',N,Theta}, b, XY, D,      RGB <,LineWidth>)
%    DRAWSHAPE({'polygon',N,Theta}, b, XY, WH,     RGB <,LineWidth>)  <todo>
%
%    DRAWSHAPE('line', b, XY0, XY1, RGB <,LineWidth>)
%    DRAWSHAPE('line', b, XYXY, RGB <,LineWidth>)
%    DRAWSHAPE('line', b, XY0, XY1, RGB0, RGB1, <,LineWidth>)  PTB only.
%    DRAWSHAPE('line', b, XYXY, RGB0, RGB1, <,LineWidth>)      PTB only.
%
%    DRAWSHAPE('binarymatrix', b, M, XY, RGB)  <todo: unfinished>
%
% See also DRAWSQUARE, DRAWRECT, DRAWROUND, DRAWOVAL, DRAWPOLYGON, DRAWLINE, DRAWCROSS.
%
% Ben,  Oct 2007.


global GLAB_BUFFERS 


%% INPUT ARGS
%%%%%%%%%%%%%%%%

%% Check args
error(nargchk(4,6,nargin));

if b > 0 && ~any(GLAB_BUFFERS.OffscreenBuffers == b)
    warning(['Buffer ' num2str(b) ' does not exist. Use "b = newbuffer();" to open an offscreen buffer.']);
end

%% Shape
if iscell(Shape) % Case of regular polygons
    ShapeParams = Shape(2:end);
    Shape = Shape{1};
else
    ShapeParams = {};
end
    
Shape = lower(Shape);
if      strcmp(Shape,'round'),  Shape = 'oval'; % Case of rounds
elseif  strcmp(Shape,'square'), Shape = 'rect'; % Case of squares
end

%% XY,WH|XYXY ; RGB
switch Shape
    case {'rect','oval'}
        % XY,WH | XYXY
        % XY & WH will be used by CG.
        % XYXY will be used by PTB, after conversions.
        if size(varargin{1},2) == 4 % XYXY given
            XYXY = varargin{1};
            i0 = 1;
            XYXY(:,[2 4]) = sort(XYXY(:,[2 4]),2); % Sort XYXY: get [x0 y0 x1 y1] order (see HELP DRAWRECT).
            WH = [XYXY(3)-XYXY(1), XYXY(4)-XYXY(2)]; % programmer's note: 1 pixel error ok
            XY = XYXY(1:2) + ceil(WH/2); % <TODO: 1 pixel error? ceil/floor?>
        else % XY & WH given
            XY = varargin{1};
            WH = varargin{2};
            if size(WH,2) == 1, WH = [WH WH]; end
            n = size(XY,1);
            if n > 1 && size(WH,1) == 1 % Same size for all shapes.
                WH = repmat(WH,n,1);
            end
            i0 = 2;
            XYXY = [XY(:,1)- ceil(WH(:,1)/2) XY(:,2)- ceil(WH(:,2)/2) ... % x0 y0 % <TODO: 1 pixel error? ceil/floor?>
                    XY(:,1)+floor(WH(:,1)/2) XY(:,2)+floor(WH(:,2)/2)];   % y1 y1 
        end
        
        % RGB
        RGB = varargin{i0+1};
        i0 = i0 + 1;
        
    case 'polygon'
        if isempty(ShapeParams)
            if size(varargin{1},2) > 2 % XYXYXY -> XXX, YYY
                XXX = varargin{1}(:,1:2:end-1);
                YYY = varargin{1}(:,2:2:end);
                nShapes = size(XXX,1);
                i0 = 1;
                
            else % XY, XYXYXY -> XXX, YYY
                x0 = varargin{1}(:,1); % x coord. of the center
                y0 = varargin{1}(:,2); % y coord. of the center
                XXX = varargin{2}(:,1:2:end-1); % x coord relative to center
                YYY = varargin{2}(:,2:2:end);   % y coord relative to center
                nShapes = size(XXX,1);
                XXX = XXX + repmat(x0,1,nShapes); % relative -> absolute x coord.
                YYY = YYY + repmat(y0,1,nShapes); % relative -> absolute y coord.
                i0 = 2;
                
            end
            
        else % XY, D|WH -> XXX, YYY
            N = ShapeParams{1};
            Theta = ShapeParams{2};
            Theta = (90 - Theta) * 2*pi / 360; % clockwise deg -> trig rad
            XY = varargin{1};
            nShapes = 1;  % <TODO: multiple polygons>
            XXX = zeros(nShapes,N);
            YYY = zeros(nShapes,N);

            if rem(N,2) % triangle, pentagon, heptagon...
                Theta0 = (0 : 2*pi/N : 1.999*pi);
            else % square, hexagon, octogon...
                Theta0 = (pi/N : 2*pi/N : 1.999*pi);
            end
            Theta0 = repmat(Theta0,nShapes,1);
            
            switch size(varargin{2},2)
                case 1 % XY, R -> XYXYXY  <TODO: multiple polygons>
                    Theta = Theta0 + Theta;
                    R = varargin{2} / 2; % radius = diameter/2
                    XXX = R .* cos(Theta);
                    YYY = R .* sin(Theta);
                    
                case 2 % XY, WH -> XYXYXY
                    WH = varargin{2};
                    Theta = Theta0; % We'll rotate later
                    XXX = cos(Theta); % We'll resize later
                    YYY = sin(Theta);
                    % Let's resize:
                    w0 = max(XXX')' - min(XXX')';
                    h0 = max(YYY')' - min(YYY')';
                    for i = 1 : nShapes
                        XXX(i,:) = XXX(i,:) * WH(i,1) / w0(i);
                        YYY(i,:) = YYY(i,:) * WH(i,2) / h0(i);
                    end
                    % Let's rotate:
                    [Theta0,Rho] = cart2pol(XXX,YYY);
                    Theta = Theta0 + Theta;
                    [XXX,YYY] = pol2cart(Theta,Rho);
            end
            
            % Add offset:
            for i = 1 : nShapes
                XXX = XXX + XY(i,1);
                YYY = YYY + XY(i,2);
            end
            i0 = 2;
            
        end

        % RGB
        RGB = varargin{i0+1};
        i0 = i0 + 1;

    case 'line'
        % XYXY
        if size(varargin{1},2) < 4;
            XYXY = [varargin{1} varargin{2}]; % XY0, XY1 -> XYXY
            i0 = 2;
        else
            XYXY = varargin{1};
            i0 = 1;
        end
        
        % RGB | RGB(=RGB0),RGB1
        RGB = varargin{i0+1};
        i0 = i0 + 1;
        if nargin >= 2+i0+1 && size(varargin{i0+1},2) >= 3 % RGB0,RGB1
            RGB1 = varargin{i0+1};
            i0 = i0 + 1;
        end
        
    case 'cross'
        XY0 = [varargin{1}; varargin{1}];
        XY1 = [varargin{1}; varargin{1}];
        WH = varargin{2};
        if size(WH,2) == 1, WH = [WH WH]; end
        n = size(XY0,1);
        if n > 1 && size(WH,1) == 1, WH = repmat(WH,n,1); end
        
        % Horizontal line(s): Odd rows
        odds = 1 : 2 : size(XY0,1);
        XY0(odds,1) = XY0(odds,1) - ceil(WH(odds,1)/2);
        XY1(odds,1) = XY1(odds,1) + floor(WH(odds,1)/2);
        
        % Vertical line(s): Even rows
        evens = 2 : 2 : size(XY0,1);
        XY0(evens,2) = XY0(evens,2) - ceil(WH(evens,2)/2);
        XY1(evens,2) = XY1(evens,2) + floor(WH(evens,2)/2);
        
        % XY0,XY1 -> XYXY
        XYXY = [XY0 XY1];
        
        % Change Shape -> 'Line'
        Shape = 'line'; % !
        
        % RGB
        RGB = varargin{3}; % <todo: multiple colors.>
        i0 = 3;
        
    case 'binarymatrix' % <TODO: Not finished>
        M = varargin{1};
        xy = varargin{2}; % coord. of the center
        RGB = varargin{3};
        m = size(M,1);
        n = size(M,2);
        
        % x
        f = find(M');
        XY = zeros(length(f),2);
        XY(:,1) = rem(f-1,n);
        XY(:,1) = xy(1) + XY(:,1) - round(n/2);
        
        % y
        f = find(M);
        XY(:,2) = rem(f-1,m);
        XY(:,1) = xy(2) + XY(:,2) - round(m/2);
        XYXY = XY;
        
        % Change Shape: 'BinaryMatrix' -> 'Dots'
        Shape = 'dots'; % !
        i0 = -2 + nargin;
end

%% nShapes: # of shapes to draw
if ~exist('nShapes','var')
    nShapes = size(XYXY,1);
end

%% LineWidth
if nargin >= 2 + i0 + 1;
    LineWidth = varargin{i0+1};
else
    if strcmp(Shape,'line')
        LineWidth = 1; % Default LineWidth.
    else
        LineWidth = 0; % 0: Filled Shape.
    end
end
	
%% RGB, LineWidth: 1-by-N -> M-by-N (Already done for WH)
if nShapes > 1
    if size(RGB,1) == 1 % Same color for all shapes.
        RGB = repmat(RGB,nShapes,1);
    end
    if size(LineWidth,1) == 1 % Same line width for all shapes.
        LineWidth = repmat(LineWidth,nShapes,1);
    end
end


%% DRAW, CONSERVING DEFAULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if iscog % CG
    % Get current defaults
    [rgb_old,lw_old] = getdraw('DrawColor','LineWidth');
    
    % Draw  % TODO: 1pix error in Y ? 
    cgsetsprite(b)
    
    for i = 1 : nShapes
        % Set drawing params
        setdraw('DrawColor',RGB(i,:));
        if LineWidth(i), setdraw('LineWidth',LineWidth(i)); end
        
        % Draw
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
                
            case 'polygon'
                cgpolygon(XXX(i,:),YYY(i,:));
                if LineWidth(i)
                    dipsinfo(mfilename,'warning','Hollow polygons not yet implemented over Cogent.');
                end
                
            case 'line'
                cgdraw(XYXY(:,1)',XYXY(:,2)',XYXY(:,3)',XYXY(:,4)',RGB);
        end
    end
    
    % Back to defaults
    setdraw('DrawColor',rgb_old,'LineWidth',lw_old);
    cgsetsprite(GLAB_BUFFERS.CurrentBuffer)
    
else     % PTB
    % PTB Var.
    if b==0, b = gcw; end % Buffer 0 -> current onscreen window id.
%     XYXY = xy2ij(XYXY);
%     if strcmp(Shape,'rect') || strcmp(Shape,'oval')
%         XYXY = XYXY([1 4 3 2]); % [x0 y0 x1 y1] -> [x0 y1 x1 y0]  (Apple convention).
%     end
% %     XYXY(:,2:3) = XYXY(:,2:3) + 1;
%     XYXY = XYXY'; % PTB multiple arg.: see, e.g. "Screen('FrameRect','?')".
    if exist('XYXY','var')
        RECT = convertcoord('XYXY -> RECT', XYXY, buffersize(b)); 
    end
    RGB = convertcoord('RGB-MATLAB -> RGB-PTB',RGB);
    isHollow = any(LineWidth); % <todo: case both 0s and Ns>
    
    % Draw!
    switch Shape
        case 'rect'
            if isHollow % Hollow frame
                Screen('FrameRect',b,RGB,RECT,LineWidth);
            else        % Filled Shape
                Screen('FillRect',b,RGB,RECT);
            end
            
        case 'oval'
            if isHollow % Hollow frame
                Screen('FrameOval',b,RGB,RECT,LineWidth);
            else        % Filled Shape
                Screen('FillOval',b,RGB,RECT);
            end
            
        case 'polygon'
            JJJ =  XXX + getscreenres(1) / 2;
            III = -YYY + getscreenres(2) / 2;
            for i = 1 : nShapes
                if LineWidth(i)
                    Screen('FramePoly', b, RGB(:,i), [JJJ(i,:)' III(i,:)'], LineWidth(i));
                else
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
            
    end
    
end