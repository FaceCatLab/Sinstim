function clearcosy
% CLEARCOSY  Stop CosyGraphics, if running, and clear all CosyGraphics's global variables.

global COSY_GENERAL

disp(' ')

if isopen('cosygraphics')
    dispinfo(mfilename,'INFO','Stopping current CosyGraphics session...')
    COSY_DISPLAY.doKeep = 0;
	try, stopcosy
    catch warning('DEBUG-INFO: Error while executing STOPCOSY.')
    end
end

dispinfo(mfilename,'INFO','Deleting all COSY_* global variables...')
clear global cogent     % Cogent2000 global variable.
clear global COSY_*     % CosyGraphics global variables.

dispinfo(mfilename,'INFO','Clearing all function (not only CosyGraphics''s ones!) from MATLAB memory...')
clear functions % <v2-alpha5>

dispinfo(mfilename,'INFO','CosyGraphics cleared. Programs will now run in the same conditions than after MATLAB''s startup.')
disp(' ')