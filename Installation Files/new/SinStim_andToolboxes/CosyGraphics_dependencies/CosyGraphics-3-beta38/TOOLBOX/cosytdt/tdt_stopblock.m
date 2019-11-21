function tdtstopblock
%% tdtstopblock  Send to TDT "block end" trigger.

global COSY_TDT

%% TDT parameters
TDT = tdt_params;

%% Send "block start" event trough // port
disp('-> TDT: block end')
sendparallelbyte(TDT.ParallelTriggers.BlockEnd);
wait(50)
sendparallelbyte(0);

%% Set TDT status
COSY_TDT.isBlockStarted = 0;