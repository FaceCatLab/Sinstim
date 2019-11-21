function Errors = findmissedframes(MeasuredTimes,TheorIntervals,OneFrame)
% FINDMISSEDFRAMES   <not used>
%    Errors = FINDMISSEDFRAMES(MeasuredTimes)
%
%    Errors = FINDMISSEDFRAMES(MeasuredTimes,TheorIntervals,FrameDuration)


%% Input Args
if nargin == 1
    OneFrame = (MeasuredTimes(end) - MeasuredTimes(1)) / (length(MeasuredTimes) - 1);
    TheorIntervals = OneFrame * ones(1,length(MeasuredTimes)-1);
else
    if length(TheorIntervals) == length(MeasuredTimes)
        TheorIntervals(end) = [];
    end
end

%% Vars
nTimes = length(MeasuredTimes);
nIntervals = nTimes - 1;
MeasuredIntervals = diff(MeasuredTimes);

%% Find Errors
% We suppose a clock precision of 1 msec.
% We optimize to avoid false negatives.
delta = MeasuredIntervals - TheorIntervals;
tolong = find(delta > OneFrame + 2);
meabytolong = find(delta > 2 & delta <= OneFrame + 2);
iErrors = tolong;

for i = meabytolong
    if i == nIntervals || TheorIntervals(i+1) > OneFrame + 2
        % Case 1: We don't have the next frame time.
        if delta(i) > OneFrame - 2;
            iErrors(end+1) = i;
        end
    else
        % Case 2: We have the next frame time.
        if MeasuredIntervals(i) + MeasuredIntervals(i+1) > 2*OneFrame + 2
            iErrors(end+1) = i;
        end
    end
end

iErrors = sort(iErrors);
nFramesPerError = round(delta(iErrors) ./ OneFrame);

S.nMissedFrames = sum(nFramesPerError);
S.nErr = length(iErrors);
S.iErr = iErrors;
S.nMissedFramesPerErr = nFramesPerError;
s.dt = MeasuredIntervals(iErrors);

Errors = zeros(1,nIntervals);
Errors(iErrors) = nFramesPerError;
            