function openglabfolder
% OPENGLABFOLDER  Open GLab folder in Windows Explorer.

if ispc
    dos(['explorer ' glabroot]);
end