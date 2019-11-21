function AI = openanaloginput(AdaptorName,BoardName,Channels,SampleRate,MaxDurationSec)
% OPENANALOGINPUT  Initialize a data acquisition device for analog input.
%    AI = OPENANALOGINPUT(AdaptorName,BoardName,Channels,SampleRate,MaxDurationSec)
%
%    Input:
%       AdaptorName    - The name of the daq adaptor. See below for the list of supported adaptors.
%       BoardName      - Leave it empty. Only usefull if you have more than one board of the same vendor.
%       Channels       - Channels numbers. On a daq board channels are numbered from 0 (AI0),
%                        on 'winsound', available channels are 1 and 2.
%       SampleRate     - In Hz.
%       MaxDurationSec - This is CRITICAL !!! It's the recording duration, in seconds. It will also
%                        serve to optimize the size of the block of samples if the acquisition buffer. 
%                        All calls to peekdata() (accessing recorded data on-line) will have a variable 
%                        latency of up to half this parameter in milliseconds !!! Example, 20 sec of
%                        max record duration gives you a variable latency of 0 to 10 msec when accessing
%                        data during your experiment ! (If you don't need to access data on-line, you
%                        don't need to worry. Just put any high value.)
%    Output:
%       AI             - Analog Input object (Daq Toolbox object). This object is global, you can 
%                        access it from anywhere with "global AI".
%
% Supported adaptors are:
%       'nidaq'         National Instrument
%       'mcc'           Measurement Computing
%       'keithley'      Keithley
%       'advantech'     Advantech
%       'hpe1432'       Agilent Technologies
%       'winsound'      Windows sound system: Can be used as a 2-channel analog board with the following 
%                       particularities: Sample freq. from 8kHz to 96kHz. High-pass filter at 20Hz.
%       'parallel'      Standard parallel port. Don't use exept for testing. Use the CosyParallelPort 
%                       module, which is more user-friendly and fixes performance issue of the Daq Toolbox.
%                       Note also that only standard parallel (i.e.: // port on the mother board) is 
%                       supported. PCI/PCI-Express ports are not supported.
%
% Example 1: Use OPENANALOGINPUT to init, and let STARTTRIAL and STOPTRIAL. (The easier.)
%       AI = openanaloginput('nidaq', '', 0:1, 1000, 20);
%       ...
%       for tr = 1 : NbOfTrials  % Loop once per trial..
%           starttrial; % AI object is started (running and waiting for trigger), but not yet triggered.
%           ...
%           displaybuffer; % First call to DISPLAYBUFFER during trial: AI will be triggered at first frame onset.
%           ...
%           D = peekdata(AI,AI.SamplesAvalaible); % PEEKDATA : get data during recording. (Daq Toolbox function)
%           ...
%           stopttrial; % Stops AI object.
%           D = getdata(AI); % GETDATA : get data after recording. (Daq Toolbox function)
%       end
%
% Example 2: Use it independently from STARTTRIAL and STOPTRIAL. 
%       AI = openanaloginput('nidaq', '', 0:1, 1000, 20);
%       ...
%       start(AI);   % Fills it´s temporary buffer and stay ready to start logging data. 10 msec to execute. (Daq Toolbox function) 
%       ...
%       trigger(AI); % Starts actual logging of data. 200 microseconds to execute. (Daq Toolbox function) 
%       ...
%       D = peekdata(AI,AI.SamplesAvalaible); % PEEKDATA : get data during recording. (Daq Toolbox function) 
%       ...
%       stop(AI); % Stop object. (Daq Toolbox function) 
%       D = getdata(AI); % GETDATA : get data after recording. (Daq Toolbox function)
%       closeanaloinput;
%
% Example 3: Use sound card.
%       AI = openanaloginput('winsound', '', [1 2], 8000, 20); % Channels are 1 and 2 (not 0 and 1), min sample freq is 8000Hz.
%
%
% Related Daq Toolbox functions:
%    See also: analoginput, start, trigger.
%
% Related CosyGraphics functions:
%    See also: OPENDAQ, STARTTRIAL, STOPTRIAL, CLOSEANALOGINPUT, OPENANALOGJOYSTICK, OPENDIGITALIO.
%
%
% Ben.J., Oct 2012.


global COSY_DAQ
global AI


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MaxNumBlocks = 2000; % Seems that max value is hardcoded to 2000. Tested on winsound and on a NI USB-6008.
InputRange = [-5 5];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Close previous AI
if isfield(COSY_DAQ,'isAI') && COSY_DAQ.isAI
    dispinfo(mfilename,'info','Previous Analog Input session not closed. First closing it...')
    try 
        closeanaloginput; % Close existing Ai if any.
    catch
    end
end

%% General Init
% General init of daq stuffs:
if isempty(COSY_DAQ), opendaq; end

% Disp:
dispinfo(mfilename,'info',['Initializing adaptor ''' AdaptorName ''' for analog input data aquisition...']);

% Check that adaptor is installed:
checkdaqadaptor(AdaptorName);

%% Create AI Object
id = getboardid(AdaptorName,BoardName);
AI = analoginput(AdaptorName,id);

%% Add Channels & Config AI
chans = addchannel(AI,Channels);
if ~strcmpi(AdaptorName,'winsound') % For sound cards, InputRange is -1 to 1 and connot be changed.
    for i = 1 : length(Channels)
        chans(i).InputRange  = InputRange;
        chans(i).SensorRange = InputRange;
        chans(i).UnitsRange  = InputRange;
    end
end
AI.TriggerRepeat = 0; % Trig repetion do not semm to work!! <TODO: 0 or inf ???>
AI.TriggerType = 'Manual'; % 'Manual': start object with start(AI); trigger(AI);
AI.SampleRate = SampleRate;
NumBlocks = MaxNumBlocks; % No interest to use less.
BlockSize = ceil((MaxDurationSec * SampleRate) / NumBlocks);
if isfinite(MaxDurationSec)  % Predefined record duration..
    AI.BufferingConfig = [BlockSize NumBlocks];
    AI.SamplesPerTrigger = BlockSize * NumBlocks;
    dispinfo(mfilename,'info','Buffering config.:');
    line1 = sprintf('%d blocks of %d bytes per channel.', NumBlocks, BlockSize);
    line2 = sprintf('Max %d sec of recording.', round(NumBlocks*BlockSize/SampleRate));
    line3 = sprintf('!!! --- Peekdata latency: 0 to %d msec. --- !!!', round(BlockSize*1000/SampleRate));
    dispbox({line1,line2,line3}, 21, 3, 1);
else                         % Continouous mode..
    AI.SamplesPerTrigger = inf;
    dispinfo(mfilename,'WARNING','Buffering config.:');
    line1 = '!!! --- LATENCY UNRELIABLE --- !!!';
    line2 = 'Continuous recording mode. You can access data during recording with peekdata()';
    line3 = 'as usual, but the latency is unpredictable. (It can be hundreds of milliseconds!)';
    line4 = 'If you just want to collect data AFTER recording, with getdata(), there is no problem.';
    dispbox({line1,line2,line3,line4}, 23, 3, 1);
end

%% Disp
disp(' ')
% disp(AI)

%% Export AI object to workspace
dispinfo(mfilename,'info','Exporting Analog Input (AI) Object to workspace... (Just type "AI" to get object´s infos...)');
disp(' ')
assignin('base','AI',AI);
% workspaceexport

%% Global Vars <TODO: review this>
COSY_DAQ.isAI = true;
COSY_DAQ.AI.AdaptorObject = daqhwinfo(AdaptorName);
COSY_DAQ.AI.AiObject = AI; % <TODO: Remove??? AI is already a global object!>
COSY_DAQ.AI.ChannelsObjects = chans;
COSY_DAQ.AI.BoardID = id;
COSY_DAQ.AI.BlockSize = BlockSize;

%% Continuous recording: Start recording immediately
if ~isfinite(MaxDurationSec)
    start(AI);
    wait(30);
    trigger(AI);
end
