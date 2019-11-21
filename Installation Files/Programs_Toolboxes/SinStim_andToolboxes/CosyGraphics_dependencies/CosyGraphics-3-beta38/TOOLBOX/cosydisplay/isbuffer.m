function bool = isbuffer(n)
% ISBUFFER  True for buffer handles.
%    ISBUFFER(n)  returns true if n is a handle of a existing offscreen buffer (see NEWBUFFER), false
%    otherwise.  If n is an array, returns an array of logical values.

global COSY_DISPLAY

bool = ismember(n, [0 COSY_DISPLAY.BUFFERS.OffscreenBuffers]);