function drawtext(Text,b,varargin)
% DRAWTEXT  Draw text in an offscreen buffer. {slow!!!}
%    Warning: This function takes several msec to execute. This can be an issue
%    on a slow computer, or if you want to draw several lines of text. In this case,
%    it is strongly recommended to prepare a text in advance in an offscreen buffer
%    (created with NEWBUFFER) and, during the real-time loop, copy it into buffer 0
%    with COPYBUFFER.
%
%    DRAWTEXT(Text,b)  draws character string Text in the center of buffer b.
%
%    DRAWTEXT(Text)  Same as DRAWTEXT(Text,0)
%
%    DRAWTEXT(Text,b,option1,option2,...)  specifies text options.
%       Options can be:
%       - Text Position:    an [x y] vector.
%       - Font Name:        'Arial', 'Courier', etc.
%       - Font Size:        value in points.
%       - Font color:       an [r g b] vector.
%       Order of options doesn't matter.
%
% Examples :
%    drawtext('Pause',4);  % draws the string 'Pause' in the center of buffer 4.
%    drawtext('+',b,20,[0 0 1]);  % draws a blue '+', 20 points heigth, in the center 
%                                 % of buffer b.
%    drawtext('Hello!',0,[0 200],'Courier',30,[.2 .2 .2]);
%
% Ben, Oct. 2007

% DRAWTEXT(buff,Text,...) works also.

% Performances: 3.35 ms on DARTAGNAN (Core2 Quad 2.66 GHz).

global COSY_DISPLAY

%% Check b
if b > 0 && ~any(COSY_DISPLAY.BUFFERS.OffscreenBuffers == b)
    warning(['Buffer ' num2str(b) ' does not exist. Use "b = newbuffer();" to open an offscreen buffer.']);
end

%% Get current defaults
Old = gettext(b);

%% Default values
New = Old;
xy = [0 0];

%% Input arg.
if nargin == 0
    stopcosy;
    error('''Text'' argument is missing.')
elseif nargin == 1
    b = 0;
elseif nargin >= 2 && isnumeric(Text) && ischar(b) % bw compat. with old syntax: drawtext(b,text,...)
    tmp = b;
    b = Text;
    Text = tmp;
end

% Check args:
if ~ischar(Text)
    stopcosy;
    error(['''Text'' argument must be a character string. (It''s a ' class(Text) '.)'])
end
if ~isnumeric(b)
    stopcosy;
    error(['''b'' argument must be a buffer number. (It''s a ' class(Text) '.)'])
elseif b ~= 0
    if ~any(COSY_DISPLAY.BUFFERS.OffscreenBuffers == b)
        stopcosy;
        error(['''b'' argument is not the handle of an existing buffer.'])
    end
end

% Optional args:
for c = 1 : length(varargin)
	arg = varargin{c};
	if ischar(arg),
		New.FontName = arg;
	elseif length(arg) == 1,
		New.FontSize = arg;
	elseif length(arg) == 2,
		xy = arg;
	elseif length(arg) == 3,
		New.FontColor = arg;
	end
end

%% Set text
settext(b,New);
settext(COSY_DISPLAY.BUFFERS.DraftBuffer,New);

%% Draw text
if iscog % CG
    cgsetsprite(b);
    cgtext(Text,xy(1),xy(2));
    cgsetsprite(COSY_DISPLAY.BUFFERS.CurrentBuffer4CG); % back to previous buffer
    
else % PTB
    % b:
    if b == 0, b = gcw; end
    % color: Font color:
    color = convertcoord('RGB-MATLAB -> RGB-PTB',New.FontColor);
    % bg: Text background color: Doesn't seem to work! <todo: fix it>
    bgcolor = [128 128 128];
    % h: Text Heigth: Assume it's the same than font size:
    h = New.FontSize;    
    % w: Text Width: Draw text string on draft buffer to get ot's actual width:
    j0 = 10;
    [j1,i1] = Screen('DrawText',COSY_DISPLAY.BUFFERS.DraftBuffer,Text,j0,0,color,bgcolor,0);
    w = j1 - j0;
    % x,y -> j0,i0 (Cartesian center coord. -> graphics top-left coord.):
    ji = convertcoord('XY,WH -> JI,WH',xy,[w h],b);
    j0 = ji(1);                 % j0: Left position
    i0 = ji(2) - floor(h/2);    % i0: Top position
%   ji = convertcoord('XY -> JI',[x y],b);
%   i1 = ji(2); % i1: Baseline position

    % Draw!
    Screen('DrawText', b, Text, j0, i0, color, bgcolor, 0);
end

%% Back to defaults
settext(b,Old);
if iscog,  end