function settext(varargin)
% SETTEXT   Set text default properties. {fast}
%    SETTEXT(S)  where S is a structure as returned by GETTEXT, sets all text properties.
%
%    SETTEXT(Property1,Value1,Property2,Value2,...)  sets given text property. Type 
%    "gettext" to get available properties.
%
%    SETTEXT(b,S) or SETTEXT(b,Property,Value)  <PTB only> sets text properties for 
%    buffer b. Default b value is 0 (the backbuffer of the onscreen window).
%    If CG is used as graphics library, the b argument is ignored (settings are global).
%
% See also GETTEXT, DRAWTEXT.


% Input Args
if isnumeric(varargin{1})
    b = varargin{1};
    varargin(1) = [];
else
    b = 0;
end
S = gettext; % Get current values, and use it as defaults.
if length(varargin) == 1,
    S = varargin{1};
else
    for p = 1 : 2 : nargin-1
        S.(varargin{p}) = varargin{p+1};
    end
end

% Set
if iscog % CG
    cgfont(S.FontName,S.FontSize);
    cgpencol(S.FontColor(1),S.FontColor(2),S.FontColor(3));
    
else % PTB
    if b == 0, b = gcw; end
    Screen('TextFont', b, S.FontName);
    Screen('TextSize', b, S.FontSize);
    if length(S.FontColor) == 3, S.FontColor(4) = 1; end % rgb -> rgba
    Screen('TextColor',b, S.FontColor * 255);  % <DEBUG: Doesn't seem to work !?!>
end