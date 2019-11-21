function t = time(t0)
% TIME  Return current time in milliseconds.
%    t = TIME  returns time in milliseconds since CosyGraphics 
%    startup or since last call to TIME(0).
%
% Deprecated: 
%    TIME(0)  resets timer.  Cogent only; not supported on PTB. Don't use that, it's a source of 
%    trouble. Only kept for backward compatibility.
%
% See also : STARTCOGENT, WAIT, WAITSYNCH.
%
% CosyGraphics function.

% Ben,	Oct 2007  	Change documentation.
%		Apr 2008	time(0)
%					Suppress rounding (no effect: already rouded in cogstd).

global COSY_DISPLAY

if ~nargin  %    t = TIME
    if iscog % CG
        t = cogstd('sGetTime',-1) * 1000;
    else     % PTB
        t = GetSecs * 1000;
    end
    
else        %    TIME(0)
    if iscog % CG
        if isopen('Display')
            if isfilledfield(COSY_DISPLAY,'CurrentDisplayDuration')
                stopcosy;
                dur = num2str(COSY_DISPLAY.CurrentDisplayDuration);
                msg = ['Cannot reset timer now.' 10 ...
                    'displaybuffer has been called with a duration argument of ' dur ' ms' 10 ...
                    'and CosyGraphics is still waiting the next displaybuffer call.' 10 ...
                    'Probably your code is missing a  displaybuffer(0) call.' ];
                error(msg);
            end
        end
        cogstd('sGetTime',t0 / 1000);
    else     % PTB
        dispinfo(mfilename,'warning','Timer reset is not supported on PTB.')
        warning('Timer reset is not supported on PTB.')
    end
    
end