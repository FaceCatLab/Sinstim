function storetuut(frequency,duration,buffer)
% STORETUUT  Fill sound buffer with a pure tone sound.
%    The sound system must have been initialized with OPENSOUND before to use this
%    function. Once stored in buffer, the sound can be played with PLAYSOUND.
%
%    STORETUUT(frequency,duration)  creates a sound buffer (buffer 1) and fills it 
%    with sin wave of given frequency (in Hz) and duration (in ms). Note that the 
%    range of human audition is from 20Hz to 20000Hz, and that sound cards apply a
%    high pass filter at 20 HZ.
%
%    STORETUUT(frequency,duration,buffer_number)  creates and fills sound buffer
%    of given number. This number can then be given as input argument to PLAYSOUND. 
%
% Examples:
%    storetuut(500,1000) prepares a 500Hz 1000 millisecond sine wave (in buffer 1).
%    storetuut(500,1000,3) prepares a 500Hz 1000 millisecond sine wave in buffer 3.
%
% See also: MAKETUUT, SINEWAVE, STORESOUND, STOREWHITENOISE.
%
% Ben, Jan 2008.

global COSY_SOUND

if nargin < 3
    try
        b = COSY_SOUND.DefaultBuffer;
    catch
        error('Sound not initialized. See OPENSOUND.')
    end
end

tuut = maketuut(frequency,duration);
storesound(tuut, b);
