function  b = storesound(matrix,b)
%% STORESOUND  Transfer a sound matrix from the matlab workspace to a sound buffer.
%    The sound system must have been initialized with OPENSOUND before to use this
%    function.  Once stored in buffer, the sound can be played with PLAYSOUND.
%
%    b = STORESOUND(SoundMatrix)  stores SoundMatrix in default sound buffer, and
%    returns it's handle b.  SoundMatrix is a N-by-1 (mono) or a N-by-2 (stereo)  
%    matrix of values ranging from -1 to +1.
%
%    b = STORESOUND(FileName)  loads sound from *.wav file and stores it in default
%    sound buffer.
%
%    STORESOUND(SoundMatrix, b)  or,
%    STORESOUND(FileName, b)  stores sound in sound buffer b.  b is a buffer handle,
%    returned by NEWSOUNDBUFFER.
%
% Example:
%    opensound;                                 % initializes sound system.
%    storesound('C:\WINDOWS\Media\ringin.wav'); % stores sound in sound buffer.
%    t0 = startsound;                           % starts playback.
%    t1 = waitsound;                            % waits until end of playback.
%
% See also: OPENSOUND, NEWSOUNDBUFFER, SINEWAVE, STORETUUT, STARTSOUND, WAITSOUND.

% <TODO: PREPAREWHITENOISE, WAITSOUND, SOUNDPOSITION, LOOPSOUND, STOPSOUND. >

% Cogent2000 function.
% Ben, Jan 2008:  - Rewrite header.
%                 - 1st arg can be a wav-file name (merge loadsound + storesound)
%                 - "b" arg. becomes optionnal.

%%                           *** ORIGINAL COGENT HEADER ***
% PREPARESOUND transfers a sound matrix from the matlab workspace to a Cogent sound buffer.
%
% Description:
%     Transfers a sound matrix from the matlab workspace to a Cogent sound buffer.  Each column of the matrix is
%     a channel waveform (1 column for mono, 2 for stereo).  Each waveform element is in the range -1 to 1.
%
% Usage:
%     PREPARESOUND( matrix, buff )
%
% Arguments:
%     matrix - nsamples by nchannels matrix containing sound waveforms, each sample ranges between -1 and 1
%     buff   - buffer number
%
% Examples:
%
% See also:
%     CONFIG_SOUND, PREPARESOUND, PREPAREPURETONE, PREPAREWHITENOISE, LOADSOUND, WAITSOUND,
%     SOUNDPOSITION, LOOPSOUND, STOPSOUND.
%
% Cogent 2000 function.

%% Global Vars
global COSY_SOUND cogent 

%% Lib
Lib = getcosylib('Sound');

%% Check sound is initialized
if ~isopen('sound')
   error('Sound not initialized. See OPENSOUND.');
end

%% Input Args <v3-beta13:rewritten>
% matrix:
if ischar(matrix) % 1st Arg is a *.wav file name.. <v1.6.2> <v2-beta33: rewritten>
    matrix = loadsound(matrix); % ..load sound matrix from *.wav file
end

% b:
if ~exist('b','var')
    b = COSY_SOUND.DefaultBuffer;
else
    if ~ismember(b,COSY_SOUND.OpenBuffers)
        msg = sprintf('Sound buffer %d does not exist. See NEWSOUNDBUFFER to create a sound buffer.', b);
        dispinfo(mfilename,'ERROR',msg);
        stopcosy;
        error(msg);
    end
end

%% Check matrix 
% <v2-beta33: rewritten>
[m,n] = size(matrix);
if ~m || ~n
    error('Empty sound matrix');
else
    switch Lib
        case 'PTB' % PTB waits row-data
            if m > n, matrix = matrix'; end
        case 'Cog' % Cog waits column-data
            if m < n, matrix = matrix'; end
    end
end
ch = COSY_SOUND.nChannelsOut;
if min([m n]) ~= ch %<v3-beta13>
    msg = [sprintf('Inconsitent matrix dimension: %dx%d matrix, %d open output channels. Your matrix should have one row per channel.',m,n,ch)];
    dispinfo(mfilename,'ERROR',msg);
    stopcosy;
    error(msg);
end

%% Fill buffer
switch Lib
    case 'PTB'
%         nchan = size(matrix,1);                             %<v3-beta13: Commented. Moved in newsoundbuffer()>
%         if nargin < 2  % <v2-beta34: TODO: review>
%             reqlatencyclass = 0; % Cannot open more than one ASIO device <TODO: review>
%             b = PsychPortAudio('Open', [], COSY_SOUND.PTB.mode, reqlatencyclass , COSY_SOUND.SampleFrequency, nchan);
%         end
        PsychPortAudio('FillBuffer', b, matrix);
        
    case 'Cog'
%         % Create buffer                                     %<v3-beta13: Commented. Moved in newsoundbuffer()>
%         if( cogent.sound.buffer(b) )
%             CogSound( 'Destroy', cogent.sound.buffer(b) );
%         end
%         cogent.sound.buffer( b ) = CogSound( 'Create', size(matrix,1), 'any', cogent.sound.nbits, ...
%             cogent.sound.frequency, size(matrix,2) );
%         
%         % Set buffer
%         switch cogent.sound.nbits
%             case 8
%                 matrix = (matrix + 1) .* 127.5;
%             case 16
%                 matrix = matrix * 32767;
%             otherwise
%                 error( 'cogent.sound.nbit must be 8 or 16' );
%         end
        CogSound( 'SetWave', cogent.sound.buffer(b), floor(matrix)' );
        
end

% COSY_SOUND.CurrentBuffer = b;  %<v3-beta13: Suppr.>