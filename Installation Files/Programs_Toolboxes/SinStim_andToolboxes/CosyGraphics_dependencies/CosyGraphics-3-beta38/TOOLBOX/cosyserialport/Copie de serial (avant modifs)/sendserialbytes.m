function sendserialbytes( port, bytes )
% SENDSERIALBYTES send bytes to serial port
%
% Description:
%     Send bytes to serial port.
%
% Usage:
%     SENDSERIALBYTES( port, bytes )
%
% Arguments:
%     port    - port number
%     bytes   - array of bytes
%
% Examples:
%     SENDSERIALBYTES( 1, 10 )          - Send 10 to COM1
%     SENDSERIALBYTES( 2, [ 1 2 4 8 ] ) - Send the bytes 1, 2, 4, 8 and 16 (in sequence) to COM2
%
% See also:
%     CONFIG_SERIAL, READSERIALBYTES, SENDSERIALBYTES, LOGSERIALBYTES, WAITSERIALBYTE, GETSERIALBYTES
%
% Cogent 2000 function.
% ben, 30 Sept 2009:    Add warnig for Cogent 1.28: Time bug.

global cogent;

error( checkserial(port) );
% <ben>
if all(getcosylib('Cog','version') >= [1 28])
    warning('COSYGRAPHICS CRITICAL WARNING !!!: Bug in Cogent 1.28: sendserialbytes takes several seconds to execute !!!')
end
bytes = double(bytes); % <v2-beta10 >
%<\ben>

CogSerial( 'Write', cogent.serial{port}.hPort, bytes );
