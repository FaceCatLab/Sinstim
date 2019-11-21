function sendserialbytes(port, bytes)
% SENDSERIALBYTES  Send bytes to serial port.
%    SENDSERIALBYTES(port, bytes)  sends bytes to serial port. 
%
% Examples:
%     SENDSERIALBYTES( 'COM1', 10 )         - Send 10 to COM1
%     SENDSERIALBYTES( 4, [ 1 2 4 8 ] )     - Send the bytes 1, 2, 4, 8 and 16 (in sequence) to COM4
%
% See also: OPENSERIALBYTES, GETSERIALBYTES, WAITSERIALBYTE.
%
% Ben, 26 Feb 2010.

global COSY_SERIALPORT

% t1=time;

%% Input Args
if isnumeric(port)
    iPort = port;
%     PortName = sprintf('COM%d',iPort);
elseif strncmpi(port,'com',3)
    iPort = str2num(port(4:end));
%     PortName = port;
else
    error('Invalid ''port'' argument.')
end
% error(checkserial(iPort));

% t2=time;

%% Check port is open <v3-beta35>
if ~ismember(port,COSY_SERIALPORT.OpenPorts)
    if isopen('display'), stopcosy; end
    error(sprintf('COM%d port not open. See OPENSERIALPORT.',iPort));
end

%% Send Bytes
switch COSY_SERIALPORT.PORTS(iPort).Lib
    case 'Cog'
        bytes = double(bytes); % char -> double

        hPort = COSY_SERIALPORT.PORTS(iPort).COGENT.hPort;
        CogSerial( 'Write', hPort, bytes );
        
    case 'MATLAB'
        bytes = char(bytes); % double -> char
        fprintf(COSY_SERIALPORT.PORTS(iPort).MATLAB.PortObj, bytes);
        
end

% t3=time;
% dt=diff([t1 t2 t3]);