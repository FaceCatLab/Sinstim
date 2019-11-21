function [keyCode,keyCode2,keyNumber,keyNumber2] = getkeycode(key,lib)
% GETKEYCODE   Get code identifying a key or a combination of keys.
%    The key code is a logical vector identifying one or several key(s). (As in PTB)
%
%    GETKEYCODE  by itself, waits for a key press and displays the key code. <TODO>
%
%    keyCode = GETKEYCODE(keyName|keyNumber|keyCode)  gets key code
%    from it's name(s), number(s) or code.
%
%    keyCode = GETKEYCODE(keyName|keyNumber|keyCode,lib)  returns code
%    for the specified library ('PTB' or 'Cog').
%
%    Programmer note: Identifying code/number is dependent of the underlying library (PTB
%    or Cogent) used for keyboard. Unless the library is explicitely specified the function
%    returns code for the current keyboard library. (See GETLIBRARY('Keyboard').)
%
%    [keyCode,keyCode2] = GETKEYCODE(...)  returns also code of a second key with the same name  
%    if any. Example: Over Cog library, getkeycode('enter') returns keyNumber=59 (Main "Enter"  
%    key) and keyNumber2=90 (NumPad "Enter" key). If there is no second key, keyCode2 value is 0.
%
%    [keyCode,keyCode2,keyNumber,keyNumber2] = GETKEYCODE(...)  is used by GETKEYNUMBER.
%
% See also: GETKEYNUMBER, GETKEYNAME, GETBELGIANMAP (Cogent only).

% Ben,  Oct. 2008   v1
%       Jul. 2009   v2 (GLab 2-beta7)

% Execution time: 0.13 ms (Matlab 6.5, Athlon X2 4400+)


global GLAB_KEYBOARD

if nargin < 2
	lib = getlibrary('Keyboard');
end
lib = upper(lib(1:3));

keyCode  = false(1,256);
keyCode2 = false(1,256);

if ~nargin				% DISPLAY NUM
	%<TODO>
    
elseif isempty(key)
    keyNumber = [];
    
elseif ischar(key)		% NAME -> NUM + CODE
	pattern = [lower(key) char(0)];
    i = strmatch(pattern,GLAB_KEYBOARD.TABLES.lowercasenames);
    keyNumber  = GLAB_KEYBOARD.TABLES.(lib).KeyNumbers(i,1);
    keyNumber2 = GLAB_KEYBOARD.TABLES.(lib).KeyNumbers(i,2);
    keyCode(keyNumber) = 1;
    if keyNumber2, keyCode2(keyNumber) = 1; end

elseif islogical(key) | (isnumeric(key) & length(key) == 256)
                        % CODE -> NUM + CODE
    keyNumber = find(key);
	keyCode = key;
	
elseif isnumeric(key)	% NUM -> NUM + CODE
	keyNumber = key;
    if any(key), keyCode(key) = 1; end
	
elseif iscell(key)		% RECURSIVE MODE
	keyNumber = zeros(size(key));
	for k = 1 : numel(key)
		[c,c2,n,n2] = getkeycode(key{k},lib);
		keyNumber(k)  = n;
        keyNumber2(k) = n2;
		keyCode  = keyCode  | c;
        keyCode2 = keyCode2 | c2;
	end
	
else
	error('Invalid argument.')
    
end

% Second key number & code
if nargout > 1 % <v2-beta10, backported on 2-beta9/7dec>
    % This is to SLOW!!! (proportionnal to the number of keys) 
    % <todo: optimize this OR suppress double IDs !!!>
    if islogical(key) || isnumeric(key)  % CODE|NUM -> NUM + CODE
        keyNumber2 = zeros(size(keyNumber));
        for k = 1 : length(keyNumber)
            for j = 1:2
                f = find((GLAB_KEYBOARD.TABLES.(lib).KeyNumbers(:,j) == keyNumber(k)) & ...
                    GLAB_KEYBOARD.TABLES.(lib).KeyNumbers(:,3-j));
                if ~isempty(f)
                    n2 = GLAB_KEYBOARD.TABLES.(lib).KeyNumbers(f(1),3-j);
                    keyNumber2(k) = n2;
                    keyCode2(n2) = 1;
                end
            end
        end
    end
end

% if isempty(keyNumber), keyNumber = 0; end % <??? Why? Suppr. in 2-beta6. Breaks something? See waitkeydown line 67>