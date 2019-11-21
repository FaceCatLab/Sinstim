function b = isptbinstalled
% ISPTB  True if PsychToolBox is installed.
%
% Ben, Jul 2011.

global COSY_GENERAL

if isfield(COSY_GENERAL,'isPTBInstalled')
    b = COSY_GENERAL.isPTBInstalled;
else
    b = exist('PsychToolboxroot') == 2;
end