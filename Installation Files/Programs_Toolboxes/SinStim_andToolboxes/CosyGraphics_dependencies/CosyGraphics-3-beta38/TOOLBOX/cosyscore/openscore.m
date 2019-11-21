function openscore(arg)
% OPENSCORE  Reset subject's current score to zero.
%    OPENSCORE  at first call {slow} initializes subject's score display and sets current score to 0   
%    points (must be called before to call any other score function, except get-/setscoreparams) ; 
%    at later calls {fast}, resets score to 0 points.
%
%    OPENSCORE DEFAULTS  resets also all parameter to default.
%    Programmer note: This is called by SETSCOREPROPERTIES DEFAULTS.
%
% Example: <TODO>
%    %% Init
%    openscore;


global COSY_SCORE % <Modular var: accessed only by module's functions (!!)>


%% Input Args
if nargin
    if strcmpi(arg,'default') || strcmpi(arg,'defaults'), doInit = true;
    else error('Invalid argument.')
    end
elseif isfilledfield(COSY_SCORE,'isInitialized') && COSY_SCORE.isInitialized
    doInit = false;
else
    doInit = true;
end


%% Set score to zero
if doInit, COSY_SCORE.isInitialized = true; end
COSY_SCORE.LastIncrement = 0;
COSY_SCORE.CurrentTotal = 0;


%% First call: Init Score Props
if doInit
    dispinfo(mfilename,'info','Setting score-display parameters to defaults.')

    % 1.1) LAST INCREMENT:
    %      Last gain, usually displayed after each trial
    p.Type = 'increment';

    p.DisplayDuration = 2000; %(ms)

    p.EnableDIGIT___ = true;
    p.DigitSize = 72;
    p.DigitX = 0;
    p.DigitY = 0;
    p.DigitColorSuccess = [0 .7 0];
    p.DigitColorFailure = [.8 .05 .05];
    p.DigitColorNeutral = [0 .5 .8];
    p.DigitFont = 'Arial';
    p.DigitPositiveWithPlus = true;
    p.DigitPrependString = '';
    p.DigitAppendString  = '';
    p.DigitBlinkPeriod = 500; %(ms) 1 period = 1 on + 1 off. 0 means no blink.
    p.DigitBlinkNumber = 4;   % number of blinks

    p.EnableBAR___ = false;
    p.BarHeight = 36;
    p.BarWidth  = getscreenres(1)/2;
    p.BarX = 0;
    p.BarY = 0;
    p.BarMaxValue = 100; % (arbitrary)
    p.BarColorSuccess = [.2 .5 .2];
    p.BarColorFailure = [.7 .1 .1];
    p.BarColorNeutral = [.4 .4 .5]; % grey, slightly cyan to be visible on a gray bg
    p.BarColorFrame   = .7*[1 1 1];

    % Sound: <NB: must be in the increment/total structure because succes.failure is linked to a score object>
    p.EnableSOUND___ = true;
    p.SoundVolume = .5;
    p.SoundFileSuccess = fullfile(cosydir,'cosyscore/sounds/Success-short/default.wav');
    p.SoundFileFailure = fullfile(cosydir,'cosyscore/sounds/Failure-short/default.wav');
    p.SoundFileNeutral = '';

    COSY_SCORE.INCREMENT = p;

    % 1.2) CURRENT TOTAL:
    %      Current total score, displayed usually after each trial (in parallel with the increment)
    old_p = p;

    p.Type = 'total';

    p.DigitBlinkNumber = 0; % total doesn't blink

    p.EnableDIGIT___ = true;
    p.DigitSize = 36;
    p.DigitY = -round(getscreenres(2)/5);

    p.EnableBAR___ = true;
    p.BarY = -round(getscreenres(2)/5);
    p.DigitPositiveWithPlus = false;
    p.DigitPrependString = 'total: ';
    
    p.EnableSOUND___ = false;
    p.SoundFileSuccess = '';
    p.SoundFileFailure = '';
    p.SoundFileNeutral = '';

    COSY_SCORE.CURRENTTOTAL = p;

    try [old_p p]; catch error('Inconsistent fields!'), end % <debug test!>

    % 2) FINAL TOTAL:
    %    Final score, displayed usually at the end of the experiment
    old_p = p;

    p.Type = 'total';
    p.DisplayDuration = 3000; %(ms)

    p.DigitSize = 72;
    p.DigitY = 0;
    p.DigitPositiveWithPlus = false;
    p.DigitPrependString = '';
    
    p.EnableSOUND___ = true;
    p.SoundFileSuccess = fullfile(cosydir,'cosyscore/sounds/Success-long/default.wav');
    p.SoundFileFailure = fullfile(cosydir,'cosyscore/sounds/Failure-long/default.wav');

    COSY_SCORE.FINALTOTAL = p;

    try [old_p p]; catch error('Inconsistent fields!'), end % <debug test!>

end

% ************************** code form reward 3.2.1 **************************
% %DISP CURRENT SCORE:
%     drawtext(str,0,[0 0],'Arial',35,rgb);
%     drawtext(num2str(TotalPoints),0,[0 -100],'Arial',25,[1 .9 0]);
%     if isProgressionBar
%         draw_progression_bar(j,nTrials);
%     end
%
% % DISPLAY FINAL SCORE
% clearbuffer;
% displaybuffer;
% if ~isabort
% %     [y,fs] = wavread([RootFolder 'cash-register-02.wav']);
% %     sound(y,fs);
%     for i = 1:10
%         clearbuffer;
%         drawtext([num2str(TotalPoints) ' !'],0,[0 0],'Arial',72,[1 .9 0]);
%         displaybuffer;
%         wait(150)
%         clearbuffer;
%         displaybuffer;
%         wait(150)
%     end
%     wait(500)
% end


