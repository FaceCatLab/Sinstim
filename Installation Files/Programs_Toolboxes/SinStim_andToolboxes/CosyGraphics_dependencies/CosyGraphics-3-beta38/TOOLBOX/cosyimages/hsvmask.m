function [M,Mh,Ms,Mv] = hsvmask(varargin)
% HSVMASK  Make binary mask for pixels within hue-saturation-value ranges.
%    M = HSVMASK(Ihsv,h)  returns logical matrix M, with 1's at the position of pixels 
%       with hue h  in HSV image 'Ihsv'. 'h' is the hue in HSV coordinate.
%    M = HSVMASK(Ihsv,[h0 h1])  finds hues in the range h0 to h1.
%    M = HSVMASK(Ihsv,[h0 h1],[s0 s1],[v0 v1])  defines also a range for saturation and
%       value. Default ranges are [1/255 1] for both. You can use the empty matrix []
%       to set an argument to it's default.
%    HSVMASK('HSV Demo')  plots the HSV hue values.
%
% See also: 
%    RGB2HSV, HSV2RGB (Matlab Toolbox)
%    ROIDEMO, ROICOLOR (Image Processing Toolbox)
%    BACKGROUNDMASK (CosyGraphics Toolbox)
%
% Ben, Nov. 2007.


% Imput Arg.
if nargin == 1  % Demo Mode:
	if strcmpi(varargin{1},'HSV Demo')
		figure; imagesc(0:1/255:1); colormap(hsv(256)) % ..plot HSB hue values,
		set(gca,'XTick',256*(0:6)/6,'XTickLabel',num2str((0:6)'/6))
		return % !!!                                     ..and return.
	else, error('Bad input argument.')
	end
else % Normal Mode
	Ihsv = varargin{1};
	h0 = varargin{2}(1);
	h1 = varargin{2}(end);
	if nargin < 3 || isempty(varargin{3})
		s0 = 1/255;
		s1 = 1;
	else
		s0 = varargin{3}(1);
		s1 = varargin{3}(2);
	end
	if nargin < 4 || isempty(varargin{4})
		v0 = 1/255;
		v1 = 1;
	else
		v0 = varargin{4}(1);
		v1 = varargin{4}(2);
	end
end

% Var.
H = Ihsv(:,:,1);
S = Ihsv(:,:,2);
V = Ihsv(:,:,3);

% Rotate Hue (To avoid problems in the red range.)
rotation = .5 - mean([h0 h1]);
h0 = h0 + rotation;
h1 = h1 + rotation;
H = H + rotation;
f = find(H > 1);
H(f) = H(f) - 1;
f = find(H < 0);
H(f) = H(f) + 1;

% Make Mask
Mh = zeros(size(H));
Ms = zeros(size(H));
Mv = zeros(size(H));
Mh(find(H >= h0 & H <= h1)) = 1;
Ms(find(S >= s0 & S <= s1)) = 1;
Mv(find(V >= v0 & V <= v1)) = 1;
M = Mh & Ms & Mv;
M  = logical(M);
Mh = logical(Mh);
Ms = logical(Ms);
Mv = logical(Mv);
