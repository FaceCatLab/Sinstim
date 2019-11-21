function dispscreenresolutions(ScreenNum)
% DISPSCREENRESOLUTIONS  Print all resolutions available for your graphics hardware. {slow}
%    DISPSCREENRESOLUTIONS  displays a table with all screen resolutions and
%    corresponding refresh frequencies availables for the main screen.
%
%    DISPSCREENRESOLUTIONS(SreenNumber)  id. for given screen.
%
% Ben, June 2010.

if ~nargout, ScreenNum = 1; end

s = Screen('Resolutions',ScreenNum);
s32 = s([s.pixelSize] == 32); % Pixel depth other than 32 are not supporte by CosyGraphics.
disptable(s32);