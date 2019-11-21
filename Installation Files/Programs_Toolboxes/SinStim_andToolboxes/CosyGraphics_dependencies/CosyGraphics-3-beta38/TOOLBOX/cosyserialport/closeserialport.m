function closeserialport
% CLOSESERIALPORT  Close serial port.
%    CLOSESERIALPORT  closes the serial port you had opened with OPENSERIALPORT.
%       (As the OPENSERIALPORT can only open one port at a time, you don't need
%       to specify the port number.) If no port is open, does nothing.
%
% See also: OPENSERIALPORT.
%
% Ben, Nov. 2007

global COSY_SERIALPORT

if ispc && isopen('display')
    CogSerial('close');
end

if isfield(COSY_SERIALPORT,'OpenPorts'), OpenPorts = COSY_SERIALPORT.OpenPorts;
else                                     OpenPorts = [];
end

for iPort = OpenPorts
    COSY_SERIALPORT.PORTS(iPort).isOpen = false;
    switch COSY_SERIALPORT.PORTS(iPort).Lib
        case 'Cog' % Cogent
            CogSerial('close'); 
        case 'MATLAB' % std Matlab lib
            fclose(COSY_SERIALPORT.PORTS(iPort).MATLAB.PortObj);
    end
end

try % <instrfindall doesn't exist on M6.5>
    fclose(instrfindall);  % <v3-alpha4: Be sure to close all Matlab serial ojects.>
catch
end

COSY_SERIALPORT.OpenPorts = [];