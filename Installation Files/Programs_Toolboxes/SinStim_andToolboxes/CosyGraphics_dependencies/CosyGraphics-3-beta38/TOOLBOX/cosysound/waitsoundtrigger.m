function [tTriggerEstimate, tFromRecordStart, AudioData] = waitsoundtrigger(varargin)
% WAITSOUNDTRIGGER  Wait until audio input reaches a threshold.  <to be finished>
%    WAITSOUNDTRIGGER(Threshold, Timeout, Channel)
%
%    [tTriggerEstimate, tFromRecordStart, AudioData] = WAITSOUNDTRIGGER(Threshold, Timeout, Channel)
%    <TODO: Fix tTriggerEstimate: bug because returned tRecordStart = 0 (on DeVolder Z400 Creative sound card)
%     => Compute time frome the end ??>
%
%    WAITSOUNDTRIGGER(...,'-v')  Verbose mode: prints infos in command window.
%
%    WAITSOUNDTRIGGER(...,'-plot')  plots captured sound data. Usefull for debug (setting
%    threshold, etc.)


%¨<TODO: 
%  tTriggerEstimate: compute from beginning (tRecordStart) or from end ???
% >


global COSY_SOUND

%% t0
tFunctionStart = time;

%% Global Var
Freq = COSY_SOUND.SampleFrequency;
pahandle = COSY_SOUND.PTB.pahandle;


%% Check sound is open
if ~isopen('sound')
    msg = 'Sound not initialized, recording not started.  See OPENSOUND, STARTSOUND.';
    error(msg)
elseif iscog('Sound')
    error([upper(mfilename) ': Not yet implemented over Cogent. Sorry. Please use PSB (see STARPSYCH).'])
end


%% Get previously recorded audio data  <must be done as quickly as possible>
% Trigger will not be searched in previousely collected data.
% <May be usefull when there is an electrical artefact at record beginning.>
[AudioData, offset, overflow, tRecordStart_sec] = PsychPortAudio('GetAudioData', pahandle);
tRecordStart = tRecordStart_sec * 1000;  % s -> ms
PreviousRecordingDuration = size(AudioData,2) * 1000 / Freq;


%% Input Vars
% Defaults:
Threshold = 0.15;  % <Good value for Christian Hendrick's button.>
Timeout = inf;
Channel = 1;
isVerbose = 0;
doPlot = 0;

% Inputs replace defaults:
% - Options:
iOpt = findoptions(varargin);
if ~isempty(iOpt)
    for i = iOpt
        switch lower(varargin{i})
            case '-v',      isVerbose = 1;
            case '-plot',   doPlot = 1;
            otherwise       error(['Unknown option: ' varargin{iOpt}])
        end
    end
    varargin(iOpt) = [];
end
% - Regular args:
if length(varargin) >= 1
    Threshold = varargin{1};
end
if length(varargin) >= 2
    Timeout = varargin{2};
end
if length(varargin) >= 3
    Channel = varargin{3};
end


%% Wait trigger
if isVerbose
    fprintf('WAITSOUNDTRIGGER-info: Waiting trigger... ')
end

% Wait in a polling loop until some sound event of sufficient loudness
% is captured:
Level = 0;
isAboveThresh = 0;

% Repeat as long as below trigger threshold:
while Level < Threshold  %&&  time - tRecordStart*1000 < Timeout
    % Fetch current chunk of audio data :
    AudioChunk = PsychPortAudio('GetAudioData', pahandle);

    % Compute maximum signal amplitude in this chunk of data:
    if ~isempty(AudioChunk)
        Level = max(abs(AudioChunk(Channel,:)));
%         Level = max(AudioChunk(1,:)); % <use only positive threshold because of a negative artefact at record startup (on DARTAGAN)>
    end
    
    % Append chunk to previousely collected audio data
    AudioData = [AudioData AudioChunk];  % <TODO: find some way to optimize that ??>
    
    % Abort if Escape key pressed by user
    if isabort
        dispinfo(mfilename,'warning','Aborted by user')
        break  % <--!!
    end
    
    % Timeout reached ?
    rest = time - tFunctionStart;
    if rest >= Timeout
        if isVerbose
            fprintf('Timeout reached. \n')
        end
        break  % <--!!
    end

    % Below trigger threshold ?
    if Level < Threshold
        % Wait for some milliseconds before next scan:
        wait( min([5; rest]) );
    else
        isAboveThresh = 1;

    end
    
end
tEndLoop = time;

%% Times
if isAboveThresh
    if isVerbose
        fprintf('Approximative time: %f4.1 ms.', tEndLoop - tFunctionStart)  % <TODO: compute better estimate>
    end
    above = find(abs(AudioChunk(Channel,:)) > Threshold);
    nSamples = size(AudioData,2) + above(1);
    tFromRecordStart = nSamples / Freq * 1000;
    tTriggerEstimate = tRecordStart + tFromRecordStart;
else
    tFromRecordStart = NaN;
    tTriggerEstimate = NaN;
end

%% Plot sound data
if doPlot
    nChannels = size(AudioData,1);
    
    figure;
    hold on
    
    t = (1/Freq : 1/Freq : size(AudioData,2)/Freq) * 1000;
    rgb = jet(8);
    labels = cell(1,nChannels);
    for i = 1 : nChannels
        plot(t, AudioData(i,:), 'Color', rgb(i,:));
        labels{i} = ['Channel ' int2str(i)];
    end
    xlabel('Time (ms)');
    legend(labels{:});
    
%     plot([1 1]*PreviousRecordingDuration, [-10 10], 'Color', [.5 .5 .5]);
    
    if     max(max(abs(AudioData))) > 0.1
        ylim = [-1 1];
    elseif max(max(abs(AudioData))) > 0.01
        ylim = [-.1 .1];
    else
        ylim = [-.01 .01];
    end
    set(gca, 'ylim', ylim);
    
end
