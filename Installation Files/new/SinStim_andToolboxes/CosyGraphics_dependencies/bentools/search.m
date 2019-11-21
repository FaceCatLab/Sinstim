function [FILES,LINES] = search(varargin)
% SEARCH  Search expression in m-files or other text files.
%    SEARCH(Exp)  searches expression 'Exp' in all M-files of the
%    current directory and it's sub-direcories. 'Exp' can be a 
%    regular expression (see REGEXP). Results are displayed in 
%    the Command Window. Same as: SEARCH(STR,'M').
%
%    SEARCH(Exp,FileExt)  searches in files with extension 'FileExt'.
%
%    SEARCH(Exp,FileExt,Dir)  searches in directory 'Dir'.
%
%    SEARCH('-i',...)  ignores case.
%
%    SEARCH('-l',...)  displays lines.
%
%    SEARCH('-s',...)  silent mode: do not displays results in Command window.
%
%    [FILES,LINES] = SEARCH(...) returns file names and line numbers 
%       in cell arrays.
%
%   See also REPLACE.
%
% Ben,   dec 2006	1.0

%        jan 2007	1.0.1   Clear output var. if nargout == 0.
%        dec		1.1		Fix case where '.' and '..' are not the two first files.
%        dec		1.2		'-i' option.
%        mar 2008	1.3		Regular Expressions.
%        apr		1.4		'-l' option.
%        apr		1.4.1	Don't display results if output arguments. <BUG! (recursive calls)>
%        may		1.4.2	Revert 1.4.1 to 1.4.0.
%        may		1.4.3	Cosmetic.
%        feb 2009	1.5		'-s' option.

%<TODO: '-s' option (silent);


% Input Args

isInsensitive = 0;
doDisplayLines = 0;
isSilent = 0;
Options = {};
for i = length(varargin) : -1 : 1
	if ischar(varargin{i})
		if strcmpi(varargin{i},'-i')
			isInsensitive = 1;
            Options{end+1} = '-i';
			varargin(i) = [];
		elseif strcmpi(varargin{i},'-l')
			doDisplayLines = 1;
            Options{end+1} = '-l';
			varargin(i) = [];
        elseif strcmpi(varargin{i},'-s')
			isSilent = 1;
            Options{end+1} = '-s';
			varargin(i) = [];
		end
	end
end
if length(varargin) >= 1, Exp = varargin{1};
else                      error('Argument EXP undefined.')
end
if isInsensitive, Exp = lower(Exp); end
if length(varargin) >= 2, FileExt = varargin{2};
else                      FileExt   = 'm';
end
if length(varargin) >= 3, SearchDir = varargin{3};
else                      SearchDir = cd;
end
if SearchDir(end) ~= filesep, SearchDir(end+1) = filesep; end

FILES = {};
LINES = {};

pd = cd;
cd(SearchDir) % ----!

list = dir;


% 1) Files

for i = find(~[list.isdir])
	f = find(list(i).name == '.');
	if length(f) && ( strcmpi(list(i).name(f(1)+1:end),FileExt) | strcmp(FileExt,'*') )
		
		% Read file
		fid = fopen(list(i).name);
		if fid == -1, error(['Impossible de lire le fichier ' list(i).name]), end
		content = fscanf(fid,'%c'); % Crée un vecteur "File" au format string, avec le contenu du fichier ascii.
		fclose(fid);
		
		% Find string
		if isInsensitive, 	ff = regexpi(content,Exp);
		else				ff = regexp(content,Exp);
		end
		linefeeds = find(content == 10);
		lines = [];
		for f = ff 
			line = length(find(linefeeds < f)) + 1;
			lines = [lines line];
		end
		if length(lines)
            if ~isSilent
                disp(['Found in ''' cd filesep list(i).name ''', at line:  ' num2str(lines)])
            end
			FILES = [FILES; {[SearchDir list(i).name]}];
			LINES = [LINES; {lines}];
			if doDisplayLines
				linefeeds(end+1) = length(content) + 1; % for particular case we found last line.
				for l = lines
					i0 = 1;
					i1 = length(content);
					if l > 1, 					i0 = linefeeds(l-1) + 1; end
					if l <= length(linefeeds), 	i1 = linefeeds(l) - 1;   end
% 					disp([repmat(' ',1,5-length(int2str(l))) int2str(l) ': |' content(i0:i1)])
				end
			end
		end
	end
end


% 2) Folders (--> recursive calls!)

for i = find([list.isdir])
	if ~strcmp(list(i).name,'.') && ~strcmp(list(i).name,'..') % v 1.1
		subdir = [SearchDir list(i).name];
		arg = [Options {Exp,FileExt,subdir}];
		[files,lines] = search(arg{:}); % <--- RECURSIVE CALL !!!
		FILES = [FILES; files];
		LINES = [LINES; lines];
	end
end

cd(pd);     % ----!

if ~nargout
	clear FILES LINES
end