function openpsb(SerialPort,nBlankingLines)
% OPENPSB  Initialize Benoit Gerard's "Psychophysics Synchronisation Box".
%    OPENPSB(SerialPortName)    e.g.: openpsb COM5
%
%    OPENPSB(SerialPortNumber)  e.g.: openpsb(5)  does the same as above.
%
%    OPENPSB(SerialPortName|SerialPortNumber,nBlankingLines) <will be deprecated in next version>

global COSY_PSB

%% Check
if ~isopen('cosygraphics')
    error('CosyGraphics not started.')
elseif isopen('PSB')
    dispinfo(mfilename, 'warning', 'PSB already open.')
    return % <===!!!
end

%% Input Arg
if ischar(SerialPort) && length(SerialPort) > 3 && strcmpi(SerialPort(1:3),'COM') % openpsb('COM#')
    SerialPortName   = upper(SerialPort);
    SerialPortNumber = str2num(SerialPort(4:end));
elseif isnumeric(SerialPort) % openpsb(#)
    SerialPortNumber = SerialPort;
    SerialPortName   = ['COM' SerialPort];
else
    error('Invalid argument.');
end
if ~nargin < 2 % <TODO: Rewrite this in next version>
    nBlankingLines = 50; % 50 is ok on both 800x600 and 1024x768 on NEFY std PCs. nb: PSB's default is also 50.
end

%% Disp info
msg = sprintf('Initializing connection with PSB (Psychophysics Synchronization Box) on COM%d...', SerialPortNumber);
dispinfo(mfilename, 'info', msg)

%% Matlab Version
v = version;
v = v(1);
if v > '7'
    dispinfo(mfilename,'warning','Not the best MATLAB version. It''s better to use the PSB with Matlab 6.5.')
end

%% Close PSB if already open
% if isopen('PSB'), closepsb; end  % <suppressed because it causes crashes>

%% Global vars
COSY_PSB.isPSB = 0;
COSY_PSB.nBlankingLines = nBlankingLines;
COSY_PSB.SerialPortNumber = SerialPortNumber;
COSY_PSB.SerialPortName   = SerialPortName;
if isfilledfield(COSY_PSB,'SerialPortObject'), COSY_PSB.SerialPortObject = []; end

%% Open link
try
    if     v <= '6'
        openserialport(SerialPortNumber,115200); % <crashes on Matlab 7.5>
    elseif v >= '7'
        if ~isempty(COSY_PSB.SerialPortObject) % If port has been already open..
            fclose(COSY_PSB.SerialPortObject); % ..close it
            COSY_PSB.SerialPortObject = [];    % ..and delete object
        end
        port = serial(SerialPortName,'baudrate',115200); % Open communication with PSB
        fopen(port);
        COSY_PSB.SerialPortObject = port;
    end
    COSY_PSB.isPSB = 1;
catch 
    disp(lasterr)
    str = 'Cannot open PSB.';
    if iscog && v <= '6', error(str) % openserialport closes Cogent window if port not found: use PTB!
    else                  warning(str)
    end
end

%% Set end blanking area
if COSY_PSB.isPSB
    % Command #1: End red blanking area
    n = int2str(nBlankingLines);
    cmd1 = '!#RB0000x$';
    cmd1(9-length(n):8) = n;
    % Command #2: Init keyboard
    cmd2 = '!#KIxxxxx$';
    % Send commands:
    psb_sendserialcommand(cmd1);
    psb_sendserialcommand(cmd2);
end
if 0 % eval the following line in command window for testing:
    psb_sendserialcommand('!#RB0100x$'); 
end

%% Init "photodiode"
% We'll use the photodiode "square" (transformed in a rectangle for the occasion) as the "red" 
% signal (actually it's white, but we are only intersted by the red component) in the blanking area.
openphotodiode([1 0; 0 0],[200 1]);
setphotodiodevalue(0); % arm target sync is off by default

%% Disp info
if COSY_PSB.isPSB
    dispinfo(mfilename,'info','PSB ready.')
end