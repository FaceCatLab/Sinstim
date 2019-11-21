function Ih = showhue(I)
% SHOWHUE  Display hue matrix of an image.
%    SHOWHUE(I)  Display hue matrix.
%    Ih = SHOWHUE(I)  Returns hue matrix.

Ihsv = rgb2hsv(I);
Ihsv(:,:,2:3) = 1;
I = hsv2rgb(Ihsv);

figure;
imshow(I);

Ih = Ihsv(:,:,1);
