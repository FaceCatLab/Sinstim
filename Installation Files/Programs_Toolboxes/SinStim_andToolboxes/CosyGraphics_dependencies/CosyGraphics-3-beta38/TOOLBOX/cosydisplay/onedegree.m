function ms = oneframe
% ONEDEGREE  One degree distance, in pixels. {fast} <TODO: UNFINISHED!>
%    ONEDEGREE  
%
% See also GETFRAMEDUR, GETSCREENFREQ.
%
% Ben, July 2010.

global COSY_DISPLAY

if isempty(COSY_DISPLAY) || isempty(COSY_DISPLAY.MeasuredScreenFrequency) % CosyGraphics never started..
    dispinfo(mfilename,'warning','CosyGraphics has never been started. ...')
    % <TODO>
else                                                                      % CosyGraphics already started..
    % <TODO>
end