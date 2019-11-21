function S = gettext(b)
% GETTEXT   Get text current settings.
%    S = GETTEXT  returns text settings (backbuffer) in structure S.
%    For PTB, the settings returned are settings of the backbuffer.
%
%    S = GETTEXT(b)  returns text settings of buffer b. <PTB only. CG: b arg. will be ignored.> 
%
% See also SETTEXT, DRAWTEXT.

if ~nargin, b = 0; end

if iscog % CG: Settings are global for all operations. Argument "b" is ignored.
    GPD = cgGetData('GPD');
    S.FontName = GPD.Fontname;
    S.FontSize = GPD.PointSize;
    S.FontColor = [GPD.DrawCOL.CR.Red GPD.DrawCOL.CR.Grn GPD.DrawCOL.CR.Blu] / 255;
    
else % PTB: Settings are specific to one buffer (window).
    if b == 0, b = gcw; end
    S.FontName  = Screen('TextFont',b);
    S.FontSize  = Screen('TextSize',b);
    S.FontColor = Screen('TextColor',b) / 255;  % <DEBUG: Doesn't seem to work !?!>
    % Screen('TextColor') returns a rgba (1-by-4) vector. If no alpha, alpha value 
    % is inf. Let's fix that:
    if length(S.FontColor) == 4 && S.FontColor(4) >= 1, S.FontColor(4) = []; end
end