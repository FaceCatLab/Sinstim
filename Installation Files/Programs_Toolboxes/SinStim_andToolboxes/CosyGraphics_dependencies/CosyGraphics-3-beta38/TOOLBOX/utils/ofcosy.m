function ofcosy(varargin)
% OFCOSY  Open CosyGraphics's folder window.
%    OFCOSY
%    OFCOSY SUBDIR
%    OFCOSY SUBDIR SUBSUBDIR ...
%
% See also: OF, CDCOSY.

cdcosy(varargin{:});
openfolder(cd);