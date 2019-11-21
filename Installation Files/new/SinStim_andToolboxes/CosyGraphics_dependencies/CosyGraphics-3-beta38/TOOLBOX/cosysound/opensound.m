function opensound(varargin)
% OPENSOUND  Initialize audio.
%    OPENSOUND(SampleFreq <,Channels=1>)
%
%    OPENSOUND  initializes sound playback with default settings. Good for most users.
%    It is the same than OPENSOUND(44100,2).
%
%    OPENSOUND(Freq)  sets the sampling frequency (Hz). Default is 44100 Hz.
%    Common values are 8000, 11025, 22050, 44100, 48000 and 96000 Hz. (NB: Default frequency of
%    Matlab's basic sound() function --usefull for demos-- is 8192 Hz.)  96000 Hz is
%    suggested for time-critical experiments.
%
%    OPENSOUND(Freq, Channels)  specifies different numbers of channels.  When 'Channels'
%    is a scalar, it specifies the number of output channels for sound playback: 1 is mono
%    (default), 2 is stereo, 3 and more is only possible on milti-channel sound card and is
%    only available if PTB's ASIO driver has been installed (see internal documentation
%    of this function about this).
%    When 'Channels' is a 2 elements vector, the first elements specifies the number of output  
%    channels and the second element specifies the number of input channels.  
%    Note that opening both output and input channels ("full-duplex" mode) is unstable on 
%    some hardware and may crash Matlab! Other hardwares refuse to initialize without at least
%    1 output channel.
%
%    OPENSOUND(Freq, Channels, RecordDuration)  in input or full-duplex mode, specifies the
%    record buffer length in milliseconds. <PTB only. Ignored on Cogent>
%
%    OPENSOUND(Lib, ...)  initialises sound using given library.  Lib can be 'PTB' or 'Cog'.
%
%
% Example:
%    opensound;                                 % initialize sound system.
%    storesound('C:\WINDOWS\Media\ringin.wav'); % stores sound in sound buffer.
%    t0 = playsound;                            % starts playback.
%    t1 = waitsound;                            % waits until end of playing.
%
%
% Example 2: Open St Luc fMRI USB external sound card (Creative Labs SBO49D): 
%     You have first to have the card's driver installed.
%     This card suffers some driver bugs. Use the following command line to open it,
%     note that not all standards sampling frequencies are supported.
%
%     opensound('ptb',48000,'-device',4);
%
%
% PsychToolbox options:
%    It's possible to specifies directly the arguments for PTB's InitializePsychSound() and 
%    PsychPortAudio() function. (See "help InitializePsychSound", "help PsychPortAudio" and 
%    "PsychPortAudio ?") Normally you should not need that: CosyGraphics chooses the best default 
%    for you, but many sound card drivers are buggy, and you may need to hack to get it working.
%
%    opensound(..., '-device',DeviceNum)  specifies the 'device' argument for PsychPortAudio.
%    opensound(..., '-reallyneedlowlatency',Flag)  specifies the 'reallyneedlowlatency' argument for InitializePsychSound.
%    opensound(..., '-reqlatencyclass',ClassNum)  specifies the 'reqlatencyclass' argument for PsychPortAudio.                   % waits until end of playing.
%
%
% Known bug:
%           There is a non-understood Cogent bug on Matlab 7.5: The foillowing lines
%                       startcogent; 
%                       opensound;  
%           are working inside an m-file but, in command-line, crashes with the following error message:
%                       ??? Error using ==> CogSound
%                       *******
%                       *ABORT* CogSound : Initialise : no active window availble
%                       *******
%
%
% See also: OPENSOUND, LOADSOUND, STORESOUND, STORETUUT, STOREWHITENOISE, STARTSOUND, PLAYSOUND<?>, 
%           GETSOUNDDATA, WAITSOUNDTRIGGERWAITSOUND, CLOSESOUND  (1)
%           SINEWAVE  (2)
%           SOUND  (3)
%           (1) CosyGraphics functions, (2) BenTools function, (3) MatLab standard function.
%
%
% Ben, Jan 2008: 1.0 - Rewrite Cogent2000 code.
%      Jan 2011: 2.0 - Port on PTB, basic mode.


