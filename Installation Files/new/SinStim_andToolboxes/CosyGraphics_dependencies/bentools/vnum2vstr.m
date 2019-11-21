function vstr = vnum2vstr(vnum,minnumbers)
% VNUM2VSTR   Convert version number to version string.
%    VSTR = VNUM2VSTR(VNUM)  converts vector VNUM to string.
%    -2 is converted to 'alpha' and -1 is converted to 'beta'.
%
% See also: VSTR2VNUM, VCMP.

%    VSTR = VNUM2VSTR(VNUM,MINNUMBERS)  <not really usefull>


if nargin < 2, minnumbers = 1; end

if length(vnum) < minnumbers
    vnum(end+1:minnumbers) = 0;
end

vstr = int2str(vnum(1));

for i = 2 : length(vnum)
    switch vnum(i)
        case -2
            vstr = [vstr '-alpha'];
        case -1,
            vstr = [vstr '-beta'];
        otherwise   
            if vnum(i-1) < 0
                vstr = [vstr num2str(vnum(i))];
            else 
                vstr = [vstr '.' num2str(vnum(i))];
            end
    end
end