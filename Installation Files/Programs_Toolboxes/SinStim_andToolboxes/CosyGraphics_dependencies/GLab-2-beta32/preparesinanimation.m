function [BUFFERS,ALPHA,Peaks,Phases] = preparesinanimation(Buff1,Buff2,Dur,SineFreq,AlphaRange,isHarmonic,RandPattern,GapBetweenPatterns)
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
    sinewave(Dur, SineFreq, getscreenfreq, AlphaRange, isHarmonic, 3*pi/2);

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