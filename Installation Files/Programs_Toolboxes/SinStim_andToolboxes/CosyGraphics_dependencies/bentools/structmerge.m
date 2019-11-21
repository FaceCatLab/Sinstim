function c = structmerge(a,b)
% STRUCTMERGE  Merge two structures in one.
%    C = MSTRUCTERGE(A,B)
%
% See also: STRUCTCAT.

if numel(a) ~= numel(b)
    error('A and B do not have the same dimensions.')
end

c = a;
fields = fieldnames(b);

for i = 1 : numel(c)
    for f = 1 : length(fields)
        c(i).(fields{f}) = b(i).(fields{f});
    end
end