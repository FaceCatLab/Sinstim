function [sudoku,responses] = playsudoku(sudoku,colorTheme,timeout,scoreGainPerCell,scoreLossPerError)
% PLAYSUDOKU  Start a Sudoku game.
%    [sudoku,responses] = PLAYSUDOKU(G <,colorTheme><,timeout><,scoreGainPerCell><,scoreLossPerError>)  
%    begins a sudoku game. G is a grid matrix as returned by LOADSUDOKU, MAKESUDOKU and FILLSUDOKU. 
%    Returns when grid is complete or when timeout is reached.  "colorTheme" can be 'classic' (default) 
%    or 'isoluminant'.  The 'isoluminant' color theme is intended to minimize effect on the pupil size <not tested, yet!!>.  
%    "timeout" is the time out in seconds.  "scoreGainPerCell" defines the points gained per cell  
%    correctly filled, while "scoreLossPerError" defines the number of point lost per mistake.
%
% Examples:
%    Classical Sudoku:
%        G = makesudoku;
%        F = fillsudoku(20,G); % make it easier
%        playsudoku(F,'classical');
%
%    Iso-luminant Sudoku, +1 point per cell filled, -2 per error:
%        G = loadsudoku('easy');
%        playsudoku(G,'isoluminant',inf,1,-2);
%
%    Edit SUDOKU to get a complete example.

resetabortflag;

%% Params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Param.GridSize = 9*50;
Param.NumPadSize = 120;
Param.NumPadGridThickness = 5;
if iscog
    Param.FontName = 'Arial';
    Param.FontSize = 40;
    Param.FontYOffset = -1;
else
    Param.FontName = 'DejaVu Sans';
    Param.FontSize = 22;
    Param.FontYOffset = -7;
end
Param.DigitColorCorrect = [.2 .3 .2];
Param.DigitColorWrong   = [.8 .1 .1];

Param.EnableSCORE = 1;

Param.EnableSOUND = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Input Args
sudokuInput = sudoku;
if ~exist('colorTheme','var'), colorTheme = 'classic'; end
colorTheme = lower(colorTheme);
if ~exist('timeout','var'), timeout = inf; end
if ~exist('scoreGainPerCell','var'), scoreGainPerCell = +1; end
if ~exist('scoreLossPerError','var'), scoreLossPerError = -2; end

solution = solvesudoku(sudoku);

%% Set Score
score = 0;
setscore(0);
p = getscoreproperties('currenttotal');
p.BarMaxValue = sum(sum(~sudoku)) * scoreGainPerCell;
p.BarY = -Param.GridSize/2 - (getscreenheight-Param.GridSize)/4;
p.DigitY = p.BarY - 5;
switch colorTheme
    case 'isoluminant'
        p.BarColorSuccess = [.2 .5 .5];
        p.BarColorFailure = [ 1 .5 .5];
        p.BarColorNeutral = [.6 .5 .5];
        p.DigitColorSuccess = [0 0 0];
        p.DigitColorNeutral = [0 0 0];
%         p.DigitColorSuccess = p.BarColorSuccess;
%         p.DigitColorFailure = p.BarColorFailure;
%         p.DigitColorNeutral = p.BarColorSuccess;
end
p.DigitSize = 18;
setscoreproperties('currenttotal',p);

%% Load Sounds
sounddir = fullfile(whichdir(mfilename),'sounds');
s = load(fullfile(sounddir,'JapaneseNumbersVoice.mat'), 'JapaneseNumbersVoice');
JapaneseNumbersVoice = s.JapaneseNumbersVoice;
[y,fs] = loadsound(fullfile(sounddir,'winningSound1.wav'));
WinningSound.y = y;
WinningSound.fs = fs;
[y,fs] = loadsound(fullfile(sounddir,'PacMan-Eating.wav'));
ErrorSound.y = y;
ErrorSound.fs = fs;

%% Create Grid
white = [1 1 1];
black = [0 0 0];
gray  = [.5 .5 .5];

