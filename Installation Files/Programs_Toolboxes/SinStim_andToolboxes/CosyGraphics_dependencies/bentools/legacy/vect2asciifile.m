function vect2asciifile(filename,varargin)
% VECT2ASCIIFILE  Save vectors in a standard text file 
% (with TABs as column delimiters and CR + LF as row delimiters).
% Variables names are used as column labels.
%
%    vect2asciifile(filename,v1,v2,v3,...)


% Input Args
for i = 1 : length(varargin)
	varargin{i} = varargin{i}(:); % Make it vertical
end

% Constants
tab = char(9);
newline = char([13 10]);

% MAKE STRING TO SAVE
str = [];
for i = 1 : length(varargin)
	str = [str num2str(varargin{i}) repmat(tab,length(varargin{i}),1)];
end
str = [str repmat(newline,length(varargin{i}),1)]; % Add linefeed and carriage return
% matrix --> vector
str = str';
str = str(:)';
% Remove last linefeed and carriage return
str(end-1:end) = [];
% Add Titles
titles = '';
for i = 2 : length(varargin)+1
	titles = [titles inputname(i) tab];
end
str = [titles(1:end-1) newline str];

% SAVE FILE
fid = fopen(filename,'w');
fprintf(fid,'%s',str);
fclose(fid);