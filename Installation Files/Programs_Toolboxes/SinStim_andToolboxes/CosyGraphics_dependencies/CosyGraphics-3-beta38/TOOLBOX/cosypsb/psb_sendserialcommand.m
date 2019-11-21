function psb_sendserialcommand(command)
% PSB_SENDSERIALCOMMAND  Replacement of SENDSERIALBYTES to send commands to PSB.
%    Serial port emulation over USB poses critical optimization issues on different MATLAB
%    versions. This function handle them and must be always used to send serial bytes to
%    the PSB (don't use send serialbytes directly).
%
%    PSB_SENDSERIALCOMMAND(command)

global COSY_PSB

debug = 1;

% Matlab version:
v = version;
v = v(1);

% Send command, choosing low-level function in function of Matlab version:
try
    for i = 1:3 % <Hack!!! Do it 3 times because of current lack of reliability.>
        if     v <= '6'
            sendserialbytes(COSY_PSB.SerialPortNumber, command); % <awfully slooooooow on Matlab 7.5>
        elseif v >= '7'
            fprintf(COSY_PSB.SerialPortObject, command);
        end
    end
    
catch
    dispinfo(mfilename,'error',['Failed to send bytes through ' COSY_PSB.SerialPortName ' port.']);
    return % <===!!!
    
end

%% Clear port's buffer (filled by command echo)
wait(30)  % <TODO: Review this>
echo = psb_getserialbytes;
if debug
    dispinfo(mfilename,'debuginfo',['Echo: ' echo]);
end