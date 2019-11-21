function b = isaborted
% ISABORTED  True if Escape key has been pressed.
%    The DISPLAYBUFFER, WAITFRAME and WAITMOUSECLICK always check the status of the Escape key. 
%    If down, they set the abort flag to 1.  ISABORTED returns the status of this flag.  (For 
%    performance reason, it doesn't check the actual status of the key ; use CHECKABORTKEY for
%    that.)  <TODO: Add abortion check in all other WAIT* functions.>
%
% Example: Stop a program if Esc has been pressed:
%
%       if isaborted
%           stopcosy;
%           return %     <=== RETURN ===!!!
%       end
%
% See also: CHECKABORTKEY, RESETABORTFLAG, STOPFULLSCREEN.

global COSY_GENERAL

b = COSY_GENERAL.isAborted;
