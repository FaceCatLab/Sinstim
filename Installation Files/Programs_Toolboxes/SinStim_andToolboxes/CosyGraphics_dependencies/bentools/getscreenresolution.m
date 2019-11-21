function [w,h] = getscreenresolution
% GETSCREENRESOLUTION  Screen resolution (pixels). This is NOT a real-time function.
%    res = GETSCREENRESOLUTION
%    [w,h] = GETSCREENRESOLUTION
%
% Ben, May 2008.

figure('vis','off','unit','norm','pos',[0 0 1 1]);
set(gcf,'unit','pix')
p = get(gcf,'pos');
w = p(1) + p(3) - 1;
h = p(2) + p(4) - 1;
if nargout < 2, w = [w h]; end
delete(gcf);