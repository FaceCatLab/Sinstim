% cosydemo_display_MovingTarget2_LogAndSaveData  Automatically log target data.
% drawround() is replaced by drawtarget() which not only draws targets but also logs it's position 
% and other data. Data so logged are recuperated at end of block by gettargetdata() and can be saved
% by Matlab's standard save() function.

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

x0 = -300;
x1 = 200;
y = 0;

for tr = 1 : NbOfTrials
    % Init trial: 
    % The starttrial function will:
    % - Configure Matlab for the real-time part of our program (!).
    % - Initialize CosyGraphics's log and automatic error checking system.
    starttrial; 
    %--------------------------------- REAL-TIME PART ---------------------------------
    
    % Fixation:
    drawtarget(1,'round',[1 0 0], 0, [x0 y], 12); % target 1 is drawn as a red (rgb=[1 0 0]) round, in buffer 0 (backbuffer), at the center (x,y= [0 0]), whith diameter of 12 pixels.
    displaybuffer(0, 600, 'Fix');  % display buffer 0 for 700 msec ("Fix" is only a tag).    <--- TRIAL ONSET: first call to displaybuffer after starttrial: the onset of this display is the onset of the trial !
    
    % Rampe:
    for i = 1 : 100
        x = x0 + (x1-x0) * i/100;
        drawtarget(1,'round',[1 0 0], 0, [x y], 12); % draws a round target AND logs it's position, time of presentation, etc.
        displaybuffer(0, oneframe, 'Rampe'); % Use the oneframe function to provide the duration argument.
    end
    
    % Blank screen:
    displaybuffer(0, 500, 'Blank');
    
    % Stop trial:
    stoptrial; %-------------------- END REAL-TIME PART --------------------------------
    waitintertrial(1000);  % one second of inter-trial
end

%% Stop
stopcosy;

%% Get target data logged by drawtarget().
T = gettargetdata; % Get all target data logged by drawtarget() in structure T. 
% save(uigefile,T); % Save it.

workspaceexport; % export all function's variables into matlab's workspace.