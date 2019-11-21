function setviewingdistancecm(d)
% SETVIEWINGDISTANCECM  Define eye to screen distance.
%    SETVIEWINGDISTANCECM(D)  sets eye-screen distance as D cm. This value will be used by DEG2PIX
%    and PIX2DEG in place of the default. Default value is 360/(2*pi) = 57.2958 cm, distance at 
%    which 1 cm = 1 deg.
%
%    SETVIEWINGDISTANCECM(57)  resets to default (i.e.: 57.2958 cm, see above). 
%
% See also GETVIEWINGDISTANCECM, SETSCREENSIZECM, GETSCREENSIZECM, DEG2PIX, PIX2DEG.

global GLAB_DISPLAY

if floor(d) == 57 % Standard distance: 57 cm
    d = 360/(2*pi);
    msg = 'Viewing distance set to 360/(2*pi) = 57.2958 cm. At this distance, 1 cm = 1 deg.';
else % Non standard distance
    % Compute cm/deg value:
    rad = atan(1/d);
    deg = rad * 180 / pi;
    % Disp info:
    msg = ['Viewing distance set to ' num2str(d) ' cm. At this distance, 1 cm = ' num2str(deg) ' deg.'];
end

GLAB_DISPLAY.ViewingDistance_cm = d;

dispinfo(mfilename,'info',msg);