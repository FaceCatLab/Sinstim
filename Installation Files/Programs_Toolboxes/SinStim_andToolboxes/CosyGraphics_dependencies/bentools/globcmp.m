function b = globcmp(Str,Pattern)
% GLOBCMP  Compare string with pattern. Pattern can contain wildcards.
%    GLOBCMP  compares string with pattern and returns logical 1 (true) if they match, and logical 0
%    (false) otherwise.  Patter can contain wildcards: "*" or "?".
%
%     Example:
%        globcmp('myfile.m','*.m')   % returns 1 (true).
%
% See also GLOBFIND.
%
% Ben, June 2011.


b1 = globfind(Str,Pattern);
b2 = globfind(Str(end:-1:end),Pattern(end:-1:end));

b = ~isempty(b1) && b1 == 1 && ~isempty(b2) && b2 == 1;