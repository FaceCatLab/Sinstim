function showhsv(Ihsv)
% SHOWHSV  Show hue-saturation-value planes of a HSV image matrix.
%    SHOWHSV(Ihsv)  shows HSV image 'Ihsv'.
%
% See also: SHOWRGB
% 
% Ben, Sept-Nov. 2007

Irgb = hsv2rgb(Ihsv);
ax = showrgb(Irgb,Ihsv);

pos1 = get(ax(1),'pos');
pos3 = get(ax(3),'pos');
y1 = pos1(2);
y0 = pos3(2) + pos3(4);
dy = y1 - y0;
h = .2 * dy;
pos = [pos1(1) y0+dy/2-h/2 pos1(3) h];
axes('pos',pos);

HSV = hsv(256);
HSV = repmat(cat(3,HSV(:,1)',HSV(:,2)',HSV(:,3)'),[30 1 1]);
subimage(HSV);

XTick = 256*(0:3)/3;
XTickLabel = [' 0 '; '1/3'; '2/3'; ' 1 '];
set(gca,'XTick',XTick,'XTickLabel',XTickLabel)