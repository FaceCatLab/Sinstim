function drawscoredigit(points,P,b)
% DRAWSCOREDIGIT  Draw a score bar.
%    DRAWSCOREDIGIT(<points,> <P,> <b>)  draws a score bar.  If 'points' is ommited, the current  
%    total (see GETSCORE) will be used.  P is a structure containing score properties as returned  
%    by GETSCOREPROPERTIES (only Bar* fields will be used) ; if ommited, the current properties 
%    of 'CurrentTotal' will be applied.  b is a buffer handle ; if ommited the default is 0.
%
% See also DRAWSCOREBAR, DISPLAYSCORE.

%% Input Args
if nargin < 1, points = getscore; end
if nargin < 2, P = getscoreproperties('CurrentTotal'); end
if nargin < 3, b = 0; end

%% Draw Bar
str = num2str(points);
if points > 0
    if P.DigitPositiveWithPlus,  str = ['+' str];  end
    rgb = P.DigitColorSuccess;
elseif points < 0
    rgb = P.DigitColorFailure;
else
    if P.DigitPositiveWithPlus, str = ['+' str]; end
    rgb = P.DigitColorNeutral;
end
str = [P.DigitPrependString str P.DigitAppendString];
drawtext(str, 0, [P.DigitX P.DigitY], P.DigitFont, P.DigitSize, rgb);