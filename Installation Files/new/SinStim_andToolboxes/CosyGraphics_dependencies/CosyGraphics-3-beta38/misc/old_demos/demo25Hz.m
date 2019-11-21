function dt = demo25Hz
% DEMO25HZ  Simple program which demonstrates a 25 Hz (the frequency of a video) flipping.

startglab('ptb', 0, [800 600], 75);

n = 100;
times = zeros(1,n)

for i = 1 : n
    if rem(i,2), color = [.25 .25 .25];
    else         color = [.75 .75 .75];
    end
    clearbuffer(0, color)
    times(i) = displaybuffer;
    waitframe(2);
end

dt = diff(times);

stopglab;