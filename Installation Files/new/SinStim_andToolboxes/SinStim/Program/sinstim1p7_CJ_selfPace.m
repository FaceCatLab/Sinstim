function [beforeDA,afterDA]=sinstim(ParamFile,ImageDir,SaveDir,SubjectNameArg)
% SinStim   Sinusoidal stimuli -- EEG Experimental Program.
%    SINSTIM   runs the program in standard mode.
%
%    SINSTIM TEST  runs the program in test mode. Uses params and images in \SinStim\Program\Test\
%    and saves data in \SinStim\Save\Test\.
%
%    SINSTIM SAME  re-runs the program with same params & images.
%
%    SINSTIM(ParamFile,ImageDir,SaveDir,<SubjectName>)  runs the program in batch mode (no GUI).
%
%       Example:
%          % Define paths, using SINSTIMROOT fuction to get SinStim's root directory (multi-platform!):
%          ParamFile = fullfile(sinstimroot,'Program','Examples','sinstim_Example_1part_v1p6p4.m'); % don't forget '.m' !
%          ImageDir  = fullfile(sinstimroot,'Program','Examples','Images-1part','');
%          SaveDir   = fullfile(sinstimroot,'Save','');
%          SubjectName = 'nobody';
%          % Run SinStim:
%          sinstim(ParamFile,ImageDir,SaveDir,SubjectName);
%
% The program will load a parameter file which must have a name of the form "SinStim_*.m".
% The example files are "SinStim_Example_Visage.m" and "SinStim_Example_TopBot.m"
%
% Needs PsychToolbox 3, BenTools and Graphics Lab 2 (see version below).
%
%
%  Version  Date            GLab Version    Comments
%   1.0     17 Dec 2008.    2-beta2         First Exp 18 Dec.
%   1.1     19 Feb 2009.    2-beta5         Keyboard events + Other modifs. + Fixes.
%   1.2     16 May 2009.    2-beta5         Delay before identity varies.
%   1.3     24 Jul 2009.    2-beta6         Variable image size. Choose priority level.
%   1.3.1   30 Jul                          Quick fix "missing event 1" bug. (l.414, 418) sinewave.m will be fixed later.
%   1.4     13 Oct          2-beta8         Close display if programs crashes.
%                                           Isochronous mode: correct missed frames.
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
%   1.7     28 sep          2-beta28       §Stable on MATLAB 7.6 / MAC OS X.
%                        bentools 0.10.9!   Only significative modif: Change way to load file: uses bentools' new "readtxt" instead
%                                           of Matlab's "load" function, which is bugged in ML 7.6 when reading ML 6.5 files.
%                                          §Fix: Add ParamDir to MATLAB path.
%                                          §Added utilities: setupsinstim, sinstimroot, cdsinstim. + Add doc for batch mode.
%                                           <TODO: Fix Matlab version pb when saving data !!!>
%                                           <TODO: Support transparency in image files (*.png, *.gif, etc).>
%
%   Benvenuto (Ben) JACOB, Institute of NeuroSiences, Universite Catholique de Louvain. Dec 2008.


%% Version
SinStimVersion = '1.7';
GLabVersion = '2-beta28';
SinStimColors = [.45 .80 .55; .10 .25 .10] * .75; % [bg, fg]


%% GLOBAL VARS
 glabglobal
persistent SubjectName

%% start fixation cross (blank) presented for a "blankDuration" duration.
% During this time, do all the preprocessing for displayanimation.
% % % % % % flagInitSinStim = 1;

% 1. %draw uniform screen with fixation cross
x0 = GLAB_DISPLAY.Resolution(1)/2;
y0 = GLAB_DISPLAY.Resolution(2)/2;


