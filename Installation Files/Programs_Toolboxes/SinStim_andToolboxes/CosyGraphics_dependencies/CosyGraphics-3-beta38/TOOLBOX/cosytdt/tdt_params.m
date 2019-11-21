function TDT = tdt_params
%% tdt_params  Define setup dependent parameters for TDT.
%    TDT = tdt_params  returns the TDT structure, containing all TDT parameters.

%% Computer name
TDT.ServerName = 'INCITATUS';

%% Trigger lines:
TDT.ParallelTriggers.BlockStart = 1;
TDT.ParallelTriggers.BlockEnd   = 2;
TDT.ParallelTriggers.TrialStart = 4;
TDT.ParallelTriggers.TrialEnd   = 8;
TDT.ParallelTriggers.FrameStart = 16;

%% Trigger width:
TDT.ParallelTriggerWidth = 2; % (ms)