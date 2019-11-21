function printtriallog()
% PRINTTRIALLOG  <todo, unfinished>

global COSY_TRIALLOG

disptable(COSY_TRIALLOG.PERFRAME,'-h')
disp(' ')

disptable(COSY_TRIALLOG.PERDISPLAY,'-h')
disp(' ')