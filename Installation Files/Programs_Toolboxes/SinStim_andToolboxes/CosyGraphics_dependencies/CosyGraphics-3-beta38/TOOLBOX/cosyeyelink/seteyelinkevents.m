function seteyelinkevents(varargin)
% SETEYELINKEVENTS  Configure which type of events are sent through the TCP/IP link.
%    SETEYELINKEVENTS(TYPE1,TYPE2,...)  sets EyeLink's event filter to allow only given types of
%    events.  Types can be: 'LEFT', 'RIGHT', 'FIXATION', 'SACCADE', 'BLINK', 'BUTTON'.
%
%    SETEYELINKEVENTS('DEFAULT')  resets CosyGraphics' default config. It's the same than:
%    seteyelink('LEFT','RIGHT','BLINK','SACCADE','BUTTON');  i.e.: everithing except fixation
%    (because startfix is the same than endsacc and endfix is the same than startsacc).
%    This is the config. that you get after the OPENEYELINK call.
%
%    SETEYELINKEVENTS('ALL')  allows all events to be sent.  It's the same than:
%    seteyelink('LEFT','RIGHT','FIXATION','SACCADE','BLINK','BUTTON');
%
% Example:
%    seteyelinkevents ALL;         % allows all events to be sent.
%    seteyelinkevents DEFAULT;     % resets default.
%    seteyelinkevents LEFT RIGHT;  % allows only the eye samples (position & pupil data) to be sent.
%    seteyelinkevents SACCADE;     % allows only saccade events.
%
% See also: OPENEYELINK, GETEYELINKEVENTS, CLEAREYELINKEVENTS.

%% Checks
if nargin==0
    if isopen('display'), stopcosy; end
    error('Missing arguments.  See " help seteyelinkevents ".')
end
if ~isopen('eyelink')
    if isopen('display'), stopcosy; end
    error('EyeLink TCP/IP link not open. Please, run OPENEYELINK first.');
end

%% Input Args
switch upper(varargin{1})
    case 'DEFAULT',  types = {'LEFT','RIGHT','BLINK','SACCADE','BUTTON'};
    case 'ALL',      types = {'LEFT','RIGHT','BLINK','FIXATION','SACCADE','BUTTON'};
    otherwise        types = varargin;
end

%% Make command string
str = 'link_event_filter = ';
for i = 1:length(types)
    str = [str upper(types{i}) ','];
end
str(end) = []; % remove last coma

%% Send command
dispinfo(mfilename,'info',['Setting EyeLink''s event filter: ' str])
Eyelink('command',str);