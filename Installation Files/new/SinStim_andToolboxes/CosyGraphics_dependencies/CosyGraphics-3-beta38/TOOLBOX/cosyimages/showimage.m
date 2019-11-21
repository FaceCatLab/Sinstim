function showimage(I,bg)
% SHOWIMAGE  Preview image(s). <deprecated. TODO: show on matlab figure>
%    This function will only work after STARTCOGENT or STARTPSYCH have
%    been run.
%    
%    SHOWIMAGE(I)
%    SHOWIMAGE(Cell)
%    SHOWIMAGE(FileNames)
%    SHOWIMAGE(FolderName)
%    SHOWIMAGE(BufferIDs)
%    SHOWIMAGE(..., <BackgroundColor>)


if nargin < 2, bg = [.5 .5 .5]; end

if ischar(I)
    I = loadimage(I);
end

b = storeimage(I);

Map = getbelgianmap;
xy_corner = [40-getscreenres(1)/2 getscreenres(2)/2-14];
xy = [20,-getscreenres(2)/2+20];

i = 1;
while i <= length(b)
    clearbuffer(0,bg)
    copybuffer(b(i),0);
    drawtext(['Image ' int2str(i)],0,xy_corner,12,[0 0 1]);
    drawtext('Press SPACEBAR to continue, or use arrow keys...',0,xy,12,[0 0 1]);
    displaybuffer(0);
    k = waitkeydown(inf,[Map.Space,Map.Right,Map.Left,Map.Up,Map.Down,Map.Escape]);
    switch k
        case {Map.Space,Map.Right,Map.Down},    i = i + 1;
        case {Map.Left,Map.Up},                 i = i - 1;
        case  Map.Escape,                       break % !
    end
end

clearbuffer(0);
displaybuffer(0);

deletebuffer(b);