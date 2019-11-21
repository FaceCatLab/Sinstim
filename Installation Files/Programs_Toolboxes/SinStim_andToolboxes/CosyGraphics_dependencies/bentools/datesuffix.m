function  d = datesuffix
% DATESUFFIX  Date suffix to be appended to a file name.
%    DATESUFFIX  returns a date string, for example: '_2011-05-28_15h04m04s'.
%
%    Example:
%       filename = [filename datesuffix];

% Programmer's note: Include seconds in suffix: it prevents data file accidental erasing.

d = datestr(now,'yyyy-mm-dd HH:MM:SS');
d(d==' ') = '_';
d(d==':') = 'hm';
d = ['_' d 's'];