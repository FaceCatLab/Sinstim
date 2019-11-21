function cdcosy(varargin)
% CDCOSY  Change directory to CosyGraphics toolbox directory.
%    CDCOSY
%    CDCOSY(SUBDIR)
%
% See also: OFCOSY.

d = fullfile(cosygraphicsroot,'TOOLBOX');

for i = 1 : nargin
    d = fullfile(d, varargin{i});
end

cd(d)
disp(cd)