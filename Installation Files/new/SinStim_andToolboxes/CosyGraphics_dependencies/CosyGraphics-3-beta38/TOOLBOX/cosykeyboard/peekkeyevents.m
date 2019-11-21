function [Times,IDs,isDown] = peekkeyevents
% PEEKKEYEVENTS  Return keyboard events without clearing the event stack. <NOT YET FULLY INTEGRATED!>
%    [Times,IDs,isDown] = PEEKKEYEVENTS  returns key events since last call 
%    to GETKEYEVENT without modifying the keyboard event stack.
%
% See also GETKEYEVENTS, CHECKKEYDOWN.

[Times,IDs,isDown] = getkeyevents('Peek');
