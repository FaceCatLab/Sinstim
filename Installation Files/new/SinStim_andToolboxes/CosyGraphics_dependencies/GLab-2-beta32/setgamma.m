function oldTABLE = setgamma(gamma);
% SETGAMMA  Set gamma value, for hardware gamma correction.
%    oldTABLE = SETGAMMA(gamma)
%    oldTABLE = SETGAMMA(TABLE)

global GLAB_DISPLAY

if 1 % What to do ??? <debug>
    % Seems that Screen('LoadNormalizedGammaTable') divide by 256
    % instead of 255, when normamizing.
    TableMax = 255/256; % ???  
else
    TableMax = 1; % ???
end

% if isfield(GLAB_DISPLAY,'Screen')
%     ScreenNum = GLAB_DISPLAY.Screen;
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

if ~nargout, clear oldTABLE, end