function glabreplace(exp0,exp1)
% COSYGRAPHICSREPLACE  Replace expression in CosyGraphics M-files.
%     COSYGRAPHICSREPLACE(exp0,exp1)  replaces exp0 by exp1 in all CosyGraphics M-files, 
%     with the exception of cosyversion.m.  Be carefull: There will be no 
%     ask for confirmation, and no possibility to cancel the replace !!!
%
% Ben, Oct 2009.

setupbentools % Because there is an eponymous "Replace" function in PTB.

if ispc
    cd(cosygraphicsroot)
    dispinfo(mfilename,'info','Backing up cosyversion.m...')
    dos(['xcopy cosyversion.m ' cosydir('tmp') ' /yvr']);
    dispinfo(mfilename,'info','Replacing...')
    cd(cosydir,'toolbox')
    replace('-r',exp0,exp1)
    dispinfo(mfilename,'info','Restoring cosyversion.m...')
    dos(['xcopy ' cosydir('tmp') 'cosyversion.m ' cosygraphicsroot ' /yvr']);
    
else
    error('COSYGRAPHICSREPLACE is not yet supported on other OSes than Windows.')
    
end