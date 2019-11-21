function [n,bits] = checkparallelbyte(varargin)
% CHECKPARALLELBYTE  Get parallel port current value.
%    CHECKPARALLELBYTE  by itself, displays current parallel port value in Command Window.
%
%    [N,BITS] = CHECKPARALLELBYTE  gets parallel port value both as an integer N (0 <= n <= 255)  
%    and, optionnally, as a logical vector of bit values BITS.
%
%    [N,BITS] = CHECKPARALLELBYTE(n) <TODO!>  checks LPTn

binvec = getvalue(getparallelport);

n = binvec2dec(binvec);

% 'binvec' element order are inverted: "A binvec
%      value is a binary vector which is written with the least significant
%      bit (LSB) as the leftmost vector element and the most significant
%      bit (MSB) as the rightmost vector element." (from "help getvalue", DAQ toolbox)
% We want something more intuitive (even if less pratical), so let's inverted it again:
bits = binvec(end:-1:1);

if ~nargout
%    disp([num2str(bits) '    (' num2str(n) ')'])
   clear n bits
end