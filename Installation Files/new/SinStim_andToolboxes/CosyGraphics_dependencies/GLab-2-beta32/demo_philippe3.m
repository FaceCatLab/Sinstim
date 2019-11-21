% demo_philippe3: Blue robe/red robe

ImageFile = 'F:\docs\My Pictures\BlueRobe.jpg';
RGB = loadimage(ImageFile);

HSV = rgb2hsv(RGB);
H = HSV(:,:,1);
robe = 3/6 < H & H < 5/6;
H(robe) = H(robe) + 1/3;
H = fitrange(H,[0 1],'cyclic');
HSV(:,:,1) = H;
RGB2 = hsv2rgb(HSV);

alpha = sinewave(10,.1,60);

startpsych(0,800);

b1 = storeimage(RGB);
b2 = storeimage(RGB2);

setpriority OPTIMAL

for i = 1 : length(alpha)
    copybuffer(b1,0);
    copybuffer(b2,0,'alpha',alpha(i));
    displaybuffer(0);
end

setpriority NORMAL

stopglab