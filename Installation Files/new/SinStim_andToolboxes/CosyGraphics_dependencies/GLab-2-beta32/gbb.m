function b = gbb
% GBB   Get Blank Buffer.
%	 b = GBB  returns the handle of the blank buffer. The blank buffer  
%    is automatically created at startup by G-Lab.
%
% See also GCB.
%
% Ben, Feb 2009

global GLAB_BUFFERS

b = GLAB_BUFFERS.BlankBuffer;