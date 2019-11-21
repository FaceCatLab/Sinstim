% cpuusefigure



%% Params
%%%%%%%%%%%%%%%%%%%%%%%%%
nAxes = 3;
nFrames = 4;

y0 = 5;
h = 10;
dy = 20;
w = 10;
wML = 3;
%%%%%%%%%%%%%%%%%%%%%%%%%

close all

Axes = [];

for a = 1 : nAxes
    switch a
        case 1, xOS = []; wOS = [];
        case 2, xOS = [1 1.7 5 7 15.3 21 33.7 36 38]; wOS = [0.3 0.6 0.1 1.5 0.7 5.5 0.5 0.3 1.2];
        case 3, xOS = [2 30]; wOS = [12 6];
    end
    
    Axes(a) = subplot(nAxes,1,a);
    p = get(gca,'pos');
    p(4) = p(4) / 2;
    set(gca,'pos',p)
    set(gca,'ytick',[]);
    
    switch a
        case 1, title('Real-time OS')
        case 2, title('General purpose OS')
        case 3, title('General purpose OS: cases of errors')
    end

    x0 = 0;
    for f = 1 : nFrames;
        ii = find((f-1)*10 <= xOS & xOS < (f-1)*10 + wML);
        wf = wML + sum(wOS(ii))%;
        rectangle('pos',[x0 y0 wf h],'FaceColor',[.9 .5 0],'EdgeColor','none');
        for i = 1 : length(xOS)
            rectangle('pos',[xOS(i) y0 wOS(i) h],'FaceColor',[.25 .5 .5],'EdgeColor','none');
        end
        rectangle('pos',[x0 y0 w h],'FaceColor','none');
        x0 = x0 + w;
    end
    
    xlabel('Time (msec)')
end

