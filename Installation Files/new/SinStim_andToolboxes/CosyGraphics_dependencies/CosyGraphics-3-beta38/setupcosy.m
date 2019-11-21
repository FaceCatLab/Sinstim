function setupcosy(vstr)
% SETUPCOSY  Install GraphicsLab toolbox.
%    SETUPCOSY  removes any existing CosyGraphics version and installs this one.  You must call it from 
%    CosyGraphics's root directory (!)
%
%       Example:
%           cd D:\MATLAB\TOOLBOX+\CosyGraphics-3.0
%           setupcosy
%
%    SETUPCOSY(vstr)  changes CosyGraphics current version (if one is already installed). 
%    'vstr' is the same version string than in the folder name (e.g.: '3-alpha4').
%    
%       Example: 
%           setupcosy 3-alpha4
%
%
% System supported:
%    CosyGraphics currently supports:
%      - Windows 32 bits (over Cogent or PsychTB)
%      - Windows 64 bits + MATLAB 32 bits (over Cogent or PsychTB) 
%      - MacOS X (over PsychTB only - some modules will not work)
%      - Linux 32 bits (over PsychTB only - some modules will not work)    
%
%     MATLAB 64 bits support will come soon, over Cogent only. 
%
%
% Dependencies and Directories architecure: (Example given for version 2-beta52.)
%
%             Directory tree:                       Comments:
%             ---------------                       ---------
%
%             TOOLBOX+                              Cannot have space in the name of parents directories. Can have another name.
%              |
%              +--> PsychToolbox                    Can be elsewhere if already installed. (But cannot have space in the name of parents directories.)
%              |
%              +--> Cogent                          Container for the Cogent toolbox folders (one per version).
%              |    |
%              |    +--> Cogent2000v1.30            Current Cogent's version. *Must* be here.
%              |
%              +--> bentools                        
%              |
%              +--> CosyGraphics-3.0                Changing current directory to this one and typing " setupcosy " will install the whole stuff.
%              |    +--> lib                        
%              |    +--> mex                        
%              |    +--> TOOLBOX                    Actual location of the m-files composing the CosyGraphics3 toolbox.
%              |
%              +--> GLab-2-beta56                   Former version (v2, here in example v2-beta56) was called "GLab".
%
%
% __________________________________________________________________________________________________
% Note about Vista and Win7: (from: http://psychtoolbox.org/wikka.php?wakka=FaqVista, 20-01-2011)
%    To provide at least somewhat reliable visual stimulus onset timing and timestamping it is 
%    crucial to disable the Aero desktop compositor, aka DWM -- the new feature that eats lots of 
%    system ressources for the benefit of half-transparent window borders and drop shadows -- and 
%    go back to a Windows XP look while running Psychtoolbox scripts. The most recent versions of 
%    Psychtoolbox will automatically shut down the DWM as soon as the first onscreen window is 
%    opened. For older Psychtoolbox versions, disabling the DWM must be done manually. The following
%    instructions, taken from the Life Hacker website, should hopefully do this:
% 
%    1. Create an application shortcut to Matlab. E.g., an icon on your desktop which you can 
%      double-click to start Matlab. Of course you can use the shortcut to Matlab which is already 
%      there after installation of Matlab, if you want.
%    2. Then right-click on the shortcut and choose Properties, and then the Compatibility tab ... 
%      Now on the Settings block check the box for "Disable desktop composition" in order to disable 
%      Aero the next time you use the shortcut.
%    3. Next time you start Matlab by double-clicking on that shortcut, the desktop compositor 
%      should be shut down and free up valuable graphics ressources and reduce interference on 
%      display timing and timestamping.

%% Programmer's notes:
%
% <v1.6: Code moved from startcogent>

% TODO: - Check path with 'doublons'.
%		- Make a backportable version which
%			-- check for other versions of itself and lauch the newest
%			-- install files in toolbox+\CosyGraphicsvX.Y.Z (==> also install new version!)
% >


%% BenTools version
BentoolsVersionRequired = '0.11.10'; % <!!!--- DON'T FORGET TO UPDATE THIS ---!!!>


%% Global var
global COSY_GENERAL


%% Toolboxes locations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% <v2-beta19: No more use cosygraphicsroot> 
% <v2-beta47: All path that can be used by setupcosy itself are defined here.>
p = which('setupcosy'); % It's the only file we are sure it'll always be in the path <v2-beta19>
f = find(p == filesep);
e = f(end) - 1;
CosyGraphicsRoot = p(1:e); % Root dir.
e = f(end-1) - 1;
CosyGraphicsParent = p(1:e); % Normally TOOLBOX+ but it's not mandatory.
CosyGraphicsToolbox = fullfile(CosyGraphicsRoot,'TOOLBOX'); % Dir which contains CosyGraphics's modules.
CosyGraphicsGeneral = fullfile(CosyGraphicsRoot,'TOOLBOX','cosygeneral'); % Dir of the module which contains generic m-files (we need getcosylib).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Set path for BenTools first
if ~nargin
    if exist('setupbentools') == 2 % <v2-beta19: Reinstall each time>
        % In path: Run setupbentools at each startup to ensure path correctness
        setupbentools;
    elseif exist([CosyGraphicsParent '/bentools']) == 7 % <v2-beta19: Rewritten stupidly already implemented feature.>
        % Not in path: Search 'bentools' dir in same parent dir than CosyGraphics's dir
        od = pwd;
        cd([CosyGraphicsParent '/bentools'])
        setupbentools;
        cd(od)
    else
        % Not found:
        error('BenTools toolbox not installed. Please run setupbentools from the ''bentools'' directory.')
    end
end
% <========================================== BENTOOLS INSTALLED ==========================================

%% Check BenTools' version <v2-beta19>
% Comes after CosyGraphics setup, so we can use dispinfo.
if vcmp(btversion,'<',BentoolsVersionRequired)
    str = ['!!! --- BenTools toolbox is obsolete: Please update to version ' ...
        BentoolsVersionRequired ' or superior --- !!!'];
    dispinfo(mfilename,'critical-warning',str);
end


%% Clear CosyGraphics <v2-beta23> <v2-beta47: clearcosygraphics now executed at the end.>
% Has CosyGraphics been started ? Get current version.
wasStarted = 0;
if isfield(COSY_GENERAL,'wasStarted')
    wasStarted = COSY_GENERAL.wasStarted;
    cur_v = COSY_GENERAL.CosyGraphicsVersion;
end
% Get new version
if nargin, new_v = vstr;
else       new_v = vnum2vstr(cosyversion); % it can be the new cosyversion if it's in current dir.
end
% Compare versions, clear CosyGraphics they differ.

if wasStarted && vcmp(new_v,'~=',cur_v)
    doClearOtherVersion = 1; % <v2-beta47: clearcosygraphics now executed at the end, to fix case it has been manually removed from path.>
else
    doClearOtherVersion = 0;
end


%% Version given as input arg.: Change current version.
% ! ---  Not backward compatible with versions older than v2-beta0 ("Cogent2007" versions).
% (SETUPCOSY.M was the same file for v1.6.2+ and v2-alpha4+.) --- !
if nargin
    switch vstr(1)
        case '3'
            root = fullfile(CosyGraphicsParent, ['CosyGraphics-' vstr]);
%             root = CosyGraphicsRoot;
%             f = strfind(lower(root),'cosygraphics') + 12;
%             if isempty(f), f = strfind(lower(root),'glab') + 4; end % v2
%             f = f(end);
%             root = [root(1:f) vstr];
        case '2' %<v3-alpha4: bw compat with v2>
            root = fullfile(CosyGraphicsParent, ['GLab-' vstr]);
        end
    if exist(root,'dir')
        od = pwd;
        cd(root) % --!
            switch vstr(1)
                case '3', setupcosy; % Run setupcosy.m of specified version.    <===RECURSIVE CALL===!!!
                case '2', setupglab; %<v3-alpha4: bw compat with v2>
            end
        cd(od)   % --!
%         cd(fullfile(matlabroot,'work')) % <v1.6.2> <suppr. v2-beta19>
        return % <====!!!
    else
        error(['Directory "' root '" does not exist.'])
    end
end


%% Define CosyGraphics's path
p = {};

% Modules
sub = dir(CosyGraphicsToolbox);
for i = find([sub.isdir])
    name = sub(i).name;
    if ~strcmp(name,'.') && ~strcmp(name,'..')
        p{end+1,1} = fullfile(CosyGraphicsToolbox,name);
    end
end

% Particular case of CosyGame module: One sub-dir per game <v3-beta35>
parent = fullfile(CosyGraphicsToolbox,'cosygames');
sub = dir(parent);
for i = find([sub.isdir])
    name = sub(i).name;
    if ~strcmp(name,'.') && ~strcmp(name,'..')
        p{end+1,1} = fullfile(parent,name);
        if exist(fullfile(parent,name,'lib'),'dir') % <v3-beta37: add ./lib dir to path>
            p{end+1,1} = fullfile(parent,name,'lib');
        end
    end
end

% Roots
p{end+1,1} = CosyGraphicsToolbox;
p{end+1,1} = CosyGraphicsRoot;

% Cogent
if ispc
    od = cd;
    cd(CosyGraphicsGeneral); % CosyGraphics is not yet installed: we need to change dir to use getcosylib.
    v = getcosylib('CG','Version'); 
    cd(od)
    
    switch v(2)
        case 24
            p = [p; {...
                [CosyGraphicsRoot '/lib/CogentGraphics/v1.24'];...
                [CosyGraphicsRoot '/lib/Cogent2000/v1.25'];...
                [CosyGraphicsRoot '/lib/Cogent2000/v1.25/dll'];...
                [CosyGraphicsRoot '/lib/Cogent2000/v1.25/Legacy/Replaced'];...
                } ];
        case 28
            p = [p; {...
                [CosyGraphicsRoot '/lib/CogentGraphics/v1.28'];...
                [CosyGraphicsRoot '/lib/Cogent2000/v1.25'];... % always use m-files of v1.25.
                [CosyGraphicsRoot '/lib/Cogent2000/v1.28/mex'];...
                } ];
        case 29
            p = [p; {...
                [CosyGraphicsRoot '/lib/CogentGraphics/v1.29'];...
                [CosyGraphicsRoot '/lib/Cogent2000/v1.25'];... % always use m-files of v1.25.
                [CosyGraphicsRoot '/lib/Cogent2000/v1.29/mex'];...
                } ];
        case 30 % <v2-beta51>
            cogtoolbox = [CosyGraphicsParent '/Cogent/Cogent2000v1.30/Toolbox'];
            if ~exist(cogtoolbox,'dir')
                msg = ['Cannot find Cogent toolbox. Please install it in "' cogtoolbox '" before to run CosyGraphics.'];
                beep;
                warning(msg);
                dispinfo(mfilename,'error',msg);
            end
            p = [p; {...
                [CosyGraphicsRoot '/lib/Cogent2000/v1.25'];... % always use m-files of v1.25. <v3-beta6: major fix!: inverted order>
                cogtoolbox;...
                } ];
    end
end
 
% /lib/PTB
if ~exist('Screen','file') % If no PTB installation in the path..
    p = [p; {[CosyGraphicsRoot '/lib/PTB']}]; % ..add embedded PTB functions to path.
end

% Misc
p = [p; {...
            [CosyGraphicsRoot '/lib/PTB/PtbModified'];...
            [CosyGraphicsRoot '/lib/PTB/PtbRenamed'];...  %<v3-alpha2: renamed>
            [CosyGraphicsRoot '/lib/PTB/PtbLowercased'];... %<v3-alpha2>
			[CosyGraphicsRoot '/lib/Colorspace'];...
            [CosyGraphicsRoot '/lib/Gama'];...
            [CosyGraphicsRoot '/tests'];...
%           [CosyGraphicsRoot '/demos'];... % <v2-beta21> <suppr v2-beta53>
		} ];
	
    
%% Set Path!
[v,vstr] = cosyversion;
dispinfo(mfilename,'INFO',['Setting MATLAB path for GraphicsLab toolbox, version ' vstr])
delpath('-q','CosyGraphics');    % Remove v3 (called "CosyGraphics").
delpath('-q','GLab-2');          % Remove v2 (called "GraphicsLab").
delpath('-q','Cogent2007');      % Remove v1 (called "Cogent2007").
delpath('-q','Cogent2000','GL'); % Remove Cogent2000.

for i = length(p) : -1 : 1
	addpath(p{i});              % Add our CosyGraphics version to path.
end


%% Don't stay in toolbox directory:
if CosyGraphicsRoot(end) == filesep, CosyGraphicsRoot(end) = []; end % <v2-beta41: fix>
if strcmpi(cd,CosyGraphicsRoot)
    cd .. % <v2-beta17: "work" -> "..">
end
% <========================================== GLAB INSTALLED ==========================================


%% Compile MEX-Files <v2-beta39>
if ~strcmp(mexext,'mexw64') % <v3-beta3: No compilator on Win 64 bits !!>
    mexall('-rup', fullfile(CosyGraphicsRoot,'mex','multiplatform'));
    if ispc
        mexall('-rup', fullfile(CosyGraphicsRoot,'mex','windows'));
    end
end
addpath(CosyGraphicsRoot); % re-put it at the 1st position
disp(' ')


%% Save path!
savepath;


%% Create "X:\cosygraphics\" ans sub-dirs <v2-beta21: "X:\glab\", v3-alpha0: becomes "X:\cosygraphics\" >
% - Issue 1:
% EDF2ASC.EXE cannot run if EDF2ASC.EXE or the *.EDF file is inside the "My Documents" folder.
% As a workaround, we'll copy files in "X:\cosygraphics\tmp\".
% <In case of modif.: Modify also EDF2ASC.M !!!>
% - Issue 2:
% Hardware-related files have to be outside the CosyGraphics main folder, to not be copied from one machine
% to another by an unaware user. Let put them in "X:\cosygraphics\var\conf" or "X:\cosygraphics\conf" or "X:\cosygraphics\hardware". <???>
% - Issue 3:
% Logs can be to heavy to stay in the CosyGraphics* folder. Put them in "X:\cosygraphics\var\log" or "X:\cosygraphics\log". <???>
% - Issue 4: <???>
% Libs represents 105 MB. This space is duplicated in each CosyGraphics installation. We could save space by
% putting it in "X:\cosygraphics\lib\". <Inconvenient: more difficult to install.> <?!?!>
% - Issue 5: In UCL's std PCs, C:\ is unwritable. So, X: cannot be C:. We'll use the drive which 
% contains the CosyGraphics intallation. (M: in our std experimental PCs.)

if ispc % Windows..
    % X:\ (drive of CosyGraphics's installation)
    r = CosyGraphicsRoot; % <v2-beta47: no more use cosygraphicsroot>
    drive = r(1:3); % X:\
    % X:\cosygraphics\, X:\cosygraphics\*
    cosydir = [drive 'cosygraphics' filesep];
else % Linux, MacOS X..
    cosydir = '~/cosygraphics/'; % ..create dir in user home dir.
end
checkdir(cosydir);          % X:\cosygraphics\
checkdir([cosydir 'tmp']);  % X:\cosygraphics\tmp
checkdir([cosydir 'lib']);  % X:\cosygraphics\lib


%% Setup PTB, if not yet done <v2-beta19>
% PTB setup comes after CosyGraphics setup, so we can use dispinfo.
od = pwd;
found = 0;
if exist('PsychtoolboxRoot') ~= 2; % PTB is not in path..
    if exist([CosyGraphicsParent '/Psychtoolbox']) == 7 % Found in the same parent dir than CosyGraphics
        found = 1;
        cd([CosyGraphicsParent '/Psychtoolbox'])
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
        warning('PsychToolBox not installed. Please run SetupPsychtoolbox from the ''Psychtoolbox'' directory.')
    end
end


%% Clear CosyGraphics from memory ?
if doClearOtherVersion
    msg = 'Another version of GraphicsLab has been run. Clearing it from memory...';
    dispinfo(mfilename,'info',msg);
    clearcosy;
end