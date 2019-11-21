function S = structcat(S1,S2)
% STRUCTCAT  Concatenate two vect. structures, keeping only common fields.
%    S = STRUCTCAT(S1,S2)

only1 = [];
only2 = [];

fields1 = fieldnames(S1);
fields2 = fieldnames(S2);

% Fields to be removed from S1:
for i = 1 : length(fields1)
    ok = 0;
    for ii = 1 : length(fields2)
        if strcmp(fields1{i},fields2{ii})
            ok = 1;
        end
    end
    if ~ok
        only1 = [only1 i];
    end
end

% Fields to be removed from S2:
for ii = 1 : length(fields2)
    ok = 0;
    for i = 1 : length(fields1)
        if strcmp(fields1{i},fields2{ii})
            ok = 1;
        end
    end
    if ~ok
        only2 = [only2 ii];
    end
end

% Remove fields:
S1 = rmfield(S1,fields1(only1));
S2 = rmfield(S2,fields2(only2));

% Concatenate structures
if size(S1,1) <= size(S1,2) % if horizontal..
    S = [S1 S2];
else,  % if vertical..
    S = [S1; S2];
end