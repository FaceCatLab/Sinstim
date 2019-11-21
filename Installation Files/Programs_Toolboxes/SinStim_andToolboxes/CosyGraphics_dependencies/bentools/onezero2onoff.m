function s = onezero2onoff(b,alwaysCell)
% ONEZERO2ONOFF  Convert 1 and 0 to 'On' and 'Off'.
%    S = ONEZERO2ONOFF(B)  if B is a scalar, converts it to a string 'on' or 'off'. 0 becomes
%    'off' any other value becomes 'on' ; if B is an array, converts it to a cell array of
%    'on' and 'off' strings.
%
%    C = ONEZERO2ONOFF(B,'cell')  returns always a cell array.
%
% See also ONOFF2ONEZERO.

% Ben, 11 June 2009

c = cell(size(b));

for i = 1 : numel(c)
    if b(i)
        c{i} = 'on';
    else
        c{i} = 'off';
    end
end

if numel(b) == 1 && nargin < 2
    s = c{1};
else
    s = c;
end