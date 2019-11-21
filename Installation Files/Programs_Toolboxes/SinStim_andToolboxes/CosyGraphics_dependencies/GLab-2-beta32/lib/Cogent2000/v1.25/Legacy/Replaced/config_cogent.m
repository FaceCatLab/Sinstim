function config_cogent(isfullscreen,resolution,varargin)
% STARTCOGENT   Initialise and start the Cogent environnement.
%	STARTCOGENT(isfullscreen,resolution)
%	STARTCOGENT(isfullscreen,resolution,option1,option2,...)
%
% See also STOPCOGENT.
%
% Ben, Sept 2007.

global cogent;

%%%%%%%%%%Parameters%%%%%%%%%
keyboard_time_res = 1; %(ms)
mouse_time_res    = 5; %(ms)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Arguments
option.keyboard = 0;
option.mouse    = 0;
option.serial   = 0;
for i = 1 : length(varargin)
	if ~isempty(varargin{i}), eval([varargin{i} '= 1;']); end
end

% CONFIG. DISPLAY
screen_sizes = [ 640 480; 800 600; 1024 768; 1152 864; 1280 1024; 1600 1200 ];
res = find(screen_sizes(:,1) == resolution(1));
if isempty(res), error('Bad screen resolution.'), end
cogent.display.res       = res;
cogent.display.size      = screen_sizes(res,:);
cogent.display.mode      = isfullscreen;
cogent.display.bg        = [0,0,0];
cogent.display.fg        = [1,1,1];
cogent.display.font      = 'Arial';
cogent.display.fontsize  =  50;
cogent.display.number_of_buffers = 0;
cogent.display.nbpp      = 32; % 32 bits display
cogent.display.scale     = resolution(1); % default unit is the pixel

% CONFIG. KEYBOARD
if option.keyboard
	config_keyboard(100,100,'nonexclusive');
else
	config_keyboard(100,keyboard_time_res,'exclusive');
end

% CONFIG. MOUSE
if option.mouse
	config_mouse(mouse_time_res);
end

% CONFIG. SERIAL PORT
if option.serial
	config_serial(1,9600,0,0,8);
end

% CONFIG. MATLAB
% Disable Matlab 7 warning messages due to case inconsistency in Cogent
warning off MATLAB:dispatcher:InexactMatch

% START COGENT
start_cogent; % (sub-function, see below)

% CONFIG. SCALE (Cogent must be started)
cgscale % units = pixels


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SUB-FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function config_keyboard( varargin )
% CONFIG_KEYBOARD configures keyboard
%
% Description:
%     Use this function to configure the keyboard before calling START_COGENT.  The device mode should be
%     'exclusive' for accurate timing.  When in 'exclusive' mode no other application (including
%     the Matlab console window) can access the keyboard.
%
% Usage:
%     CONFIG_KEYBOARD( quelength = 100, resolution = 5, mode = 'exclusive' )
%
% Arguments:
%     quelength    - maximum number of key events recorded between calls to READKEYS
%     resolution   - timing resolution in milliseconds
%     mode         - device mode (possible values 'exclusive' and 'nonexclusive')
%
% Examples:
%
% See also:
%     READKEYS, LOGKEYS, WAITKEYDOWN, WAITKEYUP, LASTKEYDOWN, LASTKEYUP, GETKEYDOWN, 
%     GETKEYUP, GETKEYMAP
%
% Cogent 2000 function.

global cogent;

error( nargchk(0,3,nargin) );

args{1}   = default_arg( 100, varargin, 1 );
args{2}   = default_arg( 5,   varargin, 2 );
args{3}   = default_arg( 'nonexclusive', varargin, 3 );

cogent.keyboard = config_device( 1, args{:} );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function config_mouse( varargin )
% CONFIG_MOUSE configures mouse
%
% Description:
%     Configures and sets up mouse
%
% Usage:
%     CONFIG_MOUSE              - configure mouse for non-polling mode
%     CONFIG_MOUSE( interval )  - configure mouse for polling mode
%
% Arguments:
%     interval - sample interval in milliseconds for polling mode
%
% Examples:
%
% See also:
%     WAITMOUSE, PAUSEMOUSE, READMOUSE, GETMOUSE, CLEARMOUSE, GETMOUSEMAP
%
% Cogent 2000 function.

global cogent;

error( nargchk(0,1,nargin) );

