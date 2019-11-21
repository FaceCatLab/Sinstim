function test_sineanim(BUFFERS,ALPHA)
% test_sineanimation(BUFFERS,ALPHA)

figure;
HSV = hsv(max(BUFFERS(:)));
G = gray(100);
colormap([HSV; G]);

m = size(BUFFERS,1);
n = size(BUFFERS,2);
M = zeros(m*3/2,n);
M(1:3:end,:) = BUFFERS(1:2:end,:);
M(2:3:end,:) = BUFFERS(2:2:end,:);
M(3:3:end,:) = size(HSV,1) + 1 + 100 * ALPHA(2:2:end,:);

image(M);
