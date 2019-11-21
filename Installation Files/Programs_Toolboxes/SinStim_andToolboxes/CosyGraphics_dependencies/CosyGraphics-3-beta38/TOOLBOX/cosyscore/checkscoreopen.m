function checkscoreopen(p)
% CHECKSCOREOPEN  Helper function. Check score module initialization.
%    CHECKSCOREOPEN  issues an error if score not initialized (through OPENSCORE).

global COSY_SCORE % <Modular var: accessed only module's functions (!!)>

if ~(isfilledfield(COSY_SCORE,'isInitialized') && COSY_SCORE.isInitialized)
    if isopen('fullscreen'), stopcosy; end
    error('Score not initialized. You must use openscore before to call this function.')
end