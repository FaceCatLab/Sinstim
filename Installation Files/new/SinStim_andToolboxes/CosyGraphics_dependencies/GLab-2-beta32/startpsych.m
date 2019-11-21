function startpsych(varargin)
% STARTPSYCH    Start G-Lab, using PsychToolBox as library.
%    STARTPSYCH  opens a PTB display with default settings (800x600 window).
%
% <TODO: Finish doc See STARTCOGENT, for the moment.>

% CogInput v1.28 unstable without CG display: Select PTB as default lib for kb. <v2-beta6>
setlibrary('Keyboard','PTB')

% Start GraphicsLab over PTB
startglab('PTB',varargin{:});