function sethardware(device,varargin)
% SETHARDWARE <unfinished>
%    sethardware('screen',n,'size(cm)',[w h])  configurates CosyGraphics for using a screen of physical size  
%    w-by-h centimeters.

global COSY_HARDWARE

%% Input Args
device = lower(device);

%% Config file name
% We always put the config file at the same place: 
% - On MS-Windows: "X:\glab-hardware.conf", where X: is the drive where CosyGraphics is installed. <TODO: Review that for v3>
%   Advantages:
%   -- writable place on UCL standard PCs
%   -- we hope on this place, users will not copy this file when copying CosyGraphics from one PC to another
%   -- on our std experimental PCs, it's on the data partion, so it'll not be inside the system 
%      partition image. (Most hw is the same, but screens differ.)
% - On Linux:
%   <todo>
p = cosygraphicsroot;
if ispc
    drive = p(1:2);
elseif IsLinux
    error('not implemented for linux.') % <todo>
else
    error('Not yet implemented for this OS.')
end
filename = [drive filesep 'glab-hardware.conf'];

%% Reload COSY_HARDWARE from conf file
if exist(filename,'file')
    COSY_HARDWARE = load(filename,'-mat');
end

%% Set COSY_HARDWARE
switch device
    case 'screen'
        n = varargin{1};  % screen #
        switch varargin{2}
            case 'size(cm)'
                wh = varargin{3};
                COSY_HARDWARE.SCREEN(n).Size_measured_cm = wh;
                [w,h] = Screen('DisplaySize',n);
                COSY_HARDWARE.SCREEN(n).Size_fromEDID_mm = [w,h];
                
            case 'viewingdistance(cm)'
                % <todo>
        end
end

%% Save modified COSY_HARDWARE
if ~exist(filename,'file')  % First time..
    save6(filename,'-mat','-struct','COSY_HARDWARE'); % ..create file
else                        % Already existing file..
    save6(filename,'-mat','-append','-struct','COSY_HARDWARE'); % ..append vars
end