switch colorTheme
    case {'classic','color'}
        buffGrid = newbuffer(gray);
        GridBackgroundColor = white;
    case 'isoluminant'
        R = rand(600,800,3);
        buffGrid = storeimage(R);
        GridBackgroundColor = gray;
end
ColorPerDigit = [ ...
    .6 .7 .7    ;...
    0 0 .6      ;...
    .7 .1 .1    ;...
    .9 .8 0     ;...
    .7 .6 1     ;...
    .8 .2 .8    ;...
    .1 .6 .1    ;...
    .5 .25 .1   ;...
    0 0 0       ];

ss = [Param.GridSize Param.GridSize];
drawsquare(black, buffGrid, [0 0], ss+10);
drawsquare(GridBackgroundColor, buffGrid, [0 0], ss);
drawgrid([3 3], black, buffGrid, [0 0], ss, 3);
[xGrid,yGrid] = drawgrid([9 9], black, buffGrid, [0 0], ss, 1);
for i = 1:9
    for j = 1:9
        if sudoku(i,j)
            xy = [xGrid(j) yGrid(i)+Param.FontYOffset];
            if strcmpi(colorTheme,'color'), color = ColorPerDigit(solution(i,j),:);
            else                            color = black;
            end
            drawtext(num2str(solution(i,j)), buffGrid, xy, Param.FontName, Param.FontSize, color);
        end
    end
end
copybuffer(buffGrid,0);
if strcmpi(colorTheme,'isoluminant') && getgamma==1
    str = 'Warning: Gamma is not corrected.';
    drawtext(str, 0, [0 getscreenheight/2-30], 'Courier', 26, [1 .8 0]);
end
if Param.EnableSCORE, sub_drawscore(score); end
displaybuffer(0);
tStart = time;

