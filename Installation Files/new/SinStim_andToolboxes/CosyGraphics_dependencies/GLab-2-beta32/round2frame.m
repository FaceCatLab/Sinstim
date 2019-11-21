function t = round2frame(t)
% ROUND2FRAME  "Round" a time to the closest multiplier of the frame duration.
%    t = ROUND2FRAME(t)

nf = round(t / getframedur);
t = nf * getframedur;