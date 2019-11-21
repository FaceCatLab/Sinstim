function openkeyboard(Lib,varargin)
% OPENKEYBOARD  Initialize keyboard.
%    OPENKEYBOARD is automatically at CosyGraphics's startup by STARTCOSY, in most of the cases, you'll not
%    have to call it yourself.
%
%    OPENKEYBOARD  initializes keyboard with default settings.
%
%    OPENKEYBOARD(Lib)  initializes keyboard with given library.  Lib can be 'Cog' or 'PTB'.
%
% Cogent-only options:
%    OPENKEYBOARD('Cog',isExclusive),  if set to 1, gives exclusive control on the keyboard to CosyGraphics.
%    This option IS NEEDED FOR PROPER TIMING PRECISION of keyboard events on MS-Windows, but in case 
%    of Matlab crash, you'll not be able to stop it with Alt+Tab, Ctrl+Alt+Del or any other Windows 
%    shortcut. So, use it with care: DO NOT USE IT WHILE YOU ARE DEBUGGING!!! Default value is of 
%    course 0. This option is only available over Cogent on MS-Windows; on other systems it will be 
%    ignored.
%
%    OPENKEYBOARD('Cog',isExclusive,TimeResolution) precises time resolution in ms. Default value is 1
%    in exclusive mode or 4 in non-exclusive mode. (USB standard is 125Hz polling: 4ms is half the period.)
%
%    OPENKEYBOARD('Cog',isExclusive,TimeResolution,QueueLength) precises length of the key buffer.
%    Default value is 100.
%
% Programmer only:
%    OPENKEYBOARD('ptb','-init')  is used by SETUPCOSYGRAPHICS to initialize PTB keyboard only for OPENDISPLAY  
%    without modifying the lib settings.
%
% See also STARTCOGENT, OPENDISPLAY, OPENSOUND, OPENSERIALPORT, OPENPARALLELPORT, STOPCOSY.
%
% CosyGraphics function.




global COSY_KEYBOARD cogent


%% Info
dispinfo(mfilename,'info','Initializing keyboard...')


%% INPUT ARGS
% Check obsolete syntax: syntax before v2-beta49 is no more supported. <!!!BREAK BACKWARD COMPAT.!!!>
if nargin
    if ~ischar(Lib)
        if isopen('cosygraphics'), stopcosy; end
        error('Obsolete syntax. The first argument is now the library name.')
    end
end

% Lib
if ~nargin
    Lib = getcosylib('Keyboard');
end

switch lower(Lib)
    case 'cog'  % Actually, we'll initialize Cog + PTB
        isPtbOnly = 0;
        setcosylib('Keyboard','Cog');
    case 'ptb'
        isPtbOnly = 1;
        if nargin < 2 || ~strcmpi(varargin{1},'-init') % in all case except openkeyboard('ptb','-init')
            setcosylib('Keyboard','PTB');
        end
        
    otherwise
        if isopen('cosygraphics'), stopcosy; end
        error('Invalid ''Lib'' argument.')
end

% Parse varargin
if nargin >= 2 && ~isPtbOnly,  isExclusive = varargin{1};
else                           isExclusive = 0;
end
if nargin >= 3,      TimeResolution = varargin{2};
else
	if isExclusive,  TimeResolution = 1;
    else             TimeResolution = 4;
	end
end
if nargin >= 4,  QueueLength = varargin{3};
else             QueueLength = 100;
end


%% *** COGENT ***

if iscog('Keyboard') && ~isPtbOnly
	if isExclusive, mode = 'exclusive';
	else            mode = 'nonexclusive';
	end
	
	cogent.keyboard.polling_flag = 1; % not used, info only
	cogent.keyboard.queuelength  = QueueLength; % not used, info only
	cogent.keyboard.resolution   = TimeResolution; % not used, info only
	cogent.keyboard.mode = mode; % not used, info only
	cogent.keyboard.time  = [];
	cogent.keyboard.id    = [];
	cogent.keyboard.value = [];

	CogInput('Initialise');
	h = CogInput('Create','keyboard',mode,QueueLength);
	
	cogent.keyboard.hDevice = h;
	cogent.keyboard.map = CogInput('GetMap',h); % used only by getkeymap & getbelgianmap
	
	CogInput('Acquire',h);
	CogInput('StartPolling',h,TimeResolution);	
