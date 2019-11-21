function h = gcw
% GCW   Get current PTB onscreen window handle. (For PTB only).
%    h = GCW  returns handle of PTB open onscreen window.
%
%    Currently multiple displays are not supported.
%
% See also GCB.

global GLAB_BUFFERS

h = GLAB_BUFFERS.BackbufferOfOnscreenWindow;

% if isptb
%     w = Screen('windows');
%     if isempty(w)
%         error('No open onscreen window')
%     end
%     h = w(1);
% else % CG: Always return 0 (handle of the backbuffer).
%     h = 0;
% end