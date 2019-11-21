function [IDs,isDown,Times,isError] = waitkeysequence(KeySequence,IgnoredKeys)
% WAITKEYSEQUENCE  Wait for a sequence of key presses. <Cog only>
%    [IDs,isDown,Times,isError] = WAITKEYSEQUENCE(KeySequence)
%
%    [IDs,isDown,Times,isError] =  WAITKEYSEQUENCE(KeySequence,IgnoredKeys) ??
%
% TODO: 'Peek'/'Get' modes. (Now it's 'Peek'). See GETKEYEVENTS, PEEKKEYEVENTS.
% 
% G-Lab function.

% Ben, May 2008


% Yield Interval. From PsychToolBox (KbWait) :
% "Time (in seconds) to wait between "failed" checks, in order to not
% overload the system in realtime mode. 5 msecs seems to be an ok value..."
YieldInterval = 5; % (ms)

% Clear the Events Stack.
getkeyevents;

% Input Args
if isnumeric(KeySequence)
	IDSequence = KeySequence;
elseif iscell(KeySequence)
	IDSequence = getkeynumber(KeySequence);
else
	error('''KeySequence'' must be a vector of key IDs or a cell vector of key names.')
end
if nargin < 2
	IgnoredIDs = [];
elseif isnumeric(IgnoredKeys)
	IgnoredIDs = IgnoredKeys;
elseif iscell(IgnoredKeys)
	IgnoredIDs = getkeynumber(IgnoredKeys);
else
	error('''IgnoredKeys'' must be a vector of key IDs or a cell vector of key names.')
end

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
	
	% Escape ?
	if any(IDs == getkeynumber('Escape'))
		return % --- !!!
	end
end

% Check if Errors in Sequence
isIgnored = ismember(IDs,IgnoredIDs);
DownSequence = IDs(isDown & ~isIgnored);
UpSequence = IDs(~isDown & ~isIgnored);
if      ( ...
		length(DownSequence) == length(IDSequence) && all(DownSequence == IDSequence) ...
		|| length(DownSequence) == length(IDSequence) - 1 && all(DownSequence == IDSequence(2:end)) ... % case 1st down missing
		) && ( ...
		length(UpSequence) == length(IDSequence) && all(UpSequence == IDSequence) ...
		|| length(UpSequence) == length(IDSequence) - 1 && all(UpSequence == IDSequence(1:end-1)) ... % case last up missing
		)
	isError = 0;
else
	isError = -1;
end

% Final Time
t = Times(ismember(IDs,IDList) & isDown);
t = t(end);