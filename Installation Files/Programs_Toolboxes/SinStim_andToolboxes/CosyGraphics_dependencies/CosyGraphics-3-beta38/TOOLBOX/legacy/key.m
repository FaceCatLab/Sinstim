function out = key(k)
% KEY <DEPRECATED. Use GETKEYNUMBER and GETKEYNAME.>
%   Convert key ID number <-> key name.
%
%   id = KEY(keyname)  returns ID number of key of given name. Keyboard
%   is supposed to be belgian.
%
%   id = KEY('any')  returns all valid key IDs.
%
%   keyname = KEY(id)  returns the name corresponding to given key ID.
%   If 'id' is a vector, returns a cell vector of strings.
%
%   KEY ?  displays valid key names. Case must be respected.
%
% See also GETKEYNUMBER, GETKEYNAME, GETBELGIANMAP.
%
% Ben, March 2008.

warning(['The "key" function is deprecated. It''s use can lead to stability issues.' 10 ...
    'Please replace it by getkeynumber/getkeyname.'])

be = getbelgianmap;
if ischar(k) && strcmp(k,'?')
	display(fieldnames(be));
elseif ischar(k) % k = key name
	if strcmpi(k,'any')
		id = 1 : 103;
	else
		try	  id = be.(k);
		catch error(['Invalid key name: ''' k ...
					'''. Type "key ?" to display valid names.'])
		end
	end
	out = id; % k = cell vector of key names
elseif iscell(k)
	out = zeros(size(k));
	for i = 1 : length(k)
		out(i) = key(k{i}); % <--- RECURSIVE CALL --- !!!
	end
else % k = key id
	id = k;
	out = cell(size(id));
	for c = 1 : length(out)
		fields = fieldnames(be);
		for f = 1 : length(fields)
			if id == be.(fields{f})
				out{c} = fields{f};
			end
		end
	end
	if length(id) == 1, out = out{1}; end
end