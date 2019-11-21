function setupglab(vstr)
% SETUPGLAB  Install GraphicsLab toolbox.
%    SETUPGLAB  removes any existing G-Lab version from path,
%    then adds this version and saves path. Removes also from path any
%    existing Cogent2000 version, without saving.
%
%    SETUPGLAB(VSTR)  changes G-Lab current version. VSTR is 
%    the same version string than in the folder name. (i.e.:
%    ['G-Labv' VSTR] is the folder name and must correspond to
%    a valid sub-folder in the same parent folder than the current
%    version.)

% <v1.6: Code moved from startcogent>

% TODO: - Check path with 'doublons'.
%		- Make a backportable version which
%			-- check for other versions of itself and lauch the newest
%			-- install files in toolbox+\G-LabvX.Y.Z (==> also install new version!)


BentoolsVersionRequiered = '0.10.7.30'; % <!!! DON'T FORGET TO UPDATE THIS !!!>


global GLAB_STATUS


%% Toolboxes locations
% <v2-beta19: no more use glabroot>
p = which('setupglab'); % It's the only file we are sure it'll always be in the path <v2-beta19>
f = find(p == filesep);
e = f(end) - 1;
GLabRoot = p(1:e);
e = f(end-1) - 1;
ParentDir = p(1:e); % Normally TOOLBOX+ but it's not mandatory.

%% Set path for BenTools first
if ~nargin
    if exist('setupbentools') == 2 % <v2-beta19: Reinstall each time>
        % In path: Run setupbentools at each startup to ensure path correctness
        setupbentools;
    elseif exist([ParentDir '/bentools']) == 7 % <v2-beta19: Rewritten stupidly already implemented feature>
        % Not in path: Search 'bentools' dir in same parent dir than GLab's dir
        od = pwd;
        cd([ParentDir '/bentools'])
        setupbentools;
        cd(od)
    else
        % Not found:
        error('BenTools toolbox not installed. Please run setupbentools from the ''bentools'' directory.')
    end
end

%% Check BenTools' version <v2-beta19>
% Comes after GLab setup, so we can use dispinfo.
if vcmp(btversion,'<',BentoolsVersionRequiered)
    str = ['!!! --- BenTools toolbox is obsolete: Please update to version ' ...
        BentoolsVersionRequiered ' or superior --- !!!'];
    dispinfo(mfilename,'critical-warning',str);
end

%% Clear GLab <v2-beta23>
% Has GLab been started ? Get current version.
wasStarted = 0;
if isfield(GLAB_STATUS,'wasStarted')       % v2-beta23+
    wasStarted = GLAB_STATUS.wasStarted;
    cur_v = GLAB_STATUS.GLabVersion;
else                                       % v2-beta12-22
    global GLAB_CURRENT_PRIORITY %#ok<TLEV>
    if ~isempty(GLAB_CURRENT_PRIORITY)
        wasStarted = 1;
        cur_v = '2-beta22'; % beta22 or less
    else
        clear global GLAB_CURRENT_PRIORITY
    end
end
% Get new version
if nargin, new_v = vstr;
else       new_v = vnum2vstr(glabversion); % it can be the new glabversion if it's in current dir.
end
% Compare versions, clear GLab they differ.

if wasStarted && vcmp(new_v,'~=',cur_v)
    msg = 'Another version of GraphicsLab has been run. Clearing it from memory...';
    dispinfo(mfilename,'info',msg);
    clearglab;
end

%% Version given as input arg.: Change current version.
% !!! ---  Not backward compatible with versions older than v2-beta0 ("Cogent2007" versions).
% (SETUPGLAB.M was the same file for v1.6.2+ and v2-alpha4+.) --- !!!
if nargin
    root = GLabRoot;
    f = strfind(lower(root),'glab') + 4;
    f = f(end);
    root = [root(1:f) vstr];
    if exist(root,'dir')
        od = pwd;
        cd(root) % --!
        setupglab; % Run setupglab.m of specified version.    <===RECURSIVE CALL===!!!
        cd(od)   % --!
%         cd(fullfile(matlabroot,'work')) % <v1.6.2> <suppr. v2-beta19>
        return % <====!!!
    else
        error(['Directory ' root ' does not exist.'])
    end
end

% %% Check presence of 'bentools' toolbox. <v2-beta19: Rewritten stupidly above>
% if ~exist('bentools','dir') % Not in path: Check if "bentools" dir 
%     %                         in same parent dir than G-Lab..
%     p = which('setupglab');
%     f = find(p == filesep);
%     parent = p(1:f(end-1));
%     if exist([parent 'bentools']) % ..Found..
%         od = pwd;
%         cd([parent 'bentools']) % --!
%         setupbentools;          % ..add bentools to path.
%         cd(od)                  % --!
%     else                          % ..Not found..
%         error('You have to install the "bentools" toolbox before to use G-Lab.')
%     end
% end

