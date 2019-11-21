function setscore(N)
% SETSCORE  Set subject's current score value.
%    SETSCORE(N)  sets current total score to N points.

global COSY_SCORE % <Modular var: accessed only module's functions (!!)>

checkscoreopen;

COSY_SCORE.CurrentTotal = N;
