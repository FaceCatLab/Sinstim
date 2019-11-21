function storetuut(frequency,duration,buffer)
% STORETUUT  Fill sound buffer with sin wave of specified duration and frequency.
%    The sound system must have been initialized with OPENSOUND before to use this
%    function. Once stored in buffer, the sound can be played with PLAYSOUND.
%
%    STORETUUT(frequency,duration)  creates a sound buffer (buffer 1) and fills it 
%    with sin wave of given frequency (in Hz) and duration (in ms). Note that the 
%    range of human audition is from 20Hz to 20000Hz.
%
%    STORETUUT(frequency,duration,buffer_number)  creates and fills sound buffer
%    of given number. This number can then be given as input argument to PLAYSOUND. 
%
% Examples:
%     storetuut(500,1000) prepares a 500Hz 1000 millisecond sine wave (in buffer 1).
%     storetuut(500,1000,3) prepares a 500Hz 1000 millisecond sine wave in buffer 3.
%
% See also: SINEWAVE, STORESOUND, STOREWHITENOISE.
%
% Ben, Jan 2008.

global cogent;

if nargin < 3, buffer = 1; end

x = 1 : floor( cogent.sound.frequency * duration / 1000 );
a = sin( 2*pi*frequency*x/cogent.sound.frequency );

storesound( a', buffer );

return;