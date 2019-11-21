% CELL2VECTSTRUCT  Convert cell array to vector of structures.
%    S = CELL2VECTSTRUCT(C)
function s = cell2vectstruct(c)

s = [];

fields = c(1,:);
c(1,:) = [];

for j = 1 : length(fields)
    for i = 1 : size(c,1)
        s(i).(fields{j}) = c{i,j};
    end
end