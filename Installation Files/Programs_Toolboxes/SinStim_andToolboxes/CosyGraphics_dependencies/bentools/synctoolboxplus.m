function synctoolboxplus(action)
% SYNCTOOLBOXPLUS  Synchronize BenTools and current GLab version files between hard-disk and USB drive. 
%    <TODO: install new GLab version>
%
%    SYNCTOOLBOXPLUS BACKUP  copies new and more recently modified files from "TOOLBOX+" folder
%    on hard disk to "X:\TOOLBOX+" folder on USB drive.
%
%    SYNCTOOLBOXPLUS UPDATE  copies new and more recently modified files from "X:\TOOLBOX+" folder
%    on USB drive to "TOOLBOX+" folder on hard disk.

%% Find "X:\TOOLBOX+" on USB device
% We assume that the TOOLBOX+ folder is in the drive's root.
% We don't know what's the drive letter; let's try all possibilities
% one by one from Z: to D:
letters = char(['W':-1:'O' 'L':-1:'D']); % 'M:' & 'N:' are data partition on DARTAGNAN & clones. <11/1/11: suppr X: to Z:>
D = whichdir(mfilename);
D = upper(D(1));
found = 0;
for i = 1 : length(letters)
    X = letters(i);
    if X ~= D && exist([X ':\'],'dir')
        found = 1;
        break
    end
end
if ~found
    error('Cannot find USB drive.')
end

%% "TOOLBOX+" folder on hard-disk
cd(bentoolsroot)
cd ..
toolboxplus_hd = cd;

%% 1) Update BenTools
folder_hd  = bentoolsroot;
folder_usb = [X ':\TOOLBOX+\bentools\'];
cd(folder_hd)
v_hd = btversion;
checkdir(folder_usb); % <11/1/11>
cd(folder_usb)
v_usb = btversion;
cd(toolboxplus_hd)
disp(' ')
disp('Syncing bentools...')
switch lower(action)
    case 'backup',  cmd = ['XCOPY ' fullfile(folder_hd ,'*') ' ' folder_usb ' /VIDERYL'];
    case 'update',  cmd = ['XCOPY ' fullfile(folder_usb,'*') ' ' folder_hd  ' /VIDERYL'];
end
disp(cmd)
disp('Files to be copied:')
[err,str] = dos(cmd);
disp(str(1:end-1))
if ~err && str(1) > '0'
    k = input('Do you want to proceed (Y/N)?  ','s');
    if     k == 'y', cmd(end) = []; 
    elseif k == 'p', cmd(end) = 'P'; % </P options bugs!>
    end
    if k == 'y' | k == 'p'
        dos(cmd);
    end
end

%% 2) Update GLab
% glabhelp('GLabManual.txt'); % Update manual; % <broken; temp suppr GLab v2-beta51>
try   v = cosyversion;
catch v = glabversion;
end
switch v(1)
    case 2
        folder_hd = glabroot;
        folder_usb = [X ':\TOOLBOX+\GLab-' vnum2vstr(glabversion)];
    case 3
        folder_hd = cosygraphicsroot;
        folder_usb = [X ':\TOOLBOX+\CosyGraphics-' vnum2vstr(glabversion)];
end
disp(' ')
disp(['Syncing GLab ' vnum2vstr(glabversion) '...'])
switch lower(action)
    case 'backup',  cmd = ['XCOPY ' fullfile(folder_hd ,'*') ' ' folder_usb ' /VIDERYL'];
    case 'update',  cmd = ['XCOPY ' fullfile(folder_usb,'*') ' ' folder_hd  ' /VIDERYL'];
end
disp(cmd)
disp('Files to be copied:')
[err,str] = dos(cmd);
disp(str(1:end-1))
if ~err && str(1) > '0'
    disp(cmd)
    k = input('Do you want to proceed (Y/N)?  ','s');
    if     k == 'y', cmd(end) = []; 
    elseif k == 'p', cmd(end) = 'P'; % </P options bugs!>
    end
    if k == 'y' | k == 'p'
        dos(cmd);
    end
end

%% end
cd(toolboxplus_hd)
disp(' ')