function sendeyelinkevent(name,status,type)
% SENDEYELINKEVENT  Send message string to EyeLink.
%    SENDEYELINKEVENT(NAME,<STATUS>,<TYPE>)  sends a standardized message string to EyeLink, which will  
%    record it in its data file, to keep track of an event. The main idea is to standardize event
%    recording (at the IoNS/COSY level) to facilitate interoperability of programs written by different
%    people.
%    Arguments are:
%       * NAME      - Name of the event.   E.g.: 'fix', 'gap', 'rampe'.
%       * STATUS    - 'ON', 'OFF', or ''.  E.g.:  sendeyelinkevent('fix','on'); % onset of fixation. 
%       * TYPE      - Any string.          E.g.:  sendeyelinkevent('cue','on','red'); % onset of "red" cue.
%
%    In the EyeLink data file (*.asc file), the event will be recorded as a line of the one of the following 
%    forms (where "########" stands for the tracker's timestamp):
%
%       MSG ######## USEREVENT: "NAME"
%       MSG ######## USEREVENT: "NAME" ON
%       MSG ######## USEREVENT: "NAME" OFF
%       MSG ######## USEREVENT: "NAME" ON "TYPE"
%       MSG ######## USEREVENT: "NAME" OFF "TYPE"
%       MSG ######## USEREVENT: "NAME"  "TYPE"
%
% See also: SENDEYELINKMESSAGE, GETEYELINKEVENTS, WAITEYELINKEVENT.

%% Check EL
if ~checkeyelink('isrecording')
    error('Eyelink tracker not recording. See OPENEYELINK and STARTEYELINKRECORD.')
end

%% Input Args
% name:
name = upper(name);

% status:
if nargout > 1
    if ~isempty(status)
        status = upper('status');
        if ~strcmp(status,'on') && ~strcmpi(status,'off')
            stopcosy;
            error('Invalid ''status'' argument.  Valid values are: ''ON'', ''OFF'' or empty string.') 
        end
    end
else
    status = '';
end
            
%% Message String
switch nargin
    case 1,     str = sprintf('USEREVENT: "%s"', name);
    case 2,     str = sprintf('USEREVENT: "%s" %s', name, status);
    case 3,     str = sprintf('USEREVENT: "%s" %s "%s"', name, status, upper(type));
end

%% Send String
Eyelink('Message',str);
helper_dispevent(mfilename,str,time);