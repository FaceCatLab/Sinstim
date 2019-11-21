function [SineWave,Peaks,Phases,Slopes,SineFreq] = sinewave(Duration,SineFreq,SampleFreq,varargin)
% SINEWAVE   Generate sinusoidal signal.
%    SineWave = SINEWAVE(Duration,Freq,SampleFreq)  units: sec, Hz, Hz. Freq can be a scalar (constant
%    frequency) or a vector (variable frequency)
%
%    SineWave = SINEWAVE(Duration,Freq,SampleFreq,Range)
%
%    SineWave = SINEWAVE(Duration,Freq,SampleFreq,Range,isHarmonic)
%
%    SineWave = SINEWAVE(Duration,Freq,SampleFreq,Range,isHarmonic,StartAngle)  specifies the sin wave's
%    starting angle (in radians): 3*pi/2 = minimum (default), pi/2 = maximum, 0 = standard sine wave.
%
%    SINEWAVE(...,'Plot')  plots results.
%
%    [SineWave,Peaks] = SINEWAVE(...)  returns an Peaks vector of 0, with
%    +1 at the places of maximums and -1 at the places of minimums. The signal 
%    begins by a minimum, so the -1 can serve of phase delimiters.
%
%    [SineWave,Peaks,Phases] = SINEWAVE(...)  returns phase number of each
%    element in vector Phases.
%
%    [SineWave,Peaks,Phases,Slopes] = SINEWAVE(...)  returns the 'Slope' 
%    vector, containing +1 in the ascending part of the phase and -1 in the
%    descending part.
%
%    [SineWave,Peaks,Phases,Slopes,SineFreq] = SINEWAVE(...)  returns final
%    sine frequency (which can have been modified if isHarmonic was set to 1).

persistent hFigure

% Input Args
if nargin > 3 && ischar(varargin{end}) && strcmpi(varargin{end},'Plot')
    isPlot = 1;
    varargin(end) = [];
else
    isPlot = 0;
end
try     Range = sort(varargin{1});
catch   Range = [0 1];                    
end
try     isHarmonic = varargin{2};
catch   isHarmonic = 0;
end
try     StartAngle = fitrange(varargin{3},[0 2*pi],'cyclic');
catch   StartAngle = 1.5*pi; % so we begin by a minimimum.            
end
if isHarmonic ~= 0 && isHarmonic ~= 1
    error('Invalid value for "isHarmonic" argument. isHarmonic must be 0 or 1.')
end

% Frequencies Ratio
FreqRatio = SampleFreq ./ SineFreq; % <11/1/11: "/" -> "./">
if isHarmonic
    FreqRatio = round(FreqRatio);
    SineFreq = SampleFreq / FreqRatio;
end

% Sine Wave
if length(FreqRatio) == 1 % Normal case : Constant freq
    x = 0 : round(SampleFreq * Duration) - 1; % <Fix 4/11/09: round>
    angles = StartAngle + 2*pi * x / FreqRatio;
%     SineWave = sin( StartAngle + 2*pi * x ./ FreqRatio ); % <11/1/11: "/" -> "./">
else % Variable freq  <11/1/11>
    if exist('isopen','file') && isopen('glab')
        feature accel on  % <Optim: The following FOR loop is 40x faster with JIT acceleration>
    end
    angles = zeros(size(FreqRatio));
    angles(1) = StartAngle;
    for i = 2 : length(angles)
        angles(i) = angles(i-1) + 2*pi / FreqRatio(i);
    end
    if exist('isopen','file') && isopen('glab')
        feature accel off  % <JIT accel must be disabled during real-time operations>
    end
end
SineWave = sin(angles);

% Peaks: Max= +1, Min= -1.
if nargout >= 2
    Peaks = -diff(sign(diff(SineWave))) / 2;
    if     StartAngle == 1.5*pi,    Peaks = [-1 Peaks 0];
    elseif StartAngle == 0.5*pi,    Peaks = [+1 Peaks 0];
    else                            Peaks = [ 0 Peaks 0];
    end
    Peaks(Peaks > 0) = +1; % <Fix 30 Jul 2009>
    Peaks(Peaks < 0) = -1; % <Fix 30 Jul 2009>
    for p = find(Peaks)
        if p > 1 && Peaks(p-1) == Peaks(p)
            Peaks(p) = 0;  % <Fix 04/11/09>
        end
    end
end

% Fit Range
SineWave = 0.5 + SineWave / 2; % -1:1 -> 0:1
SineWave = Range(1) + SineWave * (Range(2) - Range(1)); % 0:1 -> Range

% Phases: Phase #, for each sample.
if nargout >= 3
    Phases = zeros(size(SineWave));
    i0 = find(Peaks == -1);
    for p = 1 : length(i0)-1
        Phases(i0(p):i0(p+1)-1) = p;
    end
    Phases(i0(end):end) = length(i0);
    if min(Phases) == 0, Phases = Phases + 1; end  % <Fix. 09-jun-2011>
end

% Slopes: Ascending= +1, Descending= -1.
if nargout >= 4
    % 1) Create vector of +1s:
    Slopes = ones(size(SineWave));
    % 2) From "hi" peaks (max) +1 to "lo" peaks (min): put -1s.
    hi = find(Peaks == +1);
    lo = find(Peaks == -1);
    if lo(1) == 1,          lo(1) = [];
    elseif lo(1) < hi(1),   hi = [0 hi];
    end
    if hi(end) == length(SineWave), hi(end) = []; end
    if length(hi) > length(lo), lo(end+1) = length(SineWave) + 1; end
    for i = 1 : length(hi)
        Slopes(hi(i):lo(i)-1) = -1; % <Fix 4/11/09: Fix properly bug of 15-dec-08 (one element shift)>
    end
end
% Slopes(1) = []; % <Fix. 15-dec-08> <Was a hack: Suppr. 04/11/09>

% Plot
if isPlot
    try     figure(hFigure);
    catch   hFigure = figure;
    end
    hold off
    h(1) = plot(SineWave,'b');
    hold on
    h(2) = plot(Peaks,'g');
    h(3) = plot(fitrange(Phases,Range,'rescale'),'color',[.8 0 .2]);
    h(4) = plot(Slopes,'color',[.75 .4 1]);
    set(h,'marker','o')
    legend(h,'SineWave','Peaks','Phases','Slopes')
end