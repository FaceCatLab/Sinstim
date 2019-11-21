function clearkeys
% CLEARKEYS clears all keyboard events
%
% Description:
%     Clears all keyboard events.
%
% Usage:
%     CLEARKEYS
%
% Arguments:
%     NONE
%
% Examples:
%
% See also:
%
% Cogent 2000 function.

global cogent;

% error( checkkeyboard ); %<ben: commented (CosyGr. 3-beta25)>

if ~isfield(cogent.keyboard,'hDevice')
   message = 'START_COGENT must called before calling CLEARKEYS';
end

CogInput( 'GetEvents', cogent.keyboard.hDevice );

cogent.keyboard.time  = [];
cogent.keyboard.id    = [];
cogent.keyboard.value = [];
cogent.keyboard.number_of_responses = 0;



