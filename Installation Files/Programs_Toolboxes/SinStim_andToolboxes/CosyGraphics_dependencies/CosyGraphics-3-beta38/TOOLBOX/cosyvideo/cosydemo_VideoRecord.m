% cosydemo_display_ImageAnimated  Remove image's background. <TODO: Finish comments>
%    This demo is the same than the precious one, except that we added background transparency.

% function cosydemo_display_ImageAnimated

%% Load images from files
ImageDir = fullfile(cosydir('demos'),'images','animated_image');
AnimatedImage = loadimage(ImageDir);

% Choose library: 
% Cogent does not support transparency ; PsychTB does. 
Lib = 'PTB';

%% Init CosyGraphics
startpsych(0, [640 480], [0.765 0.765 0.765]);

%% Store images in video-buffers
% We use storeanimatedimage in place of the usual storeimage ; the returned handle
% can then be used exacly like a buffer handle of a unique image.
AnimHandle = storeanimatedimage(AnimatedImage); 

%% Trial loop
NbOfTrials = 1;
NbOfFrames = 100;
[w,h] = getscreenres;
yPos = linspace(-h/2, +h/2, NbOfFrames);
for tr = 1 : NbOfTrials 
    startvideorecord;
    starttrial; 

    for fr = 1 : NbOfFrames
        xy = [0 yPos(fr)];
        copybuffer(AnimHandle, 0, xy); % use animation's handle like a buffer's handle.
        displaybuffer(0, oneframe);
    end
    
    stoptrial;
    stopvideorecord;
    
    waitintertrial(1000);
end

%% Stop
stopcosy;

%% Save video
dispinfo(mfilename,'info','Saving video file to current directory...');
savevideorecord('demovideo.avi');