function n = getscore
% GETSCORE  Get subject's current total score.
%   N = GETSCORE  returns current total of points.

global COSY_SCORE % <Modular var: accessed only module's functions (!!)>

checkscoreopen;

n = COSY_SCORE.CurrentTotal;