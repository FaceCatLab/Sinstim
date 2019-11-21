function keyNumber = displaymessage(Str,BackgroundColor,FontColor,varargin)
% DISPLAYMESSAGE  Display a message in CosyGraphics screen and wait for a key press.
%    DISPLAYMESSAGE(Str,BackgroundColor,FontColor)  displays string and returns immediately. 
%    'Str' can be a string or a cell vector of strings (one per line).
%
%    DISPLAYMESSAGE(Str,BackgrounColor,FontColor,Action,Key)  see example below.
%
%    keyNumber = DISPLAYMESSAGE(Str,BackgrounColor,FontColor,Action1,Key1,Action2,Key2,...)
%
%    keyNumber = DISPLAYMESSAGE(...,TimeOut)  max time to wait for (ms). Returns 0 if time out
%    reached with no key press.
%
% Example: 
%    displaymessage('Hello!', [.5 .5 .5], [0 0 0], 'continue', 'Enter', 'abort', 'Esc');
%       will print...
%
%           +-------------------------------+
%           |                               |
%           |                               |
%           |            Hello!             |
%           |                               |
%           |    Press Enter to continue    |
%           |       Press Esc to abort      |
%           |                               |
%           |                               |
%           +-------------------------------+
%
%        ...and wait for key press, then return.
%
% See also: DISPLAYWARNING, DISPLAYERROR.


%%%%%%% Params %%%%%%%
if iscog % CG 
    MaxFontSize = 24;
    BodyHeigth = .7;
else     % PTB
    MaxFontSize = 14;
    BodyHeigth = 1;
end
%%%%%%%%%%%%%%%%%%%%%%

%% 'TimeOut' Variable
if nargin > 3 && rem(length(varargin),2) == 1
    TimeOut = varargin{end};
    varargin(end) = [];
else
    TimeOut = 20000; % <v2-beta17: Default time out: 10 sec> <v2-beta23: 20 sec>
end

%% 'Str' Variable
if ~iscell(Str), Str = {Str}; end
N0 = length(Str);
if nargin > 3
	Str = [Str; {''}];
	for a = 2 : 2 : length(varargin)
		line = ['Press ' getkeyname(varargin{a}) ' to ' varargin{a-1} '.'];
		Str = [Str; {line}];
	end
end
N = length(Str);

%% 'Keys' Variable
Keys = [];
for a = 2 : 2 : length(varargin)
    if iscog('Keyboard')
        n = getkeynumber(varargin{a},'cog2ptb');
    else
        n = getkeynumber(varargin{a});
    end
    if isempty(n)
        error('Invalid Key argument.')
    else
        Keys = [Keys n];
    end
end

%% Font Size
H = getscreenres(2);
h = floor(BodyHeigth * H / N);
FontSize = min([h MaxFontSize]);

%% Color of "Press * to *" lines
if mean(BackgroundColor) > .5 % light bg
    FontColor2 = [.25 .25 .25]; 
else % dark bg
    FontColor2 = [.75 .75 .75]; 
end

%% Draw & Display
clearbuffer(0,BackgroundColor);

for n = 1 : N
	y = (FontSize + 4*isptb) * ((N + 1) / 2 - n);
	if n <= N0
        color = FontColor;
        fsize = FontSize;
    else
        color = FontColor2;
        fsize = FontSize - 2;
	end
	drawtext(Str{n},0,[0 y],'Arial',FontSize,color);
end

displaybuffer(0);
% clearbuffer(0);

%% Wait
if nargin >= 5
    % Wait key press using PTB toolbox. DISPLAYMESSAGE is used by OPENDISPLAY and
    % thus is the only function which needs keyboard before OPENKEYBOARD can be 
    % normally run (because CogInput v1.28 cannot been called before cgopen).
    % To avoid this chick and egg problem, we always use the PTB library here.
	keyNumber = waitkeydown(Keys,TimeOut,'PTB');
    if isempty(keyNumber)
        keyNumber = 0;
    elseif iscog('Keyboard') % If Cogent is the current library.. 
        keyNumber = getkeynumber(keyNumber,'ptb2cog'); % ..convert key ID.
    end
% 	displaybuffer(0); % <todo: why does it not work ???>
elseif nargin == 4
    % Wait TimeOut
    keyNumber = 0;
    wait(TimeOut);
%     displaybuffer(0);
end