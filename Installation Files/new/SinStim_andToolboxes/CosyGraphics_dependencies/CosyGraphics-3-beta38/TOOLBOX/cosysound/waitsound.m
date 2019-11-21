function t1 = waitsound( b )
% WAITSOUND  Wait end of sound playback.
%    t1 = WAITSOUND  waits until default sound buffer (buffer 1) has  
%    stopped playing and returns offset time.
%
%    t1 = WAITSOUND(b)  waits until buffer b has stopped playing.
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

global COSY_SOUND cogent;

if ~nargin
    if iscog('Sound'),  b = 1;
    else                b = COSY_SOUND.PTB.pahandle%;
    end
end

switch getcosylib('Sound')
    case 'PTB'
        PsychPortAudio('Stop', b, 1);
    case 'Cog'
        while(cogsound('playing',cogent.sound.buffer(b))), end   
end
t1 = time;