str='Stimuli for next block are being loaded \n\n\n Please wait...';
DrawFormattedText(GLAB_DISPLAY.windowPtr4PTB,str, 'center','center',[200 200 200]);
% % % % % % Screen('FillRect',GLAB_DISPLAY.windowPtr4PTB,GLAB_DISPLAY.BackgroundColor*255);
% % % % % % drawfixation(GLAB_DISPLAY.windowPtr4PTB,[x0 y0],8,[0 0 0],1,'cross'); % to try: alpha blending on fixation point
Screen('Flip',GLAB_DISPLAY.windowPtr4PTB);
%Compare current experiment time with expected time and subtract the
%difference from the duration of blank.
startBlankTime = GetSecs;
GLAB_DISPLAY.actualBlankStartTime(GLAB_DISPLAY.currentBlock) = startBlankTime - GLAB_DISPLAY.startExpTime;
% % % % % % sub2BlankDuration = (Getsecs - GLAB_DISPLAY.startExpTime) - GLAB_DISPLAY.blankStartTime(GLAB_DISPLAY.currentBlock);
% % % % % % GLAB_DISPLAY.sub2BlankDuration(GLAB_DISPLAY.currentBlock) = sub2BlankDuration;
% % % % % % correctedBlankDuration=startBlankTime +  GLAB_DISPLAY.blankDuration - sub2BlankDuration;
% % % % % % GLAB_DISPLAY.correctedBlankDuration(GLAB_DISPLAY.currentBlock) = correctedBlankDuration-startBlankTime;
% % % % % % disp([sub2BlankDuration correctedBlankDuration-startBlankTime]);
% % % % % % while Getsecs <= correctedBlankDuration;
% % % % % %     if flagInitSinStim;
% % % % % %         flagInitSinStim = 0;

        %SinStim pre-processing untill the next "end"
        
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


        %% INIT
        % Print SinStim version
        disp(['Starting SinStim, version ' SinStimVersion ' ...'])

        % Stop G-Lab if running. (To avoid to get it masking the gui.)
        %stopglab; % commented - CJ

        % Ensure we have the right vervion of GLab <v1.6.3>
        od = pwd;
        % CJ: next part commented
        % % if ~isTest,   setupglab(GLabVersion);
        % % else          warning('Test mode. Setup GLab disabled!');
        % % end
        % % cd(od);

        % Init Matlab's pseudo-random number generator
        Seed = sum(100*clock);
        rand('state',Seed);


        %% FILES & DIRECTORIES

        % SinStim's root directory
        fullname = mfilename('fullpath');
        f = find(fullname == filesep);
        SinStimRoot = fullname(1:f(end-1)); % <v1.5: end -> end-1 (now in \Program)> <v1.6.2: def_dir -> SinStimRoot>

        % Variable file
        VarFile = [SinStimRoot fullfile('Program','sinstim_var.txt')]; % <v1.7: Replace: save/load('sinstim_var.mat')  by: writetxt/savetxt('sinstim_var.txt')>
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
        % addpath([SinStimRoot 'Program/']);
        % addpath([SinStimRoot 'Program/Examples/']);
        % addpath([SinStimRoot 'Program/Test/']);
        % savepath; - commented CJ

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
            if exist('SubjectNameArg','var'),
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

        % Backward compatibility SinStim v1.0 parameter files:
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
        if ~isfield(Gen,'Scale'), Gen.Scale = 1; end
        
        if ~isfield(Gen,'Priority'), Gen.Priority = 'OPTIMAL'; end
        % v1.5 Parameters:
        if ~isfield(Gen,'isIsochronousMode'), Gen.isIsochronousMode = 0; end
        if ~isfield(Gen.Events,'MissedFrame'), Gen.Events.MissedFrame = 200; end
        if ~isfield(ByPart,'RandPattern'), ByPart.RandPattern = 'a'; end
        if ~isfield(ByPart,'EventPattern'), ByPart.EventPattern = zeros(size(ByPart.RandPattern)); end
        if ~isfield(Gen,'isPhotodiode'), Gen.isPhotodiode = 0; end
        if ~isfield(Gen,'PhotodiodeSquareSize'), Gen.PhotodiodeSquareSize = 20; end
        % v1.6.1 Parameters:
        if ~isfield(Gen,'PhotodiodeLocation'), Gen.PhotodiodeLocation = [1 1; 0 0]; end % <v1.6.5: Fix "," -> ";" ; default 2 diodes>

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
        disp([mfilename ': Loading images from BMP files...']);       
            [I,Files] = loadimage(ImageDir);       
        
        % Separate Parts
        if nParts > 1
            for p = 1 : nParts
                part = ByPart.PartNames{p};
                ii = strncmpi(Files,part,length(part));
                if ~any(ii)
                    stopglab % <--!!!
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
        %     startpsych(Gen.Screen,Gen.Resolution,Gen.Background.FinalColor,... % <--!
        %         Gen.ScreenTheoreticalFreq,Gen.NumFramesToTestFreq); %CJ
        setpriority NORMAL
        if ispc, setlibrary('Keyboard','Cog'), end % 24/07/2009 Fix lib issue
        %         openparallelport;
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
                % ????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
                % Draw an image with variable (sinusoidal) alpha factor over another image.
                % - Back image:     an image,         global alpha = 1.
                % - Front image:    another image,    global alpha = var.
                Images(p).BuffersI = storeimage(Images(p).MatricesI);
                [B,A,Peaks,Phases] = preparesinanimation(Images(p).BuffersI,Images(p).BuffersI,Gen.Duration, ...
                    ByPart.WaveFreq{p},ByPart.AlphaRange{p},ByPart.isHarmonic{p},ByPart.RandPattern{p});

            elseif ByPart.WhatVaries{p} == 'N' % && nImages > 1 <??? todo: Check this!>
                % Exp. condition: Variable = Image (Identity). Non-Interlaced. (1 change per phase.)
                % ????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
                % Draw an image with variable (sinusoidal) alpha factor over another image.
                % - Back image:     none.
                % - Front image:    an image,    global alpha = var.
                Images(p).BuffersI = storeimage(Images(p).MatricesI);
                [B,A,Peaks,Phases] = preparesinanimation(NaN,Images(p).BuffersI,Gen.Duration, ...
                    ByPart.WaveFreq{p},ByPart.AlphaRange{p},ByPart.isHarmonic{p},ByPart.RandPattern{p});

            elseif ByPart.WhatVaries{p} == 'L'
                % Control condition: Variable = Luminance.
                % ????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
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
                [B,A,Peaks,Phases] = preparesinanimation(Images(p).BufferBG,Images(p).BufferI,Gen.Duration, ...
                    ByPart.WaveFreq{p},range,ByPart.isHarmonic{p},0);

            elseif ByPart.WhatVaries{p} == 'T'
                % Control condition: Variable = Transparency. <todo: ???>
                % ?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
                % Draw an image with variable alpha.
                % - Back image:  none.   -
                % - Front image: image,  global alpha = var.
                Images(p).BufferI = storeimage(Images(p).MatricesI(r));
                [B,A,Peaks,Phases] = preparesinanimation([],Images(p).BufferI,Gen.Duration, ...
                    ByPart.WaveFreq{p},ByPart.AlphaRange{p},ByPart.isHarmonic{p},0);

            elseif ByPart.WhatVaries{p} == 'S'
                % Control condition: Variable = Saturation.
                % ???????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
                % <todo(??)>

            elseif ByPart.WhatVaries{p} == 'C'
                % Control condition: Variable = Color.
                % ????????????????????????????????????????????????????????????????????????????????????????????????????????????
                % <todo(??)>

            else
                % Nothing varies
                % ??????????????????????????????????????????
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

        % <v1.3>  Change scale (Progr. note: Must be donne before "Delay before identity change")
        if length(Gen.Scale) == 1
            Scale = Gen.Scale;
        else
            Scale = zeros(1,nFrames);
            phases = [1, find(diff(PHASES(1,:))) + 1, nFrames+1];
            scales = randele(Gen.Scale,length(phases),1);
            
            for p = 1:length(phases)-1
                Scale(phases(p):phases(p+1)-1) = scales(p);
            end
            
            
        end

        % <v1.2>  Delay before identity change
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

        % Alpha: Squrea Wave <v1.5.1>
        for p = 1 : nParts
            if strcmpi(ByPart.WaveForm{p},'square')
                ALPHA(p*2-1:p*2,:) = round(ALPHA(p*2-1:p*2,:));
            end
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
        if ~isempty(Gen.Events.Start),    Bytes(1) = Gen.Events.Start; end
        if ~isempty(Gen.Events.Stop), Bytes(end+1) = Gen.Events.Stop;  end
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
            PhotodiodeLocation=Gen.PhotodiodeLocation;
            PhotodiodeLocation = PhotodiodeLocation';
            PhotodiodeLocation = PhotodiodeLocation(:)';
            PhotodiodeEvents(ii) = floor(Bytes(ii)/1000)* binvec2dec(PhotodiodeLocation);
        end
        GLAB_DISPLAY.photodiodeEvents=PhotodiodeEvents;
        Bytes(ii) = rem(Bytes(ii),1000);
        %     Bytes = fitrange(Bytes,[0 255]);


        %% BATCH/GUI MODE <v1.6.2>
        if nargin % Batch mode
            TimeOut = 250;
        else      % GUI mode
            TimeOut = inf;
        end


        %% EXPORT ALL VARIABLE IN BASE WORKSPACE (for debug purpose)
        var = who;
