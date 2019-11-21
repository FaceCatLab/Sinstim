function M = fitrange(M,range,mode)
% FITRANGE  Fit values within range.
%    M = FITRANGE(M,[floor ceil])  or  M = FITRANGE(M,[floor ceil],'cut')  cuts the  
%    values in the matrix 'M' under the 'floor' value and above the 'ceil' value.
%
%    M = FITRANGE(M,[floor ceil],'rescale')  rescales values to fit range.
%    <TODO: Check it! Seems to be flawed!>
%
%    M = FITRANGE(M,[floor ceil],'cyclic')  For degrees for example.
%
% Examples:
%    RGB = fitrange(RGB,[0 1]);
%    RGB = fitrange(RGB,[0 255]);
%    Theta = fitrange(Theta,[0 360],'cyclic');
%
% See also FITRBG, FITHSV (Cogent2007 Toolbox).
%
% Ben,	Nov. 2007.

%       Feb. 2009.  Fix 'cut': 'range' arg. was ignored.
%       Jan. 2010.  Fix case M is integer.


% Input Arg.
Class = class(M);
M = double(M);
v0 = range(1);
v1 = range(2);
if ~exist('mode','var')
	mode = 'cut';
end
mode = lower(mode);

% Return if values already fit in range
if max(max(max(M))) <= v1 & min(min(min(M))) >= v0
	return % !!!
end

% Fit Range
switch mode
	
	case 'cut'
		M = max(M,v0+zeros(size(M)));
		M = min(M,v1*ones(size(M)));
		
	case 'rescale'
		% Up Thresh.:
		M  = M  - v0; % floor thresh. --> 0
		v1 = v1 - v0;
		bigger = max(max(max(M)));
		if bigger > v1
			M = M * v1 / bigger;
		end		
		M  = M  + v0;
		v0 = v0 + v0;
		
		% Low Thresh.:
		M  = M  - v1; % ceil thresh. --> 0
		v0 = v0 - v1;
		smaller = min(min(min(M)));
		if smaller < v0
			M = M * v0 / smaller;
		end
		M  = M  + v1;
		
	case 'cyclic'
		M  = M  - v0; % floor thresh. --> 0
		v1 = v1 - v0;
		M = rem(M,v1);
		neg = find(M < 0);
		M(neg) = M(neg) + v1;
		M  = M  + v0;
end

% Restore class
eval(['M = ' Class '(M);']);