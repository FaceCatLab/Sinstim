function h = storeanimatedimage(C)
% STOREANIMATEDIMAGE  Store a serie of images constituting an animation in video offscreen buffers. {slow}
%    a = STOREANIMATEDIMAGE(C)  stores the images contained in the cell array C into offscreen buffers
%    in the graphics board's memory, and returns an handle a.  'a' can then be passed to COPYBUFFER
%    like a standard buffer handle.
%
% See also LOADIMAGE, STOREIMAGE, COPYBUFFER.
%
% Ben, Oct 2011.

% Programmer's note:
% The only other function which uses COSY_DISPLAY.BUFFERS.ANIMATIONS is copybuffer.

global COSY_DISPLAY

Buffers = storeimage(C);

n = length(COSY_DISPLAY.BUFFERS.ANIMATIONS);
h = -(n+1);

COSY_DISPLAY.BUFFERS.ANIMATIONS(n+1).AnimationHandle = h;
COSY_DISPLAY.BUFFERS.ANIMATIONS(n+1).Buffers = Buffers;
COSY_DISPLAY.BUFFERS.ANIMATIONS(n+1).nBuffers = length(Buffers);
COSY_DISPLAY.BUFFERS.ANIMATIONS(n+1).iCurrentBuffer = 1;

% COSY_DISPLAY.BUFFERS.ANIMATIONS(n+1) = a;