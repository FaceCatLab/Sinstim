% ssPlotKeyboard  SinStim helper program. Plot fix point change & subject response.
%    To use ssPlotKeyboard, you need to have SinStim's variables in the Workspace,
%    i.e.: either you have run SinStim or you have loaded a SinStim *.mat file.

% Get time vector (X values)
FrameDur = 10;
t = round( (0 : nFrames-1) * FrameDur ) / 1000; % time vector (sec, 1 ms precision)

% Plot fix point changes
plot(t,FixPointIsChange*50,'color',[1 .5 0]); % Plot fix point changes
hold on

% Plot Keyboard events
plot(t,KeyIDs,'color',[.3 0 1]);

% Plot displayed buffers
plot(t,BUFFERS(2,:),'color',[0 .7 .2]); % Plot displayed buffers
if nParts >= 2
   plot(t,BUFFERS(4,:),'color',[.3 .9 .5]); % Plot displayed buffers (2d part)
end
hold off

% Cosmetics
legend('Fix point changes','Keyboard responses','Displayed buffers')
set(gcf,'Units','norm','Position',[0 .25 1 .5])
xtick = 0 : round(nFrames * FrameDur / 1000);
set(gca,'XTick',xtick)
set(get(gca,'Title'),'String','Tip: To get precise times, use the "ginput" function.')
