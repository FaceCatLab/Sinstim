% function [SPIKES, INFO] = TDTgetNeuralData (saveFile, currentTank, currentBlock, currentChannel)
% extracts data from last recorded block on TDT server
% saves structures INFO (general information) and SPIKES (array of structures with data)
% inputs: saveFile is file name to save (required)
%         currentTank is the path of the current tank on the disk (recommended)
%         currentBlock is the name of the block to analyze (recommended)
%         currentChannel is the channel number to analyze (optional; defaults to chan 1)
%
% TDT says: This is a sample bit of matlab code for accessing data in a Tank
% and displaying it on a couple of plots.  Most calls return 1
% if they are successful else they return 0.  If a variant is returned
% then a -1 means Empty variant or a NULL return.
% for additional documentation on commands see the OpenDeveloper reference manual.
% Formerly Example1.m
% Modified to run within experiment control suite and save data to file JBB 12-2009, 01-2010

function [SPIKES, INFO] = TDTgetNeuralData (saveFile, currentTank, currentBlock, currentChannel)

persistent TTx		% wrapper for ActiveX code
currentServer = 'INCITATUS';	% I recommend hard-coding this since it should basically never change.

DEBUG = 0;			% if enabled, makes some test plots

% argument handling
if nargin < 4,
    help TDTgetNeuralData;
    error('Not enough arguments!!');
end
if isempty(saveFile),
	help TDTgetNeuralData; return
end
if isempty(currentTank),
% 	currentTank = 'D:\jbadler\TDT\TTankInterfacesExample\bentest';
	currentTank = 'C:\TDT\OpenEx\Tanks\bentest';
fprintf('No tank specified. Using default tank %s.\n', currentTank);
end
% there is also the question of Tank management (how often to change?)

% NOTE: handle empty block case later.
if isempty(currentChannel),
	currentChannel = 1;
	fprintf('No channel specified. Using default channel %d.\n', currentChannel);
end
% right now only one channel is recorded from.  Adding additional channels makes LFP, EEG data complicated.


% list of events to extract from data
% Code is 4-char TDT name; Name is what will be stored in extracted data file
% DO NOT EVER CHANGE OR REMOVE 'TrSc' / 'TrialOnset' UNLESS YOU ARE A MASOCHIST AND WANT TO REWRITE LOTS OF CODE.
% ALSO NOTE: these names are mostly hard-coded later in the function, so this part is less flexible than it looks.
eventScalarCodes = {'Tick', 'TrSc', 'TrEd', 'FrSc', 'Targ'};
eventScalarNames = {'Clock', 'TrialOnset', 'TrialEnd', 'FrameSync', 'TargetOnset'};

eventVectorCodes = {'pNeu', 'EEGx'};
eventVectorNames = {'LFP', 'EEG'};

eventSnipCode = 'eNeu';				% 'Snippets' are high-speed snapshots of individual spike events

eventEyeCode = 'EXY1';				% eye movement data also handled specially.
eventEyeName = 'Eye';

if isempty(TTx) || ~ishandle(TTx),
	% First instantiate a variable for the ActiveX wrapper interface
	% and take care of the silly (but apparently critical) null figure it creates.
	figure(26696);
	TTx = actxcontrol('TTank.X', 'position', [0 0 20 20], 'parent', 26696);
	set(26696, 'Visible', 'off', 'HandleVisibility', 'off', 'CloseRequestFcn', 'clear global TTx; closereq');
	% note: clear doesn't see to work on persistent variables but handle check should obviate the need for that
end

% Then connect to a server.
TTx.ConnectServer(currentServer, 'Me');

% Now open a tank for reading.
TTx.OpenTank(currentTank, 'R');
tic
if isempty(currentBlock),
	returnString = 'dummy';
	b = -1;
	while ~isempty(returnString),
		b = b + 1;
		returnString = TTx.QueryBlockName(b);
	end
	currentBlock = TTx.QueryBlockName(b-1);
	fprintf('No block specified. Using default, last recorded block %s.\n', currentBlock);
else
	fprintf('Current Block = ''%s''\n', currentBlock);
end
t = toc;
fprintf('Block detection took %.0f ms.  Create a new tank if this is too long.\n', 1000*t);

% Select the block to access
TTx.SelectBlock(currentBlock);

% Get all of the Snips across all time for current channel
% after this call they are stored locally within the ActiveX
% wrapper code.  nSnips will equal the number of events read.
% long ReadEventsV (long MaxRet, str TankCode, long Channel, long SortCode, double T1, double T2, str Options)
nSnips = TTx.ReadEventsV(10000, eventSnipCode, currentChannel, 0, 0.0, 0.0, 'ALL');
fprintf('Read %d spike snippets.\n', nSnips);

% ALTERNATE COMMAND FORM
% TTx.SetGlobalV('Channel', currentChannel);		% set the channel
% Nsnips = TTx.ReadEventsSimple(eventSnipCode);		% read the data

% To parse out elements of the returned data use the
% ParseEvV and ParseEvInfoV calls as follows.

