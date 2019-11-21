% cosydemo_display_FixImages1_basic  Bases of display, to display a sequence of images.


%% Function declaration:
% For any real-time experiment, your m-file *MUST* be declared as a function. Matlab keeps functions 
% in memory after first execution ; it doesn't for script m-files. The inconvenient of functions
% versus scripts, is that you cannot acces to a function's variable from the workspace. The workspacexport
% function fixes that for you (see at end of file).
function cosydemo_display_FixImages1_basic  % (this line can also be at top of the file, above the help header.)


%% Load images from files
% This is the path to a CosyGraphics directory containing images:
ImageDir = fullfile(cosydir('demos'),'images','faces');

% Read files:
% The loadimage function, if you provide it with a dir name, will read all valid image files
% contained in it and will return a cell array containing image matrices (M-by-N-by-3 matrices
% of numbers from 0.0 to 1.0).
[ImageMatrices,FileNames] = loadimage(ImageDir);


%% Init CosyGraphics
% Choose low-level library:
% CosyGraphics can run as a high-level layer over two libraries: Cogent or PsychToolBox. 
% PTB is more powerfull, more complete and more precise, but Cogent is by far more 
% stable on Windows PCs, especially on laptops. So, for a demo, let's choose Cogent.
Lib = 'Cog'; % 'Cog' = Cogent, 'PTB' = PsychToolBox.

% Display parameters:
ScreenNum = 0; % 0: display in a window, good for a demo. Real experiment will have to be run in full screen.
DisplayResolution = [640 480]; % [width height], in pixels.
BackgroundColor = [.5 .5 .5]; % [red green blue], value range from 0.0 to 1.0.

% Init display:
startcosy(Lib, ScreenNum, DisplayResolution, BackgroundColor);  % (note that startcogent(...) does the same than startcosy('Cog',...) )


%% Store images in video-buffers
% Our images are currently stored in the central memory (RAM), in the form of Matlab matrices.
% Let's pre-load them into the graphics memory (Video-RAM), into off-screen buffers. They will be
% then be available with the highest possible performances during the real-time part of the program.
ImageBuffers = storeimage(ImageMatrices);


%% Trial loop
NbOfTrials = 2;
for tr = 1 : NbOfTrials 
    % Init trial: 
    % The starttrial function will:
    % - Configure Matlab for the real-time part of our program (!).
    % - Initialize CosyGraphics's log and automatic error checking system.
    starttrial; 
    %--------------------------------- REAL-TIME PART ---------------------------------
    
    % Fixation Point:
    drawround([0 0 1], 0, [0 0], 12); % draw a blue round, in buffer 0 (backbuffer), at the center (x,y= [0 0]), whith diameter of 12 pixels.
    displaybuffer(0, 1200, 'Fix');  % display buffer 0 for 1200 msec ; "Fix" is only a tag.    <--- TRIAL ONSET: first call to displaybuffer after starttrial: the onset of this display is the onset of the trial !
    
    % Display Images:
    for i = 1 : length(ImageMatrices)
        displaybuffer(ImageBuffers(i), 500, FileNames{i}); % (we give the filename as tag ; that will give us a convenient feedback in the command-line.)
    end
    
    % Stop trial: 
    stoptrial; %-------------------- END REAL-TIME PART --------------------------------
    waitintertrial(1000);  % one second of inter-trial
end


%% Stop
stopcosy;
workspaceexport; % export all function's variables into matlab's workspace.