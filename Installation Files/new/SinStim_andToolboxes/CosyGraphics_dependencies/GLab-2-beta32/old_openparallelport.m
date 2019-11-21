% OPENPARALLELPORT  Open and initialize parallel port.
%    OPENPARALLELPORT OUT  if a // port exists (LPT1) and is not already open, opens it and 
%    initializes it to send data. If the port is already open, simply sets direction. 
%
%    OPENPARALLELPORT IN  opens the // port and initializes it to receive data.
%
%    OPENPARALLELPORT(PortNum <,Direction>)  opens specified // port. (See example below.)
%
%    dio = OPENPARALLELPORT(...)  returns the port's digitalio object. (See DAq toolbox help.)
%
% Examples: 
%    openparallelport out;      % opens LPT1 for output.
%    openparallelport(2,'in');  % opens LPT2 for input.
%
% See also: SENDPARALLELBYTE, CLOSEPARALLELPORT.
%
% Ben,  Nov 2007  v1.0 <
%
%       Feb 2009. v2.0

% Deprecated syntax: 
%    OPENPARALLELPORT  <Danger en cas de bricolages ==> Le port // est normalement initialisï¿½ 'in' par dï¿½faut>
%    OPENPARALLELPORT(Directions)  initializes the // port with directions given by the cell array
%    of strings Directions. This will work only if your port is line configurable. <Does it work on
%    any // port ???> <TODO: Test this.>

%_______________________________________________________________________________
%% <v2-beta9> Programmer Note: Optimization: 
% (source: http://psychtoolbox.org/wikka.php?wakka=FaqTTLTrigger)
% Cris Niell of Stryker lab found that matlab's public digitalio methods putvalue/getvalue can be 
% accelerated from ~1ms to ~20us by caching out the value of daqgetfield(dio,'uddobject'):
% 
% dio = digitalio('parallel')
% addline(dio,7,0,'out')   %pin 9
% putvalue(dio,1)          %~700 ï¿½s
% putvalue(dio.Line,1)    %~150 ï¿½s
% uddobj = daqgetfield(dio,'uddobject')
% putvalue(uddobj,1,1); %~20 ï¿½s (undocumented use demo in @dioline\putvalue.m and @digitalio\putvalue.m - args are: uddobj, vals [, lineInds])
% getvalue(uddobj,1);    %~20 ï¿½s (undocumented use demo in @dioline\getvalue.m and @digitalio\getvalue.m - args are: uddo
% <ben: Don't understand last input arg. Is not necessary.>

% Optimization level:
%                                                            6.5 (AthlonX2)  7.5 (AthlonX2)
% 0:   putvalue(getparallelport,value); <v2-beta8>             305 µs          1950 µs
% 0.5: putvalue(dio,value)                                     190 µs           425 µs
% 1:   putvalue(dio.Line,value)                                375 µs          1305 µs
% 1.5: putvalue(Line,value)                                    253 µs           470 µs
% 2:   putvalue(uddobj,value)                                  crash!           245 µs
%
% Conclusion: Best choices are:
% - Matlab 6.5:  GLAB_PARALLELPORT.OptimizationLevel = 0.5;
% - Matlab 7.5:  GLAB_PARALLELPORT.OptimizationLevel = 2;
%ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½

function dio = openparallelport(varargin)

%% Check OS
if ~ispc
    if IsOSX, wrn = 'There is no parallel port on a Mac.  Calls to the // port will simply be ignored.';
    else      wrn = 'MATLAB supports the parallel port only on MS-Windows.  Calls to the // port will simply be ignored.';
    end
    dispinfo(mfilename,'warning',wrn);
    warning('Cannot open parallel port.')
    return % <---!!!
end

%% Global Vars
global GLAB_PARALLELPORT
try GLAB_PARALLELPORT.PortNum; catch GLAB_PARALLELPORT.PortNum = []; end
try GLAB_PARALLELPORT.PortObject; catch GLAB_PARALLELPORT.PortObject = {}; end

%% Input Args
PortNum = 1;
Direction = 'out';
if nargin >= 1
    if isnumeric(varargin{1}), PortNum = varargin{1}; end
    if ~isnumeric(varargin{end}), Direction = varargin{end}; end
end
% if ischar(Direction), Direction = repmat({Direction},1,8); end  % <suppr.: // port not line configurable.>
PortName = ['LPT' int2str(PortNum)];

%% Check already open port
iPort = find(GLAB_PARALLELPORT.PortNum == PortNum);

if iPort % Port already open..
%     [dio,s] = getparallelport(PortNum);
    setparallelport(PortNum,Direction);
end

%% Open Port
if isempty(iPort) % Port not yet open, or just closed because directions change..
    iPort = length(GLAB_PARALLELPORT.PortNum) + 1;

    disp(' ')
    dispinfo(mfilename,'INFO',['Opening parallel port for ' Direction 'put.'])
    try
        dio = digitalio('parallel',PortName);
    catch
        GLAB_PARALLELPORT = []; % <v2-beta9, TODO: check this !!!>
        warning('Cannot open parallel port. (Probably your computer doesn''t have one, or the port is used by another program.)')
        return % <===!!!
    end
    addline(dio,0:7,Direction);
    try sendparallelbyte(0); end % Set lines status to 0 and define GLAB_PARALLELPORT.CurrentByte.
    GLAB_PARALLELPORT.PortNum(iPort) = PortNum;
    GLAB_PARALLELPORT.Direction{iPort} = lower(Direction);
    GLAB_PARALLELPORT.PortObject{iPort} = dio;
    GLAB_PARALLELPORT.PortLine{iPort} = dio.Line;
    v = version;
    try % Matlab 7.5
        GLAB_PARALLELPORT.PortUddObject{iPort} = daqgetfield(dio,'uddobject'); % For optim. purpose, see "Programmer Note" above
        GLAB_PARALLELPORT.OptimizationLevel = 2;
    catch % Matlab 6.5
        GLAB_PARALLELPORT.OptimizationLevel = 0.5;
    end
end