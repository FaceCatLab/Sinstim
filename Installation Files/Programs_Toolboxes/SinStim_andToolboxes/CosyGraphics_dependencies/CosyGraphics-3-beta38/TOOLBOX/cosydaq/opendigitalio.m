function DIO = opendigitalio(AdaptorName,BoardName,LinesIn,LinesOut)
% OPENDIGITALIO  Initialize a data acquisition device for digital input/output.
%    DIO = OPENDIGITALIO(AdaptorName,BoardName,LinesIn,LinesOut)
%
% Example:
%    opendigitalio('nidaq', '', 0:1, []);

global COSY_DAQ
global DIO

%% Input Args
if nargin < 4,  LinesOut = [];  end

%% General Init
% General init of daq stuffs:
if isempty(COSY_DAQ), opendaq; end
% Disp:
dispinfo(mfilename,'info',['Initializing adaptor ''' AdaptorName ''' for digital input/output...']);
% Check that adaptor is installed:
checkdaqadaptor(AdaptorName);

%% Create DIO object
id = getboardid(AdaptorName,BoardName);
DIO = digitalio('nidaq',id);

%% Add I/O lines
if ~isempty(LinesIn)
    addline(DIO,LinesIn,'in');
end
if ~isempty(LinesOut)
    addline(DIO,LinesOut,'out');
end

%% Disp
disp(' ')
% disp(DIO)

%% Export DIO object to workspace
dispinfo(mfilename,'info','Exporting Digital I/O (DIO) Object to workspace... (Just type "DIO" to get object´s infos...)');
disp(' ')
assignin('base','DIO',DIO);

%% Global Vars <TODO: review this>
COSY_DAQ.isDIO = true;
COSY_DAQ.DIO.LinesIn = LinesIn;
COSY_DAQ.DIO.LinesOut = LinesOut;
COSY_DAQ.DIO.DioObject = DIO; % <TODO: Review>