else
	% Nothing needs to be open. Just issue some warnings.
	if isExclusive
		warning('Exclusive keyboard acces not supported by ''PTB'' library.')
	end
end


%% MAKE KEY LOOKUP TABLES
% We have two libs (Cog & PTB) which use two different naming scheme and mappings.
% Let's make lookup tables to allow conversions.
if iscog('Keyboard') && ~isPtbOnly
    % - Case 1: Cogent: Use getbeglianmap() to generate the map
	CogMap = getbelgianmap;
else
    % - Case 2: PTB alone: Load map from *.mat file
    fullname = fullfile(whichdir(mfilename),'var','openkeyboard_var.mat');
	load(fullname,'CogInput_KeyMap_be')
	CogMap = CogInput_KeyMap_be;
end
if isptbinstalled
    % if ispc % <v2-beta17: "KbName: WARNING! Remapping of Linux/X11 keycodes to unified keynames not yet complete!!">
        KbName('UnifyKeyNames'); % Use MacOS X naming scheme (USB-HID standard) on all platforms.
    % end
    PtbNames = KbName('KeyNames');
else
    load(fullfile(cosygraphicsroot,'var','PTBKeyNames.mat'), 'PtbNames'); % <v2-beta45: Saved in M6.5 format.>
end
for i = 1:length(PtbNames), PtbNames{i} = char(PtbNames{i}); end % ensure it's char.
if IsLinux % Linux: Make some hard-coded modifs <hack!>
    % 'eacute',... -> '1'...
    for i = 1:9
        PtbNames{10+i} = int2str(i);
    end
    PtbNames{20} = '0';
    % 'Scroll_Lock' -> 'ScrollLock'
    i = strmatch('Scroll_Lock',PtbNames);
    PtbNames{i} = 'ScrollLock';
end

ncols = 20;
nIDs = 2;

% 0:9, A:Z
names = [char('0':'9') char('A':'Z')]';
COG = zeros(36,nIDs);
PTB = zeros(36,nIDs);
for i = 1 : 10
	COG(i,1:2) = [CogMap.(['K' int2str(i-1)]) CogMap.(['Pad' int2str(i-1)])];
    keynums = strmatch(int2str(i-1),PtbNames)';
	PTB(i,1:2) = keynums(1:2); % <v2-beta27, Fix: on MacOSX, for 0, there is also '00' and '000'>
end
for i = 11 : 36
	COG(i,1) = CogMap.(names(i));
	PTB(i,1) = double(names(i));
end
i0 = 36;

