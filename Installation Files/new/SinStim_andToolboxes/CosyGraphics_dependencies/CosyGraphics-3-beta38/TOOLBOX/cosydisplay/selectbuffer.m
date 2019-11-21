function selectbuffer(b)
% SELECTBUFFER   Select buffer b for subsequent use of CogentGraphics (cg*) functions. {fast}
%    The buffer becomes the "current buffer" (see GCB).
%    This function has no effect on other functions than CogentGraphics' ones.
%
%    SELECTBUFFER(b)  selects buffer # b.
%
% Ben, Oct 2007

global COSY_DISPLAY

if iscog
    cgsetsprite(b);
end
COSY_DISPLAY.BUFFERS.CurrentBuffer4CG = b;
