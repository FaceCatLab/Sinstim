% cosydemo_EyeLink_EyeContingent1  Gaze-contingent display. Simplest case: draw a shape at eye position.


% function cosydemo_EyeLink_EyeContingent1 


%% Load background image from file
ImageFile = fullfile(cosydir('demos'),'images','backgrounds','800x600.jpg');
ImageMatrix = loadimage(ImageFile);


%% Init CosyGraphics
Lib = 'PTB'; % Only PTB supports alpha-blending correcltly.
startcosy(Lib, 0, [640 480], [.5 .5 .5]);  % (note that startcogent(...) does the same than startcosy('Cog',...) )

% Open EyLink (We suppose that it is already calibrated !!! (see starteyelinkcalib))
openeyelink;


%% Store images in video-buffers
ImageBuff = storeimage(ImageMatrix);


%% Trial loop
NbOfTrials = 1;
NbOfFrames = 600;
for tr = 1 : NbOfTrials 
    starttrial; 
    
    % Display Images:
    for fr = 1 : NbOfFrames
        copybuffer(ImageBuff, 0);  % copy backgroundbuffer into backbuffer.
        drawround([0 0 0], 0, geteye, 100);  % draw round directly in backbuffer at eye position.
        displaybuffer(0,oneframe); 
    end
    
    % Stop trial: 
    stoptrial;
    waitintertrial(1000);
end


%% Stop
stopcosy;
workspaceexport;


%% Save
% <TODO>