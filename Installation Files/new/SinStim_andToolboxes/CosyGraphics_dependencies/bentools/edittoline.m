function edittoline(MFileName,To)
% EDITTOLINE  Edit M-file to a line. 
%    Line can be given trough it's number or through a pattern to search for.
%
%    EDITTOLINE(MFileName,n)  edits m-file to line n.
%
%    EDITTOLINE(MFileName,Pattern)  edits m-file to the first line in witch 
%       'Pattern' is found. 'Pattern' must content non-digit characters,
%       otherwise it will be interpreted as a line number.
%
% Ben, May 2008.

% Get full name (OPENTOLINE works only with full names.)
FullName = which(MFileName);

% Get line number
if isnumeric(To)
	n = To;
elseif ischar(To) && all(ismember(To,'0':'9'));
	n = str2num(To);
else
	Pattern = To;
	fid = fopen(FullName);
	if fid < 0
		errordlg(['Cannot open ' MFileName])
		return % !!!
	end
	Content = fscanf(fid,'%c');
	fclose(fid);
	f = strfind(Content,Pattern);
	if ~isempty(f)
		f = f(1);
		lf = find(Content == 10);
		n = length(find(lf < f)) + 1;
	else
		warning('Pattern not found.')
	end
end

% Open to line n
opentoline(FullName,n);