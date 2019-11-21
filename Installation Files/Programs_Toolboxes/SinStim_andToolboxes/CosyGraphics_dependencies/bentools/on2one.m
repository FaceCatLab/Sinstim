function b = on2one(str)
% b = on2one(str)  Convert 'On'/'Off' string or string cell "str",
%                  to vector of booleans "B"


if iscell(str), c = str;
else,           c = {str};
end

b = zeros(size(c));

for i = 1 : length(b)
    if strcmpi(c{i},'on');
        b(i) = 1;
    end
end
     