% for i = 1 : length(var), assignin('base',var{i},eval(var{i}));end %CJ


        %% EXPERIMENT!
%         disp(' ')
%         disp([mfilename ': Starting experiment...'])

         OldGamma = setgamma(Gen.ScreenGamma); %CJ
%     end
% % % % % % end
%-------------------------------------------------

DrawFormattedText(GLAB_DISPLAY.windowPtr4PTB,GLAB_DISPLAY.taskInstructions, 'center','center',[255 255 140]);

str=['\n\n\n press the " R " key  when you are ready to start the next block'];
sy=GLAB_DISPLAY.Resolution(2)/2 + 100; 
DrawFormattedText(GLAB_DISPLAY.windowPtr4PTB,str, 'center',sy,[255 255 255]);
% % % % % % Screen('FillRect',GLAB_DISPLAY.windowPtr4PTB,GLAB_DISPLAY.BackgroundColor*255);
% % % % % % drawfixation(GLAB_DISPLAY.windowPtr4PTB,[x0 y0],8,[0 0 0],1,'cross'); % to try: alpha blending on fixation point
Screen('Flip',GLAB_DISPLAY.windowPtr4PTB);
% [keyCode]=getKey(['*/'],GLAB_DISPLAY.inputDevice);
[keyCode]=getKey(['sa'],GLAB_DISPLAY.inputDevice);

