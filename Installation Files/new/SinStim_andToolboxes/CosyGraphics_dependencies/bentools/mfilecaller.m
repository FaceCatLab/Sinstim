function callername = mfilecaller
% MFILECALLER  Caller function of currently executing M-file.
%    MFILECALLER  returns a string containing the name of the function 
%    which called the currently executing M-file. 
%
% See also DBSTACK, MFILENAME, MFILEPATH, MFILECONTENT.
%
% Ben, June 2011.


p = dbstack;

if length(p) > 2
    callername = p(3).name;
else
    callername = '';
end