function openserialport(port,baudrate,parity,stopbits,bytesize)
% OPENSERIALPORT  Open a serial port.
%    OPENSERIALPORT  opens serial port (COM1) with default settings.
%
%    OPENSERIALPORT(port) opens given port. 'port' is the port name (e.g.: 'COM1') or the port number  
%    (e.g.: 1). Multiple serial ports are not supported: you can only open one port at a time.
%
%    OPENSERIALPORT(port,baudrate) specifies baudrate (bits per second). Default value is 9600.
%    Valid values are: 110,300,600,1200,2400,4800,9600,14400,19200,38400,56000,57600,115200,128000,256000.
%    Most modern devices support rates up to 115200. Higher values are not always supported.
%
%    OPENSERIALPORT(port,baudrate,parity) specifies also parity. Default is 'none'.
%    Valid values: 'none', 'odd', 'even', 'mark', 'space'.
%
%    OPENSERIALPORT(port,baudrate,parity,stopbits) specifies stop bits. Default is 1.
%    Valid values: 1, 1.5, 2.
%
%    OPENSERIALPORT(port,baudrate,parity,stopbits,bytesize) specifies byte size. Default is 8.
%    Valid values: 4 to 8. (Programmer's note: not sure for values 5 to 7.)
%    
% Examples:
%    openserialport(1,9600,'none',1,8)  is the same than openserialport with no arguments.
%
%    openserialport('COM4',115200)  opens COM4 with correct settings for the USB serial port (1) of
%                              Saint Luc's 3 Tesla fMRI scanner or (2) of Benoit Gerard's PSB.
%
% See also: READSERIALBYTES, SENDSERIALBYTES, WAITSERIALBYTE, GETSERIALBYTES, CLOSESERIALPORT,
%    OPENPARALLELPORT.
%
% Ben, Jan. 2008

% <TODO: From http://psychtoolbox.org/wikka.php?wakka=PlatformDifferences
%   Psychserial, Joystick
%   The old and crufty PsychSerial command is available for Windows. It is identical to the version bundled with the old Windows PTB2.54. Matlab itself also allows to control the serial port via its serial command on Windows and Linux. It works well but has the drawback of only working when Java is enabled and it is significantly slower. Our IOPort driver provides high quality, flexible serial port support (and for USB serial ports) with high timing precision on all operating systems, so use of IOPort is strongly recommended.
%   The OS-X version supports joysticks via the new GamePad functions. We provide some simple joystick support for Windows via WinJoystickMex and this link: Seems to have some downloadable joystick driver for Matlab on Windows..
%  >

global COSY_SERIALPORT

if isempty(COSY_SERIALPORT)
    COSY_SERIALPORT.OpenPorts = [];
    COSY_SERIALPORT.PORTS = [];
end

% INPUTS ARGS: DEFAULT VALUES
if ~exist('port','var') % <v3-beta4>
    iPort = 1; 
elseif isnumeric(port)
    iPort = port;
elseif ischar(port) &&  strncmpi(port,'com',3)
    iPort = str2num(port(4:end));
else
    error('Invalid ''port'' argument.')
end
COSY_SERIALPORT.PORTS(iPort).isOpen = false;
PortName = ['COM' int2str(iPort)];
if ~exist('baudrate','var'), baudrate = 9600; end
if ~exist('parity'  ,'var'), parity = 'none';
else parity = lower(parity);
end
if ~exist('stopbits','var'), stopbits = 1; end
if ~exist('bytesize','var'), bytesize = 8;
elseif ~(bytesize >= 4 && bytesize <= 8), error('Invalid ''bytesize'' value.')
end

% OPEN PORTS USING RIGHT LIBRARY
lib = getcosylib('SerialPort');

disp(' ')

switch upper(lib(1:3))
    case 'COG' % COGENT
        dispinfo(mfilename,'info',['Opening ' PortName ' port, using Cogent library...'])
        err = openserialport_with_cogent(iPort,baudrate,parity,stopbits,bytesize);
        
    case 'MAT' % MATLAB standard lib
        dispinfo(mfilename,'info',['Opening ' PortName ' port, using standard MATLAB library...'])
        dispinfo(mfilename,'warning','Standard MATLAB library has a critical performances issue !!! (Expect a dozen of milliseconds to send one byte!)')
        err = openserialport_with_matlab(iPort,baudrate,parity,stopbits,bytesize);
        
    case 'PTB' % PsychToolBox3 IOport
%         IOPort('OpenSerialPort', PortName, 
        
        % <TODO>
end

if err < 0 % Error: port not open
    error(['Cannot open  ' PortName ' port.'])
    
else % Port open: Update global var.
    % Update port status (kept redundantly in two vars for convenience)
    COSY_SERIALPORT.OpenPorts = union(COSY_SERIALPORT.OpenPorts,iPort);
    COSY_SERIALPORT.PORTS(iPort).isOpen = true;
    % Keep port's attributes for archive
    COSY_SERIALPORT.PORTS(iPort).baudrate = baudrate;
    COSY_SERIALPORT.PORTS(iPort).parity = parity;
    COSY_SERIALPORT.PORTS(iPort).stopbits = stopbits;
    COSY_SERIALPORT.PORTS(iPort).bytesize = bytesize;
    
    % Clear port's buffer:
    clearserialbytes(); 
end

%% %%%%%%%%%%%%%%%%%%%%%%%% SUB-FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%% %%

%% openserialport_with_cogent
function err = openserialport_with_cogent(iPort,baudrate,parity,stopbits,bytesize)

global COSY_SERIALPORT

% Init: It seems that cogstd initializes something at first call: without calling it first,
% Matlab crashes. <v3-beta35>
cogstd('sGetTime',-1);

% VARIABLES
% Port
serial.name = ['COM',num2str(iPort)]; % <used only by logserialbytes. TODO: suppress it>
% Baudrate
valid = [110,300,600,1200,2400,4800,9600,14400,19200,38400,56000,57600,115200,128000,256000];
if ismember(baudrate,valid)
    attr.Baud = baudrate;
else
    error(['Bad ''baudrate'' value. Valid values are:' char(10) int2str(valid)]);
end
% Parity
switch lower(parity)
    case 'none',	attr.Parity = 0;
    case 'odd',		attr.Parity = 1;
    case 'even',	attr.Parity = 2;
    case 'mark',	attr.Parity = 3;
    case 'space',	attr.Parity = 4;
    otherwise error('Bad ''parity'' value.')
end
% Stop bits
switch lower(stopbits)
    case 1,		attr.StopBits = 0;
    case 1.5,	attr.StopBits = 1;
    case 2,		attr.StopBits = 2;
    otherwise error('Bad ''stopbits'' value.')
end
% Byte size 
attr.ByteSize = bytesize;
% data: those fields will be used during run-time
% serial.value       = [];
% serial.time        = [];

% OPEN PORTS
err = 0;
try
	hPort = CogSerial('open',serial.name);
catch
    try % <v3-beta35: try to close port then try to open it again>
        CogSerial('close');
        hPort = CogSerial('open',serial.name);
    catch
        err = -1;
        disp(' ')
        disp(lasterr)
    end
end

if ~err
    % SET PORTS
    CogSerial('setattr',hPort,attr);
    CogSerial('record',hPort,1000);

    % GLOBAL VAR.
    COSY_SERIALPORT.PORTS(iPort).Lib = 'Cog'; % <TODO: Port-by-port lib support not yet fully implemented.>
    COSY_SERIALPORT.PORTS(iPort).COGENT.hPort = hPort;
%     cogent.serial{iPort} = serial; % <TODO: suppress this>
end

%% openserialport_with_matlab
function err = openserialport_with_matlab(iPort,baudrate,parity,stopbits,bytesize)

global COSY_SERIALPORT  % <v3-alpha4: Not needed.>

err = 0;

try % <instrfindall doesn't exist on M6.5>
    fclose(instrfindall);  % <v3-alpha4: Be sure to close all Matlab serial ojects.>
catch
end

PortName = ['COM' int2str(iPort)];
PortObj = serial(PortName,'baudrate',baudrate); % Open communication with PSB
if strcmp(PortObj.Status,'closed')
    fopen(PortObj);
end
PortObj.TimeOut = .002; %<v3-beta35>

COSY_SERIALPORT.PORTS(iPort).Lib = 'MATLAB'; % <TODO: Port-by-port lib support not yet fully implemented.>
COSY_SERIALPORT.PORTS(iPort).MATLAB.PortObj = PortObj;

warning off MATLAB:serial:fread:unsuccessfulRead %<v3-beta35>
