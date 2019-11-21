function pix = deg2pix(deg)
% PIX2DEG  Degrees to pixels conversion.
%    pix = DEG2PIX(deg)
%
% See also DEG2PIX, SETSCREENSIZECM, SETVIEWINGDISTANCECM, SETHARDWARE<todo>.
%
% Ben, June 2010.

%% Get setup characteristics
[Wpix,Hpix] = getscreenres;
[Wcm, Hcm ] = getscreensizecm;
[Dcm, is57] = getviewingdistancecm;

%% deg -> cm
if is57 % 1 cm = 1 deg
    cm = deg;
else
    cm = tan(deg) * Dcm;
end

%% cm -> pix
pix = round(deg * Wpix / Wcm);