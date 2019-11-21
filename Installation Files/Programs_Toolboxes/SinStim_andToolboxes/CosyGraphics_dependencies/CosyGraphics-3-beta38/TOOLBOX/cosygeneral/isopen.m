function b = isopen(What,varargin)
% ISOPEN  True for open module.
%    ISOPEN XXX  is true if module XXX is open (usually with an STARTXXX or OPENXXX function).
%
%    ISOPEN COSYGRAPHICS  true if CosyGraphics is running (with or without display, when supported).
%
%    ISOPEN DISPLAY  true if a CosyGraphics display is open.
%
%    ISOPEN FULLSCREEN  true if a CosyGraphics display is open in full screen. <v3-beta36>
%
%    ISOPEN TRIAL  true between STARTTRIAL and STOPTRIAL calls.
%
%    ISOPEN SOUND  true if sound card has been initialized with OPENSOUND.
%
%    ISOPEN KEYBOARD  true if CosyGraphics' keyboard module is initialised.
%
%    ISOPEN('SERIALPORT',i)  true if serial port #i (COMi) is open.
%    ISOPEN SERIALPORT  returns a vector with true/false values for each possible ports.
%
%    ISOPEN('PARALLELPORT')  true if // port open.
%    ISOPEN('PARALLELPORT','OUT')  true if // port open for output.
%    ISOPEN('PARALLELPORT','IN')  true if // port open for input.
%
%    ISOPEN ANALOGINPUT  true if an analog input SESSION has been opened trough OPENANALOGINPUT.
% 
%    ISOPEN EYELINK  true if Eyelink initialized. See also CHECKEYELINK.
%
%    ISOPEN PSB  true if PSB initialized. 
%
%    ISOPEN TDT  true if tdtstartblock has been called.

global COSY_GENERAL COSY_DISPLAY COSY_TRIALLOG COSY_KEYBOARD COSY_SOUND COSY_SERIALPORT COSY_PARALLELPORT COSY_DAQ COSY_PSB COSY_TDT

b = 0;

switch upper(What)
    case {'GLAB','COSYGRAPHICS','COSYGRAPHIX'}
       b = ~isempty(COSY_GENERAL) && isfield(COSY_GENERAL,'isStarted') && COSY_GENERAL.isStarted;
               
    case 'TRIAL'
        b = isfield(COSY_TRIALLOG,'isStarted') && COSY_TRIALLOG.isStarted;    
        
    case 'DISPLAY'
        b = isfield(COSY_DISPLAY,'isDisplay') && COSY_DISPLAY.isDisplay;
        if b && isptb
            if isempty(Screen('Windows'))
                b = false;
                COSY_DISPLAY.isDisplay = false;
            end
        end
        
    case 'FULLSCREEN'
        b = isfield(COSY_DISPLAY,'isDisplay') && COSY_DISPLAY.isDisplay;
        if b && isptb
            if isempty(Screen('Windows'))
                b = false;
                COSY_DISPLAY.isDisplay = false;
            end
        end
        if b, b = COSY_DISPLAY.Screen > 0; end
        
    case 'SOUND'
        b = isfield(COSY_SOUND,'isOpen') && COSY_SOUND.isOpen;
        
    case 'KEYBOARD'
        b = isfield(COSY_KEYBOARD,'isOpen') && COSY_KEYBOARD.isOpen;
        
    case {'SERIAL','SERIALPORT'}
        if nargin > 1
            iPort = varargin{1};
            b = isfield(COSY_SERIALPORT,'OpenPorts') && any(COSY_SERIALPORT.OpenPorts == iPort);
        else
            b = false(1,8);
            if isfield(COSY_SERIALPORT,'OpenPorts')
                b(COSY_SERIALPORT.OpenPorts) = true;
            end
        end
        
    case {'PARALLEL','PARALLELPORT'}
        b = ~isempty(COSY_PARALLELPORT);
        if b 
            if nargin > 1 
                Direction = varargin{1};
                iPort = 1; % <multiple ports not supported>
                b = b && strcmpi(Direction,COSY_PARALLELPORT.Direction{iPort});
            end
        end
        
    case 'ANALOGINPUT' % <v3-beta25>
        b = false;
        if isfield(COSY_DAQ,'isAI'), b = COSY_DAQ.isAI; end
        
    case 'EYELINK'
        b = checkeyelink('isopen');
        
    case 'PSB'
        b = ~isempty(COSY_PSB) && COSY_PSB.isPSB;
        
    case 'TDT'
        b = ~isempty(COSY_TDT) && COSY_TDT.isBlockStarted; 
        
    otherwise
        error(['Invalid argument. Unknown module: ''' What ''''])
        
end

b = logical(b);