%% Create Virtual Numerical Pad
n = Param.NumPadSize + Param.NumPadGridThickness;
switch colorTheme
    case {'classic','color'}
        buffNumPad = newbuffer([n n], [.9 .8 1]);
        gridColor = [.3 .1 .5];
        digitColor = Param.DigitColorCorrect;
    case 'isoluminant'
        %         R = rand(n,n,1);
        %         R = .25 + .5*R;
        %         R = cat(3,R,R,R);
        R = rand(n,n,3);
        buffNumPad = storeimage(R);
        gridColor = [1 1 1] * .3;
        digitColor = [1 1 1] * .2;
    otherwise
        stopfullscreen;
        error(['Invalid argument. Unknown colorTheme: ''' colorTheme '''.'])
end
[xPad,yPad] = drawgrid([3 3], gridColor, buffNumPad, [0 0], [Param.NumPadSize Param.NumPadSize], Param.NumPadGridThickness);
for j = 1:3
    for i = 1:3
        digit = num2str((j-1)*3+(i-1)+1);
        xy = [xPad(i) yPad(j)+Param.FontYOffset];
        drawtext(digit, buffNumPad, xy, Param.FontName, Param.FontSize, digitColor);
    end
end
% copybuffer(buffNumPad,0); dib;

%% Main Loop
finished = 0;
Pad = [1 2 3; 4 5 6; 7 8 9];
responses = dataset;
responses.i = zeros(2,1); % to get all dataset's vars expanding verically
warning off stats:dataset:subsasgn:DefaultValuesAdded
respCount = 0;

% Define sub-funs used in main loop:
    function t = remaining_time
        t = max([timeout+time-tStart 0]);
    end
    function [i,j] = get_cell_index(xy, xCells, yCells)
        [v,j] = min(abs(xCells-xy(1)));
        [v,i] = min(abs(yCells-xy(2)));
    end

% Main Loop:
while ~finished && ~isaborted && remaining_time>0

    [b,xy] = waitmouseclick(remaining_time); % Wait for user to click a cell... . . .  .   .    .

    if isinside(xy,'square',[0 0],Param.GridSize) && remaining_time>0
        rt = time - tStart;
        [i,j] = get_cell_index(xy, xGrid, yGrid);
        if ~sudokuInput(i,j) % If it's not a pre-filled cell..
            xCell = xGrid(j);
            yCell = yGrid(i);
            xy = [xCell yCell]; % re-center.
            copybuffer(buffGrid,0);
            if Param.EnableSCORE, sub_drawscore(score); end            
            copybuffer(buffNumPad,0,xy);
            displaybuffer(0);
            wait(100);

            [b,xy] = waitmouseclick(inf); % Wait for user to click a digit in the num pad... . . .  .   .    .
            
            if isinside(xy,'square',[xCell yCell],Param.NumPadSize)
                [iPad,jPad] = get_cell_index(xy, xPad+xCell, yPad+yCell);
                digit = Pad(iPad,jPad);
                xy = [xCell yCell+Param.FontYOffset];
                
                if digit == solution(i,j) % Correct :)
                    sudoku(i,j) = digit;
                    points = scoreGainPerCell;
                    score = score + points;
                    if strcmpi(colorTheme,'color'), color = ColorPerDigit(digit,:);
                    else                            color = Param.DigitColorCorrect;
                    end
                    w = floor(Param.GridSize / 9) - 6;
                    drawsquare(GridBackgroundColor, buffGrid, [xCell yCell], w);
                    drawtext(num2str(digit), buffGrid, xy, Param.FontName, Param.FontSize, color);
                    copybuffer(buffGrid,0);
                    if Param.EnableSCORE, sub_drawscore(score); end
                    displaybuffer;
                    if Param.EnableSOUND, sound(JapaneseNumbersVoice.sounds{digit},JapaneseNumbersVoice.fs); end
                    
                else % Error! :(  
                    points = -abs(scoreLossPerError);
                    score = score + points;
                    if Param.EnableSOUND, sound(ErrorSound.y,ErrorSound.fs); end
                    period = 100;
                    for r = [1 1 1 1 1:-.1:0]
                        copybuffer(buffGrid,0);
                        color = r * Param.DigitColorWrong + (1-r) * GridBackgroundColor;
                        drawtext(num2str(digit), 0, xy, Param.FontName, Param.FontSize+2, color);
                        if Param.EnableSCORE, sub_drawscore(score); end
                        displaybuffer;
                        wait(period);
                    end
                end
                % Record response:
                respCount = respCount + 1;
                responses.i(respCount) = i;
                responses.j(respCount) = j;
                responses.digit(respCount) = digit;
                responses.soluce(respCount) = (digit~=solution(i,j)) * solution(i,j); % 0 if correct, solution otherwise
                responses.score(respCount) = score;
                responses.time(respCount) = round(rt)/1000; %(sec)
                
            else
                copybuffer(buffGrid,0);
                if Param.EnableSCORE, sub_drawscore(score); end
                displaybuffer;
                
            end

        end
    end
    
    if all(sudoku(:)==solution(:))
        finished = true; 
        break
    end
end

% Success animation
if all(sudoku(:)==solution(:))
    % Play Win SOund
    if Param.EnableSOUND, sound(WinningSound.y', WinningSound.fs); end
    
    % Win Animation
    StarSizeMax = 80;
    nStars = 30;
    XY = randxy(nStars,'round',20);
    for f = 1:round(getscreenfreq*3)
        copybuffer(buffGrid,0);
        if Param.EnableSCORE, sub_drawscore(score); end
        draw('star5', [1 .5 .5], 0, XY, round(rand(nStars,1)*StarSizeMax));
        displaybuffer;
        i = randele(1:nStars);
        XY(i,:) = round(rand(1,2).*getscreenres - getscreenres/2);
    end
    copybuffer(buffGrid,0);
    if Param.EnableSCORE, sub_drawscore(score); end
    displaybuffer;
end

if isaborted
    dispinfo(mfilename,'warning','Aborted by user.');
end

%% Responses -> workspace
dispinfo(mfilename,'info','Exporting "responses" to workspace...')
assignin('base','responses',responses)
responses

%% eof
end % END FUNCTION (there are functions definitions inside the code: don't remove this END)

%% Sub-FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sub_drawscore(score)
setscore(score);
drawscorebar;
drawscoredigit;
end
