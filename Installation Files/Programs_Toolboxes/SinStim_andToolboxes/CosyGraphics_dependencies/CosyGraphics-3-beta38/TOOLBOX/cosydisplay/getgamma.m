function gamma = getgamma
% SETGAMMA  Get current gamma value. {fast}

global COSY_DISPLAY

if isfield(COSY_DISPLAY,'Gamma')
    gamma = COSY_DISPLAY.Gamma;
else
    gamma = 1;
end