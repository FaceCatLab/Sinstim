function sendeyelinkmessage(string)
% SENDEYELINKMESSAGE  Send message string to EyeLink.
%    SENDEYELINKMESSAGE(STRING)  sends message STRING to EyeLink, which will record it in  
%    it's data file.
%
% See also: SENDEYELINKEVENT.

if ~checkeyelink('isrecording')
    error('Eyelink tracker not recording. See OPENEYELINK and STARTEYELINKRECORD.')
end

Eyelink('Message',string);