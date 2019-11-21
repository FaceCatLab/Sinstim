function err = savepath(varargin)
% SAVEPATH Save the current MATLAB path in the pathdef.m file.
%   This is a replacement MATLAB 7.x SAVEPATH function which works 
%   on all MATLAB versions.
%
%   On MATLAB 7.x, a new function, called "SAVEPATH", replaces the older 
%   PATH2RC function. (It's the case for MATLAB 7.4+ ; I don't know for  
%   MATLAB 7.0 to 7.3.) This function calls the original SAVEPATH     
%   function when it exists, otherwise it calls PATH2RC.
%
%                           ***
%
%   SAVEPATH saves the current MATLABPATH in the pathdef.m
%   which was read on startup.
%
%   SAVEPATH outputFile saves the current MATLABPATH in the
%   specified file.
%
%   SAVEPATH returns:
%     0 if the file was saved successfully
%     1 if the file could not be saved
% 
%   See also PATHDEF, ADDPATH, RMPATH, PATH, PATHTOOL.  (Matlab functions)
%   See also DELPATH, RMCD, ADDCD, DUMPPATH, RESTOREPATH, DOUBLONS, WHICHDIR. (BenTools functions)

%   Copyright 1984-2007 The MathWorks, Inc.
%   $Revision: 1.1.6.11.2.1 $ $Date: 2007/07/31 14:32:59 $

% 10 Jan 2010       v2.0    Rewrite. Replace version check by exist(file) check.
%                           Replace use of savepath7 by use of original savepath.m.

v = vstr2vnum(version);

if exist([matlabroot '/toolbox/matlab/general/savepath.m'],'file') % MATLAB 7.x
    od = pwd;
    cd([matlabroot '/toolbox/matlab/general/'])  % <2011/05/13: Lots of warnings on SESOSTRIS ?!?>
    err = savepath(varargin{:});
    cd(od)
else % MATLAB 6.5
    err = path2rc(varargin{:});
end
