% OPENTDT  
%    OPENTDT  checks connection with TDT server computer ; if connection ok, initializes GLab 
%    to use TDT ; if not, initializes GLab in dummy mode.

function opentdt

% Global vars and hard-coded parameters
global GLAB_TDT
TDT = tdt_params;

% 
dispinfo(mfilename,'info','Checking network connection with TDT server computer...')
cmd = ['PING ' TDT.ServerName];
err = dos(cmd);
disp(' ')
if ~err
    dispinfo(mfilename,'info','Connection OK.')
    GLAB_TDT.isConnected = 1;
else
    dispinfo(mfilename,'warning','NO CONNECTION WITH TDT SERVER.  TDT open in dummy mode.')
    GLAB_TDT.isConnected = 0;
end
disp(' ')
