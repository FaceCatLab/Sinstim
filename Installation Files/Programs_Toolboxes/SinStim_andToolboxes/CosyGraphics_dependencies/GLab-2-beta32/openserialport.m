% OPENSERIALPORT  Open a serial port.
%    OPENSERIALPORT  opens serial port (COM1) with default settings. Will work on most cases.
%
%    OPENSERIALPORT(port) opens given port. 'port' is the port number (e.g.: 1 for COM1). 
%    Multiple serial ports are not supported: you can only open one port at a time.
%
%    OPENSERIALPORT(port,baudrate) specifies baudrate (bits per second). Default value is 9600.
%    Valid values: 110,300,600,1200,2400,4800,9600,14400,19200,38400,56000,57600,115200,128000,256000.
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
%    openserialport(4,115200)  opens COM4 with correct settings for the USB serial port (1) of
%                              Saint Luc's 3 Tesla fMRI scanner or (2) of Benoit Gerard PSB.
%
% See also: READSERIALBYTES, SENDSERIALBYTES, WAITSERIALBYTE, GETSERIALBYTES, CLOSESERIALPORT,
%    OPENPARALLELPORT.
%
% Ben, Jan. 2008

%% MAIN FUNCTION
function openserialport(iPort,baudrate,parity,stopbits,bytesize)

global GLAB_SERIALPORT

if isempty(GLAB_SERIALPORT)
    GLAB_SERIALPORT.OpenPorts = [];
    GLAB_SERIALPORT.PORTS = [];
end

% INPUTS ARGS: DEFAULT VALUES
if ~exist('iPort','var'), iPort = 1; end
GLAB_SERIALPORT.PORTS(iPort).isOpen = false;
if ~exist('baudrate','var'), baudrate = 9600; end
if ~exist('parity'  ,'var'), parity = 'none';
else parity = lower(parity);
end
if ~exist('stopbits','var'), stopbits = 1; end
if ~exist('bytesize','var'), bytesize = 8;
elseif ~(bytesize >= 4 && bytesize <= 8), error('Invalid ''bytesize'' value.')
end

% OPEN PORTS USING RIGHT LIBRARY
lib = getlibrary('SerialPort');

switch upper(lib(1:3))
    case 'COG' % COGENT
        err = openserialport_with_cogent(iPort,baudrate,parity,stopbits,bytesize);
    case 'MAT' % MATLAB
        err = openserialport_with_matlab(iPort,baudrate,parity,stopbits,bytesize);
end

if err < 0 % Error: port not open
    error(['Cannot open ' serial.name '.'])
else % Port open: Update global var.
    % Update port status (kept redundantly in two vars for convenience)
    GLAB_SERIALPORT.OpenPorts = union(GLAB_SERIALPORT.OpenPorts,iPort);
    GLAB_SERIALPORT.PORTS(iPort).isOpen = true;
    % Keep port's attributes for archive
    GLAB_SERIALPORT.PORTS(iPort).baudrate = baudrate;
    GLAB_SERIALPORT.PORTS(iPort).parity = parity;
    GLAB_SERIALPORT.PORTS(iPort).stopbits = stopbits;
    GLAB_SERIALPORT.PORTS(iPort).bytesize = bytesize;
end

%% %%%%%%%%%%%%%%%%%%%%%%%% SUB-FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%% %%

%% openserialport_with_cogent
function err = openserialport_with_cogent(iPort,baudrate,parity,stopbits,bytesize)

global GLAB_SERIALPORT
% global cogent

err = 0;

% CHECK IF GLAB IS RUNNING
if ~isopen('display')
	error('GLab must be started (with STARTCOGENT or STARTPSYCH) before to use OPENSERIALPORT.')
end

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
try
	hPort = CogSerial('open',serial.name);
%     serial.hPort = hPort;
catch
	err = -1;
end

if ~err
    % SET PORTS
    CogSerial('setattr',hPort,attr);
    CogSerial('record',hPort,1000);

    % GLOBAL VAR.
    GLAB_SERIALPORT.PORTS(iPort).Lib = 'Cog'; % <TODO: Port-by-port lib support not yet fully implemented.>
    GLAB_SERIALPORT.PORTS(iPort).COGENT.hPort = hPort;
%     cogent.serial{iPort} = serial; % <TODO: suppress this>
end

%% openserialport_with_matlab
function err = openserialport_with_matlab(iPort,baudrate,parity,stopbits,bytesize)

global GLAB_SERIALPORT

err = 0;

PortName = ['COM' int2str(iPort)];
PortObj = serial(PortName,'baudrate',115200); % Open communication with PSB
if strcmp(PortObj.Status,'closed')
    fopen(PortObj);
end
GLAB_SERIALPORT.PORTS(iPort).Lib = 'MATLAB'; % <TODO: Port-by-port lib support not yet fully implemented.>
GLAB_SERIALPORT.PORTS(iPort).MATLAB.PortObj = PortObj;
