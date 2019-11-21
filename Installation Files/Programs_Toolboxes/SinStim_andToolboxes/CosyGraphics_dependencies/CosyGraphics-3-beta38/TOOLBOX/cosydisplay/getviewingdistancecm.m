function [d,is57] = getviewingdistancecm
% GETVIEWINGDISTANCECM  Get eye-to-screen distance. {fast}
%    D = GETVIEWINGDISTANCECM  returns eye-screen distance in cm. 
%
%    [D,is57] = GETVIEWINGDISTANCECM  returns also, as second output element, a flag which value   
%    is 1 ("true") if viewing distance is 360/(2*pi) = 57.2958 cm, distance at which 1 cm = 1 deg. 
%
% See also SETVIEWINGDISTANCECM, GETSCREENSIZECM.

global COSY_DISPLAY

if isfilledfield(COSY_DISPLAY,'ViewingDistance_cm')
    d = COSY_DISPLAY.ViewingDistance_cm;
    if floor(d) == 57,  is57 = true;
    else                is57 = false;
    end
else % CosyGraphics display not open, viewing distance not set..
    d = 360/(2*pi); % ..use default.
    is57 = true;
end