if nargin == 0
    cogent.mouse = config_device( 0, 100, 5, 'exclusive' );
elseif nargin == 1
    resolution = varargin{1};
    cogent.mouse = config_device( 1, 100, resolution, 'exclusive' );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function device = config_device( varargin )

% CONFIG_DEVICE configures Direct Input device. 
%	Called by CONFIG_KEYBOARD and CONFIG_MOUSE.

global cogent;


% Check number of arguments
if nargin > 4
   error( 'wrong number of arguments' );
end

device.polling_flag = default_arg( 1,   varargin, 1 );
device.queuelength  = default_arg( 100, varargin, 2 );
device.resolution   = default_arg( 5,   varargin, 3 );
device.mode         = default_arg( 'exclusive', varargin, 4 );
device.time  = [];
device.id    = [];
device.value = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function config_serial( varargin )
% CONFIG_SERIAL configures serial port
%
% Description:
%     Configure serial port. When START_COGENT is called the port is opened. When STOP_COGENT 
%     is called the port is closed.
%
% Usage:
%     CONFIG_SERIAL( port = 1, baudrate = 9600, parity = 0, stopbits = 0, bytesize = 8 )
%
% Arguments:
%      port        - COM port number (1,2,3,4,etc)
%      baudrate    - (110,300,600,1200,2400,4800,9600,14400,19200,38400,56000,57600,11520,128000,256000)
%      parity      - (0-no, 1-odd, 2-even, 3-mark, 4-space)
%      stopbits    - (0-one, 1-one and a half, 2-two)
%      bytesize    - (4 bits, 8 bits)
%
% Examples:
%    CONFIG_SERIAL                      - Open COM1 with baudrate=9600,  parity=no,  stopbits=one and bytesize=8.
%    CONFIG_SERIAL( 2 )                 - Open COM2 with baudrate=9600,  parity=no,  stopbits=one and bytesize=8.
%    CONFIG_SERIAL( 3, 56000, 1, 2, 8 ) - Open COM3 with baudrate=56000, parity=odd, stopbits=two and bytesize=8.
%
% See also:
%     CONFIG_SERIAL, READSERIALBYTES, SENDSERIALBYTES, LOGSERIALBYTES, WAITSERIALBYTE, GETSERIALBYTES
%
% Cogent 2000 function.

global cogent;

error( nargchk(0,5,nargin) );

port = default_arg( 1, varargin, 1 );
if port < 1 
   error( 'port argument must be > 0' );
end

serial.name = [ 'COM', num2str(port) ];
serial.baudrate    = default_arg( 9600, varargin, 2 );
serial.parity      = default_arg( 0,    varargin, 3 );
serial.stopbits    = default_arg( 0,    varargin, 4 );
serial.bytesize    = default_arg( 8,    varargin, 5 );
serial.value       = [];
serial.time        = [];

cogent.serial{port} = serial;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function start_cogent
% START_COGENT   Initialises Matlab for running Cogent 2000 commands.
%	Call this after devices have been configured by CONFIG_COGENT. 
%
% Modified version of Cogent 2000 function:
% Let priority to 'Normal'. Set units = pixels. Do not create buffers.


global cogent;
cgloadlib; % added 14/03/2003. EF. (see line 64 also)
cogent.version = '1.25'; % updated to v1.25 14/04/03

cogstd( 'soutstr', [ 'Cogent 2000 Version ' num2str(cogent.version) char(10) ] )
cogstd( 'svers' );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set process priority to high
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Suppressed by Ben
% cogprocess( 'version' );
% cogent.priority.class = cogprocess( 'enumpriorities' );
% cogent.priority.old = cogprocess( 'getpriority' );
% cogprocess( 'setpriority', cogent.priority.class.high );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialise parallel ports
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4-4-2002 "cogport" obsolete
% Replaced by "inportb" & outportb" which need no initialisation
%if isfield( cogent, 'lpt' )
%	cogport( 'version' );
%	cogport( 'initialise' );
%	cogent.lpt = cogport( 'getlpts' );
%end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialise log file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cogent,'log') & isfield(cogent.log,'filename')
	cogstd( 'sLogFil', cogent.log.filename );
end
cogent.log.time=0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialise display
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield( cogent, 'display' )
	
	% Clear screen to background colour
	% cgloadlib; % removed 14/03/2003. EF. This comamnd is now run unconditionally (see line 22)
	cgopen( cogent.display.res, cogent.display.nbpp, 0, cogent.display.mode );
	bg = cogent.display.bg;
	fg = cogent.display.fg;
