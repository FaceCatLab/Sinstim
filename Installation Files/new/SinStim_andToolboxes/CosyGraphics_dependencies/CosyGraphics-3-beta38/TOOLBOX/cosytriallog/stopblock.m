function stopblock
% STOPBLOCK  End of block of trials - usefull only if several blocks without restarting CosyGraphics.

global COSY_TRIALLOG

COSY_TRIALLOG.iTrial = 0;

if checkeyelink('isrecording')
    stopeyelinkrecord;
end