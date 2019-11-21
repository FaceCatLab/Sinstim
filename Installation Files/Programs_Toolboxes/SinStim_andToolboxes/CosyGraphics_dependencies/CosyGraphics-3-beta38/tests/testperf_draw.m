function testperf_draw
% testperf_draw
%
% Result: 0.575 ms on DARTAGNAN, M6.5, PTB, GLab-2beta23. (0.888 ms with profile on)

% start
startpsych(1,800);

% Pre-load fun
draw('round',[0 0 1],0,[0 0],20)
draw('round',[0 0 1],0,[0 0],20)

% Measure
n = 100;
profile on
t0 = time;
for i = 1 : n
    draw('round',[0 0 1],0,[0 0],20)
    draw('round',[0 0 1],0,[0 0],20)
    draw('round',[0 0 1],0,[0 0],20)
    draw('round',[0 0 1],0,[0 0],20)
    draw('round',[0 0 1],0,[0 0],20)
    draw('round',[0 0 1],0,[0 0],20)
    draw('round',[0 0 1],0,[0 0],20)
    draw('round',[0 0 1],0,[0 0],20)
    draw('round',[0 0 1],0,[0 0],20)
    draw('round',[0 0 1],0,[0 0],20)
end
dt = (time - t0) / n / 10
profile viewer

% stop
stopglab
