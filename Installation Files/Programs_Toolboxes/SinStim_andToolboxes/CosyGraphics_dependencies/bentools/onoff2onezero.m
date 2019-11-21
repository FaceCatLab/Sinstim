function b = onoff2onezero(s)
% ONOFF2ONEZERO  Convert 'On' and 'Off' to 1 and 0.
%    B = ONOFF2ONEZERO(S)  converts 'On'/'Off' string or cell array of string S, to logical vector B.
%
% See also ONEZERO2ONOFF.

% Ben, 11 June 2009

if iscell(s), c = s;
else          c = {s};
end

b = false(size(c));

for i = 1 : numel(c)
    if strcmpi(c{i},'on');
        b(i) = true;
    end
end