% test_copybuffer_perf

startpsych(0,800,85,500);
bb = storeimage(PerRun.Top.Images); % buffer IDs

n = 50;
tt = zeros(1,n);

for i = 1 : n
    clearbuffer(0);
    for j = 1 : 10
        copybuffer(randele(bb),0,rand(1,2)*100,'Alpha',.5,'Rotation',180*round(rand));
%         Screen('DrawTexture',gcw,randele(bb),[],[],180*round(rand),[],.5);
    end
    tt(i) = displaybuffer(0);

end

stopglab;