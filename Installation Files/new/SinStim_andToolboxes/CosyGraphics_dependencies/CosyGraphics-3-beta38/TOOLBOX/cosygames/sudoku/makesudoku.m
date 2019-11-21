function [sudoku,solution] = makesudoku
% MAKESUDOKU  Make a sudoku matrix.
%   [sudoku,solution] = MAKESUDOKU  returns a sudoku matrix and it's 
%   solution.
%
%   This code will try to produce the hardest Sudoku it can. Since the
%   solution is given, you can always make the Sudoku easier by filling in
%   several squares (see FILLSUDOKU). The solution given is guaranteed to 
%   be the ONLY solution.
%
%   This code can sometimes spend up to a minute on a single Sudoku (I would
%   think that if a terribly difficult Sudoku is being created, this code can
%   spend many minutes on it). Progress messages will start to be shown if
%   the Sudoku is not created after 30 seconds. 
%
%   WARNING: This functions crashes PsychToolbox display !!! (for an unknown  
%   reason). Don't use if during an experiment !!!
%
% Example:
%     [puzzle,solution] = makesudoku;
%     sudoku = fillsudoku(20,puzzle,solution); % fill 20 squares to make the sudoku easier.
%
% Edit SUDOKU to get another example.


%% Call SudokuMaker to get a sudoku matrix
% % SudokuMaker says it will work only if it's dir is the current one, let's change dir.
% old_dir = cd;
% cd(fullfile(mfilepath,'lib','sudoku'))

% Call Bradley Knockel's SudokuMaker. It's a script and it will create 'sudoku' and 
% 'solution' matrices.
disp(' ')
dispinfo(mfilename,'info','Creating a Sudoku matrix...')
SudokuMaker;
disp(' ')
dispinfo(mfilename,'info','Done.')
disp(' ')

% % Restore old current dir.
% cd(old_dir)
