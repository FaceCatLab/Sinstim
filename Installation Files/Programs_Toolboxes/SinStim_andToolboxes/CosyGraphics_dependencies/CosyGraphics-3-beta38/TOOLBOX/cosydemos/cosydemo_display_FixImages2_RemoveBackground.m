function cosydemo_display_FixImages2_RemoveBackground
% cosydemo_display_FixImages2_RemoveBackground  Remove image's background. <TODO: Finish comments>
%    This demo is the same than the precious one, except that we added background transparency.


%% Load images from files
ImageDir = fullfile(cosydir('demos'),'images','faces');
[ImageMatrices,FileNames] = loadimage(ImageDir);


%% Find background pixels
% ... <TODO: comments>
BgMasks = backgroundmask(ImageMatrices);
figure; imshow(BgMasks{1});
set(gcf,'unit','norm'); p1 = get(gcf,'Position'); p1(1) = 1 - p1(3); set(gcf,'Position',p1);  % align to right.
% ... <TODO: comments>
BgMasks = backgroundmask(ImageMatrices, 10/255, 2, true);
figure; imshow(BgMasks{2});
set(gcf,'unit','norm'); p2 = get(gcf,'Position'); p2(1) = 1 - p2(3); set(gcf,'Position',p2);  % align to right.

% Choose library: 
% Cogent does not support transparency ; PsychTB does. 
Lib = 'PTB';

% Change background:
switch Lib
    case 'PTB'
        % PsychToolBox supports transparency (alpha-blending). 
        % We dus can add an alpha channel to get background pixels tranparent (alpha=0).
        for i = 1 : length(ImageMatrices)
            ImageMatrices{i}(:,:,4) = ~BgMasks{i};  % alpha layer (1=opaque, 0=transparent) = invert of bg mask (1=bg, 0=fg)
        end
        
        % Note: You can do the whole stuff in one line with the ADDBACKGROUNDALPHA function (see).
        
    case 'Cog'
        % Cogent does not support transparency. We'll then change the color of bg pixels.
        ImageMatrices = changebackgroundcolor(ImageMatrices, BgMasks, [.5 .5 .5]);
end


%% Init CosyGraphics


Lib = 'PTB'; % 'Cog' = Cogent, 'PTB' = PsychToolBox.

% Init PTB display:
startcosy(Lib, 0, [640 480], [.5 .5 .5]);


%% Store images in video-buffers
ImageBuffers = storeimage(ImageMatrices);


%% Trial loop
NbOfTrials = 2;
for tr = 1 : NbOfTrials 
    starttrial; 
    
    drawround([1 0 0], 0, [0 0], 12);
    displaybuffer(0, 700, 'Fix');
    
    for i = 1 : length(ImageMatrices)
        displaybuffer(ImageBuffers(i), 500, FileNames{i});
    end
    
    stoptrial;
    waitintertrial(1000);
end


%% Stop
stopcosy;