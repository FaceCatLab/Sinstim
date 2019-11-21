% OPENTDT  Initialise Tucker-Davies Technologies (TDT) hardware.
%    OPENTDT  checks connection with TDT server computer ; if connection ok, initializes CosyGraphics 
%    to use TDT ; if not, initializes CosyGraphics in dummy mode.

function opentdt

% Global vars and hard-coded parameters
global COSY_TDT
TDT = tdt_params;

% 
dispinfo(mfilename,'info','Checking network connection with TDT server computer...')
cmd = ['PING ' TDT.ServerName];
err = dos(cmd);
disp(' ')
if ~err
    dispinfo(mfilename,'info','Connection OK.')
    COSY_TDT.isConnected = 1;
else
    dispinfo(mfilename,'warning','NO CONNECTION WITH TDT SERVER.  TDT open in dummy mode.')
    COSY_TDT.isConnected = 0;
end
disp(' ')
