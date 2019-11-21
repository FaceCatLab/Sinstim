function plotfft(signal,sampfreq)
% PLOTFFT  Plot frequency spectrum (fast Fourier transform) of a signal.
%    PLOTFFT(SIGNAL,SAMPFREQ)
%
% Example:
%    plotfft(audiodata,44100)
%
% Ben, May 2011.


%% Compute FFT and freq vector
% L = length(signal);
% n = 2^nextpow2(L);
% x = linspace(0, sampfreq, L-1);
% y = abs(fft(signal,n)) / L;
% y = y(1:L);
% x = x(1:ceil(end/2));  % fft output is symetrical
% y = y(1:ceil(end/2));

[YfreqDomain,frequencyRange] = positiveFFT(signal,sampfreq);

x = frequencyRange;
y = abs(real(YfreqDomain)) * 4; % so, the fres of a true sine wave is at 1.


%% Plot
figure;
plot(x,y,'.-');
hold on
set(gca,'xlim',[0 x(end)]);
set(gca,'ylim',[0 2.1]);
xlabel('Frequency (Hz)')
zoom xon


%% Print freq values for each freq peak
f = find(y > max(y(2:end))/10);
[i0,i1] = findgroup(f,1,1); 

for i = 1 : length(i0)
    start = f(i0(i));
    stop  = f(i1(i));
    chunk = y(start:stop);
    [m,irel] = max(chunk);
    iabs = start + irel - 1;
    xpeak = x(iabs);
    ypeak = y(iabs);
    if xpeak > 0
        str = sprintf(' %4.2f Hz', xpeak);
        plot(xpeak,ypeak,'b.')
        text(xpeak,ypeak,str,'Color',[1 0 0]);
    end
end


%% SUB-FUN: positiveFFT
function [X,freq]=positiveFFT(x,Fs)
% [YfreqDomain,frequencyRange] = positiveFFT(signal,sampfreq);
% From  http://blinkdagger.com/matlab/matlab-introductory-fft-tutorial/
N=length(x); %get the number of points
k=0:N-1;     %create a vector from 0 to N-1
T=N/Fs;      %get the frequency interval
freq=k/T;    %create the frequency range
X=fft(x)/N; % normalize the data

%only want the first half of the FFT, since it is redundant
cutOff = ceil(N/2);

%take only the first half of the spectrum
X = X(1:cutOff);
freq = freq(1:cutOff);