function M = color2gray(M,rec);
% COLOR2GRAY   Color to grayscale conversion.
%    color = COLOR2GRAY(color)  Convert rgb vector or M-by-3 matrix 'color' to b&w.
%    I = COLOR2GRAY(I)          Convert M-by-N-by-3 image matrix 'I' to b&w.
%
% For theory, see:  http://en.wikipedia.org/wiki/Luma_%28video%29
%
% See also RGB2GRAY (Image Processing Toolbox)
%
% Ben, Oct 2007

rec = 601; % 601 or 709
switch rec
	case 601 % Rec. 601 luma coefficients. (Most standards and Image Processing Toolbox use this.)
		coeff = [0.299  0.587  0.114]; 
	case 709
		coeff = [0.2126 0.7152 0.0722]; % Rec. 709 luma coefficients. (HDTV use this.)
end

if size(M,3) == 1 & size(M,2) == 3
	luma = M * coeff;
	M = [luma luma luma];
else
	luma = coeff(1) .* M(:,:,1) + coeff(2) .* M(:,:,2) + coeff(3) .* M(:,:,3);
	M = repmat(luma,[1 1 3]);
end
