function selectbuffer(b)
% SELECTBUFFER   Select buffer b for subsequent use of cg* (CogentGraphics) functions.
%    The buffer becomes the "current buffer" (see GCB).
%    This function has no effect on PTB low-level functions.
%
%    SELECTBUFFER(b)
%
% Ben, Oct 2007

global GLAB_BUFFERS

if iscog
    cgsetsprite(b);
end
GLAB_BUFFERS.CurrentBuffer = b;
