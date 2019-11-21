function S = solvesudoku(P)
% SOLVESUDOKU  Find solution of a Sudoku grid.
%    S = SOLVESUDOKU(P)  solves puzzle matrix P and returns solution matrix S.

dispinfo(mfilename,'info','Solving Sudoku... SU will probably tell you that it is easy, don''t believe it...')
S = [];
while ~all(size(S)==[9,9])
    S = su(P,1e10,1,1,1);
end