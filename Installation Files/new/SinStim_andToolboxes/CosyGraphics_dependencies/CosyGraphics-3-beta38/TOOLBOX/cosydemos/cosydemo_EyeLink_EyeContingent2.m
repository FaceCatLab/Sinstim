% cosydemo_EyeLink_EyeContingent2  General solution for gaze-contingent display.


function cosydemo_EyeLink_EyeContingent2 


%% Load images from files
ImageFile = fullfile(cosydir('demos'),'images','backgrounds','800x600.jpg');
I = loadimage(ImageFile);

% -> image 1: color image
HSV = rgb2hsv(I);
HSV(:,:,2) = HSV(:,:,2) .* 1.3;  % increase color saturation  <todo: let that in a demo?>
I = hsv2rgb(HSV);
FovealImageMatrix = I;            % foveal image = color image.

% -> image 2: grayscale image
PeriphImageMatrix = rgb2gray(I);  % periph. image = grayscale image.


%% Init CosyGraphics
startpsych(1, [800 600], [.5 .5 .5]);  % (note that startcogent(...) does the same than startcosy('Cog',...) )
openeyelink;


%% Store images in video-buffers
PeriphImageBuff = storeimage(PeriphImageMatrix);
FovealImageBuff = storeimage(FovealImageMatrix);


%% Create mask
% M = matdraw('round', 0, ones(120), [0 0], 120); % matdraw is function which "draws" geometrical shapes into a matrix, using the same syntax than draw().

% Create gaussian mask:
m = 200;
[X,Y] = meshgrid(-m:m, -m:m);
xsd = m/2.2;
ysd = m/2.2;
M = 1 - exp(-((X/xsd).^2)-((Y/ysd).^2));

% store mask into video-RAM:
MaskBuff = storealphamask(M);

% Show mask in a Matlab figure, for demo:
close all
figure;
set(gcf, 'name', 'Alpha mask');
imshow(M);
set(gcf,'unit','norm'); p = get(gcf,'Position'); p(1) = 1 - p(3); set(gcf,'Position',p);  % align to right.
drawnow; 

%% Trial loop
NbOfTrials = 1;
NbOfFrames = 2000;
for tr = 1 : NbOfTrials 
    starttrial; 
    
    % Display Images:
    for fr = 1 : NbOfFrames
        copybufferthroughmask(FovealImageBuff, MaskBuff, geteye, PeriphImageBuff);
        displaybuffer(0,oneframe);
    end
    
    % Stop trial: 
    stoptrial;
    waitintertrial(1000);
end

%% Stop
stopcosy;
workspaceexport;