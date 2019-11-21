function pathname = cosygraphicsroot()
% COSYGRAPHICSROOT  CosyGraphics's root directory.
%    pathname = COSYGRAPHICSROOT
% 
% See also COSYDIR.
%
% Ben,	Nov. 2007.

% <NB: WE WANT NO DEPENDENCIES IN THIS CODE !!!>

p = which('cosyversion'); % <v3-beta3: cosyversion.m will always be in parent dir (setupcosy.m could be displaced to run replace)>
if isempty(p)
    p = which('glabversion'); % Compat with v2 (GLab).
    if isempty(p)
        error('Toolbox not installed properly. Cannot find "cosyversion.m" (v3) or "glabversion.m" (v2).');
    end
end
f = find(p == filesep);
f = f(end) - 1;
pathname = p(1:f);
