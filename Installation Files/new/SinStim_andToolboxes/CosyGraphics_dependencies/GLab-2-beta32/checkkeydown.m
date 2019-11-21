function [keyNumber,keyCode,keyTime] = checkkeydown(key)
% CHECKKEYDOWN  Check current state of keyboard keys.
%
%    [keyNumber,keyCode,keyTime] = CHECKKEYDOWN;  checks which keys are down
%    currently. Invalid keys (e.g.: special keys on laptops) are not checked.
%    This function does not interfere with the keyboard stack (Cog 1.24 only).
%
%    [keyNumber,keyCode,keyTime] = CHECKKEYDOWN(keyName|keyNumber|keyCode);
%    checks given keys only.
%
%    [keyNumber,keyCode,keyTime] = CHECKKEYDOWN('All');  checks all keys (i.e.: 
%    valid or not).
%
% See also GETKEYCODE, GETKEYNAME.
%
% Ben, Oct. 2008

% Execution time: 0.165 ms (Matlab 6.5, Athlon X2 4400+)

global GLAB_KEYBOARD

% Input Args <TODO: rewrite    "keyFilter = getkeycode(key)" >
if ~nargin
	keyFilter = GLAB_KEYBOARD.TABLES.PTB.KeyCodeFilter;
else
	keyFilter = getkeycode(key,'PTB');
end
% elseif islogical(key) || length(key)==256 & all(key==0 | key==1) 	% 'keyCode' arg.
% 	keyFilter = logical(key);
% elseif isnumeric													% 'keyNumber'  arg.
% 	key(key==0) = [];
% 	keyFilter = logical(ones,1,256);
% 	if ~isempty(key), keyFilter(key) = 1; end
% elseif strcmpi(key,'All');
% 	keyFilter = logical(ones,1,256);
% elseif ischar(key)													% 'keyName' arg.
% 	keyFilter = getkeycode(key);
% else
% 	error('Invalid argument.')
% end

% Check Keyboard State with KbCheck (PTB function)
[keyIsDown,secs,keyCode] = KbCheck;

% Output Args
keyCode = keyCode & keyFilter;
keyNumber = find(keyCode);
if isempty(keyNumber), keyNumber = 0; end
keyTime = secs * 1000;
