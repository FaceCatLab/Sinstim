function tuut = maketuut(Frequency,Duration,buffer)
% MAKETUUT  Make a pure tone sound.
%    The sound system must have been initialized with OPENSOUND before to use this
%    function.  Before to be played played, the sound must be stored in an audio-
%    buffer with STORESOUND.
%
%    STORETUUT(frequency,duration)  creates a sound buffer (buffer 1) and fills it 
%    with sin wave of given frequency (in Hz) and duration (in ms).  Note that the 
%    range of human audition is from 20Hz to 20000Hz, and that sound cards apply a
%    high pass filter at 20 HZ.
%
%    STORETUUT(frequency,duration,RiseFall)  <TODO>

global cogent COSY_SOUND

%% Get Sample frequency
try
    if iscog('Sound')
        SampFreq = cogent.sound.frequency;
    else
        SampFreq = COSY_SOUND.SampleFrequency;
    end
catch
    error('Sound not initialized. See OPENSOUND.')
end

%% Compute sine wave
xx = 0 : floor( SampFreq * Duration/1000 )-1;
tuut = sin( 2*pi * Frequency * xx / SampFreq )';
tuut = tuut(end:-1:1); % sounds must finish at zero, to avoid audible artefact.