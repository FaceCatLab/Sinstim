function List = delpath(varargin) 
% DELPATH  Delete from path directories that match a pattern.
%    DELPATH(Pattern) deletes from path directories in which name pattern is found.
%    'Pattern' can be character strings or cell vectors of strings. The search isn't
%    case sensitive. Wildcards ("*" and "?") can be used.
%    The new path is not saved. Use SAVEPATH if you want to save it.
%
%    DELPATH(Pattern,ExcludePattern) deletes directories where 'Pattern' is found and
%    'ExcludePattern' is not. 'Pattern' and 'ExcludePattern' can be character strings
%    or cell vectors of strings.
%
%    DELPATH('-r',...) or DELPATH('-regexp',...)  considers input arguments as regular
%    expressions. (It uses REGEXP, instead of GLOBFIND to do the matches.) Because
%    backslash is the file separator in Windows, you have to use "|" instead of "\" to
%    quote characters. See REGEXP about regular expressions.
%
%    DELPATH('-q',...) or DELPATH('-quiet',...)  doesn't print list of diretories to be 
%    deleted.
%
%    DELPATH('-l',...) or DELPATH('-list',...)  only returns list of directories to be
%    deleted, without actually delete them.
%
% See also RMCD, ADDCD, SAVEPATH, DUMPPATH, RESTOREPATH, DOUBLONS, WHICHDIR.

% Ben, Jan.-Avr. 2008

% 		Jan. 2008	1.0		<Critical bug!  Last line left commented!>
%		Avr. 		2.0		Fix "\" problem.
%							Input arg. can be cell vectors of strings.
%							Output list of directories. 
%							Options: At any position ; Fix -q option ; Add '-l' option.

% Input Arg.
% 0) Options
isRegExp   = 0;
isQuiet    = 0;
isListOnly = 0;
for i = length(varargin) : -1 : 1
	if ischar(varargin{i})
		switch lower(varargin{i})
			case {'-regexp','-r'}
				isRegExp    = 1;
				varargin(i) = [];
			case {'-quiet','-q'}
				isQuiet    = 1;
				varargin(i) = [];
			case {'-list', '-l'}
				isListOnly = 1;
				varargin(i) = [];
		end
	end
end
% 1) Pattern
Pattern = varargin{1};
if ~iscell(Pattern), Pattern = {Pattern}; end
% 2) ExcludePattern
if length(varargin) >= 2
	ExcludePattern = varargin{2};
	if ~iscell(ExcludePattern), ExcludePattern = {ExcludePattern}; end
end

% Var.
Path = lower(path);          % A --> a
Path(find(Path=='\')) = '/'; % \ --> /
for c = 1 : length(Pattern)
	pat = Pattern{c};
	pat = lower(pat);            % A --> a
	pat(find(pat == '\')) = '/'; % \ --> /
	pat(find(pat == '|')) = '\'; % | --> \
	Pattern{c} = pat;
end
if exist('ExcludePattern','var') 
	for c = 1 : length(ExcludePattern)
		pat = ExcludePattern{c};
		pat = lower(pat);            % A --> a
		pat(find(pat == '\')) = '/'; % \ --> /
		pat(find(pat == '|')) = '\'; % | --> \
		ExcludePattern{c} = pat;
	end
end

% Begins & ends of all directories
s = find(Path == pathsep); % indexes of ";".
dir0 = [1, s+1];
dir1 = [s-1, length(Path)];

% Begins & ends of patterns
pat0 = [];
pat1 = [];
for c = 1 : length(Pattern)
	pat = Pattern{c};
	if isRegExp
		[p0,p1] = regexp(Path,pat);
	else
		[p0,p1] = globfind(Path,pat,';');
	end
	pat0 = union(pat0,p0);
	pat1 = union(pat1,p1);
end

% Begins & ends of directories to delete
del0 = zeros(size(pat0));
del1 = zeros(size(pat0));
for n = 1 : length(pat0)
	f = find(dir0 <= pat0(n));
	f = f(end);
	del0(n) = dir0(f);
	del1(n) = dir1(f);
end

% Begins & ends of directories to exclude from deletion
if exist('ExcludePattern','var')
	pat0 = [];
	pat1 = [];
	for c = 1 : length(ExcludePattern)
		pat = ExcludePattern{c};
		if isRegExp
			[p0,p1] = regexp(Path,pat);
		else
			[p0,p1] = globfind(Path,pat,';');
		end
		pat0 = union(pat0,p0);
		pat1 = union(pat1,p1);
	end
	exc0 = zeros(size(pat0));
	exc1 = zeros(size(pat1));
	for n = 1 : length(pat0)
		f = find(dir0 <= pat0(n));
		f = f(end);
		exc0(n) = dir0(f);
		exc1(n) = dir1(f);
	end
else
	exc0 = [];
	exc1 = [];
end

% Exclude from deletion
del0 = setdiff(del0,exc0);
del1 = setdiff(del1,exc1);

% Reload path
Path = path; 

% Print deletion list
if ~isQuiet
	disp('Deleting from path:')
	for n = 1 : length(del0)
		disp(Path(del0(n):del1(n)))
	end
end

% Delete directories from path
for n = length(del0) : -1 : 1
	Path(del0(n):del1(n)) = [];
end

% Delete !
if ~isListOnly
	path(Path); % !
end