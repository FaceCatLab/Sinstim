function P = loadsudoku(difficulty,gridNumber)
% LOADSUDOKU  Load a Sudoku puzzle matrix from hard-disk.
%    P = LOADSUDOKU(DIFFICULTY)  loads a random Sudoku puzzle and returns it in matrix P.  DIFFICULTY 
%    can be 'easy', 'medium', 'hard' and 'absurd'.  There are 31 different Sudoku puzzle of each 
%    difficulty.
%
%    P = LOADSUDOKU(DIFFICULTY,N)  loads Sudoku matrix number N.  N goes from 1 to 31.
%
% See also: MAKESUDOKU, SOLVESUDOKU, FILLSUDOKU, PLAYSUDOKU.

persistent RandomOrder iOrder

if isempty(RandomOrder)
    RandomOrder = randperm(31);
    iOrder = 0;
end

%% Input Args
if nargin < 1
    error('"Difficulty" argument is missing.')
elseif nargin < 2
    iOrder = iOrder + 1;
    gridNumber = RandomOrder(iOrder);
else
    if ischar(gridNumber); gridNumber = eval(gridNumber); end
end

%% Load Datax from File
dispinfo(mfilename,'info',sprintf('Loading %s Sudoku #%d',upper(difficulty),gridNumber));
fullFileName = fullfile(whichdir(mfilename), 'data', [lower(difficulty),'Sudoku']);
load(fullFileName,'sudokuVector');

%% Convert Vector -> Matrix
v = sudokuVector(gridNumber,:);
P = zeros(9,9);
P(:) = v';