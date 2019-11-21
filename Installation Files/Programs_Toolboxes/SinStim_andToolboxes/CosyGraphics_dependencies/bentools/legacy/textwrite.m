function text = textwrite(filename,varargin)
% TEXTWRITE  Export Matlab variables to a standard TAB delimited ASCII file.
%   TEXTWRITE(filename,column1,column2,...)
%
%   'column1','column2',... can be numerical vectors or matrices, string arrays or cell arrays.
%   Variable names give column titles for the table.

% v2, Accept matrices as arguments


% FILE CONTENT

% Input Arg.: Ensure that vectors are verticals
for j = 1 : length(varargin)
	if size(varargin{j},1) == 1 && size(varargin{j},2) > 1
		varargin{j} = varargin{j}';
	end
end

% Var
TAB = char(9);  % tabulation
LF  = char(10); % line feed
CR  = char(13); % carriage return
text = [];

% Column titles
for j = 1 : length(varargin)
	if size(varargin{j},2) == 1 || ischar(varargin{j}) % If it's a vector, or any character array..
		text = [text inputname(j+1) TAB];
	else % If it's a numeric matrix or a cell matrix..
		for col = 1 : size(varargin{j},2)
			text = [text inputname(j+1) int2str(col) TAB];
		end
	end
end
text(end:end+1) = [CR LF];
	
% Table
for i = 1 : size(varargin{1},1)
	for j = 1 : length(varargin)
		arg = varargin{j};
		if ischar(arg) % It's a char. array..
			s = arg(i,:);
			if s == 0, s = 'NaN'; end % 0 in strings cause bugs in C.
			text = [text s TAB];
		else % It's a double or a cell array..
			for col = 1 : size(arg,2)
				if isnumeric(arg),	s = num2str(arg(i,col));
				elseif iscell(arg), s = num2str(arg{i,col});
				end
				text = [text s TAB];
			end
		end
	end
	text(end:end+1) = [CR LF];
end


% WRITE FILE

fid = fopen(filename,'w');
fprintf(fid,'%s',text);
fclose(fid);