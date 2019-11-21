function sudoku(nFilled,ColorTheme,PuzzleMat,SolutionMat)
% SUDOKU  Sudoku game.
%    SUDOKU  by itself, starts a complete Sudoku game.
%
%    SUDOKU n  starts a sudoku with n cells pre-filled (makes it easier).
%
%    SUDOKU(n,ColorTheme)  defines the color theme.  ColorTheme can be 'classic' (default),
%    'color' or 'isoluminant'.
%
%    SUDOKU(n,ColorTheme,PuzzleMat,SolutionMat)  starts game with given puzzle matrix.


%% Input Args
if ~nargin
    nFilled = 0;
elseif ischar(nFilled)
    nFilled = str2num(nFilled);
end
if nargin < 2
    ColorTheme = 'classic';
end
if nargin < 3 || isempty(PuzzleMat)
    [PuzzleMat,SolutionMat] = makesudoku;
end

%% Fill cells
PuzzleMat = fillsudoku(nFilled,PuzzleMat,SolutionMat);

%% Play Game
startpsych;
setgamma(2.3);
playsudoku(PuzzleMat,SolutionMat,ColorTheme);
stoppsych;
setgamma(1);