%% <v2-beta33> Deprecated syntaxes: <never used>
%    OPENSOUND(<Mode,> frequency, nbits)  specifies number of bits per sample (8 or 16).
%    Default is 16.
%
%    OPENSOUND(<Mode,> frequency, nbits, 2)  config. for stereo. (Default is mono.)


%% PTB demo:
% BasicSoundOutputDemo  - Very basic demo of sound output.
% BasicSoundInputDemo
% SimpleVoiceTriggerDemo  - Demo of a simple voice trigger with PsychPortAudio.

%% PTB documentation: ASIO driver
% See " help InitializePsychSound " about ASIO drivers.

%% PTB documentation: PsychPortAudio help (type "PsychPortAudio" after "InitializePsychSound")
% pahandle = PsychPortAudio('Open' [, deviceid][, mode][, reqlatencyclass][, freq][, channels][, buffersize][, suggestedLatency][, selectchannels]);
% PsychPortAudio('Close' [, pahandle]);
% oldbias = PsychPortAudio('LatencyBias', pahandle [,biasSecs]);
% PsychPortAudio('FillBuffer', pahandle, bufferdata [, streamingrefill=0);
% startTime = PsychPortAudio('Start', pahandle [, repetitions=1] [, when=0] [, waitForStart=0] );
% startTime = PsychPortAudio('RescheduleStart', pahandle, when [, waitForStart=0]);
% [startTime endPositionSecs xruns] = PsychPortAudio('Stop', pahandle [,waitForEndOfPlayback=0]);
% [audiodata absrecposition overflow cstarttime] = PsychPortAudio('GetAudioData', pahandle [, amountToAllocateSecs][, minimumAmountToReturnSecs][, maximumAmountToReturnSecs]);

%% PTB documentation: PsychPortAudio('Open') help (type "PsychPortAudio,'Open','?')")
% pahandle = PsychPortAudio('Open' [, deviceid][, mode][, reqlatencyclass][, freq][, channels][, buffersize][, suggestedLatency][, selectchannels][, specialFlags=0])
% 
% Open a PortAudio audio device and initialize it. Returns a 'pahandle' device
% handle for the device. All parameters are optional and have reasonable defaults.
%
% 'deviceid' Index to select amongst multiple logical audio devices supported by
% PortAudio. Defaults to whatever the systems default sound device is. Different
% device id's may select the same physical device, but controlled by a different
% low-level sound system. E.g., Windows has about five different sound subsystems.
%
% 'mode' Mode of operation. Defaults to 1 == sound playback only. Can be set to 2
% == audio capture, or 3 for simultaneous capture and playback of sound. Note
% however that mode 3 (full duplex) does not work reliably on all sound hardware.
% On some hardware this mode may crash Matlab! There is also a special monitoring
% mode == 7, which only works for full duplex devices when using the same number
% of input- and outputchannels. This mode allows direct feedback of captured
% sounds back to the speakers with minimal latency and without involvement of your
% script at all, however no sound can be captured during this time and your code
% mostly doesn't have any control over timing etc. 
% You can also define a audio device as a master device by adding the value 8 to
% mode. Master devices themselves are not directly used to playback or capture
% sound. Instead one can create (multiple) slave devices that are attached to a
% master device. Each slave can be controlled independently to playback or record
% sound through a subset of the channels of the master device. This basically
% allows to virtualize a soundcard. See help for subfunction 'OpenSlave' for more
% info.
%
% 'reqlatencyclass' Allows to select how aggressive PsychPortAudio should be about
% minimizing sound latency and getting good deterministic timing, i.e. how to
% trade off latency vs. system load and playing nicely with other sound
% applications on the system. Level 0 means: Don't care about latency, this mode
% works always and with all settings, plays nicely with other sound applications.
% Level 1 (the default) means: Try to get the lowest latency that is possible
% under the constraint of reliable playback, freedom of choice for all parameters
% and interoperability with other applications. Level 2 means: Take full control
% over the audio device, even if this causes other sound applications to fail or
% shutdown. Level 3 means: As level 2, but request the most aggressive settings
% for the given device. Level 4: Same as 3, but fail if device can't meet the
% strictest requirements.
%
% 'freq' Requested playback/capture rate in samples per
% second (Hz). Defaults to a value that depends on the requested latency mode.
%
% 'channels', specifying different numbers of output channels and input
% channels. The first element in such a vector defines the number of playback
% channels, the 2nd element defines capture channels. E.g., [2, 1] would define 2
% playback channels (stereo) and 1 recording channel. See the optional
% 'selectchannels' argument for selection of physical device channels on multi-
% channel cards.
%
% 'buffersize' requested size and number of internal audio buffers, smaller
% numbers mean lower latency but higher system load and some risk of overloading,
% which would cause audio dropouts. 
%
% 'suggestedLatency' optional requested latency
% in seconds. PortAudio selects internal operating parameters depending on
% sampleRate, suggestedLatency and buffersize as well as device internal
% properties to optimize for low latency output. Best left alone, only here as
% manual override in case all the auto-tuning cleverness fails.
%
% 'selectchannels' optional matrix with mappings of logical channels to device
% channels: If you only want to use a subset of the channels present on your sound
% card, e.g., only 2 playback channels on a 16 channel soundcard, then you'd set
% the 'channels' argument to 2. The 'selectchannels' argument allows you to
% select, e.g.,  which two of the 16 channels to use for playback.
% 'selectchannels' is a one row by 'channels' matrix with mappings for pure
% playback or pure capture. For full-duplex mode (playback and capture),
% 'selectchannels' must be a 2 rows by max(channels) column matrix. row 1 will
% define playback channel mappings, whereas row 2 will then define capture channel
% mappings. In any case, the number in the i'th column will define which physical
% device channel will be used for playback or capture of the i'th PsychPortAudio
% channel (the i'th row of your sound matrix). Numbering of physical device
% channels starts with zero! Example: Both, playback and simultaneous recording
% are requested and 'channels' equals 2, ie, two playback channels and two capture
% channels. If you'd specify 'selectchannels' as [0, 6 ; 12, 14], then playback
% would happen to device channels zero and six, sound would be captured from
% device channels 12 and 14. Please note that channel selection is currently only
% supported on MS-Windows with ASIO sound cards. The parameter is silently ignored
% for non-ASIO operation. 
% 
% 'specialFlags' Optional flags: Default to zero, can be or'ed or added together
% with the following flags/settings:
% 1 = Never prime output stream. By default the output stream is primed. Don't
% bother if you don't know what this means.
% 2 = Always clamp audio data to the valid -1.0 to 1.0 range. Clamping is enabled
% by default.
% 4 = Never clamp audio data.
% 8 = Always dither output audio data. By default, dithering is enabled in normal
% mode, and disabled in low-latency mode. Dithering adds a stochastic noise
% pattern to the least significant bit of each output sample to reduce the impact
% of audio quantization artifacts. Dithering can improve signal to noise ratio and
% quality of output sound, but it is more compute intense and it could change very
% low-level properties of the audio signal, because what you hear is not exactly
% what you specified.
% 16 = Never dither audio data, not even in normal mode.

%% PTB documentation: PsychPortAudio asynchronous playback (from http://tech.groups.yahoo.com/group/psychtoolbox/message/10789)
% BasicSoundOutputDemo with its default settings shows you how to play back a
% soundvector in an infite loop - until stopped. You can simply create a 1 second
% soundvector with your metronom click followed by some silence to fill up the
% second. Then you play that on infite repeat and you have your 1 click per second
% metronome. Playback happens in the background while your script can do other
% stuff.
% 
% Specifying a requested start time ahead of time is also possible with the
% current driver, and the next iteration of PsychPortAudio has improved schedule
% support for periodic tasks with very precise timing requirements as well
% (prototype available on request).
% 
% The 1st solution should be good enough. The only downside is that sound playback
% then runs on the clock of the soundcard, whereas the rest of your code runs on
% the system clock. Both may drift apart from each other on long trial durations
% due to clock imperfections and environmental influences like temperature and
% fluctuations in power supply.
% 
% The 2nd scheduling solution is a tiny bit more complex, but as schedules run on
% the system clock, you won't have any problems with possible clock drift.


%% GLOBAL VARS
global COSY_SOUND cogent 

%% PARAMS  
% Only PTB/basic mode now implemented: Use most basic/reliable defaults.
% <TODO: Review that when implementing PTB/ASIO.>
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% reallyneedlowlatency = 0; 
% reqlatencyclass = 4; % <1:4 very noisy on CHEOPS. 2 has has crashed once (Matlab stuck in buzzy loop)>
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% CLOSE SOUND IF ALREADY OPEN
if isopen('sound')
    dispinfo(mfilename,'info','Sound already open. Running CLOSESOUND first...')
end
closesound; % always run it, even if isopen('sound') returns 0: state of global vars could be inconsistent

%% INPUT VARS
% <v3-beta13: Rewritten>

% Lib: Cog/PTB  [optionnal 1st arg]
if nargin && ischar(varargin{1})
    switch lower(varargin{1})
        case 'ptb'
            Lib = 'PTB';
            setcosylib('Sound','PTB');
        case 'cog'
            Lib = 'Cog';
            setcosylib('Sound','Cog');
        otherwise, 
            stopcosy; 
            error(['Invalid argument: ''' varargin{1} '''.'])
    end
    varargin = varargin(2:end);
else
    if isopen('cosygraphics')
        Lib = getcosylib('Sound');
    else
        dispinfo(mfilename,'info','No display open. Opening PTB sound by default...')
        Lib = 'PTB';
        setcosylib('Sound',Lib);
    end
end

% PTB Options  <v3-beta15>
PTB = [];
iOpt = findoptions(varargin);
for i = iOpt
    switch varargin{i}
        case '-device',                 PTB.device = varargin{i+1};
        case '-reallyneedlowlatency',   PTB.reallyneedlowlatency = varargin{i+1};
        case '-reqlatencyclass',        PTB.reqlatencyclass = varargin{i+1};
        otherwise
            if isopen('Display'), stopcosy; end
            error(['Unknown option: ' varargin{i}])
    end
end
varargin([iOpt iOpt+1]) = [];

% Sampling frequency
if length(varargin) >= 1 && ~isempty(varargin{1})
    Frequency = varargin{1};
else
    Frequency = 44100; % <TODO: 44100 or 96000 ???>
end

% Number of channels (1 for mono, 2 for stereo)
if length(varargin) >= 2 && ~isempty(varargin{2})
    Channels = varargin{2};
else
    Channels = [1 0];  % Default = mono
end
if length(Channels) == 1, Channels(2) = 0; end  % [out in]

% Record buffer length
if length(varargin) >= 3 && ~isempty(varargin{3})
    RecordDuration = varargin{3};
else
    RecordDuration = 10000;  % Default = mono
end

%% FILL GLOBAL VARS
COSY_SOUND.isOpen = false;
COSY_SOUND.SampleFrequency = Frequency;
COSY_SOUND.nChannelsOut = Channels(1);
COSY_SOUND.nChannelsIn  = Channels(2);

switch Lib
    case 'PTB' % PTB: ASIO driver or basic driver ? (an ASIO driver has to be downloaded and added into PTB's root folder)
        % <v3-beta15: Review all>
        COSY_SOUND.PTB.isASIO = exist([PsychtoolboxRoot 'portaudio_x86.dll']) >= 2;
        if ~isfield(PTB,'device')
            PTB.device = []; % []: let PTB choose
        end
        if ~isfield(PTB,'reallyneedlowlatency')
            if ~ispc | COSY_SOUND.PTB.isASIO % Linux/MacOSX or Windows with ASIO graphics card: use the strictest parameters
                PTB.reallyneedlowlatency = 1;
            else % Windows with std Microsoft driver: use most basic parameters to ensure it just work
                PTB.reallyneedlowlatency = 0;
            end
        end
        if ~isfield(PTB,'reqlatencyclass')
            if ~ispc | COSY_SOUND.PTB.isASIO % Linux/MacOSX or Windows with ASIO graphics card: use the strictest parameters
                PTB.reqlatencyclass = 3; % <1:4 very noisy on CHEOPS. 2 has has crashed once (Matlab stuck in buzzy loop)>
            else % Windows with std Microsoft driver: use most basic parameters to ensure it just work
                PTB.reqlatencyclass = 0;
            end
        end
        
        COSY_SOUND.PTB = PTB; % <v3-beta15>
        
    case 'Cog' % Cog: Fill "cogent" global var
        cogent.sound.frequency = Frequency; 
        cogent.sound.nbits = 16; % <v2-beta33: nbits = 8 or 16 ; not advantage to use 8 ==> always use 16 bits!>
        cogent.sound.nchannels = Channels(1);
        cogent.sound.buffer = zeros(1000,1); % Number of buffers: For Cogent2000 functions only.
        % cogent.sound.number_of_buffers = default_arg(100,varargin,4);  % <Suppr. because never used in Cogent2000.>
end

%% INIT. SOUND
str = sprintf('Opening sound... Requested sample rate %d Hz...', Frequency);
dispinfo(mfilename,'info',str);

switch Lib
    case 'PTB'
%         PsychPortAudio Close  % in case it was open   <crashes Matlab if sound has never been open>
        InitializePsychSound(PTB.reallyneedlowlatency); % !
        
        mode = (Channels(1)>0) + 2 * (Channels(2)>0); % see PTB doc above
        switch mode
            case 1, chan = Channels(1);
            case 2, chan = Channels(2);
            case 3, chan = Channels;         
        end
        pahandle = PsychPortAudio('Open', PTB.device, mode, PTB.reqlatencyclass, Frequency, chan, [], [], []); % !
        COSY_SOUND.PTB.mode = mode;
        COSY_SOUND.PTB.pahandle = pahandle;

        if Channels(2) > 0
            % Preallocate an internal audio recording  buffer with a capacity of 5 seconds:
            dispinfo(mfilename,'debuginfo','<TODO: Record duration hard-coded!>');
            PsychPortAudio('GetAudioData', pahandle, RecordDuration/1000); % Init record buffer length (yes, 'GetAudioData' has two uses!)
        end
        %<v3beta13>
        COSY_SOUND.DefaultBuffer = NaN;
        COSY_SOUND.OpenBuffers = pahandle; %<3-beta15: [] -> pahandle>
%         b = newsoundbuffer; % Seems that b=1 on WinSound, b=0 on ASIO. %<Suppr. 3-beta15>
        COSY_SOUND.DefaultBuffer = pahandle; %<3-beta15: 1 -> pahandle>
        %<end/v3beta13>

    case 'Cog'
        dispinfo(mfilename,'info',['Initializing Cogent sound at ' num2str(Frequency) ' Hz...'])
        % cogcapture('Initialise'); % <v2-beta33: Fix Cog/ML7.5 crash at startup>
        cogsound('Initialise', cogent.sound.nbits, cogent.sound.frequency, cogent.sound.nchannels);
        COSY_SOUND.DefaultBuffer = 1; %<v3beta13>
        COSY_SOUND.OpenBuffers   = 1; %<v3beta13>

end

COSY_SOUND.isOpen = true;

%% MS-WINDOWS: SET NORMAL PRIORITY.
% On Windows, the PsychToolbox 3, uses always HIGH priority except if sound is
% needed. I suppose there is a reason for this and that higher than NORMAL
% priorities disturb sound processing on this wonderfull OS. So, let's set
% priority to NORMAL.
if ispc
    dispinfo(mfilename,'WARNING',...
        'Setting priority to NORMAL... (Higher priorities could impair sound processing on MS-Windows.)')
    setpriority NORMAL  %  <--- CHANGE PRIORITY ---!!!
end

disp(' ')