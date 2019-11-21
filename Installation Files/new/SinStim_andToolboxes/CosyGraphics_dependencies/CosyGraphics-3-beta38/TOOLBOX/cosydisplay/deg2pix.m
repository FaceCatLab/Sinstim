function pix = deg2pix(deg)
% DEG2PIX  Degrees to pixels conversion. {fast}
%    pix = DEG2PIX(deg)  converts degree to pixels. CosyGraphics must have been started at least once.
%
% See also DEG2PIX, SETSCREENSIZECM, SETVIEWINGDISTANCECM, SETHARDWARE<todo>.
%
% Ben, June 2010.

global COSY_DISPLAY

%% Checks
if ~isfield(COSY_DISPLAY,'Resolution')
    error('Display not initialized. You must first have started a display before to call DEG2PIX.')
elseif COSY_DISPLAY.Screen == 0
    dispinfo(mfilename,'warning','Degrees to pixels convertion will be incorrect in windowed display mode.')
end

%% Get setup characteristics
[Wpix,Hpix] = getscreenres;
[Wcm, Hcm ] = getscreensizecm;
[Dcm, is57] = getviewingdistancecm;

%% deg -> rad
rad = deg * pi/180;

%% deg -> cm
if is57 % 1 cm = 1 deg  (linear conversion)
    cm = deg;
else
    cm = tan(rad) * Dcm;
end

%% cm -> pix
pix = cm * Wpix / Wcm;
if iscog
    round(pix); % Round for Cogent (PTB has sub-pixel precision)
end