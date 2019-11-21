function startcogent(varargin)
% STARTCOGENT  Start CosyGraphics, using Cogent as library.
%    STARTCOGENT  initializes CosyGraphics and opens a PsychTB display with default settings 
%    (800x600 window).
%
%    STARTCOGENT(Screen)  starts CosyGraphics/Cogent, specifying screen or window to use.
%    'Screen' value can be 0 (display in a window), 1 (full screen display on main screen),
%    2 (full screen display on secondary screen), 3 (on screen #3), etc. 
%
%	 STARTCOGENT(Screen,ScreenRes)  starts display at given resolution.  Default ScreenRes
%    value is [800 600].
%
%    STARTCOGENT(Screen,ScreenRes,BgColor)  starts display with BgColor as default 
%    background color.  BgColor is an [r g b] triplet in the range 0.0 to 1.0.
%
%    STARTCOGENT(Screen,ScreenRes,<BgColor>,ScreenReqFreq)  checks that the actual 
%    screen frequency matches the frequency that was requested to the operating system. 
%    ScreenReqFreq must have the same value than in the OS configuration. This can be usefull
%    because Windows 2000/XP standard plug-and-play screen driver is bugged: at Cogent startup
%    the screen frequency falls to 75 Hz. This check was intended to detect that problem.
%    The BgColor argument is optionnal. 
%
%    STARTCOGENT(Screen,ScreenRes,<BgColor>,ScreenReqFreq,NumTestFrames)  specifies 
%    the number of frames to be displayed to do the screen frequency measure, which is done
%    at first start. The higher the NumFrames value, the higher the precision of the measure.
%    This is critical for EEG experiments ; for other experiments, the default value should be
%    largely enough. If NumTestFrames = 0, no test is done ; nomina value is kept as it.l 
%
%    STARTCOGENT(...,'ExclusiveKeyboard')  gives exclusive control on the keyboard to 
%    Cogent. This option IS NEEDED if you need proper timing precision for keyboard events,
%    but in case of Cogent crash, you'll not be able to stop it with Ctrl+Alt+Del or another
%    Windows shortcut. So, use it with care: DO NOT USE IT WHILE YOU ARE DEBUGGING !!!
%
%    STARTCOGENT(...,'AlphaMode')  starts display in optimized mode for alpha blending.
%    There are problems with this mode; see "help opendisplay" for more infos.
%
% See also STARTPSYCH, STARTCOSY, STOPCOSY.
%
% Ben, 2007 - 2008

startcosy('Cog',varargin{:});