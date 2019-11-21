function str = noaccent(str)
% NOACCENT  Remove accents in a string or in a cell array of strings
%    B = NOACCENT(A)

% ben  25-8-2006


if iscell(str)                   
    % If it's a cell array, call the function recursively for each element:
    for i = 1 : length(str(:))
        if ischar(str{i})
            str{i} = noaccent(str{i}); 
        end
    end
    
else
    % ÀÁÂÃÄÅ --> A
    f = find(str >= 'À' & str <= 'Å');
    str(f) = repmat('A',1,length(f));
    f = find(str >= 'à' & str <= 'å');
    str(f) = repmat('a',1,length(f));
    
    % Ç --> C
    f = find(str == 'Ç');
    str(f) = repmat('C',1,length(f));
    f = find(str == 'ç');
    str(f) = repmat('c',1,length(f));
    
    % ÈÉÊË --> E
    f = find(str >= 'È' & str <= 'Ë');
    str(f) = repmat('E',1,length(f));
    f = find(str >= 'è' & str <= 'ë');
    str(f) = repmat('e',1,length(f));
    
    % ÌÍÎÏ --> I
    f = find(str >= 'Ì' & str <= 'Ï');
    str(f) = repmat('I',1,length(f));
    f = find(str >= 'ì' & str <= 'ï');
    str(f) = repmat('i',1,length(f));
    
    % Ñ --> N
    f = find(str == 'Ñ');
    str(f) = repmat('N',1,length(f));
    f = find(str == 'ñ');
    str(f) = repmat('n',1,length(f));
    
    % ÒÓÔÕÖ --> O
    f = find(str >= 'Ò' & str <= 'Ö');
    str(f) = repmat('O',1,length(f));
    f = find(str >= 'ò' & str <= 'ö');
    str(f) = repmat('o',1,length(f));
    
    % ÙÚÛÜ --> U
    f = find(str >= 'Ù' & str <= 'Ü');
    str(f) = repmat('U',1,length(f));
    f = find(str >= 'ù' & str <= 'ü');
    str(f) = repmat('u',1,length(f));
    
    % İ --> Y, Ÿ --> Y
    f = find(str == 'İ' | str == 'Ÿ');
    str(f) = repmat('Y',1,length(f));
    f = find(str >= 'ı' & str <= 'ÿ');
    str(f) = repmat('y',1,length(f));
    
    % Š --> S
    f = find(str == 'Š');
    str(f) = repmat('S',1,length(f));
    f = find(str == 'š');
    str(f) = repmat('s',1,length(f));
    
    %  --> Z
    f = find(str == '');
    str(f) = repmat('Z',1,length(f));
    f = find(str == '');
    str(f) = repmat('z',1,length(f));
end
