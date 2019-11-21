function [Chars,Times,n] = getserialbytes(port,bytes)
% GETSERIALBYTES  return values and times of received serial bytes.
%    [chars, times, n] = GETSERIALBYTES  reads the values and times of
%    bytes sent to the serial port. n is the number of bytes. The serial 
%    port must have been open by OPENSERIALBYTES.
%
%    [chars, times, n] = GETSERIALBYTES(port)  does the same.
%    'port' is the port name (e.g.: 'COM1') or the port number (e.g.: 1).  
%
% See also: OPENSERIALBYTES, SENDSERIALBYTES, WAITSERIALBYTE.
%
% Ben, 2007-2011.

% <TODO:
%  what to do with:  [chars, times, n] = GETSERIALBYTES(port,bytes)   ????
%  NB: Used by waitserialbyte!
% >

global COSY_SERIALPORT

%% Input arguments
% error(nargchk(0,2,nargin));
if ~nargin
    if length(COSY_SERIALPORT.OpenPorts) == 1
        iPort = COSY_SERIALPORT.OpenPorts;
    else
        if isopen('display'), stopcosy; end
        if isempty(COSY_SERIALPORT.OpenPorts);
            error('No serial port open.  See OPENSERIALPORT.');
        else
            error('More than one serial port are open.  You must provide the port name or number as argument.');
        end
    end
    
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

if ~exist('bytes','var'), bytes = []; end

%% Check port is open <v3-beta35>
if ~ismember(iPort,COSY_SERIALPORT.OpenPorts)
    if isopen('display'), stopcosy; end
    error(sprintf('COM%d port not open.  See OPENSERIALPORT.',iPort));
end

%% Read serial bytes  
switch COSY_SERIALPORT.PORTS(iPort).Lib
    case 'Cog'
        % <This is the rewrite of readserialbytes.m>
        hPort = COSY_SERIALPORT.PORTS(iPort).COGENT.hPort;
        [vals,Times] = CogSerial('GetEvents',hPort);
        Chars = char(vals)'; 
        Times = Times * 1000; % s -> ms
    case 'MATLAB'
        if COSY_SERIALPORT.PORTS(iPort).MATLAB.PortObj.BytesAvailable > 0
            Chars = fread(COSY_SERIALPORT.PORTS(iPort).MATLAB.PortObj);
        else
            Chars = [];
        end
        Times = NaN + Chars; % Timestamps not supported!
end

%% Filter bytes: 
% If 2d input arg. given, keep only bytes we are interested for.
if ~isempty(bytes)
   filter = ismember(Chars,bytes);
   Chars = Chars(filter);
   Times  = Times(filter);
end

%% Output arg
n = length(Chars);