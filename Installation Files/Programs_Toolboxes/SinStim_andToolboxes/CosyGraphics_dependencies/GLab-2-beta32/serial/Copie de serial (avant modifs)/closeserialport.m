function closeserialport
% CLOSESERIALPORT  Close serial port.
%    CLOSESERIALPORT  closes the serial port you had opened with OPENSERIALPORT.
%       (As the OPENSERIALPORT can only open one port at a time, you don't need
%       to specify the port number.) If no port is open, does nothing.
%
% See also: OPENSERIALPORT.
%
% Ben, Nov. 2007

global cogent

if isfield(cogent,'serial')
   cogserial('close');
   cogent = rmfield(cogent,'serial');
end