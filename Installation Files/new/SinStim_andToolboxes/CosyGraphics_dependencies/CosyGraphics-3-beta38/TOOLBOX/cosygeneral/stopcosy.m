function stopcosy(isVerbose)
% STOPCOSY  Stop CosyGraphics.
%    STOPCOSY  closes display and everything that has been open by a CosyGraphics function.
%
% See also STARTCOSY, CLEARCOSY.
%
% Ben, Sept 2007 - March 2008


% Programmer's note: This script must be robust even in case of version change.
% It must be able to stop an older version of CosyGraphics. It must also be robust 
% in case of STARTCOSY crash (i.e.: incomplete startup). Keep that in mind.


global cogent
global COSY_GENERAL COSY_DISPLAY
global AI

%% Input Agr.
if nargin < 1, isVerbose = 1; end

%% Disp info
if isVerbose && isopen('cosygraphics')
    disp(' ')
    dispinfo(mfilename,'INFO','Stopping CosyGraphics...')
end

%% Restore priority level
if ~strcmpi(getpriority,'NORMAL') && ~all(getpriority == 0)
    setpriority NORMAL
end

%% Reset global var.
COSY_DISPLAY.BUFFERS.OffscreenBuffers = [];
COSY_DISPLAY.BUFFERS.CurrentBuffer4CG = 0;

%% Re-enable Matlab's JIT acceleration <v2-beta33>
feature accel on

%% Shutdown CosyGraphics
if isfield(cogent,'keyboard') %| isfield(cogent,'mouse') %(suppr. v1.5)
    coginput('shutdown');
    cogent = rmfield(cogent,'keyboard'); %<v2-alpha6>
end
if isfieldtrue(COSY_DISPLAY,'isDisplay') && ~isfieldtrue(COSY_DISPLAY,'doKeep')
    dispinfo(mfilename,'info','Closing display...')
    if iscog
        cgshut;
    elseif isptb
        Screen('Close');
        Screen('CloseAll');
        if isfield(COSY_DISPLAY,'Screen') && ...
                COSY_DISPLAY.Screen && isfield(COSY_DISPLAY,'SAVE_OS_SETTINGS')
            wh = COSY_DISPLAY.SAVE_OS_SETTINGS.Resolution;
            Screen('Resolution',COSY_DISPLAY.ScreenNumber4PTB,wh(1),wh(2));
        end
    end
    COSY_DISPLAY.isDisplay = 0;
    if ispc && isptbinstalled, setgamma(1); end % <TODO: Redo that properly.>
%     if isfield(COSY_DISPLAY,'ScreenSize_cm')  % <suppr. 08-02-2012, v3-beta10>
%         COSY_DISPLAY.ScreenSize_cm = [];
%     end
elseif isptbinstalled
    Screen('CloseAll'); % cannot hurt
end
COSY_GENERAL.isStarted = false;

% DirectX workaround for Wait Blanking: <v2-beta39>
if exist('WaitVerticalBlank') == 3 && WaitVerticalBlank('isinit')
    WaitVerticalBlank('uninit');
end

%% Sound
closesound;

%% Movies
if isfilledfield(COSY_DISPLAY,'MovieHandles')
    closemovie('all');
end

%% Ports
closeserialport;
closeparallelport;

%% EyeLink
closeeyelink; 

%% Misc.
closephotodiode
try closepsb; catch end  % close PSB before photodiode <??>

%% Trial log
% COSY_TRIALLOG = [];
   
%% Daq Analog Input
if ~isempty(AI)
    try
        closeanaloginput;
    catch
    end
end

%% Reset Abort Flag
COSY_GENERAL.isAborted = false;

%% Done
if isVerbose,
    dispinfo(mfilename,'INFO','CosyGraphics stopped.')
    disp(' ')
    dispbox(['   CosyGraphics ' vnum2vstr(cosyversion) ' stopped.   '])
    disp(' ')
end