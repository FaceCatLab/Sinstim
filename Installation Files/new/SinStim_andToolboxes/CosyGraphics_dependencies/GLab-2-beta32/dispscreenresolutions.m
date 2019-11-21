function dispscreenresolutions(ScreenNum)
% DISPSCREENRESOLUTIONS  Print all available screen resolutions.
%    DISPSCREENRESOLUTIONS  displays a table with all screen resolutions and
%    corresponding refresh frequencies availables for the main screen.
%
%    DISPSCREENRESOLUTIONS(SreenNumber)  id. for given screen.
%
% Ben, June 2010.

if ~nargout, ScreenNum = 1; end

s = Screen('Resolutions',ScreenNum);
s32 = s([s.pixelSize] == 32); % Pixel depth other than 32 are not supporte by GLab.
disptable(s32);