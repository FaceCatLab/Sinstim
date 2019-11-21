function I = fitrgb(I,mode)
% FITRGB  Fit pixel values within the [0,1] range.
%    I = FITRGB(I)  or  I = FITRGB(I,'cut')  clips the values in the double matrix 'I'
%    under 0 and above 1.  Usefull to fix rounding bugs.
%
%    I = FITRGB(I,'rescale')  rescales values to fit range.
%
% See also: FITHSV, FITRANGE
%
% Ben,	Nov. 2007.

if ~strcmp(class(I),'double')
	error('Input argument ''I'' must be a double matrix.')
end
if nargin < 2
	mode = 'cut';
end

I = fitrange(I,[0 1],mode);
