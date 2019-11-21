function indexes = findwordi(c,word)
% indexes = findwordi(c,word)
%
% Find given word in the cell vector c (case insentive)
%
% see also FINDWORDI

indexes = [];
for i = 1 : length(c(:))
    if strcmpi(c{i},word)
        indexes = [indexes i];
    end
end

