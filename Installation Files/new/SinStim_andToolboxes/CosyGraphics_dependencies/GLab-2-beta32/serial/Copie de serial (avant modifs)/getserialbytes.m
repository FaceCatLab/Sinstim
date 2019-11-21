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

function [Values,Times,n] = getserialbytes( varargin )

global GLAB_SERIALPORT

%% Input arguments
error(nargchk(1,2,nargin));
port  = varargin{1};
bytes = default_arg( [], varargin, 2 );

error( checkserial(port) );

%% Read serial bytes 
% <This is the rewrite of readserialbytes.m>
hPort = GLAB_SERIALPORT.PORTS(port).COGENT.hPort;
[Values,Times] = CogSerial('GetEvents',hPort);
Times = Times * 1000; % s -> ms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Filter bytes: 
% If 2d input arg. given, keep only bytes we are interested for.
if ~isempty(bytes)
   filter = ismember(Values,bytes);
   Values = Values(index);
   Times  = Times(index);
end

%% Output arg
n = length(Values);