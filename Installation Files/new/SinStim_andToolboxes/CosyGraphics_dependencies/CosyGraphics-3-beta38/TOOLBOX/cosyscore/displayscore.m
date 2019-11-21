function displayscore(p)
% DISPLAYSCORE  Display subject's score.
%    DISPLAYSCORE CURRENT  by default, displays both last points gained (last argument to ADDTOSCORE) 
%    and current total.  Intended to be called after each trial.
%
%    DISPLAYSCORE FINAL  displays subject's final score.  Intended to be called at the end of an 
%    experiment.
%
%    DISPLAYSCORE(P)  displays a customized score.  P is a structure containing score properties 
%    as returned by GETSCOREPROPERTIES (it can be an array: just concatenate individual structures). 
%
% Ben Jacob, Feb-Apr 2013.

global COSY_SCORE % <Modular var: accessed only by module's functions (!!)>

checkscoreopen;


%% Input Arg.
if nargin<1, disp('Usage:'); help(mfilename); error('Missing argument.'); end
switch lower(p)
    case 'current'
        p = [COSY_SCORE.INCREMENT COSY_SCORE.CURRENTTOTAL];
        if isabort, return, end %          <============== RETURN ==============!!!
    case 'final'
        p = COSY_SCORE.FINALTOTAL;
    otherwise
        if ~istruct(p)
            if isopen('fullscreen'), stopcosy; end
            error('Invalid argument.')
        end
end
    

%% Blink parameters
totalDisplayDuration = max([p.DisplayDuration]);

isBlink = false(1,length(p));
allblinks  = zeros(1,length(p));
allperiods = zeros(1,length(p));
for o = 1 : length(p)
   if p(o).EnableDIGIT___ && p(o).DigitBlinkNumber > 1 && isfinite(p(o).DigitBlinkPeriod) && p(o).DigitBlinkPeriod > 0
      isBlink(o) = 1;
      allblinks(o) = p(o).DigitBlinkNumber;
      allperiods(o) = p(o).DigitBlinkPeriod;
   else
      p(o).DigitBlinkNumber = 0; % ensure consistency.
   end
end

% Compute vars needed for main loop
if any(isBlink)
    nBlinks = max(allblinks(isBlink));

    if length(unique(allperiods(isBlink))) > 1
        if isopen('fullscreen'), stopcosy; end
        error('Inconsistent parameters. All blinking objects must have same blink period.')
    else
        f = find(allperiods(isBlink));
        period = allperiods(f(1));
        interval = period / 2;
    end

    remainingInterval = totalDisplayDuration - nBlinks*period;
    nIterations = nBlinks + (remainingInterval > 0);

else
    nBlinks = 0;
    nIterations = 1;
    remainingInterval = totalDisplayDuration;
    
end


%% Display Score
clearbuffer;
isPlayingSound = false;

for i = 1 : nIterations
    % No blink / Blink on..
    for o = 1 : length(p)
        switch lower(p(o).Type) % What value to display?..
            case 'increment', points = COSY_SCORE.LastIncrement;
            case 'total',     points = COSY_SCORE.CurrentTotal;
            case 'custom',    %<TODO> <NB: keep 'points' as an input arg of the subfuns to have the possibility to implement this.>
            otherwise error('Invalid field value !?!?!?')
        end
        
        if ~isPlayingSound && p(o).EnableSOUND___ % (NB: Play sound only once: Matlab's sound() waits end of playback if called twice)
            if     points > 0, file = p(o).SoundFileSuccess;
            elseif points < 0, file = p(o).SoundFileFailure;
            else               file = p(o).SoundFileNeutral;
            end
            sub_playsound(file);
            isPlayingSound = 1;
        end
      
        if p(o).EnableBAR___,   drawscorebar(points,p(o)); end
        if p(o).EnableDIGIT___, drawscoredigit(points,p(o)); end
        
    end
    if i <= nBlinks, displaybuffer(0,interval,'Score');
    else             displaybuffer(0,remainingInterval,'Score','Score');
    end

    % Blink off..
    if i <= nBlinks
        clearbuffer;
        for o = 1 : length(p)
            if p(o).EnableBAR___, drawscorebar(points,p(o)); end % bar never blinks.
            if ~(i <= p(o).DigitBlinkNumber) % don't draw in case of blink
                if p(o).EnableDIGIT___, drawscoredigit(COSY_SCORE.CurrentTotal,p(o)); end
            end
        end
        displaybuffer(0,interval,'(blinking)');%(0,interval);
    end
end

displaybuffer;

% workspaceexport  % <DEBUG>


%% Update Global Var (!)
% COSY_SCORE.LastIncrement = 0;


%% Sub-functions ==========================
function sub_playsound(filename)
if ~isempty(filename)
    if ~exist(filename,'file'), error(['File "' filename '" does not exist.']); end
    [y,fs] = wavread(filename);
    sound(y,fs); % <NB: tic/toc from <1ms to >200ms. (But we are not in real-time here)>
else % just do nothing.
end