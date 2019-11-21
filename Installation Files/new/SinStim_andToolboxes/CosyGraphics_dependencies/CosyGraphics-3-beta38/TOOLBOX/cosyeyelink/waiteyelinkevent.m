function Q = waiteyelinkevent(EventWaited, arg2, arg3)
% WAITEYELINKEVENT  Wait EyeLink online event.
%    Q = WAITEYELINKEVENT(EventWaited, TimeOut);  waits until event happens or until TimeOut expires,
%    rejects events already in queue before function call.  See GETEYELINKEVENTS about other arguments.
%
%    Q = WAITEYELINKEVENT(EventWaited, t0, TimeOut);  waits until event happens or until t0 + TimeOut,
%    rejects events before t0.
%
%    If you are interested by saccade events, see WAITEYELINKSACCADE.
%
% See also: GETEYELINKEVENTS, WAITEYELINKSACCADE.


%% Input Args
switch nargin 
    case 2    
        t0 = time;
        TimeOut = arg2;
    case 3
        t0 = arg2;
        TimeOut = arg3;
end

%% Var
Q = [];

%% tEnd
tEnd = t0 + TimeOut;
if tEnd < time
    msg = 'Negative wait time!';
    dispinfo(mfilename,'warning',msg);
    warning(msg)
end

%% Main Loop
gotIt = 0;

while ~gotIt && time < tEnd
    Q = geteyelinkevents(EventWaited);
    for i = 1 : length(Q)
        if Q(i).time > t0
            Q = Q(i);
            gotIt = 1;
            break %         <---BREAK-FOR---!!! 
        end
    end
    if ~gotIt, wait(1); end
end