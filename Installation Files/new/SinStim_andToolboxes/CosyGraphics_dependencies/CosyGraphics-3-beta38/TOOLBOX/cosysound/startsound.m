function t0 = startsound(b)
%% STARTSOUND  Start sound buffer playing/recording.
% <TODO: update doc for recording case>
%    A sound must first have been stored in the sound buffer with STORESOUND 
%    or STORETUUT.
%
%    t0 = STARTSOUND  starts playing from default sound buffer (buffer 1) and 
%    returns onset time, immediatelly (i.e.: without waiting end of playing).
%    If you need to wait until end of playing, see WAITSOUND. Once played, 
%    the sound will be deleted from the buffer and has to be stored again to 
%    be played once more.
%
%    t0 = STARTSOUND(b)  plays sound from sound buffer(s) b. b can be a scalar
%    of a vector of buffer handles. In the latter case, multiple sound will 
%    be played in parallel.
%
% Example:
%    opensound;                                 % initialize sound system.
%    storesound('C:\WINDOWS\Media\ringin.wav'); % stores sound in sound buffer.
%    t0 = startsound;                           % starts playing.
%    t1 = waitsound;                            % waits until end of playing.
%
% See also: OPENSOUND, STORESOUND, STORETUUT, STARTSOUND, WAITSOUND.

% Ben, Jan 2008.
%      Nov 2008. Add t0 output.
%                Mutltiple sounds

%%
global COSY_SOUND cogent 

if ~nargin
    b = COSY_SOUND.DefaultBuffer; 
end

if isptb('Sound')   % 'PTB'
    nRepetitions = 1;
    if nRepetitions == inf, nRepetitions = 0; end
    when = 0; % <buggy on Cheops (both in mono and stereo): plays sound, then waits +/- 'when' secs, then returns>
    waitForStart = 0; % <see above>
    PsychPortAudio('Stop', b, 2); % avoid crash if already started <TODO: change this: it takes 0 to 10 ms !!!>
    PsychPortAudio('Start', b, nRepetitions, when, waitForStart);
    t0 = time;
    if ~waitForStart, t0 = time; end

else                % 'Cog'
    for i = 1 : length(b)
        CogSound('play',cogent.sound.buffer(b(i)));
        if i == 1, t0 = time; end
    end
    
end