% To get all waveform data for all the events read just call
% the first 0 is the index offset into the list returned above
% the second arg is the number you would like parsed out and returned
% variant ParseEvV (long RecIndex, long nRecs)
spikeWaveforms = TTx.ParseEvV(0, nSnips)';

% To get other information about the record events returned call
% ParseEvInfoV.  This call has the same two parameters as ParseEvV
% with one more param to indicate which bit of information you
% want returned.  The following are valid values for the 3rd 
% parameter:
%   1  = Amount of waveform data in bytes
%   2  = Record Type (see TCommon.h)
%   3  = Event Code Value
%   4  = Channel No.
%   5  = Sorting No.
%   6  = Time Stamp
%   7  = Scalar Value (only valid if no data is attached)
%   8  = Data format code (see TCommon.h)
%   9  = Data sample rate in Hz. (not value unless data is attached)
%   10 = Not used returns 0.
%   0  = Returns all values above
spikeChannels = TTx.ParseEvInfoV(0, nSnips, 4)';
spikeSortCodes = TTx.ParseEvInfoV(0, nSnips, 5)';
spikeTimeStamps = TTx.ParseEvInfoV(0, nSnips, 6)';
spikeSampleRate = TTx.ParseEvInfoV(0, nSnips, 9)';

% Create a subplot of both displays
if DEBUG,
	figure(87);
	colorList = {'b', 'g', 'r', 'c', 'm'};
	subplot(2,1,1); hold on;
	allSortCodes = unique(spikeSortCodes);
	for c = 1:length(allSortCodes),
		whichWaves = (spikeSortCodes == allSortCodes(c));
		plot(spikeWaveforms(whichWaves, :)', 'color', colorList{mod(c-1, 5)+1});
	end
	hold off;
	ylabel('spike waveforms');
	subplot(2,1,2); hist(spikeTimeStamps, 30);
	ylabel('spike times (entire block)');
end

% Get all of the scalar events across all time (keep channel code = 0)
for c = 1:length(eventScalarCodes),
	N = TTx.ReadEventsV(10000, eventScalarCodes{c}, 0, 0, 0.0, 0.0, 'ALL');
% 	N = TTx.ReadEventsSimple(eventScalarCodes{c});
	fprintf('Read %d incidences of event %s.\n', N, eventScalarNames{c});
	eval( sprintf('%s = TTx.ParseEvInfoV(0, N, 6)'';', eventScalarNames{c}) );	% save timestamps
end

nTrials = length(TrialOnset);	% you didn't mess with this particular event, did you?

% read vector data (LFP, EEG)
for c = 1:length(eventVectorCodes),
	N = TTx.ReadEventsV(10000, eventVectorCodes{c}, currentChannel, 0, 0.0, 0.0, 'ALL');
	fprintf('Read %d incidences of event %s.\n', N, eventVectorNames{c});
	matrixData = TTx.ParseEvV(0, N);					% raw data (matrix form)
	originalTime = TTx.ParseEvInfoV(0, N, 6)';			% original time scale

	eval( sprintf('%sData = matrixData;', eventVectorNames{c}) );	% rename
	eval( sprintf('%sOriginalTime = originalTime;', eventVectorNames{c}) );
end

% A note on time interpolation: fast method used, simply interpolated between first and last time values.
% Tests indicate fast method is accurate to within 2 msec.
% test = intersect(round(expandedTime*500), round(originalTime*500)); size(test)
% should have the same number of points as the original time scale.
% (Very) slow method would be to interpolate for each time pair on the original time scale.
% Original scale is saved, so users are welcome to do their own hyper-accurate expansion.
% SUPPLEMENTARY NOTE: time expansion is now done below for each trial, so somewhat more precise.

% read eye movement data, with special handling.
N = TTx.ReadEventsV(10000, eventEyeCode, 0, 0, 0.0, 0.0, 'ALL');		% read all channels
fprintf('Read %d incidences of event %s.\n', N, eventEyeCode);
matrixData = TTx.ParseEvV(0, N); totalSamples = numel(matrixData);
chanKey = TTx.ParseEvInfoV(0, N, 4)';
originalTime = TTx.ParseEvInfoV(0, N, 6)';

eval( sprintf('%sXData = matrixData(:, chanKey == 1);', eventEyeName) );
eval( sprintf('%sYData = matrixData(:, chanKey == 2);', eventEyeName) );
eval( sprintf('%sOriginalTime = originalTime(chanKey == 1);', eventEyeName) );	% chans should be identical...


%% finished data extraction; now divide into trials
fieldList = {
	'spikeTimeStamps'
	'spikeSortCodes'
	'spikeChannels'
	'spikeWaveforms'
	'spikeSampleRate'
	'LFPOriginalTime'
	'LFPExpandedTime'
	'LFPData'
	'EEGOriginalTime'
	'EEGExpandedTime'
	'EEGData'
	'EyeOriginalTime'
	'EyeExpandedTime'
	'EyeXData'
	'EyeYData'
};
fieldList = [eventScalarNames'; fieldList];

SPIKES = cell2struct( cell(1, nTrials), 'dummy', 1);

%%%trialSync = [trialSync, Inf];	% temporarily add time bound to end - CAN USE THIS STRATEGY IF END SIGNAL FAILS.
for t = 1:nTrials,
	trStart = TrialOnset(t); trEnd = TrialEnd(t);

	% get simple time markers
	SPIKES(t).Clock = Clock(Clock > trStart & Clock < trEnd);								% absolute time
	SPIKES(t).TrialOnset = trStart;															% absolute time
	SPIKES(t).TrialEnd = trEnd;																% absolute time
	SPIKES(t).FrameSync = FrameSync(FrameSync > trStart & FrameSync < trEnd) - trStart;		% relative time
	SPIKES(t).TargetOnset = TargetOnset(TargetOnset > trStart & TargetOnset < trEnd) - trStart;

	% get spike events: time stamps, info and waveforms
	flagged = spikeTimeStamps > trStart & spikeTimeStamps < trEnd;
	SPIKES(t).spikeTimeStamps = spikeTimeStamps(flagged) - trStart;
	SPIKES(t).spikeSortCodes = spikeSortCodes(flagged);
	SPIKES(t).spikeChannels = spikeChannels(flagged);
	SPIKES(t).spikeWaveforms = spikeWaveforms(flagged, :);
	SPIKES(t).spikeSampleRate = spikeSampleRate(flagged);

	% get LFP time scale and data
	flagged = LFPOriginalTime > trStart & LFPOriginalTime < trEnd;
	firstFlagged = find(flagged, 1);			% extend time window to first "sample" before trial onset
	if firstFlagged > 1, flagged(firstFlagged-1) = 1; end
	totalSamples = sum(flagged) * size(LFPData, 1);
	deltaTime = mean(diff(LFPOriginalTime(flagged)));
	SPIKES(t).LFPOriginalTime = LFPOriginalTime(flagged);						% absolute time
	SPIKES(t).LFPExpandedTime = linspace(	SPIKES(t).LFPOriginalTime(1), ...	% relative time
										SPIKES(t).LFPOriginalTime(end) + deltaTime, totalSamples )' - trStart;
	SPIKES(t).LFPData = reshape(LFPData(:, flagged), totalSamples, 1);			% transform to vector

	% get EEG time scale and data
	flagged = EEGOriginalTime > trStart & EEGOriginalTime < trEnd;
	firstFlagged = find(flagged, 1);			% extend time window to first "sample" before trial onset
	if firstFlagged > 1, flagged(firstFlagged-1) = 1; end
	totalSamples = sum(flagged) * size(EEGData, 1);
	deltaTime = mean(diff(EEGOriginalTime(flagged)));
	SPIKES(t).EEGOriginalTime = EEGOriginalTime(flagged);						% absolute time
	SPIKES(t).EEGExpandedTime = linspace(	SPIKES(t).EEGOriginalTime(1), ...	% relative time
										SPIKES(t).EEGOriginalTime(end) + deltaTime, totalSamples )' - trStart;
	SPIKES(t).EEGData = reshape(EEGData(:, flagged), totalSamples, 1);			% transform to vector


	% get eye movement time scale and data
	flagged = EyeOriginalTime > trStart & EyeOriginalTime < trEnd;
	firstFlagged = find(flagged, 1);			% extend time window to first "sample" before trial onset
	if firstFlagged > 1, flagged(firstFlagged-1) = 1; end
	totalSamples = sum(flagged) * size(EyeXData, 1);
	deltaTime = mean(diff(EyeOriginalTime(flagged)));
	SPIKES(t).EyeOriginalTime = EyeOriginalTime(flagged);						% absolute time
	SPIKES(t).EyeExpandedTime = linspace(	SPIKES(t).EyeOriginalTime(1), ...	% relative time
										SPIKES(t).EyeOriginalTime(end) + deltaTime, totalSamples )' - trStart;
	SPIKES(t).EyeXData = reshape(EyeXData(:, flagged), totalSamples, 1);		% transform to vector
	SPIKES(t).EyeYData = reshape(EyeYData(:, flagged), totalSamples, 1);		% transform to vector

	if DEBUG,
		figure(t); clf;
		subplot(3,1,1);
		plot(SPIKES(t).LFPExpandedTime, SPIKES(t).LFPData);
		ylabel('LFP');
		subplot(3,1,2);
		plot(SPIKES(t).EEGExpandedTime, SPIKES(t).EEGData);
		ylabel('EEG');
		subplot(3,1,3);
		plot(	SPIKES(t).EyeExpandedTime, SPIKES(t).EyeXData, 'b', ...
				SPIKES(t).EyeExpandedTime, SPIKES(t).EyeXData, 'r');
		ylabel('Eye X and Y');
	end

end
SPIKES = rmfield(SPIKES, 'dummy');

% also return general info structure
INFO = struct(	'currentServer', currentServer, ...
				'currentTank', currentTank, ...
				'currentBlock', currentBlock, ...
				'currentChannel', currentChannel);

% SAVE OUTSIDE FUNCTION!
% save(saveFile, 'SPIKES', 'INFO');
% fprintf('Saved file %s.\n', saveFile);

% Close the tank when you're done
TTx.CloseTank

% Disconnect from the tank server
TTx.ReleaseServer
