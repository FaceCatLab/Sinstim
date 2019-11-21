% demo_concatsines

startpsych(0, [800 600], [0 0 0]);

v = sinewave(10, 0.5, getscreenfreq, [0 1], 0, 0);
% plot([v v]);
% w = [v v v v v v];

for i = 1 : length(v)
    color = [v(i) 0 1-v(i)];
    draw('square', color, 0, [0 0], 200);
    displaybuffer;
end

stopglab;