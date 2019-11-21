function [R,G,B] = rgb2rgb(R,G,B)
% RGB2RGB  Convertions between RGB 3-D matrix and R, G, B 2-D matrices.
%    [R,G,B] = RGB2RGB(RGB)
%    RGB = RGB2RGB(R,G,B)

switch nargin
	case 1
		RGB = R;
		R = RGB(:,:,1);
		G = RGB(:,:,2);
		B = RGB(:,:,3);
	case 3
		RGB = cat(3,R,G,B);
	otherwise
		error('Bad number of imput arguments.')
end

switch nargout
	case 1
		R = RGB;
end