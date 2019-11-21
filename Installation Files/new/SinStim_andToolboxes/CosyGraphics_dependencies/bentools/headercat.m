function headers = headercat
% HEADERCAT  Concatenate headers of m-files of current dir.
%    headers = HEADERCAT;
%
% Ben, 	Nov. 2007

% 		Mar. 2008	Sep. at the end instead of beg.
%					Fixed bugs: 
%						- '.', '..' not the firsts. 
%						- Upper case file names.
%						- Empty files.

headers = '';
separator = [repmat([' ';'_';' ';' '],1,75) char(10*ones(4,1))];
separator = separator';
separator = char(separator(:)');

files = dir;

for f = 1 : length(files)
	filename = lower(files(f).name);
	if length(filename) >= 4 % 4: practical min. for a m-file.
		if filename(end) == 'm' && filename(end-1) == '.'
			fid = fopen(filename);
			content = fscanf(fid,'%c');
			fclose(fid);
			
			f = find(content == '%');
			if length(f)
				content = content(f(1):end);
				isLF = find(content == 10);
				isPC = strfind(content,[char(10) '%']);
				isNOTPC = setdiff(isLF,isPC);
				if length(isNOTPC)
					head = content(1:isNOTPC(1));
					headers = [headers head separator];
				end
			end
		end
	end
end
	
% fid = fopen(FileName,'w');
% count = fprintf(fid,'%s',File);
% fclose(fid);