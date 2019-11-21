function startpsych(varargin)
% STARTPSYCH  Start CosyGraphics, using PsychToolBox as library.
%    STARTPSYCH  initializes CosyGraphics and opens a PsychTB display with default settings 
%    (800x600 window).
%
%    STARTPSYCH(Screen)  starts CosyGraphics/Cogent, specifying screen or window to use.
%    'Screen' value can be 0 (display in a window), 1 (full screen display on main screen),
%    2 (full screen display on secondary screen), 3 (on screen #3), etc. 
%
%	 STARTPSYCH(Screen,ScreenRes)  starts display at given resolution.  Default ScreenRes
%    value is [800 600].
%
%    STARTPSYCH(Screen,ScreenRes,BgColor)  starts display with BgColor as default 
%    background color.  BgColor is an [r g b] triplet in the range 0.0 to 1.0.
%
%    STARTPSYCH(Screen,ScreenRes,<BgColor>,ScreenReqFreq)  checks that the actual 
%    screen frequency matches the frequency that was requested to the operating system. 
%    Not really needed over PsychTB.
%
%    STARTPSYCH(Screen,ScreenRes,<BgColor>,ScreenReqFreq,NumTestFrames)  specifies 
%    the number of frames to be displayed to do the screen frequency measure, which is done
%    at first start. The higher the NumFrames value, the higher the precision of the measure.
%    This is critical for EEG experiments ; for other experiments, the default value should be
%    largely enough. If NumTestFrames = 0, no test is done ; nomina value is kept as it.l 
%
% See also STARTCOGENT, STARTCOSY, STOPCOSY.
%
% Ben, 2007 - 2008
%
% <TODO: Finish doc See STARTPSYCH, for the moment.>

% CogInput v1.28 unstable without CG display: Select PTB as default lib for kb. <v2-beta6>
setcosylib('Keyboard','PTB')

% Start CosyGraphics over PTB
startcosy('PTB',varargin{:});