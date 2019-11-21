function audiodata = getsoundrecord
% GETSOUNDRECORD  Get recorded audio data.
%    DATA = GETSOUNDRECORD

global COSY_SOUND

pahandle = COSY_SOUND.PTB.pahandle;

[audiodata, p, overflow] = PsychPortAudio('GetAudioData', pahandle);

if overflow
    dispinfo(mfilename,'ERROR','Buffer overflow: Audio recording buffer was to short. Data have been lost!!!')
end
