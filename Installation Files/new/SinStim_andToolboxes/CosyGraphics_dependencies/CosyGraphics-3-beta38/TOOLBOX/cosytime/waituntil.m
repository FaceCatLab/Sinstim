function waituntil(t)
% WAITUNTIL  Waits until specified time.
%    WAITUNTIL(t)  Wait until specified time (as measured by function TIME).
%
% Example:
%    t0 = time;
%    waituntil(t0 + 1000);
%
% See also : WAIT, WAITSYNCH.
%
% CosyGraphics function.

% Ben Oct. 2007  Same as Cogent 2000 function, just changed documentation.

while(time < t)
end