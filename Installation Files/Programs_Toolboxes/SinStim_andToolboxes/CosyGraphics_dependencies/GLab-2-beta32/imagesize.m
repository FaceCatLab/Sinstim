function varargout = imagesize(I)
% IMAGESIZE   Width and Height of the image stored in a matrix.
%    d = IMAGESIZE(I), returns the two-element row vector d = [w h] containing the
%    width and heigth in pixel of the image. Note that this order is the reverse of
%    the order used by the standard Matlab SIZE function.
%    For example, if I is a 600-by-800-by-3 matrix:
%       d = size(I);       returns d = [600 800 3] (uses Matrix Computing convention)
%       d = imagesize(I);  returns d = [800 600]   (uses Image Processing convention)
%    Note also that IMAGESIZE ignores the third dimension: it gives the size of the
%    image, not the size of the matrix in witch it's stored.
%  
%    [w,h] = IMAGESIZE(buffer) returns width and height as separate output variables.
%
%    w = IMAGESIZE(buffer,1) returns the width.
%    h = IMAGESIZE(buffer,2) returns the height.
%
% See also SIZE, BUFFERSIZE.
%
% Ben, Sept 2007.

w = size(I,2);
h = size(I,1);

if nargout == 2
	varargout{1} = w;
	varargout{2} = h;
else
	if nargin == 2
		if dim == 1
			varargout{1} = w;
		elseif dim == 2
			varargout{1} = h;
		else
			error('Bad value for the ''dim'' argument.')
		end
	else
		varargout{1} = [w h];
	end
end