%     if  strcmp(KbName(keyCode),'/') || strcmp(KbName(keyCode),'/?');
         if  strcmp(KbName(keyCode),'a') || strcmp(KbName(keyCode),'a');
                disp('script aborted by user!');
                GLAB_DISPLAY.quitflag=1;
                stopglab;
                return;
    end


% getKey('*',GLAB_DISPLAY.inputDevice);
Screen('FillRect',GLAB_DISPLAY.windowPtr4PTB,GLAB_DISPLAY.BackgroundColor*255);  %set background
Screen('Flip',GLAB_DISPLAY.windowPtr4PTB);
WaitSecs(1);

% send Initialization pulse to photodiode
flinitseq(GLAB_DISPLAY.windowPtr4PTB, GLAB_DISPLAY.trigRect);

beforeDA = GetSecs;
%-------------------------------------!!!--REAL-TIME--!!!-----------------------------------
[Times,FrameErr,KeyIDs,KeyPressTimes] = displayanimation(BUFFERS,X,XAlign,Y,YAlign,...
    'Alpha',ALPHA,...
    'AxesRotation',THETA,...
    'Scale',Scale,...
    'Draw',FixPointShape,0,Gen.FixPoint.Y,Gen.FixPoint.Size,FIXPOINTCOLOR,Gen.FixPoint.LineWidth,...
    'Send','parallel',Bytes,...
    'Send','photodiode',PhotodiodeEvents,... % <v1.5>
    'Get','keyboard',[1:16 18:256],... %<v1.5.3: quick hack to allow any key (avoid 17 to fix pb with Ctrl)>
    'Priority',Gen.Priority,... % <v1.3>
    'Isochronous',Gen.isIsochronousMode,... % <v1.4> <becomes a param in v1.5>
    'FrameErrorEvent','parallel',Gen.Events.MissedFrame);%,... % <v1.5> %CJ edit - comment
