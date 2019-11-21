function resetabortflag
% RESETABORTFLAG  Reset abortion status.
%    RESETABORTFLAG  resets the abortion flag to 0.
%
% See also: ISABORTED, CHECKABORTKEY, RESETABORTFLAG, STOPFULLSCREEN.

global COSY_GENERAL

COSY_GENERAL.isAborted = 0;