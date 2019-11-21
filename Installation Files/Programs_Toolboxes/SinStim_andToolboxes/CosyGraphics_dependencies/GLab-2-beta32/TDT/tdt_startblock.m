function tdtstartblock
%% tdtstartblock  Send to TDT "block start" trigger and wait for TDT mode switch.

global GLAB_TDT

%% TDT parameters
TDT = tdt_params;

%% Send "block start" event trough // port
disp('-> TDT: block start')
sendparallelbyte(TDT.ParallelTriggers.BlockStart);
wait(50)
sendparallelbyte(0);

%% Wait for TDT mode switch
drawtext('Wait for TDT mode switch...',0,[0 0 1]);
displaybuffer;
wait(2000)
displaybuffer;

%% Set TDT status
GLAB_TDT.isBlockStarted = 1;