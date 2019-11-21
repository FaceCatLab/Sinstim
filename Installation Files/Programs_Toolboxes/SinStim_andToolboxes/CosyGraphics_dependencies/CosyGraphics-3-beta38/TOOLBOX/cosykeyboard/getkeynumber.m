function [keyNumber,keyNumber2] = getkeynumber(varargin)
% GETKEYNUMBER   Get identifying number of a key.
%    GETKEYNUMBER  by itself, waits for a key press and displays the key number. <TODO>
%
%    keyNumber = GETKEYNUMBER(keyName|keyCode)  gets key(s) number from it's (their's) name(s) 
%    or code.
%
%    keyNumber = GETKEYNUMBER(keyName,lib)  returns number for specified library ('PTB' or 'Cog').
%
%    keyNumber = GETKEYNUMBER(keyNumber,'cog2ptb')  converts Cogent key number to PTB key number.
%    keyNumber = GETKEYNUMBER(keyNumber,'ptb2cog')  converts PTB key number to Cogent key number.
%    If the keyNumber argument is a key name or a key code instead of a number, 'cog2ptb' is the  
%    than 'PTB' and 'ptb2cog' is the same than 'Cog'.
%
%    Programmer note: Identifying code/number is dependent of the underlying library (PTB
%    or Cogent) used for keyboard. Unless the library is explicitely specified the function  
%    returns code/number for the current keyboard library. (See GETCOSYLIB('Keyboard').)
%
%    [keyNumber,keyNumber2] = GETKEYNUMBER(...)  returns also the number of a second key with the   
%    same name if any. Example: Over Cog library, getkeycode('enter') returns keyNumber=59 (Main   
%    "Enter" key) and keyNumber2=90 (NumPad "Enter" key). See also GETALLKEYNUMBERS.
%
% See also: GETALLKEYNUMBERS, GETKEYCODE, GETKEYNAME.
%
% Ben, Feb. 2009

% <TODO: Verif. what to do with multiple numbers.>

global COSY_KEYBOARD

if ~isopen('Keyboard'), error('Keyboard not initialised. Use STARTCOGENT/STARTPSYCH or OPENKEYBOARD before.'), end
if nargin >= 2 && (strcmpi(varargin{end},'cog2ptb') | strcmpi(varargin{end},'ptb2cog'))
    lib0 = upper(varargin{2}(1:3));
    lib1 = upper(varargin{2}(5:7));
    
    if isnumeric(varargin{1})
        M0 = COSY_KEYBOARD.TABLES.(lib0).KeyNumbers;
        M1 = COSY_KEYBOARD.TABLES.(lib1).KeyNumbers;
        k = varargin{1};
        f = find(M0(:,1) == k);
        if isempty(f), f = find(M0(:,2) == k); end
        if ~isempty(f)
            f = f(1);
            keyNumber = M1(f,1);
        else
            keyNumber = [];
        end
        
    else
        [keyNumber,keyNumber2] = getkeynumber(varargin{1},lib1);
        
    end
    
else
    [keyCode,keyCode2,keyNumber,keyNumber2] = getkeycode(varargin{:});
    
end