function vnum = vstr2vnum(vstr,minnumbers)
% VSTR2VNUM   Convert version string to version number.
%    VNUM = VSTR2VNUM(VSTR)  converts string VSTR to a vector of numbers.
%    'alpha' is converted to -2 and 'beta' is converted to -1. If VSRT is 
%    not a string but a numeric vector, it stays unchanged.
%
%    VNUM = VSTR2VNUM(VERSION)  returns MATLAB version as a vector of
%    numbers.
%
%    VNUM = VSTR2VNUM(VSTR,MINNUMBERS)  adds 0s to the end of vector to 
%    reach MINNUMBERS elements.
%
% See also: VNUM2VSTR, VCMP.


if nargin < 2, minnumbers = 1; end

if ischar(vstr)
    % alpha -> -2
    f = strfind(lower(vstr),'-alpha');
    if ~isempty(f)
        vstr = [vstr(1:f-1) '.-2' vstr(f+6:end)];
    end
    % beta -> -1
    f = strfind(lower(vstr),'-beta');
    if ~isempty(f)
        vstr = [vstr(1:f-1) '.-1.' vstr(f+5:end)];
    end

    % If vstr is a version() output:
    if any(vstr == '(')
        f = find(vstr == '(');
        vstr(f:end) = [];
        vstr(vstr == ' ') = [];
    end

    % Remove letters (if any)
    vstr(ismember(vstr,['a':'z','A':'Z'])) = [];

    % Convert
    vstr(vstr == '.') = ' ';
    vnum = str2num(vstr);
    
elseif isnumeric(vstr)
    vnum = vstr;
    
else
    error('Invalid vstr argument.')
    
end

% Add 0s at the end
if length(vnum) < minnumbers
    vnum(end+1:minnumbers) = 0;
end