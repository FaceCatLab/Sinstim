function [chars, t, n] = waitserialbyte(port,code,timeout)
% WAITSERIALBYTE  Wait for byte to arrive on serial port.
%    [chars, times, n] = WAITSERIALBYTE(port)  waits an indefinte amount of time for any byte to arrive at COM port.
%
%    [chars, times, n] = WAITSERIALBYTE(port, bytes)  waits an indefinte amount of time for any byte included in the 'bytes' 
%    vector to arrive at COM port.  If 'bytes' is empty, waits for any byte.
%
%    [chars, times, n] = WAITSERIALBYTE( port, bytes, timeout )  waits 'timeout' milliseconds for byte to arrive.                                                   
%
% Examples:
%     waitserialbyte('COM1', [],  1000)     - wait 1000 milliseconds for any byte to arrive on COM1
%     waitserialbyte('COM3', 'C', 2000)     - wait 2000 milliseconds for byte='C' to arrive on COM3
%     waitserialbyte( 3, [10 20], 2000)     - wait 2000 milliseconds for bytes 10 or 20 to arrive on COM3
%     waitserialbyte( 1 )                   - wait for an indefinte amount of time for any byte to arrive on COM1
%     waitserialbyte('COM4', '!')           - wait for an indefinte amount of time for byte='!' to arrive on COM4
%     waitserialbyte( 5, 'ABC')             - wait for an indefinte amount of time for bytes 'A', 'B' or 'C' to arrive on COM5
%
% See also:
%     CONFIG_SERIAL, READSERIALBYTES, SENDSERIALBYTES, LOGSERIALBYTES, WAITSERIALBYTE, GETSERIALBYTES
%
% Cogent 2000 function.

global cogent COSY_SERIALPORT;

t0 = time;

% Arguments
% error( nargchk(0,3,nargin) );
if ~nargin
    iPort = COSY_SERIALPORT.OpenPorts(end);
elseif isnumeric(port)
    iPort = port;
%     PortName = sprintf('COM%d',iPort);
elseif strncmpi(port,'com',3)
    iPort = str2num(port(4:end));
%     PortName = port;
else
    error('Invalid ''port'' argument.')
end
% error(checkserial(iPort));
if nargin < 2, code = []; end
if nargin < 3, timeout = inf; end

n = 0;
while( time-t0 < timeout & n == 0 )
%    logserialbytes( port ); %<3-beta4: suppr.>
   [chars, t, n] = getserialbytes( iPort, code );
%    readserialbytes( port );  %<3-beta4: suppr.>
end
