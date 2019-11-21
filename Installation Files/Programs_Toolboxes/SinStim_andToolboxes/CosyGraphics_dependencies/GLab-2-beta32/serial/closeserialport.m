function closeserialport
% CLOSESERIALPORT  Close serial port.
%    CLOSESERIALPORT  closes the serial port you had opened with OPENSERIALPORT.
%       (As the OPENSERIALPORT can only open one port at a time, you don't need
%       to specify the port number.) If no port is open, does nothing.
%
% See also: OPENSERIALPORT.
%
% Ben, Nov. 2007

global GLAB_SERIALPORT

if ispc && isopen('display')
    CogSerial('close');
end

if isfield(GLAB_SERIALPORT,'OpenPorts'), OpenPorts = GLAB_SERIALPORT.OpenPorts;
else                                     OpenPorts = [];
end

for iPort = OpenPorts
    GLAB_SERIALPORT.PORTS(iPort).isOpen = false;
    switch GLAB_SERIALPORT.PORTS(iPort).Lib
        case 'Cog' % Cogent
            CogSerial('close'); 
        case 'MATLAB' % std Matlab lib
            fclose(GLAB_SERIALPORT.PORTS(iPort).MATLAB.PortObj);
    end
end

GLAB_SERIALPORT.OpenPorts = [];