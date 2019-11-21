function [Times,IDs,isDown] = getkeyevents(Mode);
% GETKEYEVENTS  Get keyboard events since last call to GETKEYEVENT.
%    [Times,IDs,isDown] = GETKEYEVENTS  returns key events since last  
%    call to GETKEYEVENT or READKEYS, then clears the key events stack.
%
%    If you want to peek the keyboard stack without clearing it, use
%    PEEKKEYEVENTS. If you don't want to get past events stored in the 
%    stack, but simply want to get the current keyboard state, use 
%    CHECKKEYDOWN, which checks current down/up status without interfer-
%    ring with the event stack.
%
%    The GETKEYEVENTS function relays on CogInput.mex and is not available 
%    with the PTB. In the case you are using PTB, use CHECKKEYDOWN only. 
%    An implementation of a keyboard stack for the PTB is currently under
%    developpement.
%
% Programmer's Note:
%    This function is an interface to "CogInput('GetEvents',...)".
%    It improves the functionning of the keyboard stack. The limitation of 
%    CogInput is that it cannot read the keyboard queue without clearing it.
%    The new stack is composed by both CogInput's queue and a persistent 
%    variable in getkeyevents, but this is transparent for the programmer
%    CogInput's queue should not be be interrogated directly. (i.e.: by 
%    "CogInput('GetEvents',...)" or a m-function which use it.)
%    <TODO: Rewrite waitkeydown, etc... This not yet done !!!>
%
% Programmer only:
%    GETKEYEVENTS('PEEK') is the same than PEEKKEYEVENTS.
%
% See also PEEKKEYEVENTS, CHECKKEYDOWN.

global cogent;

persistent EventStack

if ~isstruct(EventStack)
	EventStack = struct('Times',[],'IDs',[],'isDown',logical([]));
end

% Input Args
if ~nargin
	Mode = 'Get';
end

% Get Events from Windows' Stack. This cannot be done without clearing this stack.
[Times,IDs,isDown] = CogInput('GetEvents',cogent.keyboard.hDevice);
Times = Times' * 1000;
IDs = IDs';
isDown = logical(isDown / 128)';

% Add Events Stored in CosyGraphics's Stack to those Stored in Windows' Stack
if ~isempty(EventStack.Times)
	Times  = [EventStack.Times, Times];
	IDs    = [EventStack.IDs, IDs];
	isDown = [EventStack.isDown, isDown];
end

% Update CosyGraphics's Events Stack
if strcmpi(Mode,'Get')
	% Reset stack:
	EventStack.Times  = [];
	EventStack.IDs    = [];
	EventStack.isDown = [];
elseif strcmpi(Mode,'Peek')
	% Keep what we got from Windows' Stack into CosyGraphics's Stack:
	EventStack.Times  = Times;
	EventStack.IDs    = IDs;
	EventStack.isDown = isDown;
end
