function true = isabort
% ISABORT  True if Escape key has been pressed by the user.
%
% Example: Stop a program if Esc has been pressed:
%
%       if isabort
%           return
%       end
%
% Programmer's note: WAITFRAME and DISPLAYBUFFER always check
% if Escape key state: if down, they set the abort flag to 1.

global GLAB_IS_ABORT

if GLAB_IS_ABORT
    true = 1;
else
    true = 0;
end