%     'Splash',['SinStim ' SinStimVersion]',SinStimColors(1,:),SinStimColors(2,:),TimeOut,Gen.DelayBefore*1000);  % <v1.1: add delay> 
      %last line CJ edit, commented
%-------------------------------------------------------------------------------------------
 afterDA = GetSecs;
TotalFrameErr = sum(FrameErr(~isnan(FrameErr))); % <v1.4> <v1.6.2: remove NaNs>

% wait(Gen.DelayAfter*1000); % <v1.1>


%% VARIABLES -> WORKSPACE
% disp([mfilename ': Exporting all variables to Workspace...'])
assignin('base','Times',Times);
assignin('base','FrameErr',FrameErr);
assignin('base','TotalFrameErr',TotalFrameErr);
assignin('base','KeyIDs',KeyIDs);
assignin('base','KeyPressTimes',KeyPressTimes);
% disp([mfilename ': All internal variables are now accessible in the Workspace.'])
%     who % <suppr in v1.6.2>

%% this next part is supposed to be commented !!
% %% CHECK ERRORS % <v1.1 fix: must be before stopglab.> <v1.6.2: Moved into displayanimation.>
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
% disp(' ')
% disp([mfilename ': Stopping G-Lab...'])
% disp('(Maybe PTB will issue some warnings just below. These can be false positives.')
% disp(' The reliable error count is the one printed above by DISPLAYANIMATION).')
 setgamma(OldGamma); 
%     stopglab - commented CJ

% catch %---------------------------------------------------------------------------------------------
%     % Stop GLab
%     stopglab
%     setgamma(1)
%     % Export all variable to workspace
%     var = who;
%     for i = 1 : length(var), assignin('base',var{i},eval(var{i})); end
%     % Error!
%     rethrow(lasterror)
%
% end


%% SAVE!
% disp(' ')
% disp([mfilename ': Saving data...'])
% Clear/convert variables to save memory:
clear I
clear Images
clear ans % Fix: 'ans' was a digilalio object.
% for p = 1 : length(Images) %CJ: commented
%     for i = 1 : length(Images(p).MatricesI)
%         Images(p).MatricesI{i} = uint8(Images(p).MatricesI{i} * 255); % Images: double -> int:
%     end
% end

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
    GLAB_DISPLAY.SinStinSaveFilename = SaveFile;
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
% if ~isTest
%     try
%          ssPlotKeyboard2
%     catch
%         warning(['Error in ssPlotKeyboard2: ' lasterr])
%     end
% end

% close all


%% DONE
disp(' ')
disp([mfilename ': Done.'])
disp(' ')


%% SUB-FUNCTIONS
% __________________________________________________________________________________
function s = subfun_fields2cells(s,nParts)
% subfun_fields2cells: transform fields of 'ByPart' structure into cell
%                      vectors, one cell per part.
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
function  d = datesuffix
%% DATESUFFIX  Generate a date suffix which can be appended to a file name.
d = datestr(now,'yyyy-mm-dd HH:MM:SS');
d(d==' ') = '-';
d(d==':') = 'hm';
d = ['_' d 's'];