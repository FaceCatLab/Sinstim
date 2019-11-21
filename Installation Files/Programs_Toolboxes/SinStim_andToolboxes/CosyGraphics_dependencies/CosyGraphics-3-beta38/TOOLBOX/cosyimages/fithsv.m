function I = fithsv(I,mode)
% FITHSV  Fit values in a HSV image matrix within the [0,1] range.
%    I = FITHSV(I)  The hue is be cyclically reduced (e.g.: 1.3 becomes 0.3);
%       the saturation and value are cutted above 1 and under 0.
%    I = FITHSV(I,'cut')  is the same as above.
%    I = FITHSV(I,'rescale')  The saturation and value are rescaled to fit
%       the [0,1] range. Same as above for the hue.
%
% See also FITRGB, FITRANGE.
%
% Ben,	Nov. 2007.

% Input Arg.
if ~strcmp(class(I),'double')
	error('Input argument ''I'' must be a double matrix.')
end
if nargin < 2
	mode = 'cut';
end

% Fit Range
I(:,:,1)   = fitrange(I(:,:,1),[0 1],'cyclic');
I(:,:,2:3) = fitrange(I(:,:,2:3),[0 1],mode);
