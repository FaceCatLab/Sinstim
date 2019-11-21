function addtoscore(n)
% ADDTOSCORE  Increment subject's score.
%    ADDTOSCORE(n)  adds n noints to current score.  The n value can then be displayed to
%    the subject by DISPLAYSCORE CURRENT. 

global COSY_SCORE % <Modular var: accessed only module's functions (!!)>

checkscoreopen;

COSY_SCORE.LastIncrement = n;
COSY_SCORE.CurrentTotal = COSY_SCORE.CurrentTotal + n;
