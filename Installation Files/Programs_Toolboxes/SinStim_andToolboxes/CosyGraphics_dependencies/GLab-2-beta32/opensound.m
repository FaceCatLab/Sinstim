function opensound(frequency,nbits,nchannels)
% OPENSOUND  Initialize sounds for G-Lab.
%    OPENSOUND  initializes sounds with default settings. Good for most users.
%    It is the same than OPENSOUND(44100,16,2).
%
%    OPENSOUND(frequency)  specifies the sampling frequency. Default is 44100.
%    Common values are 8000, 11025, 22050 and 44100.
%
%    OPENSOUND(frequency,nbits)  specifies number of bits per sample (8 or 16). 
%    Default is 16.
%
%    OPENSOUND(frequency,nbits,2)  config. for stereo. (Default is mono.)
%
% Example:
%    opensound;                                 % initialize sound system.
%    storesound('C:\WINDOWS\Media\ringin.wav'); % stores sound in sound buffer.
%    t0 = playsound;                            % starts playing.
%    t1 = waitsound;                            % waits until end of playing.
%
% See also: OPENSOUND, STORESOUND, STORETUUT, PLAYSOUND, WAITSOUND.

% Ben, Jan. 2008


global cogent GLAB_IS_RUNNING


%% CHECK IF COGENT IS STARTED
% <suppr. for Matlab 7 in 2-beta17> 
%  Works somtimes on Cog 1.29 / Matlab 7.5 w/o window, sometimes crashes
%  Crashes on Matlab 6.5 (both Cog 1.25 & 1.29!): 
%      " Invalid MEX-file
%        ...\GLab-2-beta17\lib\cogent2000\v1.25\dll\CogCapture.dll
%        Le module spécifié est introuvable. "
%  Tried to use cgloadlib: it changes nothing.
if ~isopen('glab')
	error('G-Lab must be started before to use OPENSOUND.')
end

%% VARIABLES
% Sampling frequency
if ~exist('frequency','var')
    frequency = 44100;
end
cogent.sound.frequency = frequency;
% Number of bits per sample
if exist('nbits','var')
	if nbits == 8 | nbits == 16
		cogent.sound.nbits = nbits;
	else
		error( ['nbits = 8 or 16 not ' num2str(nbits) ] );
	end
else
	cogent.sound.nbits = 16;
end
% Number of channels (1 for mono, 2 for stereo)
if exist('nchannels','var')
	if nbits == 1 | nbits == 2
		cogent.sound.nchannels = nchannels;
	else
		error( ['nchannels = 1 or 2 not ' num2str(nbits) ] );
	end
else
	cogent.sound.nchannels = 1;
end
% Number of buffers
cogent.sound.buffer = zeros(1000,1); % For Cogent2000 functions only.
% cogent.sound.number_of_buffers = default_arg( 100, varargin, 4 ); % Suppr. because never used in Cogent2000.

%% INIT. SOUND
if isfield( cogent, 'sound' )
    dispinfo(mfilename,'INFO',['Initializing sound at ' num2str(frequency) ' Hz...'])
	cogcapture('Initialise');
	cogsound('Initialise',cogent.sound.nbits,cogent.sound.frequency,cogent.sound.nchannels);
end

%% MS-WINDOWS: SET NORMAL PRIORITY.
% On Windows, the PsychToolbox3, uses always HIGH priority except if sound is
% needed. I suppose there is a reason for this and that higher than NORMAL
% priorities disturb sound processing on this wonderfull OS. So, let's set
% priority to NORMAL.
if ispc
    dispinfo(mfilename,'WARNING',...
        'Setting priority to NORMAL... (Higher priorities could impair sound processing on MS-Windows.)')
    setpriority NORMAL %  <--- CHANGE PRIORITY ---!!!
end
