% GETSERIALBYTES  return values and times of received serial bytes
% <TODO: rewrite doc !!!>
% Description:
%     GETSERIALBYTES reads the values and times of bytes sent to the serial port.
%     Use GETSERIALBYTES to access these values and times.  
%
% Usage:
%   [ value, time, n ] = GETSERIALBYTES( port, bytes )
%
% Arguments:
%     port   - port number
%     bytes  - 
%     value  - array of byte values
%     time   - array of times
%     n      - number of serial bytes
%
% See also:
%     CONFIG_SERIAL, READSERIALBYTES, SENDSERIALBYTES, LOGSERIALBYTES, WAITSERIALBYTE, GETSERIALBYTES
%
% Cogent 2000 function.

function [Values,Times,n] = getserialbytes(iPort,bytes)

global GLAB_SERIALPORT

%% Input arguments
error(nargchk(1,2,nargin));
error( checkserial(iPort) );

if ~exist('bytes','var'), bytes = []; end

%% Read serial bytes  
switch GLAB_SERIALPORT.PORTS(iPort).Lib
    case 'Cog'
        % <This is the rewrite of readserialbytes.m>
        hPort = GLAB_SERIALPORT.PORTS(iPort).COGENT.hPort;
        [Values,Times] = CogSerial('GetEvents',hPort);
        Times = Times * 1000; % s -> ms
    case 'MATLAB'
        if GLAB_SERIALPORT.PORTS(iPort).MATLAB.PortObj.BytesAvailable
            Values = fscanf(GLAB_SERIALPORT.PORTS(iPort).MATLAB.PortObj);
        else
            Values = [];
        end
        Times = NaN + Values; % Timestamps not supported!
end

%% Filter bytes: 
% If 2d input arg. given, keep only bytes we are interested for.
if ~isempty(bytes)
   filter = ismember(Values,bytes);
   Values = Values(index);
   Times  = Times(index);
end

%% Output arg
n = length(Values);