function t = round2frame(t)
% ROUND2FRAME  "Round" a time to the closest multiplier of the frame period. {fast}
%    t = ROUND2FRAME(t)  rounds time t (msec) to the closest integer multiplier of the display
%    refresh cycles.
%
% See also: ROUND2FREQDIVISOR, ONEFRAME.

nf = round(t / oneframe);
t = nf * oneframe;