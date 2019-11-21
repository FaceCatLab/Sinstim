function [TreeStr,TreeCell] = dispstructree(Struc)
% DISPSTRUCTREE  Print tree hierachy diagram of a structure.
%    DISPSTRUCTREE(S)  prints the field organigram of structure S in the form:
%
%            Level 1
%              |
%              |-- Level 2
%              |     |
%              |     |-- Level 3
%              |     +-- Level 3
%              +-- Level 2
%
% Ben, Jul 2011.

%% Parmas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nIndent0 = 1;
nIndent  = 3;
Branch = '-->.';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Names of fields
Fields = fieldnames(Struc);
nFields = length(Fields);

%% Cell
TreeCell = cell(nFields,1);
TreeCell{1} = inputname(1);
for f = 1 : nFields
    TreeCell{f+1} = [blanks(nIndent0), '|', Branch, Fields{f}];
end
TreeCell{end}(nIndent0+1) = '+'; % last '|' -> '+'

%% Sub-structures: Recursive calls
for f = nFields : -1 : 1
    if isempty(Struc), content = Struc.(Fields{f});
    else               content = Struc(1).(Fields{f});
    end
    if isstruct(content)
        [SubTreeStr,SubTreeCell] = dispstructree(content);  % <===RECURSIVE-CALL===!!!
        SubTreeCell(1) = []; % suppr first level
        if f+1 ~= length(TreeCell)
            v = find(TreeCell{f+1} == '|');
        else
            v = [];
        end
        for subf = length(SubTreeCell) : -1 : 1 % from bottom to first horiz branch (see break)..
%             if ~isempty(strmatch([blanks(nIndent0), '|', Branch], SubTreeCell{subf}))
%                 break % found last horiz branch => continue in next loop !!
%             end
            SubTreeCell{subf} = [blanks(nIndent0), ' ', blanks(nIndent), SubTreeCell{subf}]; % ..add one level indent without '|'.
            SubTreeCell{subf}(v) = '|';
        end
%         for subf = subf : -1 : 1 % first horiz branch (break) to top..
%             SubTreeCell{subf} = [blanks(nIndent0), '|', blanks(nIndent), SubTreeCell{subf}]; % ..add one level indentwith '|'.
%         end
        supra = TreeCell(1:f+1);   % <MATLAB BUG !!! On M7.5, particular case TreeCell(end-1:end) returns a 1x2 and not 2x1 cell !!!>
        supra = supra(:);          % <fix it!>
        infra = TreeCell(f+2:end); % <MATLAB BUG !!! On M7.5, particular case TreeCell(end-1:end) returns a 1x2 and not 2x1 cell !!!>
        infra = infra(:);          % <fix it!>
        TreeCell = [supra; SubTreeCell; infra];
    end
end

%% Cell -> String
TreeStr = '';
for i = 1 : length(TreeCell)
    TreeStr = [TreeStr TreeCell{i} 10];
end

%% Ouput
if nargout == 0
    disp(' ')
    disp(TreeStr)
    clear TreeStr
end