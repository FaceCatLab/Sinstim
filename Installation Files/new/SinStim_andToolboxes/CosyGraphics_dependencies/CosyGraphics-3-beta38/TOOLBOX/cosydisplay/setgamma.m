function oldTABLE = setgamma(gamma)
% SETGAMMA  Set gamma value, for hardware gamma correction. {fast}
%    oldTABLE = SETGAMMA(gamma)
%    oldTABLE = SETGAMMA(TABLE)
%
% See also: GETGAMMA, GAMMAEXPAND, GAMMACOMPRESS.

global COSY_DISPLAY

if ~isptbinstalled
    msg = 'Gamma table manipulation is not supported by Cogent, and PsychTooBox is not installed. Gamma table unchanged!';
    warning(msg);
    dispinfo(mfilename,'error',msg);
    return 
end

if 1 % What to do ??? <debug>
    % Seems that Screen('LoadNormalizedGammaTable') divide by 256
    % instead of 255, when normalizing.
    TableMax = 255/256; % ???  
else
    TableMax = 1; % ???
end

if ischar(gamma)
    gamma = str2double(gamma); % for command syntax
end

% if isfield(COSY_DISPLAY,'Screen')
%     ScreenNum = COSY_DISPLAY.Screen;
% else
    ScreenNum = 0;
% end

if numel(gamma) == 1  % SETGAMMA(gamma)
    c = linspace(0,TableMax,256)';
    TABLE = gammaexpand([c c c],gamma);
else                  % SETGAMMA(TABLE)
    TABLE = gamma;
end

oldTABLE = Screen('LoadNormalizedGammaTable',ScreenNum,TABLE);

COSY_DISPLAY.Gamma = gamma;

if ~nargout, clear oldTABLE, end