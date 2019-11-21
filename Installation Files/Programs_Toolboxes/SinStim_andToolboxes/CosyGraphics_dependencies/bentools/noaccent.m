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
    % ������ --> A
    f = find(str >= '�' & str <= '�');
    str(f) = repmat('A',1,length(f));
    f = find(str >= '�' & str <= '�');
    str(f) = repmat('a',1,length(f));
    
    % � --> C
    f = find(str == '�');
    str(f) = repmat('C',1,length(f));
    f = find(str == '�');
    str(f) = repmat('c',1,length(f));
    
    % ���� --> E
    f = find(str >= '�' & str <= '�');
    str(f) = repmat('E',1,length(f));
    f = find(str >= '�' & str <= '�');
    str(f) = repmat('e',1,length(f));
    
    % ���� --> I
    f = find(str >= '�' & str <= '�');
    str(f) = repmat('I',1,length(f));
    f = find(str >= '�' & str <= '�');
    str(f) = repmat('i',1,length(f));
    
    % � --> N
    f = find(str == '�');
    str(f) = repmat('N',1,length(f));
    f = find(str == '�');
    str(f) = repmat('n',1,length(f));
    
    % ����� --> O
    f = find(str >= '�' & str <= '�');
    str(f) = repmat('O',1,length(f));
    f = find(str >= '�' & str <= '�');
    str(f) = repmat('o',1,length(f));
    
    % ���� --> U
    f = find(str >= '�' & str <= '�');
    str(f) = repmat('U',1,length(f));
    f = find(str >= '�' & str <= '�');
    str(f) = repmat('u',1,length(f));
    
    % � --> Y, � --> Y
    f = find(str == '�' | str == '�');
    str(f) = repmat('Y',1,length(f));
    f = find(str >= '�' & str <= '�');
    str(f) = repmat('y',1,length(f));
    
    % � --> S
    f = find(str == '�');
    str(f) = repmat('S',1,length(f));
    f = find(str == '�');
    str(f) = repmat('s',1,length(f));
    
    % � --> Z
    f = find(str == '�');
    str(f) = repmat('Z',1,length(f));
    f = find(str == '�');
    str(f) = repmat('z',1,length(f));
end
