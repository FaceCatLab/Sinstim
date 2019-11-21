function deg = pix2deg(pix)
% PIX2DEG  Pixels to degrees conversion.
%    deg = PIX2DEG(pix)
%
% See also DEG2PIX, SETSCREENSIZECM, SETVIEWINGDISTANCECM, SETHARDWARE<todo>.
%
% Ben, June 2010.

% <TODO: manage VIEWING DISTANCE !!!>

%% Get setup characteristics
[Wpix,Hpix] = getscreenres;
[Wcm, Hcm ] = getscreensizecm;
[Dcm, is57] = getviewingdistancecm;

%% pix -> cm
cm = pix * Wcm / Wpix;

%% cm -> deg
if is57 % 1 cm = 1 deg
    deg = cm;
else
    deg = atan(cm / Dcm);
end