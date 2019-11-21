function t1 = waitsound( b )
% WAITSOUND  Wait sound playing end.
%    t1 = WAITSOUND  wait until default sound buffer (buffer 1) has  
%    stopped playing and returns offset time.
%
%    t1 = WAITSOUND(b) - wait until buffer b has stopped playing.
%
% Example:
%    opensound;                                 % initialize sound system.
%    storesound('C:\WINDOWS\Media\ringin.wav'); % stores sound in sound buffer.
%    t0 = playsound;                            % starts playing.
%    t1 = waitsound;                            % waits until end of playing.
%
% See also: OPENSOUND, STORESOUND, STORETUUT, PLAYSOUND, WAITSOUND.

% Cogent 2000 function.
% Ben, Nov. 2008: Rewrite header.
%                 Add t1 arg.
%                 b arg. optionnal.

global cogent;

if ~nargin, b = 1; end % <ben>
% error(checksound(b));

while(cogsound('playing',cogent.sound.buffer(b)))
end
t1 = time;