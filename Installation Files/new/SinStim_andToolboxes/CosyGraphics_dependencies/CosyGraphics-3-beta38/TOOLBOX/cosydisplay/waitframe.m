function [t,err,times] = waitframe(F);
% WAITFRAME   Wait for frame update(s). {fast}
%    t = WAITFRAME  waits until next screen refresh onset and returns time.
%    
%    t = WAITFRAME(N)  waits for N frame updates.
%
%    [t,err] = WAITFRAME(...)  returns error status. "err" is an estimation 
%    of the number of missed frames. Note that the computation of err is not 
%    100pc reliable.
%
% See also : WAITSYNCH, WAITUNTIL, WAIT.
%
% Note: There is a also WAITFRAME function in Cogent2000: Dont use it! 
%       It's critically bugged!
%
% Ben, Nov. 2008. 

global COSY_GENERAL COSY_TRIALLOG COSY_DISPLAY

%% Init vars
t0 = time;

if ~nargin, F = 1; end

t = -1;
err = -1;
times = -1;

% Check Abort
if isptbinstalled
    if checkkeydown('Escape');
        COSY_GENERAL.isAborted = true;
        dispinfo(mfilename,'warning','Abortion key (Esc) has been pressed by the user. Aborting...')
        return %                       <===!!!
    end
end

%% Main
if iscog || (isfield(COSY_TRIALLOG,'isStarted') && COSY_TRIALLOG.isStarted) % Cogent: always, PTB: only if trial started.
    % First case: We'll wait frame by frame, either because we are on Cogent and we have no
    % C-implemented alternative, or because we are on PTB during a trial and we have to manage 
    % per frame events at each frame onset.
    
    OneFrame = getframedur;
    
    err = 0;
    times = NaN + zeros(1,F);
    f0 = 0; % number of already displayed frames.
    t_old = t0;
    
    while f0 < F
        f = f0 + 1;    
        
        % Wait 1 screen refresh
        if iscog
            t = cgflip('v') * 1000; %(ms)
            if t == -2, error('cgflip error: Probably no Cogent display open.'), end
        else
            if COSY_DISPLAY.UseDirectXWorkaround4PTB  % If opendisplays has detected an issue with Screen('WaitBlanking')..
                WaitVerticalBlank wait; % ..use Andre Conte's DirectX workaround.
            else  % Regular case..
                wait(1); % <v2-beta41: fix WaitBlanking. Same than in opendisplay. <Was used befor in v2-beta23 in windowed mode only.>>
                Screen('WaitBlanking',gcw);
            end
            t = time;
        end
        
        % Frame onset: Send/Get events
        helper_perframeevents;
        
        % Check how many frames we have waited:
        dt = t - t_old;
        df = dt / OneFrame;
        if f == 1 && dt > OneFrame+2 % First frame: We assume we missed a frame if  
            % dt exceeds normal refresh interval by more than 2ms.
            howmany = ceil((dt-2) / OneFrame);
        elseif f > 1 && df > 1.5 % Next frames: We assume we missed a frame if
            % dt > 150% of normal. <todo: Still a bug opportunity if false + error 
            % on first frame, due to delay in time measure returned by cgflip.>
            howmany = round(df);
        else % Regular case
            howmany = 1;
        end
        % Update f0  <todo?: redo that? make a fun which compute ms2frame?>
        f0 = f0 + howmany;
        if f0 > F, err = f0 - F; end
        % Store t
        times(min([f,F])) = t;
        t_old = t;
        % Wait
        % <todo: add non-buzzy wait here.>
    end
    
else     % PTB, when trial not started..
    % Second case: We are on PTB, we are not during a trial and we can simply use
    % the Screen('WaitBlanking') function.
    
    % Check Abort
    if checkkeydown('Escape');
        COSY_GENERAL.isAborted = true;
        return %                  <===!!!
    end
    
    % Wait
    wait(1); % <v2-beta23: fix windowed mode> 
    Screen('WaitBlanking',gcw,F);

    % Error check
    t = time;
    if t-2 - t0 > F * getframedur, % we accept a 2ms timing error
        err = ceil(t-2 - t0) - F;
    else
        err = 0;
    end
    
end