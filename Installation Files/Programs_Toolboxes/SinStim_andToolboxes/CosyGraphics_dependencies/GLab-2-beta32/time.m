function t = time(t0)
% TIME  Return current time in milliseconds.
%    t = TIME  returns time in milliseconds since G-Lab 
%    startup or since last call to TIME(0).
%
% CG only:
%    TIME(0)  resets timer. Not supported on PTB.
%
% See also : STARTCOGENT, WAIT, WAITSYNCH.
%
% G-Lab function.

% Ben,	Oct 2007  	Change documentation.
%		Apr 2008	time(0)
%					Suppress rounding (no effect: already rouded in cogstd).

if ~nargin  %    t = TIME
    if iscog % CG
        t = cogstd('sGetTime',-1) * 1000;
    else     % PTB
        t = GetSecs * 1000;
    end
    
else        %    TIME(0)
    if iscog % CG
        cogstd('sGetTime',t0 / 1000);
    else     % PTB
        warning('Timer reset is not supported on PTB.')
    end
    
end