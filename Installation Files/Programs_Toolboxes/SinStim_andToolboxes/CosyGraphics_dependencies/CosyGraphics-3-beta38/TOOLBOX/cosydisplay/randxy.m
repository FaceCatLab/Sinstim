function XY = randxy(n,shape,wh)
% RANDXY  Random coordinates for shapes fitting in an area without overlap.
%    XY = randxy(n,shape,w|wh <,xyxy>)

%% Input Args & Vars
wh = [wh(1) wh(end)]; % w -> wh
if nargin<4
    [wArea,hArea] = getscreenres;
    wArea = wArea - wh(1);
    hArea = hArea - wh(2);
    xyxy = [-wArea -hArea wArea hArea] / 2;
end

x0 = mean(xyxy([1 3]));
w  = diff(xyxy([1 3]));
y0 = mean(xyxy([2 4]));
h  = diff(xyxy([2 4]));

%% Main Loop
ko = true(n,1);
count = 0;

while any(ko)
    XY(ko,1) = rand(sum(ko),1) * wArea + x0;
    XY(ko,2) = rand(sum(ko),1) * hArea + y0;
    ko = iscollision(shape, XY, wh);
    
    count = count + 1;
    if count >= 1000, error('Maximum number of iteration (1000) reached, no solution found.'); end
end

XY(:,1) = XY(:,1) - wArea/2 + x0;
XY(:,2) = XY(:,2) - hArea/2 + y0;
