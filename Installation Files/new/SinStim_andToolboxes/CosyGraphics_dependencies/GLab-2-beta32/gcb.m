function buffer = gcb
% GCB   Get Current Buffer.
%	 b = GCB  returns the handle of the current offscreen buffer, i.e.: the
%    last buffer either created by NEWBUFFER or selected by SELECTBUFFER.
%
% See also GBB, GCW, NEWBUFFER, SELECTBUFFER.
%
% Ben, Sept 2007

global GLAB_BUFFERS

buffer = GLAB_BUFFERS.CurrentBuffer;