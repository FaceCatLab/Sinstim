function sendserialbytes( iPort, bytes )
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
% Ben, 26 Feb 2010.

global GLAB_SERIALPORT

error(checkserial(iPort));

switch GLAB_SERIALPORT.PORTS(iPort).Lib
    case 'Cog'
        if all(getlibrary('Cog','version') >= [1 28])
            disp('SENDSERIALBYTE WARNING !!!: Bug in Cogent on Matlab 7: sendserialbytes takes several seconds to execute !!!')
        end
        bytes = double(bytes); % char -> double

        hPort = GLAB_SERIALPORT.PORTS(iPort).COGENT.hPort;
        CogSerial( 'Write', hPort, bytes );
        
    case 'MATLAB'
        bytes = char(bytes); % double -> char
        fprintf(GLAB_SERIALPORT.PORTS(iPort).MATLAB.PortObj, bytes);
        
end
