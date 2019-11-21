function mat2asciifile(M,filename,pathname)
% MAT2ASCIIFILE  Save a matrix in a standard text file 
% (with TABs as column delimiters and CR + LF as row delimiters).
%    mat2asciifile(M)
%    mat2asciifile(M,filename)
%    mat2asciifile(M,filename,pathname)


% Input Arg.
if nargin < 2
	[filename,pathname] = uiputfile('*.txt','Save as...');
	filename = [filename '.txt'];
elseif nargin == 2
	pathname = pwd;
end

% Make string to save
str = [];
for i = 1 : size(M,1)
	for j = 1 : size(M,2)
		str = [str num2str(M(i,j)) char(9)]; % TAB is ascii character n°9
	end
	str(end) = []; % Remove last TAB
	str = [str char([13 10])]; % Add linefeed and carriage return
end
str(end-1:end) = []; % Remove last linefeed and carriage return

% Save file
fid = fopen(filename,'w');
c=fprintf(fid,'%s',str);
fclose(fid);