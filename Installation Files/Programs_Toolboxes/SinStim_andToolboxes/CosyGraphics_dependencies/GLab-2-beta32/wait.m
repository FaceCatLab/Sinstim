function wait(ms)
% WAIT  Wait for a specified duration.
%    WAIT(t)  waits t milliseconds. Note that this wait is not synchronized
%    with the screen refresh cycle. See WAITSYNCH for that.
%
%    Programmer note: Over PTB the function avoids system overload, 
%    but over Cogent, it's a buzzy wait. <TODO: Use always PTB ???>
%
% See also : WAITSYNCH, WAITFRAME, WAITUNTIL, TIME.
%
% G-Lab function.

% Ben, 	1.0.1	Oct. 2007   Same as Cogent 2000 function, just changed documentation.
% 		2.0		May  2008   Use PsychToolbox WaitSecs function which avoid buzzy wait.
%               Sep.        Revert to 1.0.1

if isopen('glab') && iscog  % CG
    % Cogent: No C function, let's do a busy wait.
    t = time + ms;
    while( time < t )
    end
else                        % PTB
    % PTB: WaitSecs does not a busy wait: that's why we use it as default.
    WaitSecs(ms / 1000);
end