%	cgpencol( bg(1), bg(2), bg(3) ); % Add palette mode 27-3-01
	if cogent.display.nbpp~=8
		cgpencol( bg(1), bg(2), bg(3) );
	else
		cgpencol( bg(1) );
	end
	cgrect;
	cgflip;
%	cgpencol( fg(1), fg(2), fg(3) ); % Add palette mode 27-3-01
	if cogent.display.nbpp~=8
		cgpencol( fg(1), fg(2), fg(3) );
	else
		cgpencol( fg(1) );
	end
	
	% Create offscreen buffers
	% Suppressed by Ben !!
% 	for i=1:cogent.display.number_of_buffers
% %		cgmakesprite( i, cogent.display.size(1), cogent.display.size(2), bg(1), bg(2), bg(3) ); % Add palette mode 27-3-01
% 		if cogent.display.nbpp~=8
% 			cgmakesprite( i, cogent.display.size(1), cogent.display.size(2), bg(1), bg(2), bg(3) );
% 		else
% 			cgmakesprite( i, cogent.display.size(1), cogent.display.size(2), bg(1) );
% 		end % if
% 	end % for
	
	% Setup drawing parameters
%	cgpencol( cogent.display.fg(1), cogent.display.fg(2), cogent.display.fg(3) ); % Add palette mode 27-3-01
	if cogent.display.nbpp~=8
		cgpencol( cogent.display.fg(1), cogent.display.fg(2), cogent.display.fg(3) );
	else
		cgpencol( cogent.display.fg(1) );
	end
	cgfont( cogent.display.font, cogent.display.fontsize );
	
	if isfield( cogent.display, 'scale' )
		cgscale( cogent.display.scale );
	end
	
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialise sound
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield( cogent, 'sound' )
	cogcapture( 'Version' );
	cogcapture( 'Initialise' );
	cogsound( 'Version' );
	cogsound( 'Initialise', cogent.sound.nbits, cogent.sound.frequency, cogent.sound.nchannels );
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load and initialise DirectInput if required
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cogent,'keyboard') | isfield(cogent,'mouse')
	coginput( 'Version' );
	coginput( 'Initialise' );
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialise keyboard
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield( cogent, 'keyboard' )
	hDevice = coginput( 'Create', 'keyboard', cogent.keyboard.mode, cogent.keyboard.queuelength );
	cogent.keyboard.hDevice = hDevice;
	cogent.keyboard.map = coginput( 'GetMap', hDevice );
	coginput( 'Acquire', hDevice );
	if ( cogent.keyboard.polling_flag )
		coginput( 'StartPolling', hDevice, cogent.keyboard.resolution );
	end	
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialise mouse
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield( cogent, 'mouse' )
	cogent.mouse.hDevice = coginput( 'Create', 'mouse', cogent.mouse.mode );
	cogent.mouse.map = coginput( 'GetMap', cogent.mouse.hDevice );
	coginput( 'Acquire', cogent.mouse.hDevice );
	if ( cogent.mouse.polling_flag )
		coginput( 'StartPolling', cogent.mouse.hDevice, cogent.mouse.resolution );
	end	
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialise serial
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield( cogent, 'serial' )
	cogserial( 'version' );
	for i = 1 : length(cogent.serial)
		port = cogent.serial{i};
		if ~isempty(port)
			port.hPort = cogserial( 'open', port.name );
			
			attr.Baud = port.baudrate;
			attr.Parity = port.parity;
			attr.StopBits = port.stopbits;
			attr.ByteSize = port.bytesize;
			cogserial( 'setattr', port.hPort, attr );
			cogserial( 'record', port.hPort, 1000 );
			
			cogent.serial{i} = port;
		end
	end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialise National Instruments DAQ DIO24
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if isfield( cogent, 'dio24' )
% 	cogdio24( 'version' );
% 	cogdio24( 'initialise', cogent.dio24.deviceno );
% 	for i=1:length(cogent.dio24.input)
% 		if ~isempty( cogent.dio24.input{i} )
% 			cogdio24( 'config', i, 0 );
% 			cogdio24( 'start',  i, cogent.dio24.interval, 1000 );
% 		end
% 	end
% end

% Set timer to 0
cogstd( 'sgettime', 0 );

logstring( 'COGENT START' );
