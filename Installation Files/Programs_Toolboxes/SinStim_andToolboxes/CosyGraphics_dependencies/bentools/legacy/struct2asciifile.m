function ok = Struct2AsciiFile(S,filename,pathname)
% ok = Struct2AsciiFile(S,filename,[pathname])


% Titles
%========

titles = fieldnames(S);

row1 = [];

for j = 1 : length(titles)
    row1 = [row1 titles{j} char(9)];  % TAB is ascii character n°9
end
row1 = [row1(1:end-1) char([13 10])];  % remove last TAB and add end of line

f = find(row1 == '_');
row1(f) = repmat(' ',1,length(f));  % replace underscores by spaces


% Data
%======

rows = row1;

for n = 1 : length(S)
    for j = 1 : length(titles)
        data = eval(['S(n).' titles{j}]);
        data = num2str(data);
        rows = [rows data char(9)];  % add TAB
    end
    rows = [rows(1:end-1) char([13 10])];  % remove last TAB and add end of line
end
rows = rows(1:end-2);
        

% Write file
%============

if nargin < 3
    pathname = [cd filesep];
end

fid = fopen([pathname filename],'w');
count = fprintf(fid,'%s',rows);
fclose(fid)

% if count
%     FILE.export_file = export_file;
%     helpdlg(['Saved to ' pathname filename]);
% else
%     errordlg('Can not save !')
% end