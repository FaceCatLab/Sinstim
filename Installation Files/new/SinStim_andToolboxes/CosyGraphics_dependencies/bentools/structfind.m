function s = structfind(S,tofind,structname)
% s = structfind(S,tofind)

% s = structfind(S,tofind,structname)  For recursive calls.

if nargin < 3
	structname = inputname(1);
end

s = '';
c = {};
fields = fieldnames(S);

for i = 1 : length(fields)
	val = S.(fields{i});
	if isnumeric(val)
		ind = find(val == tofind);
		for k = 1 : length(ind)
			s = [structname '.' fields{i}];
			if length(val) > 1 % Array: add subscripts
				if size(val,1) == 1, val = val'; end % avoid horiz. vect.
				[i1,i2,i3,i4,i5,i6] = ind2sub(size(val),ind(k));
				sub = [i1,i2,i3,i4,i5,i6];
				s = [s '(' int2str(i1)];
				for d = 2 : min([ndims(val) size(val,2)]) % ndims always >= 2
					s = [s ',' int2str(sub(d))];
				end
				s = [s ')'];
			end
			c = [c; {s}];
			s = '';
		end
	elseif ischar(val)
		% ...
	elseif iscell(val)
		% ...
	elseif isstruct(val) % Sub-struct.: recursive call !!!
		substructname = [structname '.' fields{i}];
		cc = structfind(S.(fields{i}),tofind,substructname);
		if ischar(cc) & length(cc)
			c = [c; {cc}];
		elseif iscell(cc)
			c = [c; cc];
		end
	end
end

if length(c) == 1,
	s = c{1}; % Single output is a string
elseif length(c) > 1,
	s = c; % Multiple outputs returned in a cell
end 