%% Define G-Lab's path
if ispc
    v = getlibrary('CG','Version'); 
    switch v(2)
        case 24
            p = {    GLabRoot;...
                [GLabRoot '/lib/CogentGraphics/v1.24'];...
                [GLabRoot '/lib/Cogent2000/v1.25'];...
                [GLabRoot '/lib/Cogent2000/v1.25/dll'];...
                [GLabRoot '/lib/Cogent2000/v1.25/Legacy/Replaced'] };
        case 28
            p = {    GLabRoot;...
                [GLabRoot '/lib/CogentGraphics/v1.28'];...
                [GLabRoot '/lib/Cogent2000/v1.25'];... % always use m-files of v1.25.
                [GLabRoot '/lib/Cogent2000/v1.28/mex'] };
        case 29
            p = {    GLabRoot;...
                [GLabRoot '/lib/CogentGraphics/v1.29'];...
                [GLabRoot '/lib/Cogent2000/v1.25'];... % always use m-files of v1.25.
                [GLabRoot '/lib/Cogent2000/v1.29/mex'] };
    end
elseif isunix
    p = {GLabRoot}; % Cogent not supported
end
if ~exist('Screen','file') % If no PTB installation in the path..
    p = [p; {[GLabRoot '/lib/PTB']}]; % ..add embedded PTB functions to path.
end
p = [p; {...
            [GLabRoot '/serial'];... % v2-beta17>
            [GLabRoot '/eyelink'];... % v2-beta11>
            [GLabRoot '/PSB'];... % v2-beta15>
            [GLabRoot '/TDT'];... % v2-beta15>
            [GLabRoot '/lib/PTB/PtbModified'];...
            [GLabRoot '/lib/PTB/PtbReplacement'];...
			[GLabRoot '/lib/Colorspace'];...
            [GLabRoot '/lib/Gama'];...
			[GLabRoot '/legacy'];...
            [GLabRoot '/tests'];...
            [GLabRoot '/demos'];... % v2-beta21>
		} ];
	
[v,vstr] = glabversion;
dispinfo(mfilename,'INFO',['Setting MATLAB path for GraphicsLab toolbox, version ' vstr])
disp(' ')

%% Set Path!
delpath('-q','GLab');           % Remove v2 (called GLab).
delpath('-q','Cogent2007');     % Remove v1 (which was callec Cogent2007).
for i = length(p) : -1 : 1
	addpath(p{i});              % Add our G-Lab version to path.
end
savepath;                       % Save !
delpath('-q','Cogent','GL');    % Remove Cogent2000 from path, but don't save.
% Don't stay in toolbox dir.:
if strcmpi(pwd,GLabRoot)
    cd .. % <v2-beta17: work -> ..>
end

%% Create "X:\glab\" ans sub-dirs <v2-beta21>
% - Issue 1:
% EDF2ASC.EXE cannot run if EDF2ASC.EXE or the *.EDF file is inside the "My Documents" folder.
% As a workaround, we'll copy files in "X:\glab\tmp\".
% <In case of modif.: Modify also EDF2ASC.M !!!>
% - Issue 2:
% Hardware-related files have to be outside the GLab main folder, to not be copied from one machine
% to another by an unaware user. Let put them in "X:\glab\var\conf" or "X:\glab\conf" or "X:\glab\hardware". <???>
% - Issue 3:
% Logs can be to heavy to stay in the GLab* folder. Put them in "X:\glab\var\log" or "X:\glab\log". <???>
% - Issue 4: <???>
% Libs represents 105 MB. This space is duplicated in each GLab installation. We could save space by
% putting it in "X:\glab\lib\". <Inconvenient: more difficult to install.> <?!?!>
% - Issue 5: In UCL's std PCs, C:\ is unwritable. So, X: cannot be C:. We'll use the drive which 
% contains the GLab intallation. (M: in our std experimental PCs.)

if ispc % Windows..
    % X:\ (drive of GLab's installation)
    r = glabroot;
    drive = r(1:3); % X:\
    % X:\glab\, X:\glab\*
    glab = [drive 'glab' filesep];
else % Linux, MacOS X..
    glab = '~/glab/'; % ..create dir in user home dir.
end
checkdir(glab);          % X:\glab\
checkdir([glab 'tmp']);  % X:\glab\tmp
checkdir([glab 'lib']);  % X:\glab\lib

%% Setup PTB, if not yet done <v2-beta19>
% PTB setup comes after GLab setup, so we can use dispinfo.
od = pwd;
found = 0;
if exist('SetupPsychtoolbox') ~= 2 % Not in path:
    if exist([ParentDir '/Psychtoolbox']) == 7 % Found in the same parent dir than GLab
        found = 1;
        cd([ParentDir '/Psychtoolbox'])
    elseif ispc
        % Windows only: Search it in all drive roots:
        drives = char('C':'Z');
        for i = 1 : 24
            if exist([drives(i) ':\Psychtoolbox']) == 7
                found = 1;
                cd([drives(i) ':\Psychtoolbox'])
            elseif exist([drives(i) ':\matlab\Psychtoolbox']) == 7
                found = 1;
                cd([drives(i) ':\matlab\Psychtoolbox'])
            end
            if found, break, end
        end
    end
    if found
        dispinfo(mfilename,'info','Installing PsychToolBox...')
        SetupPsychtoolbox;
        cd(od)
    else
        error('PsychToolBox not installed. Please run SetupPsychtoolbox from the ''Psychtoolbox'' directory.')
    end
end
