function pathname = mfilepath
% MFILEPATH  Path to currently executing M-file.
%    MFILEPATH  returns a string containing the path to the 
%    currently executing M-file. 
%
% See also MFILENAME, MFILECALLER, MFILECONTENT.
%
% Ben, June 2011.


pathname = whichdir(mfilecaller);