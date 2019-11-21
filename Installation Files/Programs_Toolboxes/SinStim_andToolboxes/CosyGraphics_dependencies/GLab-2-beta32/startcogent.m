function startcogent(varargin)
% STARTCOGENT  Start G-Lab, using Cogent as library.
%   STARTCOGENT  starts G-Lab with the CogentGraphics display, with default settings.
%
%   STARTCOGENT(Screen)  starts G-Lab Cogent with or without the CogentGraphics display.
%   'Screen' value can be 0 (display in a window), 1 (full screen display on main screen),
%   2 (full screen display on secondary screen), 3 (on screen #3), etc. If 'Screen' value 
%   is -1 or 'NoDisplay', Cogent starts without display. Display can be open later with
%   OPENDISPLAY.
%
%	STARTCOGENT(Screen,ScreenRes)  starts display at given screen resolution. Default 
%   'ScreenRes' value is [800 600].
%
%   STARTCOGENT(Screen,ScreenRes,BgColor)  starts display with BgColor as default 
%   background color. BgColor is an RGB triplet in the range 0.0 to 1.0.
%
%   STARTCOGENT(Screen,ScreenRes,<BgColor>,ScreenReqFreq)  checks that the actual 
%   screen frequency matches the frequency that was requested to the operating system. 
%   ScreenReqFreq must have the same value than in the OS configuration. The BgColor 
%   argument is optionnal.
%
%   STARTCOGENT(Screen,ScreenRes,<BgColor>,ScreenReqFreq,NumTestFrames)  specifies 
%   the number of frames to be displayed to do the screen frequency measure, which is done
%   at first start. The higher the NumFrames value, the higher the precision of the measure.
%   This is critical for EEG experiments. If NumTestFrames = 0, no test is done ; nominal 
%   value is kept as it. 
%
%   STARTCOGENT(...,'ExclusiveKeyboard')  gives exclusive control on the keyboard to 
%   Cogent. This option IS NEEDED if you need proper timing precision for keyboard events,
%   but in case of Cogent crash, you'll not be able to stop it with Ctrl+Alt+Del or another
%   Windows shortcut. So, use it with care: DO NOT USE IT WHILE YOU ARE DEBUGGING !!!
%
%   STARTCOGENT(...,'AlphaMode')  starts display in optimized mode for alpha blending.
%   There are problems with this mode; see "help opendisplay" for more infos.
%
% See also OPENDISPLAY, STOPGLAB.
%
% Ben, 2007 - 2008

startglab('Cog',varargin{:});