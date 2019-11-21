function ms = helper_measureeyelinktimeoffset(n)
% HELPER_MEASUREEYELINKTIMEOFFSET  Measure delta between MatLab PC's clock and EyeLink PC's clock.
%    ms = HELPER_MEASUREEYELINKTIMEOFFSET is used by OPENEYELINK and STARTTRIAL to measure the delta-time 
%    between the two PC's clocks, the measure will then be available trough GETEYELINKTIMEOFFSET.  
%    Unit is msec, measure's precision is +/- 25 usec.  A drift of 1 msec/sec has been measured on Marcus'  
%    PCs => That's why the offset is re-measured before each trial.
%
%    ms = HELPER_MEASUREEYELINKTIMEOFFSET(N)  specifies the number of measures.

%% Programmer's note: <v3-beta27>
% Eyelink('TimeOffset') doesn't work. It returns a number which is probably the difference
% between something and something, but the big question is what. 
% => Everything is re-implemented in Matlab. <v3-beta27>

%% Interrogates both clocks several times
if ~nargin
    n = 20; % # measures
end
tM = 0;
tE = 0;
dEM = zeros(1,n); % asking time first to EyeLink, then to MatLab
dME = zeros(1,n); % asking time first to MatLab, then to EyeLink
for i = 1:n
    tE = Eyelink('TrackerTime'); % ask EyeLink first
    tM = GetSecs;
    dEM(i) = tM - tE;
    tM = GetSecs; % ask MatLab first
    tE = Eyelink('TrackerTime');
    dME(i) = tM - tE;
end
% round((dEM - dME) * 1e6) %<debug>

%% Comptute the median
% Median will be robust to OS's interruptions
mME = median(dME);
mEM = median(dEM);

%% Compute the mean between the two measures 
% Median difference between the two measures is 55 usec (ATHOS vs PLOTINUS, Marcus' human lab). 
% Let's take the mean between the two. (=> Hence the error of +/- 25 usec mentioned above.)
s = (mME + mEM) / 2;

%% sec -> msec
ms = s * 1000;

%% Output: Command line use: Print result
% Just to avoid that annoying scientific notation of Matlab...
if isempty(callername)
    fprintf('%.3f msec\n', ms);
    if ~nargout, clear ms; end
end
