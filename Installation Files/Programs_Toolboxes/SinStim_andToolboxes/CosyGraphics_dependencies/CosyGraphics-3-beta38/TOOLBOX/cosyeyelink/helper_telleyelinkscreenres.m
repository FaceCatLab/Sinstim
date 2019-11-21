function helper_telleyelinkscreenres(wh, CallerName)
% HELPER_TELLEYELINKSCREENRES  Tell EyeLink PC what's the screen resolution (actual or virtual).
%    This helper function is used by OPENEYELINK, OPENSIDPLAY, SETOFFSETY. 
%
%    HELPER_TELLEYELINKSCREENRES(WH, CallerName) 
%
%    Example:
%        if isopen('eyelink')
%            helper_telleyelinkscreenres(getscreenres, mfilename);
%        end

Width  = wh(1);
Height = wh(2);

try 
    Eyelink('command', 'screen_pixel_coords = %ld %ld %ld %ld', 0, 0, Width-1, Height-1);
    Eyelink('message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, Width-1, Height-1);

    str = sprintf('Told EyeLink PC that the display resolution is: %dx%d.', Width, Height);
    dispinfo(CallerName,'info',str);
    
catch
    error('Error while sendind command to EyeLink PC.')
    
end

