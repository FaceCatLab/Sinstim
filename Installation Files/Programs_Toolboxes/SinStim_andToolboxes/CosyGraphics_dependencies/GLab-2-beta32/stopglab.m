function stopglab(isVerbose)
% STOPGLAB  Stop GraphicsLab.
%    STOPGLAB  closes display and everything that has been open by a GLab function.
%
% See also STARTGLAB, CLEARGLAB.
%
% Ben, Sept 2007 - March 2008


% Programmer's note: This script must be robust even in case of version change.
% It must be able to stop an older version of G-Lab. It must also be robust 
% in case of STARTGLAB crash (i.e.: incomplete startup). Keep that in mind.


global cogent
global GLAB_IS_RUNNING
global GLAB_DISPLAY GLAB_BUFFERS
global GLAB_TRIAL GLAB_EYELINK
global AI

%% Input Agr.
if nargin < 1, isVerbose = 1; end

%% Disp info
if isVerbose && isopen('glab')
    disp(' ')
    dispinfo(mfilename,'INFO','Stopping GLab...')
end

%% Restore priority level
if ~strcmpi(getpriority,'NORMAL') && ~all(getpriority == 0)
    setpriority NORMAL
end

%% Reset global var.
GLAB_BUFFERS.OffscreenBuffers = [];
GLAB_BUFFERS.CurrentBuffer = 0;

%% Shutdown G-Lab
if isfield(cogent,'keyboard') %| isfield(cogent,'mouse') %(suppr. v1.5)
    coginput('shutdown');
    rmfield(cogent,'keyboard'); %<v2-alpha6>
end
if isfield(cogent,'sound')
    cogsound('shutdown');
    cogcapture('shutdown');
    rmfield(cogent,'sound'); %<v1.6.2: needed by SETPRIORITY('OPTIMAL')>
end
if isfieldtrue(GLAB_DISPLAY,'isDisplay') && ~isfieldtrue(GLAB_DISPLAY,'doKeep')
    dispinfo(mfilename,'info','Closing display...')
    if iscog
        cgshut;
    elseif isptb
        Screen('Close');
        Screen('CloseAll');
        if isfield(GLAB_DISPLAY,'Screen') && ...
                GLAB_DISPLAY.Screen && isfield(GLAB_DISPLAY,'SAVE_OS_SETTINGS')
            wh = GLAB_DISPLAY.SAVE_OS_SETTINGS.Resolution;
            Screen('Resolution',GLAB_DISPLAY.ScreenNumber4PTB,wh(1),wh(2));
        end
    end
    GLAB_DISPLAY.isDisplay = 0;
    if ispc, setgamma(1); end % <TODO: Redo that properly.>
    if isfield(GLAB_DISPLAY,'ScreenSize_cm')
        GLAB_DISPLAY.ScreenSize_cm = [];
    end
end
GLAB_IS_RUNNING = 0;

%% Close Ports
closeserialport
closeparallelport

%% EyeLink
closeeyelink; 

%% Close Misc.
try 
    closepsb; % close PSB before photodiode
end
closephotodiode
% if exist('closeeyelink') == 2, closeeyelink; end % <v2-beta11>

%% GLAB_TRIAL
% GLAB_TRIAL = [];
   
%% Daq Analog Input
if ~isempty(AI)
    try
        stop(AI)
        delete(AI)
        AI = [];
    end
end

%% Done
if isVerbose,
    dispinfo(mfilename,'INFO','GraphicsLab stopped.')
    disp(' ')
    dispbox(['    GraphicsLab stopped.    '])
    disp(' ')
end