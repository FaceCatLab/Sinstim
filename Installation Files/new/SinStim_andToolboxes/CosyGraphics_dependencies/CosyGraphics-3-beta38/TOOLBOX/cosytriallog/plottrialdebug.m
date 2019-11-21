function dt = plottrialdebug
% PLOTTRIALDEBUG  Plot last trial's logged data for debug purpose.
%
% <FIXME: UserCodeTime??>

global COSY_TRIALLOG

t = COSY_TRIALLOG.PERDISPLAY.TimeStamps - COSY_TRIALLOG.PERDISPLAY.TimeStamps(1);
TimeWaited = COSY_TRIALLOG.PERDISPLAY.ScreenFlipReturnedTimeStamps - COSY_TRIALLOG.PERDISPLAY.ScreenFlipCalledTimeStamps;
DisplaybufferTime1 = COSY_TRIALLOG.PERDISPLAY.ScreenFlipCalledTimeStamps - COSY_TRIALLOG.PERDISPLAY.DisplaybufferCalledTimeStamps;
DisplaybufferTime2 = COSY_TRIALLOG.PERDISPLAY.DisplaybufferReturnedTimeStamps - COSY_TRIALLOG.PERDISPLAY.ScreenFlipReturnedTimeStamps;
isAnim = COSY_TRIALLOG.PERDISPLAY.ExpectedDurations_frames == 1;
TimeWaited(~isAnim) = NaN;
UserCodeTime = [NaN COSY_TRIALLOG.PERDISPLAY.DisplaybufferCalledTimeStamps(2:end) - COSY_TRIALLOG.PERDISPLAY.DisplaybufferReturnedTimeStamps(1:end-1)];

hold off
h(1) = plot(t,TimeWaited,'bo-');
hold on
h(3) = plot(t,DisplaybufferTime1,'go-');
h(4) = plot(t,DisplaybufferTime2,'co-');
h(2) = plot(t,UserCodeTime,'ro-');
set(gca,'ylim',[0 2*oneframe+1])
grid on

ylabel('Duration (ms)')
% xlabel('Displays')

if iscog, str1 = 'cgflip: Time waited';
else      str1 = 'Screen(''Flip''): Time waited';
end
legend(h, str1, 'User code execution time', 'displaybuffer: Exec time before flip', 'displaybuffer: Exec time after flip');

figure(gcf);

dt.displaybufferComputationTimeBefore = DisplaybufferTime1;
dt.ScreenFlipTime = TimeWaited;
dt.DeltaBetweenTimestampAndReturnTime = COSY_TRIALLOG.PERDISPLAY.DisplaybufferReturnedTimeStamps - COSY_TRIALLOG.PERDISPLAY.TimeStamps;
dt.displaybufferComputationTimeAfter = DisplaybufferTime2;
