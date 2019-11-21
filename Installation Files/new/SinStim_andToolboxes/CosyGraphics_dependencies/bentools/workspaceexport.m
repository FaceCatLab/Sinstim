% WORKSPACEEXPORT  Export all variables from caller function's space to workspace.
%
% Ben, June 2011.

WorkSpaceExportVars = who;

dispinfo(mfilename, 'info', ['Exporting all variables of ' upper(mfilecaller) ' to workspace...'])

for iWorkSpaceExport = 1 : length(WorkSpaceExportVars)
    assignin('base', WorkSpaceExportVars{iWorkSpaceExport}, eval(WorkSpaceExportVars{iWorkSpaceExport})); 
end

clear *WorkSpaceExport*