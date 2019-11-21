%% Cosygraphics' Sudoku demo.

[P,S] = makesudoku;
F = fillsudoku(52,P,S);

startpsych;
setgamma(2.3);
playsudoku(F,S,'isoluminant');
setgamma(1);
stopcosy
