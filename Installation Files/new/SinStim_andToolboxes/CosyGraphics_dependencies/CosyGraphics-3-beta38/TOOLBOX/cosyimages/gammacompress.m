function M = gammacompress(M,gamma)
% GAMMACOMPRESS  Undo gamma correction on a matrix.
%    M = GAMMACOMPRESS(M,gamma)  undo gamma correction on image matrix I.
%
%    C = GAMMACOMPRESS(C,gamma)  where C is a cell array containing image matrices,
%    applies gamma correction on each elements of C.
%
% See also: GAMMAEXPAND, SETGAMMA.

M = gammaexpand(M, 1/gamma);