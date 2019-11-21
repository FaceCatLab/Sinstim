

%% CODE FROM DOTFLOCKS 5.5:

tic
dt430=time-t0
toc
% Colors:
% tic
switch FlickMode
    case 1
        red = [RedFlock.Color RedFlock.SineWave(f)];  % [r g b alpha]
        blu = [BluFlock.Color BluFlock.SineWave(f)];
    case 2
        red = RedFlock.Color * RedFlock.SineWave(f);  % [r g b]
        blu = BluFlock.Color * BluFlock.SineWave(f);
    case 3
        meanbg = mean(BackgroundColorRange);
        red = RedFlock.Color * RedFlock.SineWave(f) + meanbg * (1 - RedFlock.SineWave(f));  % [r g b]
        blu = BluFlock.Color * BluFlock.SineWave(f) + meanbg * (1 - BluFlock.SineWave(f));
end
% toc
dt441=time-t0
toc


%% TIMES RECORDED:
%
% dt430 =
% 
%     0.8510
% 
% 
% elapsed_time =
% 
%      0
% 
% 
% dt441 =
% 
%     6.5510
% 
% 
% elapsed_time =
% 
%     0.0160
