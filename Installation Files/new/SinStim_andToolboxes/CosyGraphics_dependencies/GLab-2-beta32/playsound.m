function t0 = playsound(b)
%% PLAYSOUND  Start sound buffer playing.
%    A sound must first have been stored in the sound buffer with STORESOUND 
%    or STORETUUT.
%
%    t0 = PLAYSOUND  starts playing from default sound buffer (buffer 1) and 
%    returns onset time, immediatelly (i.e.: without waiting end of playing).
%    If you need to wait until end of playing, see WAITSOUND. Once played, 
%    the sound will be deleted from the buffer and has to be stored again to 
%    be played once more.
%
%    t0 = PLAYSOUND(b)  plays sound from sound buffer(s) b. b can be a scalar
%    of a vector of buffer handles. In the latter case, multiple sound will 
%    be played in parallel.
%
% Example:
%    opensound;                                 % initialize sound system.
%    storesound('C:\WINDOWS\Media\ringin.wav'); % stores sound in sound buffer.
%    t0 = playsound;                            % starts playing.
%    t1 = waitsound;                            % waits until end of playing.
%
% See also: OPENSOUND, STORESOUND, STORETUUT, PLAYSOUND, WAITSOUND.

% Ben, Jan 2008.
%      Nov 2008. Add t0 output.
%                Mutltiple sounds

%%
global cogent;

if ~nargin, b = 1; end % <ben>
% for i = 1 : length(b) % <ben>
%     error(checksound(b(i))); % <TODO: review this!>
% end

for i = 1 : length(b) % <ben>
    CogSound('play',cogent.sound.buffer(b(i)));
    if i == 1, t0 = time; end % <ben>
end
