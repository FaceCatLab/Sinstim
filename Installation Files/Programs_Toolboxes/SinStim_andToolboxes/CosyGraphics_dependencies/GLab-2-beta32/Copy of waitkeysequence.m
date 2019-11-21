function [Times,IDs,isDown] = waitkeysequence(KeySequence,isUpEventSequence)
% WAITKEYSEQUENCE  Wait for a sequence of key presses.
%    WAITKEYSEQUENCE(KeySequence)
%    WAITKEYSEQUENCE(KeySequence,isUpEventSequence)

% Clear the Events Stack.
getkeyevents;

% Input Args
if isnumeric(KeySequence)
	IDSequence = KeySequence;
elseif iscell(KeySequence)
	IDSequence = zeros(size(KeySequence));
	for k = 1 : length(KeySequence)
		IDSequence(k) = key(KeySequence{k});
	end
end
if nargin < 2
	isUpEventSequence = logical(ones(size(KeySequence)));
	isUpEventSequence(end) = 0;
else
	isUpEventSequence = logical(isUpEventSequence);
end

% Yield Interval. From PsychToolBox (KbWait) :
% "Time (in seconds) to wait between "failed" checks, in order to not
% overload the system in realtime mode. 5 msecs seems to be an ok value..."
YieldInterval = 5; % (sec)

% Var.
IDList = unique(IDSequence);
Ok = zeros(size(IDList));

% Main Loop
while ~all(Ok)
	% Wait for YieldInterval to Prevent System Overload.
	wait(YieldInterval);
	
	% Peek Keybord Events Stack
	[Times,IDs,isDown] = peekkeyevents;
	
	% Test if Sequence is Finished
	for i = 1 : length(IDList)
		id = IDList(i);
		if id ~= IDSequence(end) % General case. It's not the last key: wait for 'Up' event(s).
			if length(find(IDs == id & ~isDown)) ... % If # of 'Up' events for this ID...
					>= length(find( IDSequence == id )) % is reaches the # of occurences of ID in 'IDSequence'.
				Ok(i) = 1;
			end
		else % Particular case of the last key: wait only for 'Down' event(s)
			if length(find(IDs == id & isDown)) ... % If # of 'Down' events for this ID...
					>= length(find( IDSequence == id )) % is reaches the # of occurences of ID in 'IDSequence'.
				Ok(i) = 1;
			end
		end
	end
end

% Check if Errors in Sequence
DownSequence = IDs(isDown)%;
UpSequence = IDs(~isDown)%;