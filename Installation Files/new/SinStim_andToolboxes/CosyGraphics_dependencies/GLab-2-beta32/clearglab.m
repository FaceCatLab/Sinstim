function clearglab
% CLEARGLAB  Stop G-Lab, if running, and clear all G-Lab's global variables.

global GLAB_IS_RUNNING

disp(' ')

if GLAB_IS_RUNNING
    dispinfo(mfilename,'INFO','Stopping current GLab session...')
    GLAB_DISPLAY.doKeep = 0;
	try stopglab
    catch warning('DEBUG-INFO: Error while executing STOPGLAB.')
    end
end

dispinfo(mfilename,'INFO','Deleting all GLAB_* global variables...')
clear global cogent     % Cogent2000 global variable.
clear global GLAB_*     % G-Lab global variables.

dispinfo(mfilename,'INFO','Clearing all function (not only GLab''s ones!) from MATLAB memory...')
clear functions % <v2-alpha5>

dispinfo(mfilename,'INFO','GraphicsLab cleared. Programs will now run in the same conditions than after MATLAB''s startup.')
disp(' ')