function keyNumbers = getallkeynumbers(varargin)
% GETKEYNUMBER   Get key number, numbers if more than one key, corresponding to a key name.
%    GETKEYNUMBER  by itself, waits for a key press and displays the key number(s). <TODO>
%
%    keyNumbers = GETKEYNUMBER(keyNumber|keyName|keyCode)  returns key(s) numbers in the n-by-2
%    matrix keyNumbers. Missing values are replaced by 0s.
%
%    keyNumbers = GETKEYNUMBER(keyName,lib)  returns number for specified library ('PTB' or 'Cog').
%
%    keyNumbers = GETKEYNUMBER(keyNumber,'cog2ptb')  converts Cogent key number to PTB key number.
%    keyNumbers = GETKEYNUMBER(keyNumber,'ptb2cog')  converts PTB key number to Cogent key number.
%    If the keyNumber argument is a key name or a key code instead of a number, 'cog2ptb' is the  
%    than 'PTB' and 'ptb2cog' is the same than 'Cog'.
%
%    Programmer note: Identifying code/number is dependent of the underlying library (PTB
%    or Cogent) used for keyboard. Unless the library is explicitely specified the function  
%    returns code/number for the current keyboard library. (See GETLIBRARY('Keyboard').)
%
% See also: GETKEYCODE, GETKEYNAME.
%
% Ben, Feb. 2009

% <TODO: Verif. what to do with multiple numbers.>

global GLAB_KEYBOARD

[keyNumber,keyNumber2] = getkeynumber(varargin{:});
keyNumbers = [keyNumber(:) keyNumber2(:)];