function sinstim(ParamFile,ImageDir,SaveDir,SubjectNameArg,isBlockMode)
% SinStim   Sinusoidal stimuli -- EEG Experimental Program.
%    SINSTIM  runs the program in standard mode. The program will open dialog boxes and ask the user
%    to choose select parameter file (see infra) and a folder containing the images to be displayed.
%
%    The parameter file (External m-file):
%       The program neads to load a parameter file which must have a name of the form "SinStim_*.m".
%       Two param file examples are provided:
%       - "<SinStim's folder>\Program\Examples\SinStim_Example_1part_v1p*.m" : Up-to-date example.  
%       (All the parameters are defined, here, including those of the latest versions.)
%       - "<SinStim's folder>\Program\Examples\SinStim_Example_2parts_v1p4.m" : Example demonstrating
%       how to get stimuli composed of several parts. This file has not been updated since v1.4, but
%       generalization to later (missing) parameters should be straightforward.
%       Please, don't modify these example files!
%
%    SINSTIM TEST  runs the program in test mode. Uses params and images in \SinStim\Program\Test\
%    and saves data in \SinStim\Save\Test\.
%
%    SINSTIM SAME  re-runs the program with same params & images.
%    
%    SINSTIM(ParamFile,ImageDir,SaveDir,<SubjectName>,<BlockMode>)  runs the program in batch mode (no GUI).
%    Argumentts are:
%         - ParamFile     Name of the parameter file (see above)
%         - ImageDir      Directory where *.bmp files are stored
%         - SaveDir       Directory where data will be saved
%         - SubjectName   Subject's name. If empty, will open a GUI.
%         - BlockMode     If BlockMode=1, the display will not be closed at the end of the trial.
%                         This permits to write a script which executes a block of trials one after another.
%                         Use KbWait() function to wait key press between trials. Use stoppsych() function to 
%                         close the display at the end of the block. (See example below.)
%                         If BlockMode=0 (default), SinStim runs in normal mode.
%       
%
% Example:
%          % Define paths, using SINSTIMROOT fuction to get SinStim's root directory (multi-platform!):
%          ParamFile = fullfile(sinstimroot,'Program','Examples','sinstim_Example_1part_v1p8p3.m'); % don't forget '.m' !!!
%          ImageDir  = fullfile(sinstimroot,'Program','Examples','Images-1part','');
%          SaveDir   = fullfile(sinstimroot,'Save','');
%          SubjectName = 'nobody';
%          % Run SinStim:
%          sinstim(ParamFile,ImageDir,SaveDir,SubjectName);
%
%
% Example of script to run a block of 3 trials:
%          sinstim(ParamFile,ImageDir,SaveDir,SubjectName,1);
%          sinstim(ParamFile,ImageDir,SaveDir,SubjectName,1);
%          sinstim(ParamFile,ImageDir,SaveDir,SubjectName,1);
%          stoppsych;
%
%
% SinStim needs PsychToolBox 3, BenTools and GraphicsLab 2 (see version below).
%
%% Versions history:
% ===================
%  Version  Date            GLab Version    Comments
%  -------  ----            ------------    --------
%   1.0     17 Dec 2008.    2-beta2         First Exp 18 Dec.
%   ---
%   1.1     19 Feb 2009.    2-beta5         Keyboard events + Other modifs. + Fixes.
%   ---
%   1.2     16 May 2009.    2-beta5         Delay before identity varies.
%   ---
%   1.3     24 Jul 2009.    2-beta6         Variable image size. Choose priority level.
%   1.3.1   30 Jul                          Quick fix "missing event 1" bug. (l.414, 418) sinewave.m will be fixed later.
%   ---
%   1.4     13 Oct          2-beta8         Close display if programs crashes.
%                                           Isochronous mode: correct missed frames.
%   ---
%   1.5     22 Oct          2-beta9       x Fix 1.4: Add Gen.isIsochronous param.
%                                         t Fix 1.4: Add error event.
%                                         x Add random pattern feature
%                                         t     events pattern
%                                         / Add replace background option
%                                         t Add photodiode support
%                                         t test // port optim
%                                         ? Fix even divisor freq bug.
%   1.5.1   4 nov                           Fix Index exceed dimension bug in sinewave (bentools function)
%                                           Fix AxesRotation param
%                                           Fix Scale param (bug when identity not changing)
%                                           Fix 'square' wave
%                                           Delete blanks in RandPattern
%   1.5.2   10 nov          2-beta9/10nov   Workaround "negtimes" bug <unefffective>
%                                           Fix: Save GLab global vars
%   1.5.3   7 dec           2-beta9/7dec    Allow any key <needed a fix in getkeycode to work.>
%                                           ssPlotKeyboard2
%   ---
%   1.6     10 dec          2-beta10        Rewrite Workaround "negtimes" bug.
%   1.6.1   20 jan 2010     2-beta12        (2-beta12a: Partial fix isochronous mode ("negtimes" bug!))
%                                           Suppress legacy code about this bug. <inefficient>
%                                           Isochronous mode: append '(corr)' to filename.
%                                           Fix WhatVaries = '-' (do nothing) condition.
%   1.6.2                  dvpt version     (2-beta12b: Fix isochronous mode ("negtimes" bug!))
%                                           Test mode.
%                                           Fix batch mode.
%                                           Set path.
%                                           Add /SinStim/Program/Test/ and /SinStim/Save/Test/ dirs
%                                           Fix case i15 > nFrames
%                                           Fix minor bug "crash ssPlotKeyboard*"
%                                           Add '_aborted' suffix when aborted by user.
%   1.6.3                   2-beta14        Fix AlphaRange for WhatVaries = 'I' or 'N' <!!!>
%                                           Fix 1.6.2 SaveDir bug
%                                           Print sSintim version at startup.
%                                           Force GLab version.
%                                           Store actual stim freq in StimFreqs (req. by Esther)
%   1.6.3.1                dvpt version     setup glab disabled <reverted in 1.6.4>
%                                           Linux fix: don't use Cog lib for kb.
%   1.6.3.2                dvpt version     clear Images (.mat files 32 times lighter !!!) <replaced in 1.6.4 by conversion to uint8>
%                        bentools 0.10.3!   Use datesuffix <bentools 0.10.3> to create mat-file name (fix file erase bug)
%   1.6.3.3                dvpt version     ssPlotKeyboard2 now in a TRY statement
%   1.6.4   18 mar          2-beta14        Compress 'Images' structure : makes file 5.3x lighter
%                                           Make datesuffix a sub-function  <bentools 0.10.3 no more needed>
%                                           Add '_DurErr!' suffix to save file name in case of total duration error.
%   1.6.4.1                dvpt version     For developper: setupglab disabled if ~isTest ; ssPlotKeyboard2 only if ~isTest. Fix ";" bug.
%   1.6.5   26 apr          2-beta14        Fix minor bug in  v1.6.3: Fix StimFreqs in non-harmonic mode.
%                                           Cosmetic: Add program name in command window messages.
%                                           Fix photodiode: error in default location.
%   1.6.6   23 sep         dvpt version     MAC OS X version!
%                                           Change GLab version to 2-beta28 (compatible Mac OS X!)
%   ---
%   1.7     28 sep          2-beta28       §Stable on MATLAB 7.6 / MAC OS X.
%                        bentools 0.10.9!   Only significative modif: Change way to load file: uses bentools' new "readtxt" instead
%                                           of Matlab's "load" function, which is bugged in ML 7.6 when reading ML 6.5 files.
%                                          §Fix: Add ParamDir to MATLAB path.
%                                          §Added utilities: setupsinstim, sinstimroot, cdsinstim. + Add doc for batch mode.
%                                           <TODO: Fix Matlab version pb when saving data !!!> 
%                                           <TODO: Support transparency in image files (*.png, *.gif, etc).>
%   ---
%   1.8     29 nov          2-beta32       §Dana exp: Add variable arbitray gaps between RandPattern repetitions.
%                                           preparesinanimation -> subfun_*. Replaced by sub-function (same than v2-beta31's fun) <!!!>
%                                           preparesinanimation: Add GapBetweenPatterns arg. + Finalize doc.
%                                           GapBetweenPatterns: New param.
%                                          §Cosmetic: Params: add internal code doc. Param file: update & improve SinStim's doc.
%   1.8.1   24 mar 2011    demo version     Add demos. Revert sinstim_test.m. No code modif in this file.
%   1.8.2   09 jun          2-beta32       §Fix missing last // byte: displayanimation -> sub_displayanimation <!!> <Same fix in GLab v2-beta39>
%                                           (First // byte: 254/255 bug: cannot reproduce bug.)
%                                          §Sine wave strat angle: becomes a param.
%                                           Fix sinewave's bug when start angle is not 3*pi/2.
%                                           Doc+
%   1.8.3   01 sep          2-beta32       §Fix cross during delay. sub_displayanimation modified <!>
%                                          §Fade out.
%   1.8.4   01 sep         dvpt version     §Comment glabglobal.
%   1.8.5   07 nov          unstable       §Block mode!: Add BlockMode arg. +Help. <BUGS!>
%   1.8.6   10 nov          unstable        Fix block mode, line 823: no timeout in block mode. <STILL BUGGY> 
%                                           <TODO: Put TimeOut in params ?!?!>
%   1.8.7   18 nov          unstable        Fix block mode, lines 917-18: deletebuffer all; <MAJOR FIX!> <STILL BUGGY> 
%   1.8.8   22 nov          2-beta32        Fix block mode, lines 922-24: Workaround for "deletebuffer all" (deletes also Draft Buffer => drawtext draws into SinStim's buffer).
%                                           Fix block mode, lines 982: No Matlab figure in block mode (was actually executed during next trial).
%                                           Fix block mode doc: Suppr KbWait (not needed).
%                                           Code cleaning: Replace stopglab -> stoppsych (Fw compat). Chg var: BlockMode -> isBlockMode
%   1.8.8.1 23 nov                          Fix line 922: Add ~isabort test to fix bug when Esc pressed (Goedele).
%   1.8.9   22 dec          2-beta32        Fix warning: "Conversion rounded non-integer floating point value to nearest uint8 value.", line 957.
%                                           Fix missing fix cross bug (round & square ok, bot cross missing after splash): draw -> drawshape, line 851.
%   1.8.10  22 dec          2-beta32        Suppport different scales for differnet parts: Gen.Scale -> ByPartScale, Scale (vector) -> SCALE (matrix).
%   ---
%
%   Benvenuto JACOB, Institute of NeuroSiences, Universite Catholique de Louvain.


%% Version
SinStimVersion = '1.8.10';
GLabVersion = '2-beta32';
bg = [.9 .6 .4] * .65;
fg = [0 0 0];
SinStimColors = [bg; fg]; % [bg, fg]


%% GLOBAL VARS
% glabglobal % <TODO: Suppress this ?!?> <Suppr v1.8.4>
persistent SubjectName


%% INPUTS ARGS (see also FILES & DIRECTORIES below)
isTest = 0;
isSame = 0;
if nargin == 1
    if strcmpi(ParamFile,'test') % <v1.6.2>
        isTest = 1;
        clear ParamFile
    elseif strcmpi(ParamFile,'same') % <v1.7>
        isSame = 0;
    end
end
if ~exist('isBlockMode','var') % <v1.8.5>
    isBlockMode = 0;
end


%% INIT
% Print SinStim version
disp(['Starting SinStim, version ' SinStimVersion ' ...'])

% Stop G-Lab if running. (To avoid to get it masking the gui.)
if ~isBlockMode
    stoppsych;
end

% Ensure we have the right vervion of GLab <v1.6.3>
od = pwd;
if ~isTest,   setupglab(GLabVersion);
else          warning('Test mode. Setup GLab disabled!');
end
cd(od);

% Init Matlab's pseudo-random number generator
Seed = sum(100*clock);
rand('state',Seed);


%% FILES & DIRECTORIES

% SinStim's root directory
fullname = mfilename('fullpath');
f = find(fullname == filesep);
SinStimRoot = fullname(1:f(end-1)); % <v1.5: end -> end-1 (now in \Program)> <v1.6.2: def_dir -> SinStimRoot>

% Variable file
VarFile = [SinStimRoot 'Program/sinstim_var.txt']; % <v1.7: Replace: save/load('sinstim_var.mat')  by: writetxt/savetxt('sinstim_var.txt')>
% "sinstim_var.txt" format <v1.7> :
% line #1:  SinStim's version
% line #2:  SinStim's version
% line #3:  date
% line #4:  ParamDir
% line #5:  ImageDir
% line #7:  SaveDir
% line #8:  ParamFile
lineVersion   = 2;
lineDate      = 3;
lineParamDir  = 4;
lineImageDir  = 5;
lineSaveDir   = 6;
lineParamFile = 7;
lineSubjectName = 8;
nLinesInVarFile = 8;

% Set Matlab path <v1.6.2>
addpath([SinStimRoot 'Program/']);
addpath([SinStimRoot 'Program/Examples/']);
addpath([SinStimRoot 'Program/Test/']);
savepath;

% Params, Images & Save locations
if isTest % SINSTIM TEST
    ParamDir = [SinStimRoot 'Program/Test/'];
    ParamFile = 'sinstim_Test.m';
    ImageDir = [ParamDir 'Images-Test'];
    SaveDir = [SinStimRoot 'Save/Test/'];
    SubjectName = 'test';

elseif nargin >= 3 % SINSTIM(ParamFile,ImageDir,SaveDir,<SubjectName>)
    seps = ParamFile == '/' | ParamFile == '\';
    if ~any(seps)
        ParamFile = which(ParamFile);
        seps = ParamFile == '/' | ParamFile == '\';
    end
    seps = find(seps);
    ParamDir = ParamFile(1:seps(end));
    ParamFile = ParamFile(seps(end)+1:end);
    if exist('SubjectNameArg','var') && ~isempty(SubjectNameArg) % <v1.8.5: check not empty>
        SubjectName = SubjectNameArg; % input arg must have a different name because SubjectName is persistent
    else
        SubjectName = 'xx';
    end
    
elseif nargin <= 1 % SINSTIM  or  SINSTIM TEST
    % <This is the normal mode for average users. We want total robustness here.>
    % <Totally rewritten in v1.7, because of flaw in ML7.6's load() function.>
    
    % Read "sinstim_var.txt" file
    if exist(VarFile,'file')
        [str,lines] = readtxt(VarFile);
        if numel(lines) == nLinesInVarFile;
            % Get ParamDir, ImageDir & SaveDir:
            ParamDir = lines{lineParamDir};
            ImageDir = lines{lineImageDir};
            SaveDir  = lines{lineSaveDir};
            % Get ParamFile only if the 'same' argument was given:
            if isSame % "sinstim same"
                ParamFile = lines{lineParamFile};
            end
            % Get subject name only if var file is from the same day
            FileDate = lines{lineDate};
            if strcmp(FileDate(1:11),date)
                SubjectName = lines{lineSubjectName};
            end
            % ok
            isFileFound = 1;
        else
            warning(['Invalid variable file ("sinstim_var.txt"). File content is:' 10 ...
                '-----' 10 ...
                str 10 ...
                '-----' 10 ...
                'Default values will be used for this time, and a new file will be created.' 10
                ])
            isFileFound = 0;
        end
    else % "sinstim_var.txt" doesn't exist (which is not normal): use default (as a fix)
        warning(['Cannot find "sinstim_var.txt" file.' 10 ...
            'Default values will be used for this time, and a new file will be created.'])
        isFileFound = 0;
    end

    % Fallback on default in case of problem
    default = SinStimRoot;
    % - Error 1: File not found.
    if ~isFileFound
        ParamDir = default;
        ImageDir = default;
        SaveDir  = fullfile(default,'save');
    end
    % - Error 2: Invalid dir.
    if ~exist(ParamDir,'dir')
        warning(['ParamDir does not exist: ' ParamDir])
        ParamDir = default;
    end
    if ~exist(ImageDir,'dir')
        warning(['ImageDir does not exist: ' ImageDir])
        ImageDir = default;
    end
    if ~exist(SaveDir ,'dir')
        warning(['SaveDir does not exist: ' SaveDir])
        SaveDir  = fullfile(default,'save');
    end
    if isSame && ~exist(fullfile(ParamDir,ParamFile), 'file')
        error(['ParamFile does not exist: ' SaveDir])
    end
    % - Subject name: has been defined only if found correct file of the same day.
    if ~exist('SubjectName','var')
        SubjectName = '';
    end
    
    % Param dir+file GUI
    if ~isSame
        od = cd;
        cd(ParamDir)
        [ParamFile,ParamDir] = uigetfile('sinstim_*.m',['Select the parameter file (' mfilename '_*.m).']);
        cd(od);
        if isazero(ParamFile) % User clicked on "Cancel"
            disp([mfilename ': Aborted by user.' 10])
            return % <==!!!
        end
    end
    
    % Image dir GUI
    if strcmp(ImageDir,default)
        ImageDir = ParamDir; % instead using default, guess that image folder will be close to param folder
    end
    ImageDir = uigetdir(ImageDir,'Select the folder containing the image files (*.bmp).');
    if isazero(ParamFile) % User clicked on "Cancel"
        disp([mfilename ': Aborted by user.' 10])
        return % <==!!!
    end
    
    % Subject name GUI
    SubjectName = char(SubjectName);
    answer = inputdlg('Enter subject name :','Subject name :',1,{SubjectName});
    SubjectName = answer{1};
    
    % Save dir GUI
    % ...do nothing here, it's done at the end of program.
    
else
    error('Invalid number of arguments.')
    
end

% Save "sinstim_var.txt"
c = {'File automatically created by SinStim.' ;...
    ['v' SinStimVersion] ;...
    datestr(now) ;...
    ParamDir ;...
    ImageDir ;...
    SaveDir  ;... % <--will be re-written at end of program
    ParamFile ;...
    SubjectName ;...
    };
writetxt(VarFile,c);

%% PARAMETERS
% Add ParamDir to MATLAB path <v1.7>
addpath(ParamDir)

% Evaluate Parameter File
disp(' ')
disp([mfilename ': Loading parameters...'])
eval(ParamFile(1:end-2)) % <--- EVAL PARAM FILE --!!!
assignin('base','Gen',Gen);
assignin('base','ByPart',ByPart);
% Gen  %#ok<NOPRT>     <suppr. v1.6.2>
% ByPart %#ok<NOPRT>
disp([mfilename ': Your parameters can be accessed in the "Gen" and "ByPart" variables. Just type variable name in command window.'])

% Backward compatibility with SinStim v1.0 parameter files: 
% - SinStim 1.0's parameters are required in the parameter file.
% - For later versions' parameter, if missing in param file, a parameter    
%   field with default value (conserving former behavior) is defined.
% v1.1 Parameters:
if ~isfield(Gen,'ResponseKey'), Gen.ResponseKey = 'Space'; end
if ~isfield(Gen.FixPoint,'WhatChanges'), Gen.FixPoint.WhatChanges = 'C'; end
if ~isfield(Gen.FixPoint,'ChangedShape'), Gen.FixPoint.ChangedShape = 'round'; end
if ~isfield(Gen,'DelayBefore'), Gen.DelayBefore = 0; end
if ~isfield(Gen,'DelayAfter'),  Gen.DelayAfter  = 0; end
% v1.2 Parameters:
if ~isfield(Gen.Events,'FirstIdentityChange'), Gen.Events.FirstIdentityChange = 99; end
if ~isfield(ByPart,'VariesAfter'), ByPart.VariesAfter = 0; end
% v1.3 Parameters:
% if ~isfield(Gen,'Scale'), Gen.Scale = 1; end  % <v1.8.10: Gen.Scale -> ByPart.Scale>
if ~isfield(Gen,'Priority'), Gen.Priority = 'OPTIMAL'; end
% v1.5 Parameters:
if ~isfield(Gen,'isIsochronousMode'), Gen.isIsochronousMode = 0; end
if ~isfield(Gen.Events,'MissedFrame'), Gen.Events.MissedFrame = 200; end
if ~isfield(ByPart,'RandPattern'), ByPart.RandPattern = 'a'; end
if ~isfield(ByPart,'EventPattern'), ByPart.EventPattern = zeros(size(ByPart.RandPattern)); end
if ~isfield(Gen,'isPhotodiode'), Gen.isPhotodiode = 0; end
if ~isfield(Gen,'PhotodiodeSquareSize'), Gen.PhotodiodeSquareSize = 20; end
% v1.6.1 Parameter:
if ~isfield(Gen,'PhotodiodeLocation'), Gen.PhotodiodeLocation = [1 1; 0 0]; end % <v1.6.5: Fix "," -> ";" ; default 2 diodes>
% v1.8 Parameter:
if ~isfield(ByPart,'GapBetweenPatterns'), ByPart.GapBetweenPatterns = 0; end
if ~isfield(ByPart,'SineWaveStartAngle'), ByPart.SineWaveStartAngle = 3*pi/2; end % <v1.8.2>
if ~isfield(Gen,'FadeOut'), Gen.FadeOut = 0; end % <v1.8.3>
if ~isfield(Gen,'FadeIn'), Gen.FadeIn = 0; end % <v1.8.9>
if ~isfield(ByPart,'Scale') % <v1.8.10: Gen.Scale -> ByPart.Scale>
    if isfield(Gen,'Scale'), ByPart.Scale = Gen.Scale;  % <bw compat with v1.3 to 1.8.9 parameter file>
    else                     ByPart.Scale = 1;
    end
end 
if ~isfield(Gen,'AllPartsSharingScalesOf'), Gen.AllPartsSharingScalesOf = 0; end % <v1.8.10: Change behavior!!! Use 1 to emulate older versions.>

% Parameters varying by Part
nParts = length(ByPart.PartNames); % # of image parts.
if ~nParts
    ByPart.PartNames = {''};
    nParts = 1;
end
ByPart = subfun_fields2cells(ByPart,nParts);

% RandPattern: suppress spaces <v1.5.1>
for p = 1 : nParts
    ByPart.RandPattern{p}(ByPart.RandPattern{p} == ' ') = [];
end


%% IMAGES
% Load Images
disp(' ')
disp([mfilename ': Loading images from BMP files...'])
[I,Files] = loadimage(ImageDir);

% Separate Parts
if nParts > 1
    for p = 1 : nParts
        part = ByPart.PartNames{p};
        ii = strncmpi(Files,part,length(part));
        if ~any(ii)
            stoppsych % <--!!!
            error(['Cannot find any ''' part '*.bmp'' file.'])
        end
        Images(p).MatricesI = I(ii);
    end
else
    Images.MatricesI = I;
end

% Image Processings: (On differents Parts separetely)
disp(' ')
disp([mfilename ': Processing images...'])
for p = 1 : nParts
    % Equalize matrix sizes:
    if ByPart.doEqualizeSize{p}
        VH = [ByPart.VerticalAlignement{p}, ByPart.HorizontalAlignement{p}];
        if     VH(1) == 'T',    VH(1) = 'B';
        elseif VH(1) == 'B',    VH(1) = 'T';
        end
        if     VH(2) == 'L',    VH(2) = 'R';
        elseif VH(2) == 'R',    VH(2) = 'L';
        end
        mn = [2 2] * Gen.Background.isBackground;
        Images(p).MatricesI = samesize(Images(p).MatricesI,Gen.Background.OriginalColor,VH,mn,'even');
    end

    % Get Background Mask:
    if Gen.Background.isBackground
        bg = ByPart.Background;
        Images(p).MatricesBG = backgroundmask(Images(p).MatricesI,...  <-- CRITICAL STEP !
            Gen.Background.OriginalColor,bg.ColorError{p},bg.ErodeBorder{p},bg.FillHoles{p});
    else
        for i = 1 : length(Images(p).MatricesI)
            Images(p).MatricesBG{i} = false(size(Images(p).MatricesI{i}(:,:,1)));
        end
    end

    % Equalize Background:
    % Keep as foreground only pixels which are foreground pixels in all images.
    if ByPart.Background.doEqualize{p}
        FG = ones(size(Images(p).MatricesBG{1}));
        for i = 1 : length(Images(p).MatricesBG),  FG = FG & ~Images(p).MatricesBG{i};  end
        for i = 1 : length(Images(p).MatricesBG),  Images(p).MatricesBG{i} = ~FG;       end
    end

    % Inverse gamma correction, completely or partially:
    % Images can have been corrected previousely (properly or not, that's another
    % question). We don't want the correction to be applied twice. So, here we
    % eventually apply the operation inverse of gamma correction.
    % NB: Must be done after backgroundmask.
    if Gen.ApparentGammaCorrection < Gen.ScreenGamma
        g = Gen.ScreenGamma / Gen.ApparentGammaCorrection;
        Images(p).MatricesI = gammacompress(Images(p).MatricesI,g);
    end

    % Color -> Gray:
    if ByPart.doConvertToGrayscale{p}
        Images(p).MatricesI = rgb2ggg(Images(p).MatricesI); % Change color, but keep M-by-N-by-3 matrix format.
    end

    % Equalize hue:
    if ByPart.doEqualizeHue{p} % <before luminance!>
        warning('Hue equalization not yet imlemented!')
        % <TODO>
    end

    % Equalize Luminance:
    if ByPart.doEqualizeLuminance{p}
        Images(p).MatricesI = sameluminance(Images(p).MatricesI,Images(p).MatricesBG);
    end

    % Scramble Pixels (could be a usefull control):
    if ByPart.doScramblePixels{p}
        Images(p).MatricesI = scrambleimage(Images(p).MatricesI,Images(p).MatricesBG);
    end

    % Replace background by final background color OR Add an Alpha Channel to Make Background Transparent:
    for i = 1 : length(Images(p).MatricesI)
        if ByPart.Background.doMakeItTransparent{p} % Add an Alpha Channel
            Images(p).MatricesI{i}(:,:,4) = ~Images(p).MatricesBG{i};
        else % Replace background by final background color
            BG = Images(p).MatricesBG{i};
            for k = 1:3
                I = Images(p).MatricesI{i}(:,:,k);
                I(BG) = I(BG) * Gen.Background.FinalColor(k);
                Images(p).MatricesI{i}(:,:,k) = I;
            end
        end
    end

end


%% START GRAPHICS LAB !
% Start G.Lab over PsychToolBox:
disp(' ')
disp([mfilename ': Starting GraphicsLab...'])

% try %-----------------------------------------------------------------------------------------------
    if ~isopen('display') % <v1.8.5: Add test.>
        startpsych(Gen.Screen,Gen.Resolution,Gen.Background.FinalColor,... % <--!
            Gen.ScreenTheoreticalFreq,Gen.NumFramesToTestFreq);
    end
    setpriority NORMAL
    if ispc, setlibrary('Keyboard','Cog'), end % 24/07/2009 Fix lib issue
%     openparallelport;
    openparallelport_inpout32(hex2dec('d010'));

    if Gen.isPhotodiode
        openphotodiode(Gen.PhotodiodeLocation,Gen.PhotodiodeSquareSize);
    end
    ScreenFreq = getscreenfreq; % <v1.5>
    
    % Store stimulation frequencies in a variable easy to access by user <v1.6.3, non-harmonic mode fixed in v1.6.5>
    StimFreqs  = cell2mat(ByPart.WaveFreq);
    for p = 1 : nParts
        if ByPart.isHarmonic{p}
            StimFreqs(p) = round2freqdivisor(StimFreqs(p),ScreenFreq);
        end
    end

    
%% PREPARE ANIMATION:
    % We do two kind of things here:
    % 1) Store images (currently stored in Matlab matrices) into video-RAM buffers.
    % 2) Get "BUFFERS" and "ALPHA" matrices, for "displayanimation" funtion, see below.
    disp(' ')
    disp([mfilename ': Preparing experiment...'])

    % Experimental Conditions
    nFrames = length(sinewave(Gen.Duration,1,getscreenfreq));
    BUFFERS = [];
    ALPHA   = [];
    PEAKS   = [];
    PHASES  = [];

    for p = 1 : nParts
        nImages = length(Images(p).MatricesI); % # of images for this part (! don't use outside this loop).
        r = randele(1:nImages); % In cases we need 1 image and we have more: pick 1 at random.

        if ByPart.WhatVaries{p} == 'I' % && nImages > 1 <??? todo: Check this!>
            % Exp. condition: Variable = Image (Identity). Interlaced. (1 change per half-phase.)
            % ===================================================================================
            % Draw an image with variable (sinusoidal) alpha factor over another image.
            % - Back image:     an image,         global alpha = 1.
            % - Front image:    another image,    global alpha = var.
            Images(p).BuffersI = storeimage(Images(p).MatricesI);
            [B,A,Peaks,Phases] = subfun_preparesinanimation(Images(p).BuffersI,Images(p).BuffersI,Gen.Duration, ...
                ByPart.WaveFreq{p},ByPart.AlphaRange{p},ByPart.isHarmonic{p},ByPart.RandPattern{p}); %v1.8.x: mode "I" not more supported for new features>

        elseif ByPart.WhatVaries{p} == 'N' % && nImages > 1 <??? todo: Check this!>
            % Exp. condition: Variable = Image (Identity). Non-interlaced. (1 change per phase.)
            % ==================================================================================
            % Draw an image with variable (sinusoidal) alpha factor over another image.
            % - Back image:     none.
            % - Front image:    an image,    global alpha = var.
            Images(p).BuffersI = storeimage(Images(p).MatricesI);
% 533 % <suppr. this in next version>
% var = who;
% for i = 1 : length(var), assignin('base',var{i},eval(var{i})); end
            [B,A,Peaks,Phases] = subfun_preparesinanimation(NaN,Images(p).BuffersI,Gen.Duration, ...
                ByPart.WaveFreq{p},ByPart.AlphaRange{p},ByPart.isHarmonic{p},ByPart.RandPattern{p}, ...
                ByPart.GapBetweenPatterns{p}, ...  % <v1.8: add GapBetweenPatterns arg. (only in "N" mode)>
                ByPart.SineWaveStartAngle{p});  % <v1.8.2>

        elseif ByPart.WhatVaries{p} == 'L'
            % Control condition: Variable = Luminance.
            % ========================================
            % Draw an image with variable alpha over it's own background mask.
            % - Back image:     image bg,   global alpha = 1.
            % - Front image:    image,      global alpha = var.

            % Get back image:
            % We want color images (M-by-N-by-3) with only the background.
            rgb = Gen.Background.FinalColor;
            BG = Images(p).MatricesBG{r};
            ColorBG = cat(3,BG*rgb(1),BG*rgb(2),BG*rgb(3));

            % Get front image:
            I = Images(p).MatricesI{r};
            range = ByPart.AlphaRange{p};
            if max(range) > 1 % Alpha value cannot be > 1
                I = fitrange(I * max(range), [0 1]);
                range = range / max(range);
            end

            % Store images into Video-RAM buffer:
            Images(p).BufferI  = storeimage(I);
            Images(p).BufferBG = storeimage(ColorBG);

            % Get BUFFERS and ALPHA:
            [B,A,Peaks,Phases] = subfun_preparesinanimation(Images(p).BufferBG,Images(p).BufferI,Gen.Duration, ...
                ByPart.WaveFreq{p},range,ByPart.isHarmonic{p},0, 0, ByPart.SineWaveStartAngle{p});

        elseif ByPart.WhatVaries{p} == 'T'
            % Control condition: Variable = Transparency. <todo: ???>
            % ===========================================
            % Draw an image with variable alpha.
            % - Back image:  none.   -
            % - Front image: image,  global alpha = var.
            Images(p).BufferI = storeimage(Images(p).MatricesI(r));
            [B,A,Peaks,Phases] = subfun_preparesinanimation([],Images(p).BufferI,Gen.Duration, ...
                ByPart.WaveFreq{p},ByPart.AlphaRange{p},ByPart.isHarmonic{p},0, 0, ByPart.SineWaveStartAngle{p});

        elseif ByPart.WhatVaries{p} == 'S'
            % Control condition: Variable = Saturation.
            % =========================================
            % <todo(??) - never requested>

        elseif ByPart.WhatVaries{p} == 'C'
            % Control condition: Variable = Color.
            % ====================================
            % <todo(??) - never requested>

        else
            % Nothing varies
            % ==============
            % Back image:  image,  global alpha = 1.
            % Front image: none.   -
            b = storeimage(Images(p).MatricesI(r));
            Images(p).BufferI = b;
            B = repmat([b; NaN], 1, nFrames);
            A = ones(2, nFrames);
            Peaks  = zeros(1, nFrames);
            Phases = zeros(1, nFrames);

        end
        BUFFERS = [BUFFERS; B];
        ALPHA   = [ALPHA  ; A];
        PEAKS   = [PEAKS  ; Peaks];
        PHASES  = [PHASES ; Phases];

    end

    %   Change scale (Progr. note: Must be donne before "Delay before identity change")  <v1.3, rewritten v1.8.10>
    %     if length(Gen.Scale) == 1
    %         Scale = Gen.Scale;
    %     else
    %         Scale = zeros(1,nFrames);
    %         phases = [1, find(diff(PHASES(1,:))) + 1, nFrames+1];
    %         scales = randele(Gen.Scale,length(phases),1);
    %         for p = 1:length(phases)-1
    %             Scale(phases(p):phases(p+1)-1) = scales(p);
    %         end
    %     end
    % <v1.8.10: Rewritten v1.3 code: Gen.Scale -> ByPartScale, Scale (vector) -> SCALE (matrix)>
    SCALE = zeros(2*nParts,nFrames);
    if Gen.AllPartsSharingScalesOf % Not-Independent scales mode (default): randomize once for all. <v1.8.10>
        p0 = Gen.AllPartsSharingScalesOf;
        phases = [1, find(diff(PHASES(p0,:))) + 1, nFrames+1];
        scales0 = randele(ByPart.Scale{p},length(phases),1);
    end
    for p = 1 : nParts
        if length(ByPart.Scale{p}) == 1  % Constant scale
            scales = repmat(ByPart.Scale{p}, 1, nFrames);
        else                             % Variable scale
            if ~Gen.AllPartsSharingScalesOf  % Independent scales mode: randomize once for each part. (New default.) <v1.8.10>
                phases = [1, find(diff(PHASES(p,:))) + 1, nFrames+1];
                scales = randele(ByPart.Scale{p},length(phases),1);
            else                             % Not-Independent scales mode (default): randomize once for all. <v1.8.10>
                scales = scales0;
            end
        end
        for ph = 1:length(phases)-1
            SCALE(2*p-1, phases(ph):phases(ph+1)-1) = scales(ph);
            SCALE(2*p  , phases(ph):phases(ph+1)-1) = scales(ph);
        end
    end

    % Delay before identity change  <v1.2>
    wv = cell2mat(ByPart.WhatVaries);
    va = cell2mat(ByPart.VariesAfter);
    if any(wv == 'N') && any(va) % Avalaible only in 'N' mode
        for p = find(va)
            nf = round(ByPart.VariesAfter{p} * getscreenfreq);
            BUFFERS(2*p,1:nf) = BUFFERS(2*p,nf);
        end
    end

    % Alpha: Ensure validity.
    ALPHA = fitrange(ALPHA,[0 1]);
    
    % Alpha: Square Wave <v1.5.1>
    for p = 1 : nParts
        if strcmpi(ByPart.WaveForm{p},'square')
            ALPHA(p*2-1:p*2,:) = round(ALPHA(p*2-1:p*2,:));
        end
    end
    
    % Alpha: Fade Out <v1.8.3> 
    if Gen.FadeOut
        nf = round(Gen.FadeOut * getscreenfreq);
        fade = linspace(1,0,nf);
        ALPHA(:,end-nf+1:end) = ALPHA(:,end-nf+1:end) .* repmat(fade,2*nParts,1);
    end
    % Alpha: Fade In <v1.8.9> 
    if Gen.FadeIn
        nf = round(Gen.FadeIn * getscreenfreq);
        fade = linspace(0,1,nf);
        ALPHA(:,1:nf) = ALPHA(:,1:nf) .* repmat(fade,2*nParts,1);
    end

    
%% FIX POINT COLORS AND SHAPES
    fp = Gen.FixPoint;

    % We prepare input arg. for "displayanimation" :
    % - "FIXPOINTCOLOR",  1-by-N-by-3 (!) matrix
    FIXPOINTCOLOR = zeros(1,nFrames,3);
    for k = 1:3, FIXPOINTCOLOR(:,:,k) = fp.Color(k); end
    % - "FixPointShape", cell array of strings
    FixPointShape = repmat({fp.Shape},1,nFrames);

    % Color/Shape changes
    if fp.NumChanges > 0
        f = round(fp.ColorChangeDur / getframedur); % duration in frames.
        r = randperm(floor(nFrames/f));
        r(r==1) = [];
        nc = min([length(r); fp.NumChanges]);
        r = r(1:nc);
        jj = [];
        for i = 1 : nc, jj = [jj, r(i)*f+1:r(i)*f+f]; end
        switch fp.WhatChanges
            case 'C',   for k = 1:3, FIXPOINTCOLOR(1,jj,k) = fp.ChangedColor(k); end
            case 'S',   FixPointShape(jj) = repmat({fp.ChangedShape},1,length(jj));
        end
        % Store change events for ssPlotKeyboard
        FixPointIsChange = false(1,nFrames);
        FixPointIsChange(jj) = 1;
        FixPointIsChange(nFrames+1:end) = []; % <v1.6.2: Fix minor bug "crash ssPlotKeyboard*">
    end


%% X, Y THETA
    % X, Y
    X = zeros(2*nParts,nFrames);
    Y = zeros(2*nParts,nFrames);
    for p = 1 : nParts
        [h,w] = size(Images(p).MatricesI{1});
        x = ByPart.X{p};
        %     if ByPart.HorizontalAlignement{p} == 'L', x = x + w/2; end
        %     if ByPart.HorizontalAlignement{p} == 'R', x = x - w/2; end
        X(2*p-1:2*p,:) = x;
        y = ByPart.Y{p};
        %     if ByPart.VerticalAlignement{p} == 'B', y = y + h/2; end
        %     if ByPart.VerticalAlignement{p} == 'T', y = y - h/2; end
        Y(2*p-1:2*p,:) = y;
    end

    % Alignement <rewritten in v1.3>
    XAlign = char(zeros(nParts,1));
    for p = 1 : nParts, XAlign(2*p-1:2*p,:) = ByPart.HorizontalAlignement{p}; end
    YAlign = char(zeros(nParts,1));
    for p = 1 : nParts, YAlign(2*p-1:2*p,:) = ByPart.VerticalAlignement{p}; end

    % Axes Rotation
    THETA = zeros(2*nParts,nFrames);
    for p = 1 : nParts
        THETA(2*p-1:2*p,:) = ByPart.AxesRotation{p};
    end

    
%% EVENTS (Parallel Port and Photodiode)
    Bytes = zeros(1,nFrames);
    % i10 = 10 * round(getscreenfreq) + 1; % index of frame beginning at 10 sec.
    i15 = 15 * round(getscreenfreq) + 1; % index of frame beginning at 15 sec. <v1.2>
    if ~isempty(Gen.Events.TenSec) && i15 <= nFrames % <v1.6.2 fix case i15 > nFrames.>
        Bytes(i15) = Gen.Events.TenSec; 
    end
    for p = 1 : nParts
        maxs = PEAKS(p,:) > 0;
        if ~isempty(ByPart.Events.SineMax)
            Bytes(maxs) = Bytes(maxs) + ByPart.Events.SineMax{p};
        end
        mins = PEAKS(p,:) < 0;
        if ~isempty(ByPart.Events.SineMin)
            Bytes(mins) = Bytes(mins) + ByPart.Events.SineMin{p};
        end
    end
    % <v1.2>
    for p = 1 : nParts
        if ByPart.VariesAfter{p}
            f = find(BUFFERS(2*p,:) > BUFFERS(2*p,1)); % Find first change
            if ~isempty(f)
                f = f(1);
                Bytes(f) = Gen.Events.FirstIdentityChange;
            end
        end
    end
    % <v1.8.2: Moved that at the end to be sure no other value can be added.>
    if ~isempty(Gen.Events.Start),    Bytes(1) = Gen.Events.Start; end
    if ~isempty(Gen.Events.Stop), Bytes(end+1) = Gen.Events.Stop;  end
    
    % <v1.5> Repeating Pattern
    for p = 1 : nParts
        iMins = find(PEAKS(p,:) < 0);
        for e = find(ByPart.EventPattern{p}) % Loop once per element in pattern with an event
            n = length(ByPart.EventPattern{p});
            ii = iMins(e:n:end);
            Bytes(ii) = Bytes(ii) + ByPart.EventPattern{p}(e); % add pattern events
        end
    end
        
    % <v1.5> Separate Parallel Port Events and Photodiode Events
    PhotodiodeEvents = zeros(1,nFrames);
    ii = find(Bytes >= 1000);
    if Gen.isPhotodiode % <fix v1.6.2>
        PhotodiodeEvents(ii) = floor(Bytes(ii)/1000);
    end
    Bytes(ii) = rem(Bytes(ii),1000);
%     Bytes = fitrange(Bytes,[0 255]);


%% BATCH/GUI MODE <v1.6.2>
if nargin && ~isBlockMode  % Batch mode   <v1.8.6: no timeout in block mode.>
    TimeOut = 250;
else      % GUI mode
    TimeOut = inf;
end


%% CREATE "DELAY BUFFER" (to be displayed between splash & stim)  % <v1.8.3>
DelayBuffer = newbuffer;
% xy = [0 Gen.FixPoint.Y];
[th,r] = cart2pol(0,Gen.FixPoint.Y);
th = th - ByPart.AxesRotation{1} * pi/180;
[x,y] = pol2cart(th,r);
% draw(Gen.FixPoint.Shape, Gen.FixPoint.Color, DelayBuffer, [x y], Gen.FixPoint.Size, Gen.FixPoint.LineWidth); 
drawshape(Gen.FixPoint.Shape, DelayBuffer, [x y], Gen.FixPoint.Size, Gen.FixPoint.Color, Gen.FixPoint.LineWidth); % <v1.8.9: draw -> drawshape>

%% EXPORT ALL VARIABLE IN BASE WORKSPACE (for debug purpose)
    var = who;
    for i = 1 : length(var), assignin('base',var{i},eval(var{i})); end


%% EXPERIMENT!
    disp(' ')
    disp([mfilename ': Starting experiment...'])

    OldGamma = setgamma(Gen.ScreenGamma);

    %-------------------------------------!!!--REAL-TIME--!!!-----------------------------------
    [Times,FrameErr,KeyIDs,KeyPressTimes] = sub_displayanimation(BUFFERS,X,XAlign,Y,YAlign,... <v1.8.3: became a sub-fun>
        'Alpha',ALPHA,...
        'AxesRotation',THETA,...
        'Scale',SCALE,...
        'Draw',FixPointShape,0,Gen.FixPoint.Y,Gen.FixPoint.Size,FIXPOINTCOLOR,Gen.FixPoint.LineWidth,...
        'Send','parallel',Bytes,...
        'Send','photodiode',PhotodiodeEvents,... % <v1.5>
        'Get','keyboard',[1:16 18:256],... % <v1.5.3: quick hack to allow any key (avoid 17 to fix pb with Ctrl)>
        'Priority',Gen.Priority,... % <v1.3> 
        'Isochronous',Gen.isIsochronousMode,... % <v1.4> <becomes a param in v1.5>
        'FrameErrorEvent','parallel',Gen.Events.MissedFrame,... % <v1.5>
        'Splash',['SinStim ' SinStimVersion]',SinStimColors(1,:),SinStimColors(2,:),TimeOut,Gen.DelayBefore*1000,DelayBuffer);  % <v1.1: add delay, v1.8.3: add DelayBuffer>
    %-------------------------------------------------------------------------------------------
    
    TotalFrameErr = sum(FrameErr(~isnan(FrameErr))); % <v1.4> <v1.6.2: remove NaNs>
    
    wait(Gen.DelayAfter*1000); % <v1.1>


%% VARIABLES -> WORKSPACE
    disp([mfilename ': Exporting all variables to Workspace...'])
    assignin('base','Times',Times);
    assignin('base','FrameErr',FrameErr);
    assignin('base','TotalFrameErr',TotalFrameErr);
    assignin('base','KeyIDs',KeyIDs);
    assignin('base','KeyPressTimes',KeyPressTimes);
    disp([mfilename ': All internal variables are now accessible in the Workspace.'])
%     who % <suppr in v1.6.2>


% %% CHECK ERRORS % <v1.1 fix: must be before stoppsych.> <v1.6.2: Moved into displayanimation.>
%     disp(' ')
%     disp([mfilename ': Checking errors...')
%     disp([mfilename ': Here are the results of our own checkings. We want no errors here:')
%     if TotalFrameErr > Gen.MissedFramesTolerance;
%         str = {'!!! Timing errors !!!';...
%             '';...
%             'Unusual number of timing errors:';...
%             '';...
%             [int2str(TotalFrameErr) ' frames where missed.']};
%         displaywarning(str);
%     end
%     str = [int2str(TotalFrameErr) ' missed frames on ' int2str(nFrames) ' frames displayed.'];
%     if TotalFrameErr > 0
%         str = [str ' Missed frame numbers are:  ' int2str(find(FrameErr>0))];
%         disp(str)
%         if Gen.isIsochronousMode
%             disp([mfilename ': Isochronous mode: Frames have been skipped to correct the phase shift.')
%         else
%             disp([mfilename ': Non-isochronous mode: No correction has been applied.')
%         end
%     else
%         disp(str)
%     end


%% STOP GLAB
    disp(' ')
    disp([mfilename ': Stopping G-Lab...'])
    disp('(Maybe PTB will issue some warnings just below. These can be false positives.')
    disp(' The reliable error count is the one printed above by DISPLAYANIMATION).')
    if ~isBlockMode %<v1.8.5>
        stoppsych;
    else
        deletebuffer all; %<v1.8.7: MAJOR FIX for block mode!>
        if vcmp(GLabVersion,'<=','3-beta4') && ~isabort %<v1.8.8: Workaround for bug in deletebuffer (fixed only in CosyGraphics v3-beta4).>
            GLAB_BUFFERS.DraftBuffer = newbuffer;
        end
    end
    setgamma(OldGamma);
    
% catch %---------------------------------------------------------------------------------------------
%     % Stop GLab
%     stoppsych
%     setgamma(1)
%     % Export all variable to workspace
%     var = who;
%     for i = 1 : length(var), assignin('base',var{i},eval(var{i})); end
%     % Error!
%     rethrow(lasterror)
%     
% end


%% SAVE!
disp(' ')
disp([mfilename ': Saving data...'])
% Clear/convert variables to save memory:
clear I 
clear ans % Fix: 'ans' was a digilalio object.
for p = 1 : length(Images)
    for i = 1 : length(Images(p).MatricesI)
        Images(p).MatricesI{i} = uint8(round(Images(p).MatricesI{i} * 255)); % Images: double -> int. <v1.8.9: Add round() to fix warning.>
    end
end
% Save file & dir:
SaveFile = [SubjectName '_' ParamFile(1:end-2) datesuffix]; % datesuffix: sub-function <TODO: replace by bentools/datesuffix>
if TotalFrameErr, % If frame missed..
    SaveFile = [SaveFile '_' int2str(TotalFrameErr) 'err']; % ..append '_#err'
    if Gen.isIsochronousMode, SaveFile = [SaveFile '(corr)']; end
end
if stats.TotalDuration_ERROR
    SaveFile = [SaveFile '_DurErr!'];
end
if isabort
    SaveFile = [SaveFile '_aborted'];
end
% Save dir GUI
if nargin < 3 % <v1.6.2: add IF test> <v1.6.3: fix> <v1.7: rewrite>
    SaveDir = uigetdir(SaveDir,'Select the folder where to save data. (Or click Cancel.)');
end
% Save:
if any(SaveDir); % if uigetdir did not return 0
    % Save data
    save(fullfile(SaveDir,SaveFile)) % <--save!
    disp([mfilename ': Data saved in:   ' fullfile(SaveDir,SaveFile) '.mat'])
    % Record save dir name in "sinstim_var.txt" <v1.7: rewritten with readtxt/writetxt>
    [str,lines] = readtxt(VarFile);
    lines{lineSaveDir} = SaveDir;
    writetxt(VarFile,lines);
else
    disp('Canceled.')
end


%% PLOT FIXPOINT CHANGES & KEYBOARD EVENTS
if ~isTest && ~isBlockMode
    try
        ssPlotKeyboard2
    catch
        warning(['Error in ssPlotKeyboard2: ' lasterr])
    end
end


%% DONE
disp(' ')
disp([mfilename ': Done.'])
disp(' ')


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SUB-FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
% __________________________________________________________________________________
%% subfun_fields2cells: transform fields of 'ByPart' structure into cell vectors, one cell per part.
function s = subfun_fields2cells(s,nParts)
fields = fieldnames(s);
for f = 1 : length(fields)
    field = fields{f};
    if ~isstruct(s.(field)) % Regular Field
        if ~iscell(s.(field)),
            s.(field) = repmat({s.(field)},1,nParts);
        end
    else % Field = Sub-structure
        s.(field) = subfun_fields2cells(s.(field),nParts);  % <--recursive call
    end
end

% __________________________________________________________________________________
%% DATESUFFIX  Generate a date suffix which can be appended to a file name.
function  d = datesuffix
d = datestr(now,'yyyy-mm-dd HH:MM:SS');
d(d==' ') = '-';
d(d==':') = 'hm';
d = ['_' d 's'];

% __________________________________________________________________________________
%% SUBFUN_PREPARESINANIMATION  Prepare variables for DISPLAYANIMATION, to get sinusoidal stimuli. <v1.8: becomes a sub-fun>
function [BUFFERS,ALPHA,Peaks,Phases] = subfun_preparesinanimation(Buff1,Buff2,Dur,SineFreq,AlphaRange,isHarmonic,RandPattern,GapBetweenPatterns,SineWaveStartAngle)
% PREPARESINANIMATION  Prepare variables for DISPLAYANIMATION, to get sinusoidal stimuli.
%    [BUFFERS,ALPHA,Peaks,Phases] = PREPARESINANIMATION(Buff1,Buff2,Dur,SineFreq,AlphaRange,isHarmonic,<RandPattern>,<GapBetweenPatterns>)
%
%    1) Image is Variable, Interlaced: Image changes at each half-phase, with progressive super-imposition.
%    PREPARESINANIMATION(bb,bb,...)  (twice the same vector bb.)
%
%    2) Image is Variable, Non-Interlaced: Image changes at each phase.
%    PREPARESINANIMATION(NaN,bb,...)
%
%    3) Image is Constant.
%    PREPARESINANIMATION(NaN|b1,b2,...)  (b* are scalars.)
%
%    Other inputs:
%       - Dur:          Duration in seconds.
%       - SineFreq:     Freq. of sinusoid (not screen freq.!).
%       - AlphaRange:   [min max]
%       - isHarmonic:   1: Round period to integer number of frames ; 0: don't.
%       - RandPattern:  
%       - GapBetweenPatterns: [min max]: random gap between min sec and max sec ; 0: no gap.
%
%    Outputs:
%       - BUFFERS:      2-by-N matrix. Interlaced case uses 2 rows ; other cases use 2d row only (row1 filled of NaNs).
%       - ALPHA:        2-by-N matrix. Id.

% In <-
ByRun.Buff1 = Buff1;
ByRun.Buff2 = Buff2;
if ~exist('RandPattern','var')
    RandPattern = 'a';
end
if ~exist('GapBetweenPatterns','var') % <SS v1.8>
    GapBetweenPatterns = 0;
else
    GapBetweenPatterns = round(GapBetweenPatterns * getscreenfreq); % sec -> frame
end

% Sine Wave
[ByFrame.Wave, ByFrame.Peaks, ByFrame.Phases, ByFrame.Slopes, ByRun.FinalFreq] = ...
    sinewave(Dur, SineFreq, getscreenfreq, AlphaRange, isHarmonic, SineWaveStartAngle);
if min(ByFrame.Phases) == 0, ByFrame.Phases = ByFrame.Phases + 1; end  % <v1.8.2: Fix bug in sinewave before 09-jun-2011>

% Counts
nImages = length(Buff1);
if length(Buff2) ~= length(Buff1)
    nImages(2,1) = length(Buff2); 
end
nPhases = max(ByFrame.Phases);
nFrames = length(ByFrame.Wave);

% ALPHA
ByFrame.ALPHA = ones(2,nFrames);
ByFrame.ALPHA(2,:) = ByFrame.Wave;

% BUFFERS
ByFrame.BUFFERS = NaN + zeros(2,nFrames);

if length(Buff1) == length(Buff2) && all(Buff1 == Buff2) % Buff, Buff
    % Image is Variable, Interlaced: Image change at each half phase.
    % ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
    % Back image:  Buff1{i}, global alpha = 1.
    % Front image: Buff1{j}, global alpha = var. (Buff2 is the same than Buff1)
    % (i and j are arbitrary indexes.)
    
    % Phase count -> Image presentation count
    IC = [2*ByFrame.Phases-1; 2*ByFrame.Phases];
    descending = (ByFrame.Slopes == -1);
    IC(1,descending) = IC(1,descending) + 2; % Shift half a phase left
    ByFrame.ImageCount = IC;
    
    % By Run -> By HalfPhase (Order of presentation of Images)
    nHalfPhases = max(ByFrame.ImageCount(:)); % 1 HalfPhase = 1 Presentation of image
    order = randpattern(1:nImages,RandPattern,nHalfPhases); %  ..replace randele by randpattern>
    ByHalfPhase.Buffers = ByRun.Buff1(order);
    
    % By HalfPhase -> By Frame
    row1 = ByHalfPhase.Buffers(ByFrame.ImageCount(1,:));
    row2 = ByHalfPhase.Buffers(ByFrame.ImageCount(2,:));
    ByFrame.BUFFERS = [row1(:)'; row2(:)'];
    
elseif all(isnan(Buff1)) && length(Buff2) > 1
    % Image is Variable, Non-Interlaced: Image change at each phase.
    % ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
    % Back image:  none.
    % Front image: Buff2{i}, global alpha = var.
    nImages = nImages(2);
    
    order = randpattern(1:nImages,RandPattern,nPhases);
    ByPhase.Buffers = ByRun.Buff2(order);
    ByFrame.BUFFERS = NaN + zeros(2,nFrames);
    ByFrame.BUFFERS(2,:) = ByPhase.Buffers(ByFrame.Phases);
    
    % Add gap between patterns <v1.8>
    if any(GapBetweenPatterns)
        buffers0 = ByFrame.BUFFERS(2,:);
        buffers1 = [];
        alpha1 = [];
        peaks1 = [];
        phases1 = [];
        npPat = length(RandPattern); % # phases in pattern
        for i0 = 0 : npPat : nPhases % i0: phase index
            ii = find(ByFrame.Phases > i0 & ByFrame.Phases <= (i0 + npPat));
            nfGap = GapBetweenPatterns(2) + round(rand * diff(GapBetweenPatterns)); % # frames in this gap
            buffers1 = [buffers1, ByFrame.BUFFERS(2,ii), zeros(1,nfGap) + NaN];
            alpha1   = [alpha1  , ByFrame.ALPHA(2,ii)  , zeros(1,nfGap)];
            peaks1   = [peaks1  , ByFrame.Peaks(ii)    , zeros(1,nfGap)];
            phases1  = [phases1 , ByFrame.Phases(ii)   , zeros(1,nfGap)];
            if length(buffers1) >= nFrames 
                break  % <--!!
            end
        end
        ByFrame.BUFFERS(2,:) = buffers1(1:nFrames);
        ByFrame.ALPHA(2,:)   = alpha1(1:nFrames);
        ByFrame.Peaks(:)     = peaks1(1:nFrames);
        ByFrame.Phases(:)    = phases1(1:nFrames);
    end
    
elseif length(Buff1) <= 1 && length(Buff2) <= 1
    % Image is Constant: 
    % ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
    % Back image:  Buff1, global alpha = 1. (if Buff1 == NaN, no back image.)
    % Front image: Buff2, global alpha = var.
    if ~isempty(Buff1), ByFrame.BUFFERS(1,:) = Buff1; end
    if ~isempty(Buff2), ByFrame.BUFFERS(2,:) = Buff2; end
    
else
    error('Case not implemented. Invalid "Buff1", "Buff2" arguments.')
    
end

% <- Out
BUFFERS = ByFrame.BUFFERS;
ALPHA = ByFrame.ALPHA;
Peaks = ByFrame.Peaks;
Phases = ByFrame.Phases;


%% SUB_DISPLAYANIMATION
function [DisplayTimes,FramesMissed,varargout] = sub_displayanimation(B,varargin)
% DISPLAYANIMATION  Real-time display of a sequence of images to be build from pre-stored buffers.
%    [DisplayTimes,FrameErr] = DISPLAYANIMATION(B,X,Y)  displays sequence buffers whose handles are stored
%    in matrix B. Each buffer will be displayed with X and Y offsets during one screen frame. B, X
%    and Y are either scalars (buffer/x/y constant) or b-by-N matrices, where b is the number of
%    buffers per frames and N is the number of frames to display (buffer/x/y variable). It returns
%    1-by-N vectors DisplayTimes (timestamps of begins of vertical blankings) and FrameErr.
%
%    [DisplayTimes,FrameErr] = DISPLAYANIMATION(B,X,XAlign,Y,YAlign)  specifies the x/y alignement. XAlign
%    can be 'L', 'C' or 'R' to align on left, center or right respectivelly. YAlign ca be 'T', 'C'
%    or 'B' (top, center, bottom). XAlign and YAlign can also be b-by-N matrices of characters.
%
%    [DisplayTimes,FrameErr] = DISPLAYANIMATION(...,Durations)  specifies durations (in ms) of display
%    for each image buffer. 'Durations' is a 1-by-N vector (N is the number of images). Values of 0
%    are interpreted as 1 frame duration.
%
% Image Processings (PTB only):
%    The following options are only availables if PTB is used as graphics library.
%
%    DISPLAYANIMATION(...,'Alpha',ALPHA)  copies buffers with an alpha (translucency)
%    factor. ALPHA is a b-by-N matrix (see above).
%
%    DISPLAYANIMATION(...,'Scale',S)  copies buffers with a scaling factor S. (S=1 is 100%.)
%
%    DISPLAYANIMATION(...,'BufferRotation',THETA)  copies buffers with a rotation. THETA is
%    a b-by-N matrix (see above) containing the rotation angles, in degrees, clockwise.
%
%    DISPLAYANIMATION(...,'AxesRotation',THETA)  copies buffers with a rotation of both (x,y)
%    coordinates and buffer orientation. THETA is a b-by-N matrix (see above) containing the
%    rotation angles, in degrees, clockwise. If you want to rotate the x, y coordinates but not
%    the buffer orientation, use:  DISPLAYANIMATION(...,'AxesRotation',THETA,'BufferRotation',0).
%
% Drawings:
%    DISPLAYANIMATION(...,'Draw',Draw.Draw.Shape,X,Y,W,<H>,RGB,<LineWidth>) draws geometrical
%    object(s). Draw.Draw.Shape can be 'square', 'rect', 'round', 'oval' or 'cross' (if shape is
%    constant) ; it can also be a 1-by-N cell array of strings, one for each image to display (if
%    shape varies). X, Y, W (widths), H (heigths) and LineWidth are s-by-N matrices, where s is the
%    number of shapes to draw and N is the number of frames to display.
%    H and LineWidth are optionnals. RGB is a s-by-N-by-3 matrix or rgb values, in the range 0.0 to
%    1.0. In all matrices missing values are replaced by NaNs.
%    See DRAWSHAPE for more informations.
%
% Triggers and Events:
%    [DisplayTimes,FrameErr,TrigTimes] = DISPLAYANIMATION(...,'Wait',Device,Bytes)  waits trigger.
%    <todo: not yet implemented>
%
%    [DisplayTimes,FrameErr,EventValues,EventTimes] = DISPLAYANIMATION(...,'Get',Device,Values)  gets
%    events from device during the animation. Device can only be 'Keyboard'. <todo: Implement others.>
%    Values are the IDs of the keys to wait for.
%
%    [DisplayTimes,FrameErr,SendTimes] = DISPLAYANIMATION(...,'Send',Device,Bytes)  sends bytes
%    through device. Device can be 'parallel', 'serial' or 'photodiode'. <todo: 'Daq'> "Bytes" is a
%    1-by-N or 1-by-(N+1) vector, containing values to be sent (integers from 1 to 255)
%    and 0s or NaNs where nothing has to be sent. With parallel port you cannot send the same value
%    two times in a row. With photodiode, values are half-bytes (from 0 to 15) (1: upper-left
%    corner, 2: upper-right, 4: lower-left, 8: lower-right; numbers can be added). Bytes will be
%    sent at the beginning of the display (refresh cycle onset) of the corresponding image. If there
%    is a (N+1)th value, it will be sent at the end of the last display.
%
%    If more than one of these options is used, output argume order is:
%    [DisplayTimes,FrameErr,EventValues,EventTimes,SendTimes] = DISPLAYANIMATION(...)
%
% Real-time Control:
%    DISPLAYANIMATION(...,'FrameErrorEvent',Device,ErrorCode)  sends ErrorCode through Device each
%    time a frame has been missed. Device can be 'parallel' or 'serial'. ErrorCode is an integer
%    from 1 to 255.
%
%    [DisplayTimes,FrameErr] = DISPLAYANIMATION(...,'Isochronous',flag)  in isochronous mode (flag=1), the
%    function corrects timing errors due to missed refresh deadlines by skipping the next frame after
%    each missed refresh. This will be perfectly efficient if PTB can get high precision timestamps.
%    If PTB has to fallback to lower precision timestamps due to driver bugs, false positive are
%    possibles. Non-isochronous mode (flag=0) is the default. No correction are done in this mode, but
%    all images are guanrantied to be displayed.
%
%           Normal display (no errors):                 1, 2, 3, 4, 5, 6, 7,...
%           Missed frame #4, no correction:             1, 2, 3, 3, 4, 5, 6, 7,...
%           Missed frame #4, isochronous correction:    1, 2, 3, 3, 4, 6, 7,...    (skip frame #5 to correct phase shift)
%
%           Corresponding elements in vetors:          [1  2  3  4 NaN 6  7 ...]
%
%    DISPLAYANIMATION(...,'Priority',PriorityLevel)  sets priority level during animation.
%    PriorityLevel can be 'NORMAL', 'HIGH', 'REALTIME' or 'OPTIMAL'. (In the latter case, GLab will
%    choose for you the optimal solution; this is also the default behavior.)
%
% Splash Screen:
%    DISPLAYANIMATION(...,'Splash',MessageString,BgColor,FontColor,<TimeOut>,<Delay>,<DelayBuffer>)  
%    displays a splash screen when ready and waits a key press to start the animation. MessageString is a cell 
%    array of strings. 'TimeOut' (optional) is the max time to wait for, in milliseconds. Default value is inf.
%    'Delay' (optional) is the number of milliseconds to wait after the key press before to start. 'DelayBuffer'
%    (optional) is the handle of the buffer to be displayed during the delay ; if not provided, a blank screen 
%    will be shown.
%
%
% See also PREPARESINANIMATION.
%
% Ben, 2007-2009

% VERSION HISTORY
% v0.1	 Sep. 07    REALTIMEDISPLAY. First simple function, with support for daq trigger.
% v0.2   Oct.   	Precompilation of children function.
% v0.9   Nov.		Add parallel port. Suppr. daq trigger. Fix. timing err.: - 1 frame dur.
% v1.0   Nov.		RTDISPLAYBUFFERS. No more substract 1 frame dur., now it's done by waitsync.
%                   No more set priority itself. Use SETPRIORITY !!!
%        Dec.       rtdisplaysprites
% v2.0   Nov. 08                    DISPLAYANIMATION. Add Special Effects. Send Events: change arguments.
% v2.0.1 Feb. 09                    Fix "Durations" spelling bug.
% v2.1   June                       Suppr. X, Y input arg no more optional. B can be a scalar.
%                                   XAlign, YAlign optional args.
%                                   'Scale' option.
%                                   'Priority' option.
%                                   Fix case no ALPHA or no THETA.
% v2.2   Oct.                       'Isochronous' option.
%                                   <!> FrameErr becomes now a 1xN vector (instead of a scalar).
% v2.3   Oct.                       Fix 2.2.
%                                   'FrameErrorEvent' option.
% v2.4   Nov.       2-beta9/10nov   Store all time vars in GLAB_FUNCTIONS.s
%                                   Workaround "neg timestamps" bug
% v2.5   Dec.       2-beta10.       Rewrite totally 2.4.
% v2.6   Jan. 2010  2-beta12a       Fix isochronous mode. <unfinished>
% v2.7              2-beta12b       Fix isochronous mode.
%                                   Splash: Add time out.
%                                   STATS:
%                                   - Rewrite 2.5 exported structure, add lot of stats.
%                                   - Move error messages from Sinstim 1.6.2.
%                                   - Make the function verbose.
%                                   - Export "stats" variable to base ws and caller ws.
%                                   <TODO: Fix N vs N+1 problem>
% v2.7.1            2-beta14        Save log
%                                   ReadyToDisplayTimes = ReadyToDisplayTimesCOG;
% v2.7.2            2-beta15        Moved errors checks & messages to glabhelper_checkerrors (+fix missed frames indexes)
%                                   Fix CpuTime max: ignore 2 first times + add CpuTime_FirstLoop_ms
% v2.7.3            2-beta17        Linux fix: use cogstd only on Windows.  
%                                   Log: Small fixes. stats = s;
% v2.8   Jul.       2-beta23        Fix FunVersion (was 2.7.1).
%                                   Log: Use glablog => Log in x:\glab\var\log. Log only if full screen.
% v2.8.1 Nov.       2-beta31        Fix case no buffers (only NaNs).
%
% v2.8.1a June 2011 2-beta32/09jun <backport v2-beta39, put as sub-fun in SinStim 1.8.2 for bw compat with GLab 2-beta32> 
%                                   Fix: last byte of BytesToSend was not sent.
%
% v2.8.1a/SinStim1.8.3 Sept 2011 2-beta32 <backport v3-alpha1 into SinStim 1.8.3's sub-fun>
%                                   'Splash' option: Add DelayBuffer arg.
tic

global GLAB_FUNCTIONS 

GLabVersion = glabversion;
FunVersion = '2.8';

dispinfo(mfilename,'info','Preparing animation...')

% INPUT ARGs
% X, Y, XALIGN, YALIGN
X = varargin{1};
if ischar(varargin{2}) && all(ismember(varargin{2},'LCR'))
    XALIGN = varargin{2};
    varargin(2) = [];
else
    XALIGN = 'C';
end
Y = varargin{2};
if numel(varargin) >=3 && ischar(varargin{3}) && all(ismember(varargin{3},'TCB'))
    YALIGN = varargin{3};
    varargin(3) = [];
else
    YALIGN = 'C';
end
varargin(1:2) = [];

% Get b and N
b = max([size(B,1) size(X,1) size(Y,1)]); % nb of buffers per set
N = max([size(B,2) size(X,2) size(Y,2)]); % nb of image to display

% Durations
if numel(varargin) >= 1 && isnumeric(varargin{1})
    Durations = varargin{1};
    varargin(1) = [];
    if isempty(Durations), Durations = ones(1,N) * getframedur;
    elseif length(Durations) == 1, Durations = repmat(Durations,1,N);
    end
else
    Durations = zeros(1,N);
end

% Options
Get = 0;
Send = 0;
BytesToSend = zeros(1,N);
Draw.Shape = {};
ALPHA  = 1;
XSCALE = 1;
YSCALE = 1;
% THETA  = 0; <Don't define it!>
FrameErrorEvent.Code = 0;
FrameErrorEvent.Device = 'none';
isPhotodiode = 0;
isIsochronous = 0;
Priority = 'OPTIMAL';

for i = 1 : length(varargin)
    if strcmpi(varargin{i},'Get')
        if strcmpi(varargin{i+1},'Keyboard') | strcmpi(varargin{2},'Serial') %#ok<OR2>
            Get = upper(varargin{i+1}(1)); % 'K', 'S'
            ValuesToGet = varargin{i+2};
            if Get == 'K', ValuesToGet = getkeycode(ValuesToGet,'PTB'); end
        end
        
    elseif strcmpi(varargin{i},'Send')
        if strcmpi(varargin{i+1},'parallel') | strcmpi(varargin{i+1},'serial') | strcmpi(varargin{i+1},'daq') %#ok<OR2>
            Send = upper(varargin{i+1}(1)); % 'P', 'S' or 'D'
            BytesToSend = varargin{i+2};
            if Send == 'P', BytesToSend(isnan(BytesToSend)) = 0; end
        elseif strcmpi(varargin{i+1},'photodiode')
            if any(varargin{i+2} > 0)
                isPhotodiode = 1;
                PhotodiodeHalfbytesToSend = varargin{i+2};
            end
        else
            error('Unknown "Send" device.')
        end
        
    elseif strcmpi(varargin{i},'Alpha')
        ALPHA = varargin{i+1};
        
    elseif strcmpi(varargin{i},'Scale')
        XSCALE = varargin{i+1};
        YSCALE = varargin{i+1};
        
    elseif strcmpi(varargin{i},'XScale')
        XSCALE = varargin{i+1};
    elseif strcmpi(varargin{i},'YScale')
        YSCALE = varargin{i+1};
        
    elseif strcmpi(varargin{i},'AxesRotation')
        ETA = varargin{i+1};
        
    elseif strcmpi(varargin{i},'BufferRotation') | strcmpi(varargin{i},'Rotation') %#ok<OR2>
        THETA = varargin{i+1};
        
    elseif strcmpi(varargin{i},'Draw')
        % <- varargin
        Draw.Shape = varargin{i+1};
        if ~iscell(Draw.Shape), Draw.Shape = repmat({Draw.Shape},1,N); end
        Draw.X = varargin{i+2};
        Draw.Y = varargin{i+3};
        Draw.W = varargin{i+4};
        if size(varargin{i+5},3) < 3, i1 = i+5;
        else                          i1 = i+4;
        end
        Draw.H = varargin{i1};
        Draw.RGB = varargin{i1+1};
        if length(varargin) >= i1+2 && isnumeric(varargin{i1+2})
            Draw.L = varargin{i1+2};
        else
            Draw.L = 1;
        end
        % 1-by-1 -> b-by-s
        s = max([size(Draw.X,1) size(Draw.Y,1)]);
        fields = fieldnames(Draw);
        for f = 1 : length(fields)
            x = fields{f};
            if size(Draw.(x),1) == 1, Draw.(x) = repmat(Draw.(x),s,1); end
            if size(Draw.(x),2) == 1, Draw.(x) = repmat(Draw.(x),1,N); end
        end
        
    elseif strcmpi(varargin{i},'FrameErrorEvent')
        FrameErrorEvent.Code = varargin{i+1};
        FrameErrorEvent.Device = varargin{i+2};
        
    elseif strcmpi(varargin{i},'Isochronous')
        isIsochronous = varargin{i+1};
        
    elseif strcmpi(varargin{i},'Priority')
        Priority = varargin{i+1};
        
    elseif strcmpi(varargin{i},'Splash')
        Splash.Message   = varargin{i+1};
        Splash.BgColor   = varargin{i+2};
        Splash.FontColor = varargin{i+3};
        if length(varargin) >= i+4 && isnumeric(varargin{i+4})
            Splash.TimeOut = varargin{i+4};
        else
            Splash.TimeOut = inf;
        end
        if length(varargin) >= i+5 && isnumeric(varargin{i+5})
            Splash.Delay = varargin{i+5};
        else
            Splash.Delay = 0;
        end
        if length(varargin) >= i+6 && isnumeric(varargin{i+6})
            Splash.DelayBuffer = varargin{i+6};
        else
            Splash.DelayBuffer = 0;
        end
        
    end
end

% *-by-* -> b-by-N matrices
if size(B,1) == 1, B = repmat(B,b,1); end
if size(B,2) == 1, B = repmat(B,1,N); end
if size(X,1) == 1, X = repmat(X,b,1); end
if size(X,2) == 1, X = repmat(X,1,N); end
if size(Y,1) == 1, Y = repmat(Y,b,1); end
if size(Y,2) == 1, Y = repmat(Y,1,N); end
if size(XALIGN,1) == 1, XALIGN = repmat(XALIGN,b,1); end
if size(XALIGN,2) == 1, XALIGN = repmat(XALIGN,1,N); end
if size(YALIGN,1) == 1, YALIGN = repmat(YALIGN,b,1); end
if size(YALIGN,2) == 1, YALIGN = repmat(YALIGN,1,N); end
if size(XSCALE,1) == 1, XSCALE = repmat(XSCALE,b,1); end
if size(XSCALE,2) == 1, XSCALE = repmat(XSCALE,1,N); end
if size(YSCALE,1) == 1, YSCALE = repmat(YSCALE,b,1); end
if size(YSCALE,2) == 1, YSCALE = repmat(YSCALE,1,N); end
if size(ALPHA,1) == 1, ALPHA = repmat(ALPHA,b,1); end
if size(ALPHA,2) == 1, ALPHA = repmat(ALPHA,1,N); end
if exist('ETA','var')
    if size(ETA,1) == 1, ETA = repmat(ETA,b,1); end
    if size(ETA,2) == 1, ETA = repmat(ETA,1,N); end
end
if exist('ETA','var') & ~exist('THETA','var'); %#ok<AND2>
    THETA = ETA;
end
if size(THETA,1) == 1, THETA = repmat(THETA,b,1); end
if size(THETA,2) == 1, THETA = repmat(THETA,1,N); end

% Correct X, Y
% for Scale
[W,H] = buffersize(B);
W = W .* XSCALE;
H = H .* YSCALE;
X(XALIGN=='L') = X(XALIGN=='L') + W(XALIGN=='L')/2;
X(XALIGN=='R') = X(XALIGN=='R') - W(XALIGN=='R')/2;
Y(YALIGN=='T') = Y(YALIGN=='T') - H(YALIGN=='T')/2;
Y(YALIGN=='B') = Y(YALIGN=='B') + H(YALIGN=='B')/2;

% for Axes Rotation
if exist('ETA','var')
    [TH,R] = cart2pol(X,Y);
    TH = TH - ETA * pi/180;
    [X,Y] = pol2cart(TH,R);
    if ~isempty(Draw.Shape)
        [TH,R] = cart2pol(Draw.X,Draw.Y);
        E = repmat(ETA(1,:),size(Draw.X,1),1); % we suppose that angle is the same for every buffer.
        TH = TH - E * pi/180;
        [Draw.X,Draw.Y] = pol2cart(TH,R);
    end
end

% PsychToolBox: Get "RECT" argument
% To get best performances in the real-time loop, we'll use PTB's Screen function
% directly. (Much faster than copybuffers, mainly due to current lack of optimization
% in convertcoord.)
XY = [X(:) Y(:)];  % b*N-by-2
% WH = zeros(b*N,2); % b*N-by-2
% for i = 1 : b*N, WH(i,:) = buffersize(B(i)); end
WH = [W(:) H(:)];
RECT = convertcoord('XY,WH -> RECT',XY,WH); % 4-by-b*N
RECT3 = zeros(4,b,N); % 4-by-b-by-N
RECT3(:) = RECT(:);

% Export reprocessing duration to workspace
assignin('base','dt_displayanimation',toc)

% Splash Screen
if exist('Splash','var')
    displaymessage(Splash.Message,Splash.BgColor,Splash.FontColor,...                   % W...a...i...t...
        'continue',getkeynumber('Enter'),'quit',getkeynumber('Escape'),Splash.TimeOut);
    if Splash.Delay
        %         clearbuffer(0); % <todo: usefull? displaybuffer has already cleared buff0!>
        tEndSplash = displaybuffer(Splash.DelayBuffer);
        waitsynch(Splash.Delay);
    end
end

% Init. Var.
DisplayTimes = NaN + zeros(1,N+1);
ReadyToDisplayTimes = NaN + zeros(1,N);
ReturnFromDisplayTimesPTB = NaN + zeros(1,N);
ReturnFromDisplayTimesCOG = NaN + zeros(1,N);
GetValues = NaN + zeros(1,N);
GetTimes  = NaN + zeros(1,N);
SendTimes = NaN + zeros(1,N+1);
FramesMissed = zeros(1,N);  % # of frame misses detected
FramesSkipped = false(1,N); % 1 if skipped, 0 if not.
all_j = NaN + zeros(1,N);
OneFrame = getframedur;

% PRECOMPILE FUNCTIONS
j = 1;
if isPhotodiode
    setphotodiodevalue(0);
end
if ~isempty(Draw.Shape)
    xy = [Draw.X(:,j) Draw.Y(:,j)];
    wh = [Draw.W(:,j) Draw.H(:,j)];
    rgb = reshape(Draw.RGB(:,j,:),size(Draw.RGB,1),3);
    l = Draw.L(:,j);
    drawshape(Draw.Shape{j},0,xy,wh,rgb,l);
end

% MAIN LOOP
setpriority(Priority) %=================================================
dispinfo(mfilename,'info','Starting real-time animation...')
j = 1;
old_j = 1; % <This fixes "miss frame #3 bug! old_j must be defined to avoid a delay on second iteration!>
str = '';  % <id.>

tMainLoopStart = time;
% t0=time;
while j <= N
    % Create image to display in backbuffer
    % For optimization, we use directly lower-level C functions.
% if j==1, t383=time-t0, end
    ii = ~isnan(B(:,j));
    if any(ii)
        if isptb
            Screen('DrawTextures',gcw,B(ii,j),[],RECT3(:,ii,j),THETA(ii,j),[],ALPHA(ii,j));
        else
            error('Not yet implemented for CogentGraphics.')
        end
    end
% if j==1, t390=time-t0, end
    if ~isempty(Draw.Shape)
        xy = [Draw.X(:,j) Draw.Y(:,j)];
        wh = [Draw.W(:,j) Draw.H(:,j)];
        rgb = reshape(Draw.RGB(:,j,:),size(Draw.RGB,1),3);
        l = Draw.L(:,j);
        drawshape(Draw.Shape{j},0,xy,wh,rgb,l);
    end
% if j==1, t398=time-t0, end
    % Photodiode: Draw square for photodiode?
    if isPhotodiode
        setphotodiodevalue(PhotodiodeHalfbytesToSend(j));
    end
% if j==1, t403=time-t0, end
    % Wait trigger
    % <TODO>

    % Display!
    ReadyToDisplayTimesPTB(j) = time;
    if ispc, ReadyToDisplayTimesCOG(j) = cogstd('sGetTime',-1); end
    DisplayTimes(j) = displaybuffer(0); %  <----- D I S P L A Y  !
    ReturnFromDisplayTimesPTB(j) = GetSecs;
    if ispc, ReturnFromDisplayTimesCOG(j) = cogstd('sGetTime',-1); end
% if j==1, t413=time-t0, end
    % Frame errors <takes 60ï¿½s to execute on DARTAGNAN>
    nMisses = 0;
    nSkips  = 0;
    if j > 1 % <AVOID THIS !!!>
        dt = DisplayTimes(j) - DisplayTimes(old_j); % <v1.6.1 (fix v1.4): j-1 -> old_j !!!> <v1.6.2: Fix "miss fram #3 bug: old_j must be declared>
        if dt > 1.5 * OneFrame
            nMisses = round(dt / OneFrame) - 1;
            FramesMissed(j) = nMisses;
        end
    end
% if j==1, t424=time-t0, end
    % -Isochronous mode: Correct missed refreshes:
    if isIsochronous && nMisses > 0
        nSkips = nMisses;
        j1 = min([N j+nSkips]);
        FramesSkipped(j+1:j1) = 1;
        FramesMissed(j+1:j1) = NaN;
        if strcmpi(FrameErrorEvent.Device,'serial')
            sendserialbytes(1,FrameErrorEvent.Code);
        end
    end
% if j==1, t435=time-t0, end
    % Just after display: Send Event?
    if     Send == 'P'
        b = BytesToSend(j);
        if nSkips && strcmpi(FrameErrorEvent.Device,'parallel') % Isochronous mode..
            b = b + FrameErrorEvent.Code; % ..send error code
        end
        sendparallelbyte(b);
        if BytesToSend(j)
            SendTimes(j) = time;
        end
    elseif Send == 'S'
        if ~isnan(BytesToSend(j))
            sendserialbytes(1,BytesToSend(j));
            SendTimes(j) = time;
        end
    elseif Send == 'D'
        % <TODO>
    end
% if j==1, t454=time-t0, end
    % Get Events?
    if Get == 'K'
        [n,c,t] = checkkeydown(ValuesToGet);
        GetValues(j) = n(1);
        GetTimes(j)  = t(1);
    elseif Get == 'S',
        % <TODO>
    end
    
    % Abort?
    if isabort, break, end % !
    
    % Wait...
    if ~isempty(Durations) && Durations(j) > 0
        if Durations(j)
            waitsynch(Durations(j));   %  W . . . a . . . i . . . t . . .
        end
    end
% if j==1, t473=time-t0, end
    % j+
    if nSkips > 0 % Isochronous mode:
        msg = ['Missed  frame(s) # ' int2str(old_j+1 : old_j+nSkips) '. ' ...
                'Skipping frame(s) # ' int2str(old_j+2 : old_j+nSkips+1) ' to correct temporal shift.'];
        dispinfo(mfilename,'warning',msg);
        disp(str)
    end
    old_j = j;
    all_j(j) = j;
    j = j + 1 + nSkips;
% if j==1, t483=time-t0, end
end

% End
if ~isabort, nDisplayed = N;
else         nDisplayed = j;
end
clearbuffer(0); % <todo: usefull? displaybuffer has already cleared buff0!>
t1 = displaybuffer(0);
DisplayTimes(nDisplayed+1) = t1; % Add "the end" display time
if Send == 'P'
    % <09-06-2011>
    if ~isabort 
        if length(BytesToSend) > N
            t1 = sendparallelbyte(BytesToSend(N+1));
            wait(1);
            sendparallelbyte(0);
        else
            t1 = sendparallelbyte(0);
        end
        SendTimes(nDisplayed+1) = t1;
    else
        sendparallelbyte(0);
    end
    % </09-06-2011>
    
%     t1 = sendparallelbyte(0);
%     SendTimes(nDisplayed+1) = t1;
end

dispinfo(mfilename,'info','...end real-time animation.')
setpriority('NORMAL') %===================================================


% TIMES
RawDisplayTimes = DisplayTimes;
ReturnFromDisplayTimesPTB = ReturnFromDisplayTimesPTB * 1000;
ReturnFromDisplayTimesCOG = ReturnFromDisplayTimesCOG * 1000;

if exist('tEndSplash','var'),  Delay = DisplayTimes(1) - tEndSplash;
else                           Delay = 0;
end

Durations(Durations==0) = OneFrame;
nFrames = sum(round(Durations / OneFrame));
t0 = DisplayTimes(1);
DisplayTimes = DisplayTimes - t0;

t = DisplayTimes([~FramesSkipped true]);
dt = diff(t);
DisplayIntervals = NaN + zeros(1,N);
DisplayIntervals(~FramesSkipped) = dt;

if isptb 
    ReadyToDisplayTimes = ReadyToDisplayTimesPTB;
    ReturnFromDisplayTimes = ReturnFromDisplayTimesPTB;
else      
    ReturnFromDisplayTimes = ReturnFromDisplayTimesCOG;
    ReadyToDisplayTimes = ReadyToDisplayTimesCOG;
end

GetTimes = GetTimes - t0;
SendTimes = SendTimes - t0;
% <todo: remove the following in next version>
% if isIsochronous
%     ok = ~isnan(all_j);
%     t = DisplayTimes([ok true])
%     dt = diff(t);
%     e = abs(Durations(ok) - dt);
%     e = round(e / getframedur);
%     FrameErr(ok) = e;
% else
%     e = abs(Durations - diff(DisplayTimes));
%     FrameErr = round(e / getframedur);
% end
    

% STATS
% Export stats in a global variable <GLab v2-beta10, rewritten in v2-beta12b>
% <SinStim 1.6.1+: No more used directly ==> Modularity is restored>

try % We want to compute stats without lowering the function stability
    s = struct;
    
    % General info
    s.ScreenFreq_Hz = getscreenfreq;
    s.GLabVersion = glabversion('str');
    s.MatlabVersion = version;
    if isIsochronous, s.Mode = 'isochronous';
    else              s.Mode = 'non-isochronous';
    end
    
    % Displays
    s.Displayed = nDisplayed;
    pd.DisplayTimes_ms = DisplayTimes; % final timestamps
    pd.DisplayIntervals_ms = DisplayIntervals;
    pd.DisplayIntervals_frames = round(DisplayIntervals / OneFrame);
    
    % Missed Frames
    nFrameMisses = sum(FramesMissed(FramesMissed > 0));
    s.MissedRefreshDeadlines_ERRORS = nFrameMisses;
    s.FramesSkippedToCorrect = sum(FramesSkipped > 0);
    f = find(FramesMissed > 0); % <NB: find(FramesMissed) would find also NaNs>
    s.MissedRefreshDeadlines_frameindexes = f;
    s.MissedRefreshDeadlines_framespermiss = FramesMissed(f);
    pd.FramesMissed = FramesMissed;
    pd.FramesSkipped = FramesSkipped;
    
    % Send/Get Bytes
    pd.SentTimes_ms = SendTimes;
    ii = find(SendTimes > 0);
    pd.SentValues_byte = zeros(size(SendTimes)) + NaN;
    pd.SentValues_byte(ii) = BytesToSend(ii); % <todo: what if length(SendTimes) > length(BytesToSend) ?>
    s.BytesSent = length(ii);
    ii_notsent = find(BytesToSend > 0 & [FramesSkipped false]);
    s.BytesNotSent_ERRORS = length(ii_notsent);
    s.BytesNotSent_frameindexes = ii_notsent;
    s.BytesNotSent_values = BytesToSend(ii_notsent);
    if isPhotodiode
        ii_notdiode = find(PhotodiodeHalfbytesToSend > 0  &  FramesSkipped);
        s.PhotodiodeNotDisplayed_ERRORS = length(ii_notdiode);
        s.PhotodiodeNotDisplayed_frameindexes = ii_notdiode;
        s.PhotodiodeNotDisplayed_halfbytes = PhotodiodeHalfbytesToSend(ii_notdiode);
    end
    pd.GotTimes_ms    = GetTimes;
    pd.GotValues_byte = GetValues;
    
    % Durations
    s.DelayBeforeStart_s = Delay / 1000;
    TotalDuration_ms = DisplayTimes(nDisplayed+1) - DisplayTimes(1);
    s.TotalDuration_s = TotalDuration_ms / 1000;
    s.TotalDuration_frames = round(TotalDuration_ms / OneFrame);
    s.TotalDuration_ERROR = s.TotalDuration_frames - nFrames;
    s.TotalDurationImprecision_ms = TotalDuration_ms - nFrames*OneFrame;
    pd.DEBUG.ReadyToDisplayTimes_ms = ReadyToDisplayTimes;
    pd.DEBUG.RawDisplayTimes_ms = RawDisplayTimes; % raw times, as returned by Screen('flip') (without substracting t0, but divided by 1000)
    pd.DEBUG.ReturnFromDisplayTimesPTB_ms = ReturnFromDisplayTimesPTB; % times without beam position correction
    pd.DEBUG.ReturnFromDisplayTimesCOG_ms = ReturnFromDisplayTimesCOG; % id., from low res. timer trough cogstd
    
    % CPU Execution Duration:
    CpuTimes = [NaN, ReadyToDisplayTimes(2:end) - ReturnFromDisplayTimes(1:end-1)]; % CPU exec times
    CpuTimes(1) = ReadyToDisplayTimes(1) - tMainLoopStart;
    pd.CpuTimes_ms = CpuTimes;
    xd = CpuTimes(~isnan(CpuTimes));
    s.CpuTime_FirstLoop_ms  = xd(1); % loop 1 (prepares frame 2)
    s.CpuTime_SecondLoop_ms = xd(2); % loop 2 (prepares frame 3)
    mmm = [min(xd) median(xd) max(xd(3:end))]; % Don't take in account frame 1 and 2 for max, because of interpreter overload
    s.CpuTime_MinMedianMax_ms = mmm;
    s.CpuLoad_MinMedianMax_pc = mmm * 100 / OneFrame;
%     if mmm(2) >= OneFrame,   s.CpuLoad_ERROR = true;  % longer than frame interval
%     else                     s.CpuLoad_ERROR = false;
%     end
%     if mmm(2) >= OneFrame/2, s.CpuLoad_WARNING = true; % longer than half the frame interval
%     else                     s.CpuLoad_WARNING = false;
%     end
    s.CpuLoadAboveCapacity_ERRORS = sum(CpuTimes(2:end) >= OneFrame); % longer than frame interval
    s.CpuLoadAboveHalfCapacity_WARNINGS = sum(CpuTimes(2:end) > OneFrame/2); % longer than half the frame interval

    % Timer Imprecision:
    TimerImprecisions = pd.DisplayIntervals_ms - pd.DisplayIntervals_frames * OneFrame;
    pd.TimerImprecisions_ms = TimerImprecisions;
    TimerImprecisions = abs(TimerImprecisions);
    s.TimerImprecision_MinMedianMax_ms = [min(TimerImprecisions) median(TimerImprecisions) max(TimerImprecisions)];
    s.TimerImprecisionAbove2ms_ERRORS = sum(TimerImprecisions > 2); % > 2 ms is considered as an error.
    s.TimerImprecisionAbove2ms_frameindexes = find(abs(TimerImprecisions) > 2);
    
    % % debug
    % pd.DEBUG.all_j = all_j;
    
    % Fix "[1x0 double]" display>
    fields = fieldnames(s);
    for f = 1 : length(fields)
        if isempty(s.(fields{f})), s.(fields{f}) = []; end
    end
    
catch
    disp(' ')
    disp('DISPLAYANIMATION ERROR!:  !!! ----- DISPLAYANIMATION MADE A BUG DURING STATS COMPUTATIONS ----- !!!')
    disp('The function will try to continue but it''s behavior is now unpredictable.')
    disp('Please copy/paste the following MATLAB error message and send it to ben.jacob@uclouvain.be:')
    disp(' ')
    disp(lasterr)
    disp(' ')
    
end


% EXPORT STATS
% pd -> s.PERDISPLAY
try s.PERDISPLAY = pd; end

% Export s
stats = s; % <v2-beta17>
GLAB_FUNCTIONS.displayanimation = s; % -> global var.
assignin('base','stats',s);            % -> workspace
assignin('caller','stats',s);          % -> workspace
disp('DISPLAYANIMATION-info: Stats about the animation have been exported to your workspace.')
disp('                       You can now find it in the "stats" structure:')
disp(' ')
disp(s)


% ERROR MESSAGES   
% <v2-beta12b: Moved from SinStim 1.6.2>
% <v2-beta15:  Moved to glabhelper_checkerrors>

thresh = 5; % <TODO: hard coded -> global var?>
glabhelper_checkerrors(mfilename,'missedframes',FramesMissed,nDisplayed,thresh,isIsochronous);


% Save Log  <v2-beta14>
if isfullscreen
    logfile = fullfile(glablog,[mfilename datesuffix]);
    v = version;
    if v >= '7', save(logfile,'-v6');
    else         save(logfile);
    end
end


% Output Arg.
varargout = {};
if Get
    varargout{end+1} = GetValues;
    varargout{end+1} = GetTimes;
end
if Send
    varargout{end+1} = SendTimes;
end


% Done.
dispinfo(mfilename,'info','Done.')
disp(' ')