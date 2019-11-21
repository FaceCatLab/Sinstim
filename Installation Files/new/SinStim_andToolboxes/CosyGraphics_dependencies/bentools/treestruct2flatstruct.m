function sflat = treestruct2flatstruct(s,sep)
% TREESTRUCT2FLATSTRUCT  Convert structure containing sub-structure into "flat" structure (no sub-structures).
%    S = TREESTRUCT2FLATSTRUCT(S)
%    S = TREESTRUCT2FLATSTRUCT(S,SEP)

if ~exist('sep','var')
    sep = '__';
end

tree = fieldstree(s);

flatfields = tree;
for i = 1 : length(flatfields)
    ff = find(tree{i} == '.');
    for f = ff(end:-1:1)
        flatfields{i} = [flatfields{i}(1:f-1) sep flatfields{i}(f+1:end)];
    end
    sflat.(flatfields{i}) = eval(['s.' tree{i}]);
end