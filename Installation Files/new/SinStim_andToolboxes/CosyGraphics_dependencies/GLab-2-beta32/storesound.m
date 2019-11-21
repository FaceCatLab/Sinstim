function storesound( matrix, bufnum )
%% STORESOUND  Transfer a sound matrix from the matlab workspace to a sound buffer.
%    The sound system must have been initialized with OPENSOUND before to use this
%    function. Once stored in buffer, the sound can be played with PLAYSOUND.
%
%    STORESOUND(FileName)  loads sound from *.wav file and stores it in default
%    sound buffer (buffer 1).
%
%    STORESOUND(SoundMatrix)  stores SoundMatrix in default sound buffer (buffer 1).
%    SoundMatrix is a N-by-1 (mono) or a N-by-2 (stereo) matrix of values in the 
%    range -1 to +1.
%
%    STORESOUND(FileName,b)  or,
%    STORESOUND(SoundMatrix,b)  stores sound in sound buffer b. b can then be given
%    as input argument to PLAYSOUND.
%
% Example:
%    opensound;                                 % initialize sound system.
%    storesound('C:\WINDOWS\Media\ringin.wav'); % stores sound in sound buffer.
%    t0 = playsound;                            % starts playing.
%    t1 = waitsound;                            % waits until end of playing.
%
% See also: OPENSOUND, SINEWAVE, STORETUUT, PLAYSOUND, WAITSOUND.

% <TODO: PREPAREWHITENOISE, WAITSOUND, SOUNDPOSITION, LOOPSOUND, STOPSOUND. >

% Cogent2000 function.
% Ben, Jan 2008:  - Rewrite header.
%                 - 1st arg can be a wav-file name (merge loadsound + storesound)
%                 - "bufnum" arg. becomes optionnal.

%%                           *** ORIGINAL HEADER ***
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
global cogent;

if ~isfield( cogent, 'sound' )
   error( 'sound not configured' );
end

%% Input Args
% Default bufnum value <ben, v1.6.2>
if nargin < 2, bufnum = 1; end 

% 1st Arg is a wav-file name: <ben, v1.6.2>
% We merge STORESOUND and LOADSOUND.
if ischar(matrix)
    filename = matrix;
    if exist(filename,'file')
        % Code stolen from Cogent2000 loadsound.m [
        if(cogent.sound.buffer(bufnum))
            CogSound('Destroy',cogent.sound.buffer(bufnum));
        end
        cogent.sound.buffer(bufnum) = CogSound( 'Load', filename);
        % ] end stolen code
        return % <=== !!!
    else
        error(['File ' filename 'does not exist.'])
    end
end

%% Check matrix
if size(matrix,2) == 0
   error( 'empty sound matrix' );
elseif size(matrix,2) > 2
   error( 'sound matrix has too many columns (1 column for mono, 2 columns for stereo)' );
end

%% Create buffer
if( cogent.sound.buffer(bufnum) )
   CogSound( 'Destroy', cogent.sound.buffer(bufnum) );
end
cogent.sound.buffer( bufnum ) = CogSound( 'Create', size(matrix,1), 'any', cogent.sound.nbits, ...
                                          cogent.sound.frequency, size(matrix,2) );

%% Set buffer
switch cogent.sound.nbits
case 8
   matrix = (matrix + 1) .* 127.5;
case 16
   matrix = matrix * 32767;
otherwise
   error( 'cogent.sound.nbit must be 8 or 16' );
end   
CogSound( 'SetWave', cogent.sound.buffer(bufnum), floor(matrix)' );