% DEMO_ERWAN  Fix images sequence demo.

%% Load image files
imagedir = fullfile(glabroot,'\demos\images\faces\'); % a set of images included in GLab toolbox.
images = loadimage(imagedir); % Load images from files to MxNx3 matrices of doubles in the range 0.0 to 1.0.

%% Change background color to medium gray
bg = backgroundmask(images, 6/255, 2); % 
images = changebackgroundcolor(images, bg, [.5 .5 .5]);
% bgcolor = [.5 .5 .5];
% for i = 1 : length(images)
%     BG = backgroundmask(images{i}, 6/255, 2);
%     R = images{i}(:,:,1);
%     G = images{i}(:,:,2);
%     B = images{i}(:,:,3);
%     R(BG) = bgcolor(1);
%     G(BG) = bgcolor(2);
%     B(BG) = bgcolor(3);
%     images{i} = cat(3,R,G,B);
% end

%% Start GLab over Cogent
startcogent(0, [800 600], [.5 .5 .5]);
opensound;
openparallelport;
% openserialport(4,115200) correct settings for the USB serial port of Saint Luc's 3 Tesla fMRI scanner

%% Store images into video-RAM buffers
buffers = storeimage(images);
for i = 1 : length(buffers)
    drawround([1 1 1], buffers(i), [0 0], 10); % (rgb, buffer handle, [x y], diameter)
end

%% Store sound into audio buffer
storetuut(300,500);

%% Trial loop
nTrials = 2;
for tr = 1 : nTrials
    starttrial;
    
    % Fix:
    drawround([1 1 1], 0, [0 0], 10); % (rgb, buffer handle, [x y], diameter)
    displaybuffer(buffers(i), 1000, 'fix');
    % Send // trigger:
    sendparallelbyte(255); % Put it immediately after displaybuffer to have it synchronized with display onset
    wait(1); % wait 1 ms
    sendparallelbyte(0); % reset // port
    
    % Faces:
    for i = 1 : length(buffers)
        displaybuffer(buffers(i), 750, ['face' num2str(i) ]);
        if i == 1 || i == 12
            playsound; % Put it immediately after displaybuffer to have it synchronized with display onset
        end
    end
    displaybuffer(0);
    
    stoptrial;
    wait(1000)
end

%% Stop
stopglab;