% demoeyelink1  Mouse contingent demo. 
% Use mouse position to replace eye position.

ImageFile = 'C:\Documents and Settings\All Users\Documents\Mes images\Échantillons d''images\Nénuphars.jpg';
I = loadimage(ImageFile);

startpsych(0,800);

bIm = storeimage(I);
bMask = newbuffer;

setpriority OPTIMAL

while 1
    clearbuffer(bMask,[0 0 0]);
    drawround(bMask,getmouse('R'),100,[0 0 0 0]);
    copybuffer(bIm,0);
    copybuffer(bMask,0);
    displaybuffer(0);
    
    if isabort, break; end
end

setpriority NORMAL