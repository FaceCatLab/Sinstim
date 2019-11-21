function [RES,Hz] = getvalidscreenres(ScreenNum,ScreenFreq)
% GETVALIDSCREENRES  <TODO: what about it??>
%    WH = GETVALIDSCREENRES(ScreenNum)  returns resolutions supported by
%    your hardware at current screen frequency.
%
%    WH = GETVALIDSCREENRES(ScreenNum,ScreenFreq)  returns resolutions 
%    supported by your hardware at given screen frequency.
%
% See also:  GETSCREENRES.
%
% Ben, May 2011.



% Input Args
if nargin < 2
    ScreenFreq = getscreenfreq('nominal');
end

% Get Resolutions from PTB's Screen() function
s = Screen('Resolutions',0);

RAW = [[s.width]' [s.height]' [s.pixelSize]' [s.hz]']  % <for debug>


% Keep only 32 bit mode
is32 = [s.pixelSize] == 32;
s = s(is32);

% Keep only freq
if isnumeric(ScreenFreq)
    isFreq = [s.hz] == ScreenFreq;
    s = s(isFreq);
    
elseif strcmpi(ScreenFreq,'all')
    % <TODO>
    
end

%Output Vars
RES = [[s.width]' [s.height]'];
Hz  = [s.hz]';
