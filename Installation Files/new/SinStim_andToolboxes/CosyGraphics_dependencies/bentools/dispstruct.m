function dispstruct(S)
% dispstruct(structure)


M = [];
inter = 3;


fields = fieldnames(S);

for j = 1 : length(fields)
    
    C = {};
    C{1} = fields{j}; 
    
    for i = 1 : length(S)
        x = getfield(S(i),fields{j});
        if isstruct(eval(['S(i).' fields{j}]));
            C{i+1} = '[substruct]';
        elseif isstr(x);
            C{i+1} = x;
        elseif length(x) > 1;
            C{i+1} = ['[' num2str(size(x,1)) ' x ' num2str(size(x,2)) ']'];
        elseif length(x) == 1;
            C{i+1} = num2str(x);
        else
            C{i+1} = '[]';
        end
    end
    
    M = [M repmat(' ',1+length(S),inter) char(C)];
end


M = [ M(1,:);...
      repmat('_',1,size(M,2));... % insert "____________"
      M(2:end,:) ];
rows = num2str((1 : length(S))');
rows = [ rows repmat(' ',size(rows,1),2) ];
rows = [ repmat(' ',2,size(rows,2));...
         rows ];
M = [ rows M ];


disp(' ')
disp(M)
disp(' ')