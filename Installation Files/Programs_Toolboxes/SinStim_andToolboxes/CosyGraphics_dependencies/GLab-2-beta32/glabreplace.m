function glabreplace(exp0,exp1)
% GLABREPLACE  Replace expression in GLab M-files.
%     GLABREPLACE(exp0,exp1)  replaces exp0 by exp1 in all GLab M-files, 
%     with the exception of glabversion.m.
%
% Ben, Oct 2009.



if ispc
    cdglab
    dispinfo(mfilename,'info','Backing up glabversion.m...')
    dos(['xcopy glabversion.m ' glabtmp ' /yvr']);
    dispinfo(mfilename,'info','Replacing...')
    replace(exp0,exp1)
    dispinfo(mfilename,'info','Restoring glabversion.m...')
    dos(['xcopy ' glabtmp 'glabversion.m ' glabroot ' /yvr']);
    
else
    error('Not yet supported on other OSs than Windows.')
    
end