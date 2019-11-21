function readkeys
% READKEYS  Read all keyboard events since last call to READKEYS or CLEARKEYS
%    READKEYS  reads all keyboard events since last call to READKEYS or CLEARKEYS.
%       Key IDs are defined in the structure returned by GETKEYMAP (Qwerty us)
%       or GETBELGIANMAP (Azerty be).
%
% Cogent 2000 function. v1.0
% Ben, Mar. 2008. 		v1.0.1	Modif. doc.

global cogent;

error( checkkeyboard );

if ~isfield(cogent.keyboard,'hDevice')
   message = 'START_COGENT must be called before calling READKEYS';
end

[ t, c, value ] = CogInput( 'GetEvents', cogent.keyboard.hDevice );

%cogent.keyboard.time  = floor( t/1000 ); % time now in seconds not us 4-4-2002 e.f.
cogent.keyboard.time = floor( t * 1000 );
cogent.keyboard.id    = c;
cogent.keyboard.value = value;
cogent.keyboard.number_of_responses = length( cogent.keyboard.time );
