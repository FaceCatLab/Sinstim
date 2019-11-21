
function openserialport(port,baudrate,parity,stopbits,bytesize)
% OPENSERIALPORT  Open a serial port.
%    OPENSERIALPORT opens serial port (COM1) with default settings. Will work on most cases.
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


global cogent COSY_IS_RUNNING;


%% CHECK IF COSYGRAPHICS IS RUNNING
if ~isopen('display')
	error('CosyGraphics must be started (with STARTCOGENT or STARTPSYCH) before to use OPENSERIALPORT.')
end


%% VARIABLES
% Port #
if ~exist('port','var'), port = 1; end
serial.name = ['COM',num2str(port)];
% Baudrate
valid = [110,300,600,1200,2400,4800,9600,14400,19200,38400,56000,57600,115200,128000,256000];
if exist('baudrate','var'),
	if ismember(baudrate,valid)
		serial.baudrate = baudrate;
	else
		error(['Bad ''baudrate'' value. Valid values are:' char(10) int2str(valid)]);
	end
else serial.baudrate = 9600;
end
% Parity
if exist('parity'  ,'var')
	switch lower(parity)
		case 'none',	serial.parity = 0;
		case 'odd',		serial.parity = 1;
		case 'even',	serial.parity = 2;
		case 'mark',	serial.parity = 3;
		case 'space',	serial.parity = 4;
		otherwise error('Bad ''parity'' value.')
	end
else serial.parity = 0;
end
% Stop bits
if exist('stopbits','var')
	switch lower(stopbits)
		case 1,		serial.stopbits = 0;
		case 1.5,	serial.stopbits = 1;
		case 2,		serial.stopbits = 2;
		otherwise error('Bad ''stopbits'' value.')
	end
else serial.stopbits = 0;
end
% Byte size
if exist('bytesize','var'), 
	if bytesize >= 4 && bytesize <= 8
		serial.bytesize = bytesize;
	else error('Bad ''bytesize'' value.')
	end
else serial.bytesize = 8;
end
% ?
serial.value       = [];
serial.time        = [];


%% OPEN PORT
try
	serial.hPort = CogSerial('open',serial.name);
catch
	error(['Cannot open ' serial.name '.'])
	return % !!!
end


%% SET PORT
attr.Baud = serial.baudrate;
attr.Parity = serial.parity;
attr.StopBits = serial.stopbits;
attr.ByteSize = serial.bytesize;
CogSerial('setattr',serial.hPort,attr);
CogSerial('record',serial.hPort,1000);


%% 'cogent' VARIABLE
cogent.serial{port} = serial;
