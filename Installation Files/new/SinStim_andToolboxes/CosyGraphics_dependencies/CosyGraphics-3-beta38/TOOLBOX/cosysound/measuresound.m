function [volume,audiodata] = mesuresound
% mesuresound  
%    [volume,audiodata] = mesuresound


%% Params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SamplingFreq = 44100; %(Hz)
FilterCutoff = 2000;  % !!!!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
% NB: Test full-duplex mode :
%     input 1133 samples later than output at 96000 Hz (o=1101, i=2304)

%%
% Init 
nChan = [0 1];  % [out in]
opensound(SamplingFreq, nChan); % initialize and configure audio system
SoundBuffer = 0;
setcosylib('Keyboard','PTB')
openkeyboard;

% Wait key press
disp('Press any key when ready...')

waitkeydown;

% Start playback
startsound(SoundBuffer);

% Get recorded data  <TODO: revoir!!!>
startsound(0);
fprintf('Make noise! Make noise!          ');
wait(4000); 
audiodata = getsounddata;

% Wait end of playback & close sound
waitsound(SoundBuffer);
closesound;

%% Compute sound's volume
% Find sine wave's maxima
signal = autoregfiltinpart(SamplingFreq, FilterCutoff, audiodata);

peaks = -diff(sign(diff(signal))) / 2; % +1 at max, -1 at mins
peaks = [0 peaks 0];
ii = find( peaks == 1 & audiodata > 0.9*max(abs(audiodata)) );

% Get max values
yy = zeros(size(ii));
for i = 1 : length(yy)
    yy(i) = max(audiodata(ii(i)-3:(ii(i)+3)));
end
volume = median(yy);

%% Plot
close all
plot(audiodata); 
hold on; 
set(gcf,'units','norm','pos',[0 0.4 0.5 0.5]);
set(gca,'ylim',[-0.01 0.01]); 
figure(gcf);
plot(signal,'c');
plot(ii,yy,'mo');
xlim = get(gca,'xlim');
plot(xlim,[volume volume],'r')
legend('Raw data', 'Filtered data', 'Maxima', 'Median of maxima')
text(xlim(2),volume,num2str(volume));

%% Plot FFT
plotfft(audiodata,SamplingFreq);
set(gcf,'units','norm','pos',[0.5 0.05 0.5 0.5]);