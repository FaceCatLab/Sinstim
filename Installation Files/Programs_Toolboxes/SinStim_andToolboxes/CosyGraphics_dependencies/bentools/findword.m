function indexes = findword(c,word)
% indexes = findword(c,word)
%
% Find given word in the cell vector c (case sentive)
%
% see also FINDWORDI

indexes = [];
for i = 1 : length(c(:))
    if strcmp(c{i},word)
        indexes = [indexes i];
    end
end