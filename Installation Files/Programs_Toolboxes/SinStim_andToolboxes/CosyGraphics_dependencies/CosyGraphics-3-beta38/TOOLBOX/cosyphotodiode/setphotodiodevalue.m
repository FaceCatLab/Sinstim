function setphotodiodevalue(value)
% SETPHOTODIODEVALUE  Set status (on/off) of photodiode squares.
%    SETPHOTODIODEVALUE(HalfByte)  sets state of photodiode squares for the next display. 'HalfByte'
%    is an integer between 0 and 15: 1 is upper-left corner, 2 is upper-right, 4 is lower-left, 8 is 
%    lower-right; numbers can be added. The state will be actually changed at the next call of
%    DISPLAYBUFFER.
%
%    SETPHOTODIODEVALUE(SquareMatrix)  does the same. 'SquareMatrix' is 2-by-2 square matrix of 0
%    (off, black), 1 (on, white) and NaNs (no photodiode) which define the state of the photodiode
%    squares in the corresponding screen corners.
%
% Example 1:
%    openphotodiode([1 1; 1 0],16)  % Init for 3 photodiode squares in TL, TR and BL corners.
%    setphotodiodevalue(5)          % Set on photodiodes squares in TL (1) and BL (4) corners. (1+4=5)
%    displaybuffer(...)             % Display. The photodiode squares are actually updated.
%    setphotodiodevalue(0)          % Set off all photodiodes squares.
%    displaybuffer(...)             % Display. Photodiode squares actually off.
%
% Example 2:
%    setphotodiodevalue([1 0; 1 NaN])   % is the same than  setphotodiodevalue(5) in the above example.
%
% See also: OPENPHOTODIODE, CLOSEPHOTODIODE, DISPLAYBUFFER.

global COSY_PHOTODIODE

if isempty(COSY_PHOTODIODE) || ~COSY_PHOTODIODE.isPhotodiode
    error('openphotodiode must be run before any call to setphotodiodevalue.')
end

if numel(value) == 1
    v = dec2bin(value,4) - '0';
    COSY_PHOTODIODE.Values = [v(4) v(3); v(2) v(1)];
    COSY_PHOTODIODE.Values(~COSY_PHOTODIODE.Locations) = NaN;
    
elseif all(size(value)) == [2 2]
    COSY_PHOTODIODE.Values = value;
    COSY_PHOTODIODE.Values(~COSY_PHOTODIODE.Locations) = NaN;
    
else
    error('SETPHOTODIODEVALUE: Invalid argument dimensions.')
    
end