% cpuusefigure



%% Params
%%%%%%%%%%%%%%%%%%%%%%%%%
y0 = 5;
h = 10;
dy = 20;
w = 100;
wMatlab = 30;
%%%%%%%%%%%%%%%%%%%%%%%%%


x0 = 0;
for j = 1 : 4
    rectangle('pos',[x0 y0 w h],'FaceColor',[1 1 1]);
    rectangle('pos',[x0 y0 wMatlab h],'FaceColor',[.9 .5 0],'EdgeColor','none');
    x0 = x0 + w;
end