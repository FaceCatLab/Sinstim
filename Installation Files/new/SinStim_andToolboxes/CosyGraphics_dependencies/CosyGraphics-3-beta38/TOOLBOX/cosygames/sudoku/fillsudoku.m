function sudoku = fillsudoku(n,sudoku,solution)
% FILLSUDOKU  Fill sudoku's squares to make it easier.
%   sudoku = FILLSUDOKU(n, sudoku <,solution>)  fills n random "squares" in sudoku matrix.

if nargin <3, solution = solvesudoku(sudoku); end
if n > sum(~sudoku(:)), n = sum(~sudoku(:)); end
free = Shuffle(find(~sudoku(:)));
sudoku(free(1:n)) = solution(free(1:n));