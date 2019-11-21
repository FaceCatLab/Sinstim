% cosydemo_display_MovingTarget_basic  Bases of display, to display a sequence of images.


%% Function declaration:
% For any real-time experiment, your m-file *MUST* be declared as a function. Matlab keeps functions 
% in memory after first execution ; it doesn't for script m-files. The inconvenient of functions
% versus scripts, is that you cannot acces to a function's variable from the workspace. The workspacexport
% function fixes that for you (see at end of file).
function cosydemo_display_MovingTarget  % (this line can also be at top of the file, above the help header.)


%% Init CosyGraphics
% Choose low-level library:
% CosyGraphics can run as a high-level layer over two libraries: Cogent or PsychToolBox. 
% PTB is more powerfull, more complete and more precise, but Cogent is by far more 
% stable on Windows PCs, especially on laptops. So, let's try PTB, but if you experiment 
% trouble on your personnal computer, switch to 'Cog'.
Lib = 'PTB'; % 'Cog' = Cogent, 'PTB' = PsychToolBox.

% Display parameters:
ScreenNum = 0; % 0: display in a window, good for a demo. Real experiment will have to be run in full screen.
DisplayResolution = [640 480]; % [width height], in pixels.
BackgroundColor = [.5 .5 .5]; % [red green blue], value range from 0.0 to 1.0.

% Init display:
startcosy(Lib, ScreenNum, DisplayResolution, BackgroundColor);  % (note that startcogent(...) does the same than startcosy('Cog',...) )


%% Trial loop
NbOfTrials = 2;

x = -200 : 2 : 200;
y = 0;

for tr = 1 : NbOfTrials % Loop once per trial..
    % Init trial: 
    % The starttrial function will:
    % - Configure Matlab for the real-time part of our program (!).
    % - Initialize CosyGraphics's log and automatic error checking system.
    starttrial; 
    %--------------------------------- REAL-TIME PART ---------------------------------
    
    % Fixation:
    drawround([1 0 0], 0, [x(1) y], 12); % draw a red (rgb= [1 0 0]) round, in buffer 0 (backbuffer), at the center (x,y= [0 0]), whith diameter of 12 pixels.
    displaybuffer(0, 700, 'Fix');  % display buffer 0 for 700 msec ("Fix" is only a tag).    <--- TRIAL ONSET: first call to displaybuffer after starttrial: the onset of this display is the onset of the trial !
    
    % Rampe:
    for fr = 2 : length(x) % Animation: Loop once per frame..
        drawround([1 0 0], 0, [x(fr) y], 12);
        displaybuffer(0, oneframe, 'Rampe'); % Use the oneframe function to provide the duration argument.
    end
    
    % Blank screen
    displaybuffer(0, 500, 'Blank');
    
    % Stop trial: 
    stoptrial; %-------------------- END REAL-TIME PART --------------------------------
    waitintertrial(1000);  % one second of inter-trial
end


%% Stop
stopcosy;
workspaceexport; % export all function's variables into matlab's workspace.