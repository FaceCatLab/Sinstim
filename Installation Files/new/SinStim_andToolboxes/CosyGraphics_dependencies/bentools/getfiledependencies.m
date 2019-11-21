function DepList = getfiledependencies(MFileName)
% GETFILEEPENDENCIES  <UNFINISHED>


%% Input Arg
MFileFullName = which(MFileName); % any kind of name -> fullname.
[p,MFileShortName] = filenameparts(MFileFullName);

%% Read file
fid = fopen(MFileFullName);
if fid < 0, error(['Cannot read file "' MFileFullName '".']), end
MFileContent = fscanf(fid,'%c');
fclose(fid);

%% Strip comments
isComment = sub_iscomment(MFileContent);
MFileContent(isComment) = [];

% Strip blanks
MFileContentNoBlank = MFileContent(MFileContent ~= ' ');

%% Parse content
isAphaNum = ismember(MFileContent, ['0':'9','A':'Z','_','a':'z']);
ii = find(isAphaNum);
[gg0,gg1] = findgroup(ii);
ii0 = ii(gg0);
ii1 = ii(gg1);

DepList = {};
for count = 1 : length(ii0)
    i0 = ii0(count);
    i1 = ii1(count);
    if ismember(MFileContent(i0), ['A':'Z','a':'z']);
        name = MFileContent(i0:i1);
        fullname = which(name);
        if ~isempty(fullname) && exist(name,'file') ...
                && ~strcmp(fullname,'variable') && ~strcmp(fullname,MFileFullName) ...
                && isempty(strfind(fullname,'built-in')) ...
                && isempty(strfind(fullname,fullfile(matlabroot,'toolbox','matlab')));
            DepList{end+1} = fullname;
%             ok = 1;
%             for i = 1 : length(DepList)
%                 if 
        end
    end
end
DepList = unique(DepList');

%% Output Arg
if ~nargout
    disp(' ')
    for i = 1 : length(DepList)
        disp(DepList{i})
    end
    disp(' ')
    
    clear DepList
end


%% SUB-FUN
function isComment = sub_iscomment(MFileContent)
% SUB_ISCOMMENT  True for commented text

% <note: CRs & LFs into comment are not 1 (!?!)>

if MFileContent(end) == 10
    isEndLF = 1;
else
    MFileContent(end+1) = 10;
    isEndLF = 0;
end
MFileContent(MFileContent==13) = 10; % CR -> LF
lf = find(MFileContent==10);
pc = find(MFileContent=='%');

isComment = false(size(MFileContent));

for c = 1 : length(pc);
    f = find(lf > pc(c));
    next_lf = lf(f(1));
    isComment(pc(c):next_lf) = 1;
end

if ~isEndLF
    isComment(end) = [];
end