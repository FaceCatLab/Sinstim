% ISOPEN  True for open module.
%    ISOPEN XXX  is true if XXX is open (usually with the the STARTXXX or OPENXXX function).
%
%    ISOPEN GLAB  true if GLab is running (with or without display, when supported).
%
%    ISOPEN DISPLAY  true if a GLab display is open.
%
%    ISOPEN TRIAL  true between STARTTRIAL and STOPTRIAL calls.
%
%    ISOPEN('SERIALPORT',i)  true if serial port #i (COMi) is open.
%    ISOPEN SERIALPORT  returns a vector with true/false values for each possible ports.
%
%    ISOPEN('PARALLELPORT')  true if // port open.
%    ISOPEN('PARALLELPORT','OUT')  true if // port open for output.
%    ISOPEN('PARALLELPORT','IN')  true if // port open for input.
% 
%    ISOPEN EYELINK  true if Eyelink initialized. See also CHECKEYELINK.
%
%    ISOPEN PSB  true if PSB initialized. 
%
%    ISOPEN TDT  true if tdtstartblock has been called.

function b = isopen(What,varargin)

b = 0;

switch upper(What)
    case ('GLAB')
       global GLAB_IS_RUNNING
       
       b = ~isempty(GLAB_IS_RUNNING) && GLAB_IS_RUNNING;
    
    case 'DISPLAY'
        global GLAB_DISPLAY
        
        b = isfield(GLAB_DISPLAY,'isDisplay') && GLAB_DISPLAY.isDisplay;
        
    case 'TRIAL'
        global GLAB_TRIAL
        
        b = isfield(GLAB_TRIAL,'isStarted') && GLAB_TRIAL.isStarted;
        
    case {'SERIAL','SERIALPORT'}
        global GLAB_SERIALPORT
        
        if nargin > 1
            iPort = varargin{1};
            b = isfield(GLAB_SERIALPORT,'OpenPorts') && any(GLAB_SERIALPORT.OpenPorts == iPort);
        else
            b = false(1,8);
            if isfield(GLAB_SERIALPORT,'OpenPorts')
                b(GLAB_SERIALPORT.OpenPorts) = true;
            end
        end
        
    case {'PARALLEL','PARALLELPORT'}
        global GLAB_PARALLELPORT
        
        b = ~isempty(GLAB_PARALLELPORT);
        if b 
            if nargin > 1 
                Direction = varargin{1};
                iPort = 1; % <multiple ports not supported>
                b = b && strcmpi(Direction,GLAB_PARALLELPORT.Direction{iPort});
            end
        end
        
    case 'EYELINK'
        b = checkeyelink('isopen');
        
    case 'PSB'
        global GLAB_PSB
        b = ~isempty(GLAB_PSB) && GLAB_PSB.isPSB;
        
    case 'TDT'
        global GLAB_TDT
        b = ~isempty(GLAB_TDT) && GLAB_TDT.isBlockStarted;        
end

b = logical(b);