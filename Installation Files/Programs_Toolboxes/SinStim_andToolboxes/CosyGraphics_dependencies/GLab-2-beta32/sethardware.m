function sethardware(device,varargin)
% SETHARDWARE
%    sethardware('screen',n,'size(cm)',[w h])  configurates GLab for using a screen of physical size  
%    w-by-h centimeters.

global GLAB_HARDWARE

%% Input Args
device = lower(device);

%% Config file name
% We always put the config file at the same place: 
% - On MS-Windows: "X:\glab-hardware.conf", where X: is the drive where GLab is installed.
%   Advantages:
%   -- writable place on UCL standard PCs
%   -- we hope on this place, users will not copy this file when copying GLab from one PC to another
%   -- on our std experimental PCs, it's on the data partion, so it'll not be inside the system 
%      partition image. (Most hw is the same, but screens differ.)
% - On Linux:
%   <todo>
p = glabroot;
if ispc
    drive = p(1:2);
elseif IsLinux
    error('not implemented for linux.') % <todo>
else
    error('Not yet implemented for this OS.')
end
filename = [drive filesep 'glab-hardware.conf'];

%% Reload GLAB_HARDWARE from conf file
if exist(filename,'file')
    GLAB_HARDWARE = load(filename,'-mat');
end

%% Set GLAB_HARDWARE
switch device
    case 'screen'
        n = varargin{1};  % screen #
        switch varargin{2}
            case 'size(cm)'
                wh = varargin{3};
                GLAB_HARDWARE.SCREEN(n).Size_measured_cm = wh;
                [w,h] = Screen('DisplaySize',n);
                GLAB_HARDWARE.SCREEN(n).Size_fromEDID_mm = [w,h];
                
            case 'viewingdistance(cm)'
                % <todo>
        end
end

%% Save modified GLAB_HARDWARE
if ~exist(filename,'file')  % First time..
    save6(filename,'-mat','-struct','GLAB_HARDWARE'); % ..create file
else                        % Already existing file..
    save6(filename,'-mat','-append','-struct','GLAB_HARDWARE'); % ..append vars
end