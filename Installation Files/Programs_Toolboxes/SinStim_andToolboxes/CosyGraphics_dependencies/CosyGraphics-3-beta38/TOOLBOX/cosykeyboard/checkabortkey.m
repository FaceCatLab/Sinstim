function b = checkabortkey
% CHECKABORTKEY  True if Escape key has been pressed. Update abortion flag.
%    b = CHECKABORTKEY  updates the abortion flag used by ISABORTED.

global COSY_GENERAL

b = COSY_GENERAL.isAborted;

if ~b
    b = checkkeydown('Escape');
    if b, COSY_GENERAL.isAborted = true; end
end

if b
    dispinfo(mfilename,'warning','Abortion key (Esc) has been pressed by the user. Aborting...')
end