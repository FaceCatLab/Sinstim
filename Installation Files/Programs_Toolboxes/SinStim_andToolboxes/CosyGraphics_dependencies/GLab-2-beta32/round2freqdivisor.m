function freq = round2freqdivisor(freq,screenfreq,onlyeven)
% ROUND2FREQDIVISOR  Round frequencies to the closest divisor of the screen frequency.
%    freq = ROUND2FREQDIVISOR(freq)  Round to the closest divisor of 'screenfreq'.
%
%    freq = ROUND2FREQDIVISOR(freq,screenfreq)  Round to the closest divisor of 'screenfreq'.
%
%    freq = ROUND2FREQDIVISOR(freq,screenfreq,'even')  Round to the closest frequency with a 
%                                   even number of frames in a phase.
%
%    freq = UNIQUE(ROUND2FREQDIVISOR(...))  Suppress repetitions.
%
% Ben, Oct. 2007

screenfreq = getscreenfreq;

if nargin == 3
	phase = round(screenfreq ./ freq / 2) * 2;
else
	phase = round(screenfreq ./ freq);
end
freq = screenfreq ./ phase;