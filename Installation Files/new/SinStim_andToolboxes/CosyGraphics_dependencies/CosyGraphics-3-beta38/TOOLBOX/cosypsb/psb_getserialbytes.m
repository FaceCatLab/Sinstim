function chars = psb_getserialbytes
% PSB_GETSERIALBYTES  Replacement of GETSERIALBYTES to get PSB's repsonse.
%    chars = PSB_GETSERIALBYTES  

global COSY_PSB

debug = 0;

% Matlab version:
v = version;
v = v(1);

% Send command, choosing low-level function in function of Matlab version:
try
    if     v <= '6'
        %     readserialbytes(4);
        chars = char(getserialbytes(COSY_PSB.SerialPortNumber))';
    elseif v >= '7'
        chars = fscanf(COSY_PSB.SerialPortObject);
    end
    if debug
        dispinfo(mfilename,'debuginfo',['Echo: ' chars]);
    end
    
catch
    dispinfo(mfilename,'error',['Failed to get bytes from ' COSY_PSB.SerialPortName ' port.']);
    
end