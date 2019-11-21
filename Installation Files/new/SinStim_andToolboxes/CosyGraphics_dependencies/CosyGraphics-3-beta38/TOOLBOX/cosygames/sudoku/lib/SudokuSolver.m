%% Solve a Sudoku!!!

% You must be in the Sudoku directory for this to work.
%
% If you are solving a very underdetermined Sudoku, it can take hours
% before memory will run out. Pressing "ctrl-c" at the command line works
% to stop the code if you don't want to wait for it to finish.
%
% For certain Sudokus, a value called "depth of thread" is returned. Given
% an ordering that specifies which squares are to be guessed first, this
% value is the minimum number of guesses that the code needs to make. I
% have somewhat randomized the method I use to determine the ordering
% because the "depth of thread" value of a single ordering is not
% significant, so now you can run the same Sudoku twice to get different
% values. The randomization will not be complete randomization. The
% ordering will always cause the group of squares that have the least
% uncertainty to be guessed first, the group of squares that have slightly
% more uncertainty to be guessed second, etc.
%
% http://www.sudokuwiki.org/sudoku.htm is a great Sudoku solver. The primary
% purpose of SudokuSolver.m is to explore the solver su.m that
% SudokuMaker.m uses.
%
% (c) 2008 Bradley Knockel

%% choose a Sudoku

matrix='matrix4';

% here is a blank (be careful to not try to solve this when it's blank!)
% You can fill this in manually or paste Sudokus from SudokuMaker.m from
% the command window to inside the brackets (solving the Sudokus from
% SudokuMaker.m here is useful to get more "depth of thread" values)
matrix1=[
    0,0,0,0,0,0,0,0,0
    0,0,0,0,0,0,0,0,0
    0,0,0,0,0,0,0,0,0
    0,0,0,0,0,0,0,0,0
    0,0,0,0,0,0,0,0,0
    0,0,0,0,0,0,0,0,0
    0,0,0,0,0,0,0,0,0
    0,0,0,0,0,0,0,0,0
    0,0,0,0,0,0,0,0,0];

% here is a typical easy Sudoku (one that can be solved by simply checking
% every row, column, box, and square over and over again) (I got this from
% the Yahoo game "Sudoku Daily")
matrix2=[
    2,0,0,7,1,0,0,6,0
    0,0,5,0,8,2,0,0,3
    0,7,0,0,9,0,0,0,0
    0,8,0,3,0,0,0,0,0
    0,6,0,0,7,0,0,5,0
    0,0,0,0,0,5,0,2,0
    0,0,0,0,5,0,0,3,0
    4,0,0,1,3,0,7,0,0
    0,3,0,0,6,4,0,0,1];

% here is a moderate Sudoku (one that requires some fancy tricks) (many
% people have confused this one with the world's hardest)
matrix3=[
    8,5,0,0,0,2,4,0,0
    7,2,0,0,0,0,0,0,9
    0,0,4,0,0,0,0,0,0
    0,0,0,1,0,7,0,0,2
    3,0,5,0,0,0,9,0,0
    0,4,0,0,0,0,0,0,0
    0,0,0,0,8,0,0,7,0
    0,1,7,0,0,0,0,0,0
    0,0,0,0,3,6,0,4,0];

% A hard Sudoku is one that requires tricks too fancy, too numerous,
% and too complex, so I resort to guessing. The following Sudoku is the
% famed "AI Escargot", which is claimed to be world's hardest, and I think
% it is.
matrix4=[
    1,0,0,0,0,7,0,9,0
    0,3,0,0,2,0,0,0,8
    0,0,9,6,0,0,5,0,0
    0,0,5,3,0,0,9,0,0
    0,1,0,0,8,0,0,0,2
    6,0,0,0,0,4,0,0,0
    3,0,0,0,0,0,0,1,0
    0,4,0,0,0,0,0,0,7
    0,0,7,0,0,0,3,0,0];

% overdetermined in a trivial way
matrix5=[
    0,0,0,0,0,0,0,0,0
    7,0,0,0,0,0,0,0,7
    0,0,0,0,0,0,0,0,0
    0,0,0,0,0,0,0,0,0
    0,0,0,0,0,0,0,0,0
    0,0,0,0,0,0,0,0,0
    0,0,0,0,0,0,0,0,0
    0,0,0,0,0,0,0,0,0
    0,0,0,0,0,0,0,0,0];

% overdetermined in a non-trivial way
matrix6=[
    5,7,4,8,6,2,9,1,3
    6,3,1,0,0,0,0,0,4
    9,2,8,0,0,0,0,0,6
    4,0,0,3,5,8,0,0,2
    3,0,0,7,1,9,0,0,5
    1,0,0,6,2,4,0,0,9
    8,0,0,0,0,0,3,6,7
    7,0,0,0,0,0,2,9,8
    2,0,0,0,0,0,4,5,1];

% overdetermined in a diabolical way
matrix7=[
    1,8,0,0,0,7,0,9,0
    0,3,0,0,2,0,0,0,8
    0,0,9,6,0,0,5,0,0
    0,0,5,3,0,0,9,0,0
    0,1,0,0,8,0,0,0,2
    6,0,0,0,0,4,0,0,0
    3,0,0,0,0,0,0,1,0
    0,4,0,0,0,0,0,0,7
    0,0,7,0,0,0,3,0,0];

% Here is a good example of an underdetermined Sudoku. Because the goal of
% my code is far from dealing with very underdetermined Sudokus, Sudokus
% that are any more underdetermined than this one will cause the code to
% take a LONG time to run. Different solutions will be returned for
% different runs.
matrix8=[
    2,4,8,7,1,3,9,6,5
    6,9,5,0,0,0,0,0,3
    1,7,3,0,0,0,0,0,8
    5,0,0,3,2,9,0,0,7
    9,0,0,8,7,1,0,0,4
    3,0,0,6,4,5,0,0,9
    8,0,0,0,0,0,4,3,6
    4,0,0,0,0,0,7,9,2
    7,0,0,0,0,0,5,8,1];


%% solve the Sudoku

disp(['******************** ',matrix,' is being analyzed... ********************'])
eval(['sudoku=',matrix])
disp('calling su.m...')
a=su(sudoku,1e10,1,1,1);
if all(size(a)==[9,9])
    solution=a
end
clear all