% +-*/.
names = [names; ('+-*/.')'];
COG(i0+1:i0+5,1) = [CogMap.PadAdd; CogMap.PadSubtrack; CogMap.PadMultiply; CogMap.PadDivide; CogMap.PadPeriod];
COG(i0+2,1) = CogMap.Minus;
for i = i0+1:i0+5
	n = strmatch(names(i),PtbNames)';
	PTB(i,1:length(n)) = n;
end
i0 = i0+5;

% Non alpha-mumeric keys
% We don't use the same names than PTB (based on QWERTY!), exept for the ",".
 % <fix v2-beta29: non-ascii char (>127) are replaced by '�' by the UNIX Matlab editor (v7.6)
 %  ==> don't write them directly, but use char().>
ugrave = char(249);
mu = char(181);
square = char(178);
chars = [',;:=' ugrave mu '^$)<' square];  % length = 11
names = [names; chars'];
for i = i0+1:i0+11
	switch names(i)
		case ',',	 COG(i,1) = CogMap.Comma;
					 PTB(i,1) = strmatch(',',PtbNames);
		case ';',	 COG(i,1) = CogMap.SemiColon;
					 PTB(i,1) = 190;
		case ':',	 COG(i,1) = CogMap.Colon;
					 PTB(i,1) = 191;
		case '=',	 COG(i,1) = CogMap.Equals;
					 PTB(i,1) = 187;
		case ugrave, COG(i,1) = CogMap.UGrave;
					 PTB(i,1) = 192;
		case mu,	 COG(i,1) = CogMap.Mu;
					 PTB(i,1) = 220;
		case '^',	 COG(i,1) = CogMap.Circumflex;
					 PTB(i,1) = 221;
		case '$',	 COG(i,1) = CogMap.Dollar;
					 PTB(i,1) = 186;
		case ')',	 COG(i,1) = CogMap.RParenthese;
					 PTB(i,1) = 219;
		case '<',	 COG(i,:) = 0;   % Not available with Cogent!
					 PTB(i,1) = 226; % Available, but does not have a name in PTB.
		case square, COG(i,1) = CogMap.Square;
					 PTB(i,1) = 222;
	end
end
i0 = i0+11;

% Special Keys
NAMES = names; % Will become a matrix.
i = i0 + 1;
NAMES = subfun_addrow(NAMES,'Space');
NAMES = subfun_addrow(NAMES,' ');
COG(i:i+1,1) = CogMap.Space;
PTB(i:i+1,1) = strmatch('space',PtbNames);
i = length(NAMES)+1;
NAMES = subfun_addrow(NAMES,'BackSpace');
COG(i,1) = CogMap.BackSpace;
if IsOSX,  PTB(i,1) = strmatch('DELETE',PtbNames); % On OSX: back space = "DELETE", del = "DeleteForward"
else       PTB(i,1) = strmatch('BackSpace',PtbNames);
end
i = length(NAMES)+1;
NAMES = subfun_addrow(NAMES,'Enter');
NAMES = subfun_addrow(NAMES,'Return');
COG(i:i+1,1:2) = repmat([CogMap.Return CogMap.PadEnter],2,1);	% Cog: 2 different #
PTB(i:i+1,1)   = strmatch('Return',PtbNames);					% PTB: Same # (13)
i = length(NAMES)+1;
NAMES = subfun_addrow(NAMES,'Escape');
NAMES = subfun_addrow(NAMES,'Esc');
COG(i:i+1,1) = CogMap.Escape;
PTB(i:i+1,1) = strmatch('ESCAPE',PtbNames);
i = length(NAMES)+1;
NAMES = subfun_addrow(NAMES,'NumLock');
COG(i,1) = CogMap.NumLock;
try PTB(i,1) = strmatch('NumLock',PtbNames); % <v2-beta29: crash on Stanford's Mac.>
catch PTB(i,1) = 0; 
end
i = length(NAMES)+1;
NAMES = subfun_addrow(NAMES,'Tab');
COG(i,1) = CogMap.Tab;
PTB(i,1) = strmatch('tab',PtbNames);
i = length(NAMES)+1;
NAMES = subfun_addrow(NAMES,'CapsLock');
COG(i,1) = CogMap.CapsLock;
PTB(i,1) = strmatch('CapsLock',PtbNames);
i = length(NAMES)+1;
NAMES = subfun_addrow(NAMES,'Shift');
NAMES = subfun_addrow(NAMES,'LeftShift');
NAMES = subfun_addrow(NAMES,'LShift');		% L* names for Cogent2000 backward compatibility
NAMES = subfun_addrow(NAMES,'RightShift');
NAMES = subfun_addrow(NAMES,'RShift');		% R* names for Cogent2000 backward compatibility
COG(i,1:2) = [CogMap.LShift CogMap.RShift];
COG(i+1:i+2,1) = CogMap.LShift;
COG(i+3:i+4,1) = CogMap.RShift;
try PTB(i,1) = strmatch('Shift',PtbNames); end    %  16 <v2-beta17: Add TRY, because no 'Shift' on Linux>
PTB(i+1:i+2,1) = strmatch('LeftShift',PtbNames);  % 160
PTB(i+3:i+4,1) = strmatch('RightShift',PtbNames); % 161
i = length(NAMES)+1;
NAMES = subfun_addrow(NAMES,'Control');
NAMES = subfun_addrow(NAMES,'Ctrl');
NAMES = subfun_addrow(NAMES,'LeftControl');
NAMES = subfun_addrow(NAMES,'LControl');
NAMES = subfun_addrow(NAMES,'LeftCtrl');
NAMES = subfun_addrow(NAMES,'LCtrl');
NAMES = subfun_addrow(NAMES,'RightControl');
NAMES = subfun_addrow(NAMES,'RControl');
NAMES = subfun_addrow(NAMES,'RightCtrl');
NAMES = subfun_addrow(NAMES,'RCtrl');
COG(i:i+1,1:2) = repmat([CogMap.LControl CogMap.RControl],2,1);
COG(i+2:i+5,1) = CogMap.LControl;
COG(i+6:i+9,1) = CogMap.RControl;
try PTB(i:i+1,1)   = strmatch('control',PtbNames); end  %  17 <v2-beta17: Add TRY, because no 'control' on Linux>
PTB(i+2:i+5,1) = strmatch('LeftControl',PtbNames);	    % 162
PTB(i+6:i+9,1) = strmatch('RightControl',PtbNames);	    % 163
i = length(NAMES)+1;
NAMES = subfun_addrow(NAMES,'Alt');
NAMES = subfun_addrow(NAMES,'LeftAlt');
NAMES = subfun_addrow(NAMES,'LAlt');
NAMES = subfun_addrow(NAMES,'AltGr');
NAMES = subfun_addrow(NAMES,'RightAlt');
NAMES = subfun_addrow(NAMES,'RAlt');
COG(i+0:i+2,1) = CogMap.LAlt;
COG(i+3:i+5,1) = CogMap.RAlt;
% PTB(i,1:2)   = strmatch('alt',PtbNames);		%  18	Don't use to stick on phisical key labels
PTB(i+0:i+2,1) = strmatch('LeftAlt',PtbNames);	% 164
PTB(i+3:i+5,1) = strmatch('RightAlt',PtbNames);	% 165  (AltGr ->  17    18   162   165)
i = length(NAMES)+1;
NAMES = subfun_addrow(NAMES,'Start');
COG(i,:) = 0; % Not supported.
PTB(i,1) = 91; % <"KbNames(91)" returns 'left_menu', but "strmatch('left_menu',PtbNames)" returns [].>
i = length(NAMES)+1;
NAMES = subfun_addrow(NAMES,'Menu');
COG(i,:) = 0; % Not supported.
PTB(i,1) = 93; % <"KbNames(93)" returns 'applications', but "strmatch('applications',PtbNames)" returns [].>
i = length(NAMES)+1;
NAMES = subfun_addrow(NAMES,'Home');
COG(i,1) = CogMap.Home;
PTB(i,1) = strmatch('Home',PtbNames); % 36
i = length(NAMES)+1;
NAMES = subfun_addrow(NAMES,'End');
COG(i,1) = CogMap.End;
PTB(i,1) = strmatch('End',PtbNames); % 35
i = length(NAMES)+1;
NAMES = subfun_addrow(NAMES,'Delete');
NAMES = subfun_addrow(NAMES,'Del');
COG(i:i+1,1) = CogMap.Delete;
if IsOSX,  PTB(i:i+1,1) = strmatch('DeleteForward',PtbNames); % On OSX: back space = "DELETE", del = "DeleteForward"
else       PTB(i:i+1,1) = strmatch('DELETE',PtbNames); % 46 <todo: check if correct on Windows>
end
i = length(NAMES)+1;
NAMES = subfun_addrow(NAMES,'Insert');
NAMES = subfun_addrow(NAMES,'Ins');
COG(i:i+1,1) = CogMap.Insert;
PTB(i:i+1,1) = strmatch('Insert',PtbNames); % 45
i = length(NAMES)+1;
NAMES = subfun_addrow(NAMES,'PageUp');
COG(i,1) = CogMap.PageUp;
PTB(i,1) = strmatch('PageUp',PtbNames); % 33
i = length(NAMES)+1;
NAMES = subfun_addrow(NAMES,'PageDown');
COG(i,1) = CogMap.PageDown;
PTB(i,1) = strmatch('PageDown',PtbNames); % 34
i = length(NAMES)+1;
NAMES = subfun_addrow(NAMES,'LeftArrow');
NAMES = subfun_addrow(NAMES,'LArrow');
NAMES = subfun_addrow(NAMES,'Left');
COG(i:i+2,1) = CogMap.Left;
PTB(i:i+2,1) = strmatch('LeftArrow',PtbNames);
i = length(NAMES)+1;
NAMES = subfun_addrow(NAMES,'RightArrow');
NAMES = subfun_addrow(NAMES,'RArrow');
NAMES = subfun_addrow(NAMES,'Right');
COG(i:i+2,1) = CogMap.Right;
PTB(i:i+2,1) = strmatch('RightArrow',PtbNames);
i = length(NAMES)+1;
NAMES = subfun_addrow(NAMES,'UpArrow');
NAMES = subfun_addrow(NAMES,'Up');
COG(i:i+1,1) = CogMap.Up;
PTB(i:i+1,1) = strmatch('UpArrow',PtbNames);
i = length(NAMES)+1;
NAMES = subfun_addrow(NAMES,'DownArrow');
NAMES = subfun_addrow(NAMES,'Down');
COG(i:i+1,1) = CogMap.Down;
PTB(i:i+1,1) = strmatch('DownArrow',PtbNames);
i = length(NAMES)+1;
NAMES = subfun_addrow(NAMES,'ScrollLock');
COG(i,1) = CogMap.Scroll;
PTB(i,1) = strmatch('ScrollLock',PtbNames); % 145
i = length(NAMES)+1;
NAMES = subfun_addrow(NAMES,'PrintScreen');
COG(i,:) = 0;                               % Not supported!
% PTB(i,1) = strmatch('PrintScreen',PtbNames); % 44 <NB: KbName fails to retrieve the name from the keycode.>
%                                                   <2-beta17: Suppress: Does not work on Linux>
i = length(NAMES)+1;
NAMES = subfun_addrow(NAMES,'Pause');
COG(i,1) = CogMap.Pause;
PTB(i,1) = 19; % No name.
i = length(NAMES)+1;

% F1:F12
for f = 1 : 12
    Fx = ['F' int2str(f)];
    NAMES = subfun_addrow(NAMES,Fx);
    COG(i,1) = CogMap.(Fx);
    PTB(i,1) = strmatch([Fx ' '],PtbNames); % 112:123
    i = i+1;
end

%% OUTPUT -> GLOBAL VARIABLES
% Optimize matrix for 'strmatch' usage.
NAMES(:,end+1) = 0; % Add a col of 0s so we can add a 0 at the end of the pattern to search for.
names = lower(NAMES); % For case insensitive matching.
% Execution time of "strmatch(name,COSY_KEYBOARD.TABLES.lowercasenames)":
% 70 microseconds (on Matlab 6.5 on Athlon X2 4400+)

% For PTB: We need a filter to filter valid codes in 'keyCode' arg.
if isptbinstalled
    [k,s,keyCode] = KbCheck;
    isValid = false(size(keyCode)); % <v2-beta35: 1x255 hard-coded replaced by size(keyCode)>
    isValid(setdiff(unique(PTB(:)),0)) = 1;
else
    isValid = [];
end

% -> Global Vars
COSY_KEYBOARD.TABLES.CamelCaseNames = NAMES;
COSY_KEYBOARD.TABLES.lowercasenames = names;
COSY_KEYBOARD.TABLES.COG.KeyNumbers = COG;
% COSY_KEYBOARD.TABLES.COG.Filter = ;
COSY_KEYBOARD.TABLES.PTB.KeyNumbers = PTB;
COSY_KEYBOARD.TABLES.PTB.KeyCodeFilter = isValid;

COSY_KEYBOARD.isOpen = true;


%% SUB-FUN
%_____________________________
function M = subfun_addrow(M,word) %<todo: replace by strvcat>

	if length(word) > size(M,2)
		M = [M, char(zeros(size(M,1),length(word)-size(M,2)))];
	end

	row = [word, zeros(1,size(M,2)-length(word))];
	M(end+1,:) = row;
