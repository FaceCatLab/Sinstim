% TESTANIMATION  Test program.

startpsych(1,[800 600],85,0);

b = storeimage(zeros(600,800,3));
w = storeimage(ones(600,800,3));

X = zeros(1,500);

[Times,FrameErr,Times2] = displayanimation(repmat([b w],1,250),X,X,[],...
    'Rotation',round(rand(1,500))*180,'Alpha',round(rand(1,500)));

d = diff(Times);
mu = mean(d)
mx = max(d)
n = find(d > 17)

stopglab;