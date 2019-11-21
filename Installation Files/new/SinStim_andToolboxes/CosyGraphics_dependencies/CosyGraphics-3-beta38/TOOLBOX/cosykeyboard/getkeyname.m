function keyName = getkeyname(key,lib)
% GETKEYNAME   Name of a key
%    GETKEYNAME  waits for a key press, then displays the key name. <TODO>
%
%    GETKEYNAME ?  or GETKEYNAME ALL  displays all key names.
%
%    keyName = GETKEYNAME(keyNumber|keyCode)  gets key name from key code or number.
%
%    keyName = GETKEYNAME(keyNumber|keyCode,lib)  gets name from code/number of the
%    specified library ('PTB' or 'Cog').
%
% See also: GETKEYNUMBER, GETKEYCODE, GETBELGIANMAP (Cogent only).
%
% Ben, Oct. 2007

% <TODO: 
% - No arg.
% - GETKEYNAMES: More than 1 key. Returns always a cell array of strings.
% >

global COSY_KEYBOARD

if ~isopen('Keyboard'), error('Keyboard not initialised. Use STARTCOGENT/STARTPSYCH or OPENKEYBOARD before.'), end
if isempty(COSY_KEYBOARD)
	openkeyboard
end

if nargin < 2
	lib = getcosylib('Keyboard');
end
lib = upper(lib(1:3));

if ~nargin															% DISPLAY NAME
	%<TODO>
elseif ischar(key)
    if strcmpi(key,'?') | strcmpi(key,'all')                        % DISPLAY ALL NAMES
        disp(COSY_KEYBOARD.TABLES.CamelCaseNames)
    else                                                            % NAME -> NAME
        keyName = key;
    end
    return % !!!
elseif islogical(key) || length(key)==256 & all(key==0 | key==1)	% CODE -> NAME
	keyNumber = find(key);
elseif isnumeric(key)												% NUM -> NAME 
	keyNumber = key;
end

% keyNumber -> keyName
keyNamesCell = cell(size(keyNumber));
for k = 1 : numel(keyNamesCell)
    i1 = find(COSY_KEYBOARD.TABLES.(lib).KeyNumbers(:,1) == keyNumber(k));
    i2 = find(COSY_KEYBOARD.TABLES.(lib).KeyNumbers(:,2) == keyNumber(k));
    i = min([i1,i2]);
    if isempty(i)
        keyNamesCell{k} = '';
    else
        keyNamesCell{k} = COSY_KEYBOARD.TABLES.CamelCaseNames(i,:);
        keyNamesCell{k} = keyNamesCell{k}(find(keyNamesCell{k}));
    end
end

if numel(keyNamesCell) > 1 ,    keyName = keyNamesCell;
else                            keyName = keyNamesCell{1};
end