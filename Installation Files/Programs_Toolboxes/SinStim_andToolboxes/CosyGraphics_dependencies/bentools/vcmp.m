function b = vcmp(v1,r,v2)
% VCMP  Compare version numbers.
%    b = VCMP(v1,r,v2)  returns logical true (1) if the relationship r applies to the version 
%    numbers v1 and v2. v1 and v2 can be numerical vectors or character strings (see VSTR2VNUM).
%    r can be '==', '=~', '>', '<', '>=' or '<='. Limitations: Max vector length: 9 ; Max value: 999.
%
% See also: VNUM2VSTR, VSTR2VNUM.


v1 = vstr2vnum(v1,9);
v2 = vstr2vnum(v2,9);
if max(v1) > 999 || max(v2) > 999 
    error('Max allowed values is 999.')
end
pow = 24 : -3 : 0;
mult = 10.^pow;
v1 = v1 .* mult;
v2 = v2 .* mult;
s1 = sum(v1);
s2 = sum(v2);
b = eval(['s1' r 's2']);