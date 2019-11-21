function [Names,Sizes,Classes] = fieldstree(s)
% FIELDSTREE  Full name, size and class of every sub-field in a structure.
%    NAMES = FIELDSTREE(S) returns a cell array of strings containing the 
%    structure field and sub-field of the structure s. Names of fields, sub-fields,
%    sub-sub-fields, etc. are separated by dots.
%
%    [NAMES,SIZES,CLASSES] = FIELDSTREE(S)  returns also sizes and classes of elements.

Names = {};
Sizes = [];
Classes = {};
if length(s) > 1
    s = s(1);
end

% name0 = inputname(s);
fields = fieldnames(s);

for f = 1 : length(fields)
    field = fields{f};
    if ~isstruct(s(1).(field))
        % If field is not a sub-structure, we are at the end of the tree branch
        Names{end+1} = field;
        siz = size(s(1).(field));
        Sizes(end+1,1:length(siz)) = siz;
        Classes{end+1} = class(s(1).(field));
    else
        % If field is a sub-structure, we call the function recursively
        [names1,sizes1,classes1] = fieldstree(s(1).(field));  % <=== RECURSIVE CALL !!!
        for f1 = 1 : length(names1)
            Names{end+1}   = [field '.' names1{f1}];
            Sizes(end+1,1:size(sizes1,2)) = sizes1(f1,:);
            Classes{end+1} = classes1{f1};
        end
    end
end

Names = Names(:);
Classes = Classes(:);