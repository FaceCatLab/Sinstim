function h = gcw
% GCW   Get current PTB onscreen window handle. (For PTB functions.) {fast}
%    h = GCW  returns handle of PTB open onscreen window.
%
%    Currently, multiple displays are not supported.

global COSY_DISPLAY

h = COSY_DISPLAY.BUFFERS.Backbuffer;

% if isptb
%     w = Screen('windows');
%     if isempty(w)
%         error('No open onscreen window')
%     end
%     h = w(1);
% else % CG: Always return 0 (handle of the backbuffer).
%     h = 0;
% end