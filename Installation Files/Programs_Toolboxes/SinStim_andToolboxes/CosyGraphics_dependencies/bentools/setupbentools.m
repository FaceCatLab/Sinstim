function setupbentools
% SETUPBENTOOLS  Set MATLAB path for BenTools toolbox.

dispinfo(mfilename,'info',['Setting MATLAB path for BenTools toolbox, version ' vnum2vstr(btversion)])

%% Get root directory
bentoolsroot = which(mfilename);
bentoolsroot(end-14:end) = [];

%% Remove older install from Matlab path
od = pwd;
cd(bentoolsroot) % --!
delpath('-q','bentools');
cd(od)           % --!

%% Add BenTool's directories to path
v = version;
if v(1) <= '6' % Matlab 6: Replace missing Matlab 7 functions
    addpath(fullfile(bentoolsroot,'matlab6')); % v0.10.4.16
end
addpath(fullfile(bentoolsroot,'legacy')); % v0.10
addpath(bentoolsroot);
savepath;

%% Delete deprecated/unfinished m-files <v0.12>
obsolete = {'repele', 'mfiledir', 'derivee', 'txtfile2struct', 'fieldtree', 'findoption'};

% <v0.12>
for i = 1 : length(obsolete)
    fullname = fullfile(bentoolsroot, [obsolete{i} '.m']);
    if exist(fullname,'file')
        file = [obsolete{i} '.m'];
        dispinfo(mfilename,'warning', sprintf('Deleting obsolete file "%s".', file));
        delete(fullfile(bentoolsroot,file));
    end
end

% (move them to "bentools\trash\" dir)  <old v0.11.6 code>
% if ~exist(fullfile(bentoolsroot,'trash'), 'dir')
%     ok = mkdir(bentoolsroot,'trash');
%     if ~ok
%         warning(['Cannot write in ' bentoolsroot]); 
%     end
% else
%     ok = 1;
% end
% 
% if ok
%     for i = 1 : length(obsolete)
%         if exist(obsolete{i})
%             file = [obsolete{i} '.m'];
%             dispinfo(mfilename,'info', sprintf('Moving obsolete file "%s" to bentools/trash/', file));
%             cp(fullfile(bentoolsroot,file), fullfile(bentoolsroot,'trash',file));
%             delete(fullfile(bentoolsroot,file));
%         end
%     end
% end