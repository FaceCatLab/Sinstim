function varargout = convertcoord(Formula,varargin)
% CONVERTCOORD  Convertions between graphics coordinate systems. {fast}
%    This function is a tool used by other CosyGraphics functions.
%
%    varargout = CONVERTCOORD(Formula,varargin)
%
% Spatial coordinates:
%    XYXY = CONVERTCOORD( 'XY,WH -> XYXY'  , XY,WH)   
%
%    JI   = CONVERTCOORD(    'XY -> JI'    , XY, <b|wh> )  or,
%    JI   = CONVERTCOORD('XYXYXY -> JIJIJI', XY, <b|wh> )  is the same than above.
%
%    JI   = CONVERTCOORD( 'XY,WH -> JI,WH' , XY, <b|wh> )
%
%    JIJI = CONVERTCOORD( 'XY,WH -> JIJI'  , XY,WH, <b|wh> ) 
%    JIJI = CONVERTCOORD(  'XYXY -> JIJI'  , XYXY,  <b|wh> ) 
%
%    RECT = CONVERTCOORD( 'XY,WH -> RECT'  , XY,WH, <b|wh> )  % CG -> PTB !
%    RECT = CONVERTCOORD(  'XYXY -> RECT'  , XYXY,  <b|wh> )
%    RECT = CONVERTCOORD(  'JIJI -> RECT'  , JIJI )         
%    
%    Variables:
%       XY, WH          Cogent coord.: [x,y], [width,heigth], Cartesian coord. (x,y= center).
%       XYXY            [x0,y0,x1,y1], Cartesian coord.
%       JIJI            [j0,j0,i1,i1], graphics coord. (= [left,up,rigth,down])
%       XY or XYXYXY    Cartesian coord. M-by-N matrix. Odd cols: x ; even cols: y. (x,y = center)
%       JI or JIJIJI    Graphics coord.  M-by-N matrix. Odd cols: j ; even cols: i. (j,i = center)
%       JI, WH          [j0,i0], [width,heigth], Graphics coord. (j0,i0 = upper-left corner).
%       RECT            PsychToolBox "rect" argument.
%       b               Buffer ID. Always optional. Default is 0 (backbuffer).
%       wh              [width,heigth] of the buffer. Can replace b.
%
% Color coordinates:
%    CONVERTCOORD('RGB-MATLAB -> RGB-PTB', RGB)  converts standard Matlab RGB
%    matrix (N-by-3, double 0:1 or uint 0:255), to PsychToolBox "rgb" argument  
%    (3-by-N, double 0:255).

% INFO:
% PTB Coord. system: < Seems to be for 'DrawLines' only (?)>
% Seems that x position is rounded right and y position is rounded up.
% ==> in cartesian coord., all coord. are "ceiled".
%
%       1
%     0-|--------> 799
%       |
%       |
%       V
%      600

% Parse Formula
Formula(Formula == ' ') = [];
Formula = upper(Formula);
f = find(Formula == '>');
In  = Formula(1:f-2);
Out = Formula(f+1:end);

% varargin -> ...
switch In
    case 'XY,WH'
        XY = varargin{1};
        WH = varargin{2};
        if size(WH,2) == 1; WH = [WH WH]; end                  % W -> WH
        if size(WH,1) == 1; WH = repmat(WH,size(XY,1),1); end  % 1-by-2 -> N-By-2
        
    case 'RGB-MATLAB'
        RGB = varargin{1};
        
    otherwise
        eval([In '= varargin{1};']);
end
    
% w,h
if strncmp(In,'XY',2)  &  ( strncmp(Out,'JI',2) | strcmp(Out,'RECT') )
    if nargin == 3 + length(find(In == ','))
        if length(varargin{end}) == 2
            w = varargin{end}(1); % Buffer Width
            h = varargin{end}(2); % Buffer Heigth
        else
            [w,h] = buffersize(varargin{end});
        end
    else
        [w,h] = getscreenres;
    end
end

% Conversions
switch Formula
    case 'XY,WH->XYXY'
        XYXY = [XY XY] + [-WH WH]/2;
    
    case {'XY->JI', 'XYXYXY->JIJIJI'}
        JI = zeros(size(XY));
        % X Axis: -400 to +399  ->  0 to 799  (for a 800x600 buffer)
        JI(:,1:2:end-1) = XY(:,1:2:end-1) + w/2;
        % Y Axis: +300 to -299  ->  0 to 599 (invert direction)
        JI(:,2:2:end) = -XY(:,2:2:end) + h/2;
        % out ->
        varargout{1} = JI;
        
    case 'XY,WH->JI,WH'
        % XY->JI (i,j = center)
        JI = zeros(size(XY));
        JI(:,1:2:end-1) = XY(:,1:2:end-1) + w/2;
        JI(:,2:2:end) = -XY(:,2:2:end) + h/2;
        % JI,WH  (j,i = upper-left corner)
        JI = round(JI - WH / 2); % <debug: 1pix pb: "round(JI - WH / 2)" or "JI - round(WH / 2)" ?
        varargout{1} = JI;
        varargout{2} = WH;
        
    case 'XYXY->JIJI'
        JIJI = zeros(size(XYXY));
        JIJI(:,1:2:end-1) = XYXY(:,1:2:end-1) + w/2;
        JIJI(:,2:2:end) = -XYXY(:,2:2:end) + h/2;
        JIJI = JIJI(:,[1 4 3 2]); % [left,bottom,right,top] -> [left,top,right,bottom]
        varargout{1} = JIJI;
        
    case 'XY,WH->JIJI'
        % XY,WH->XYXY
        XYXY = [XY XY] + [-WH WH]/2;
        % XYXY->JIJI
        JIJI = zeros(size(XYXY));
        JIJI(:,1:2:end-1) = XYXY(:,1:2:end-1) + w/2;
        JIJI(:,2:2:end) = -XYXY(:,2:2:end) + h/2;
        JIJI = JIJI(:,[1 4 3 2]);
        varargout{1} = JIJI;
        
    case 'JIJI->RECT'
        RECT = JIJI';
        varargout{1} = RECT;
        
    case 'XYXY->RECT'
        % XYXY->JIJI
        JIJI = zeros(size(XYXY));
        JIJI(:,1:2:end-1) = XYXY(:,1:2:end-1) + w/2;
        JIJI(:,2:2:end) = -XYXY(:,2:2:end) + h/2;
        JIJI = JIJI(:,[1 4 3 2]); 
        % JIJI->RECT
        RECT = JIJI';
        varargout{1} = RECT;

    case 'XY,WH->RECT' % CG -> PTB
        % XY,WH->XYXY
        XYXY = [XY XY] + [-WH WH]/2;
        % XYXY->JIJI
        JIJI = zeros(size(XYXY));
        JIJI(:,1:2:end-1) = XYXY(:,1:2:end-1) + w/2;
        JIJI(:,2:2:end) = -XYXY(:,2:2:end) + h/2;
        JIJI = JIJI(:,[1 4 3 2]);
        % JIJI->RECT
        RECT = JIJI';
        varargout{1} = RECT;
        
    case 'RGB-MATLAB->RGB-PTB'
        if ~strncmp(class(RGB),'uint',4)
            RGB = round(RGB * 255);
        end
        RGB = RGB';
        varargout{1} = RGB;
end

% % ... -> varargout   % <suppr 2-beat23 (optim)>
% switch Out
%     case 'RGB-PTB'
%         varargout{1} = RGB;
%         
%     otherwise
%         eval(['varargout = {' Out '};']);
% end