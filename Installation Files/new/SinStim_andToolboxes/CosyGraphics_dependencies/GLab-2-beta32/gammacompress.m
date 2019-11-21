function M = gammacompress(M,gamma)
% GAMMACOMPRESS  Undo gamma correction on a matrix.
%    M = GAMMACOMPRESS(M,gamma)
%    C = GAMMACOMPRESS(C,gamma)

M = gammaexpand(M,1/gamma);