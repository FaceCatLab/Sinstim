function setcoordsystem(system,b)
% SETCOORDSYSTEM  <PTB only> Set coordinate system used by CosyGraphics/PTB/OpenGL. {fast}
%    SETCOORDSYSTEM CARTESIAN
%
%    SETCOORDSYSTEM SCREEN
%
%    SETCOORDSYSTEM('CARTESIAN',b)
%
%    SETCOORDSYSTEM('SCREEN',b)
%
% Ben, May 2011.

global COSY_DISPLAY

if ~isopen('display')
    error('No display open.')
end

if nargin<2, b=gcw; end
if b==0, b=gcw; end
if b==gcw
    [w,h] = getscreenres;
    xOffset = COSY_DISPLAY.Offset(1);
    yOffset = COSY_DISPLAY.Offset(2);
else
    [w,h] = buffersize(b);
    xOffset = 0;
    yOffset = 0;
end

switch(system)
    case 'cartesian',
        Screen('glLoadIdentity', b);
        Screen('glTranslate', b, w/2-xOffset, h/2-yOffset);
        Screen('glScale', b, 1, -1);
        
    case 'screen'
        Screen('glLoadIdentity', b);
        Screen('glTranslate', b, yOffset, -yOffset);
        
end