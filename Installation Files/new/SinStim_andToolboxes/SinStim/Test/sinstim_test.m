% SinStim_*   Parameter file for SinStim 1.4.
% New parameters (above version 1.0) are marked with a <v1.x> tag.
%
% New params v1.2:
%   - ByPart.VariesAfter
%   - Gen.Events.FirstIdentityChange
% New params v1.3:
%   - Gen.Priority
%   - Gen.Scale

Gen.Priority = 'HIGH';
Gen.Duration = 70; % (sec) Duration of stimulation. 

% Display:
Gen.Screen = 1; % 1: Full screen display, 2: Display on secondary screen, 0: Display in a window. 
Gen.Resolution = [800 600]; % Display [width heigth] in pixels.
Gen.ScreenTheoreticalFreq = 100; % Screen frequency set in MS-Windows (Hz). (Must be 85 on EEG experimental setup.)
Gen.NumFramesToTestFreq = 800; % Set 4000 or 5000 for EEG experiment (!!!)

% Gamma:
Gen.ScreenGamma = 1.0; % Screen gamma value. Must be measured for each screen.
Gen.ApparentGammaCorrection = 1.0; % Value between 1 and ScreenGamma. Visual effect only. No impact on computations.

% Missed Screen Refreshes:
Gen.isIsochronousMode = 1; % 1: Correct missed frames (by skipping the next one), 0: Don't.
Gen.MissedFramesTolerance = 4; % Number of missed frames to trigger a warning message.

% Image Files:
% You'll be asked to browse for the image directory at running time. To change your image set, 
% simply create a new directory and copy to it the needed image files. Image categories ("Parts")
% is determined by a file name prefix, defined by the parameter below:
ByPart.PartNames = {'top','bot'}; % Names of the image parts and prefix to the image file names.
%                                   E.g.: 'top' and 'bot'. All "top*.bmp" and "bot*.bmp" files will be loaded.

% Image Processing: 1) Background:
Gen.Background.isBackground = 1; % 1: Images have a background, which must be automatically detected. 0: No background.
Gen.Background.OriginalColor = [1 1 1]; % [r g b] Background in the BMP files. DON'T USE GRAY BACKGROUNDS !!!
Gen.Background.FinalColor = [.5 .5 .5]; % [r g b] Original background will be replaced by this.
ByPart.Background.ColorError = 1/255; % Error tolerance to automatically find background pixels.
ByPart.Background.ErodeBorder = 4; % Number of pixels of foreground to remove at the border. 
ByPart.Background.FillHoles = 1; % <TODO>
ByPart.Background.doEqualize = 0; % 1: Equalize backgrounds (keep common area). 0: Don't.
ByPart.Background.doMakeItTransparent = 1; % 1: Final bg of images is transparent. 0: bg is opaque (of final color).

% Image Processing: 2) Other:
ByPart.doConvertToGrayscale = 0; % 1: Convert from color to grayscale. 0: Don't.
ByPart.doEqualizeSize = 1; % 1: Equalize size of matrices. Use this to avoid bugs. 0: Don't. Not tested.
ByPart.doEqualizeHue = 0; % <TODO> 1: Equalize the hue of all images (for color images). 0: Don't.
ByPart.doEqualizeLuminance = 1; % 1: Equalize the luminance of all images. 0: Don't.
ByPart.doScramblePixels = 0; % 1: Scramble foreground pixels in the images. 0: Don't.

% Position and Scale:
ByPart.X = 0;  % X co-ord. (in pixels). 0 = center of the screen;
ByPart.Y = {5,-5}; % Y co-ord. (in pixels). 0 = center of the screen;
ByPart.HorizontalAlignement = 'C'; % 'L' (Left), 'C' (Center), 'R' (Right).
ByPart.VerticalAlignement = {'B','T'}; % 'T' (Top), 'C' (Center), 'B' (Bottom).
ByPart.AxesRotation = 19; % 0: Normal orientation. % 180: Upside down.
Gen.Scale = [.9 1.0 1.1]; % Image scales. 1=100pc  <v1.3>

% Fix Point:
% (If you don't want a fix point, set: Gen.FixPoint.Size = 0;)
Gen.FixPoint.Size = 12; %(pixels)
Gen.FixPoint.Shape = 'round'; % 'cross', 'round' or 'square'.
Gen.FixPoint.Color = [246 150 72] / 255; % Normal color. 
Gen.FixPoint.LineWidth = 0; % Line thickness. Set to 0 to get plain square/round.
Gen.FixPoint.Y = 60; % Y offset (pixels).
% Fix Point Changes:
Gen.FixPoint.NumChanges = 2; % Number of color changes in one run.
Gen.FixPoint.WhatChanges = 'C'; % 'C' (color) or 'S' (shape). <v1.1>
Gen.FixPoint.ChangedShape = 'round';  % 2d shape for shape changes.  <v1.1>
Gen.FixPoint.ChangedColor = [250 249 106] / 255; % 2d color for color changes.
Gen.FixPoint.ColorChangeDur = 120; %(ms) Duration of change (for both color and shape changes).

% EVENTS
% Parallel port ents to send:
% In case of co-incidence, event # will be added. (==> Choose carefully the numbers with that in mind.)
ByPart.Events.SineMax = {1, 4}; % # to send at each sine wave max. 0: Send nothing.
ByPart.Events.SineMin = {1000, 2000}; % # to send at each sine wave min. 0: Send nothing.
Gen.Events.Start  = 255; % Display start.
Gen.Events.TenSec = 100; % 10 sec after start.
Gen.Events.FirstIdentityChange = 99; % if ByPart.VariesAfter > 0, see below. <v1.2>
Gen.Events.Stop   = 255; % Display end.

% Keyboard events to get:
Gen.ResponseKey = 'Space'; % Name of the key that subject has to press for response.  <v1.1>
%                            Type "getkeyname ?" to get all valid key names.

% Photodiode <v1.5>
Gen.isPhotodiode = 1; % 1: Display a black/white square on the upper-left corner for photodiode. 0: don't. <v1.5>
Gen.PhotodiodeSquareSize = 50; % Size in pixels of the photodiode square. <v1.5>
% Gen.PhotodiodeLocation = [1 1; 0 0];

% EXPERIMENT
% Durations:
Gen.DelayBefore = 1; % (sec) # secs before stim. begin. Use "rand" (e.g.: 5 + 10*rand;) to get random delay. <v1.1>
% Gen.Duration = 2; % (sec) Duration of stimulation. <moved above>
Gen.DelayAfter = 1; % (sec) <v1.1>

% Conditions (!!!)
% What varies in the experiment?
ByPart.WhatVaries = 'N'; %'I': Image, Interlaced mode: one change per half-phase (with overlap).
%                         'N': image, Non-interlaced mode: one change per phase (no overlap).
%                         'L': Luminance.
%                         'T': Transparency.
%                         '-': Nothing.

ByPart.VariesAfter = 0; % (sec) 'N' condition only: Delay before identity begins to change. <v1.2>

% Sine Waves:
ByPart.WaveForm = {'sine','sine'}; % 'square', 'sine'.
ByPart.WaveFreq = {2.5, 1.5}; % Sinusoid freq. (Hz). NB: 4 Hz sinusoid = 8 identities per sec!
ByPart.isHarmonic = 0; % 1: Round to closest screen frequency divisor. 0: Don't.
ByPart.BetweenRepeat = 1; % For randomization: minimum number of elements (images) between repetition of an image.

% Sine range:
ByPart.AlphaRange = [0 1]; % [min,max] values between 0 and 1.

% Save data
Gen.SaveDir = 'd:\Exp_EEG_Matlab';
